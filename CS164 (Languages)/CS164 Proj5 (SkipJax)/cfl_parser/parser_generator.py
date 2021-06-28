##
 # @file parser_generator.py
 #
 # $Id: parser_generator.py,v 1.1 2007/04/23 10:31:42 cgjones Exp $
import grammar, grammar_parser, re, sys, types, util

##-----------------------------------------------------------------------------
## Module interface
##

def makeRecognizer (gram, type='cyk'):
    '''Construct and return a "recognizer" of GRAM.

    A recognizer is an object with a method recognize(inp), returning
    True if INP is a valid string in GRAM, and False otherwise.
    '''
    class Recognizer:
        def __init__ (self, parser):
            self.parser = parser

        def dump (self, f=sys.stdout):
            self.parser.dump (f)
        
        def recognize (self, inp):
            self.parser.parse (inp)
            return True

    return Recognizer (makeParser (gram, type))


def makeParser (gram, type='cyk'):
    '''Construct and return a parser of GRAM.

    A parser is an object with a method parse(inp), returning the AST
    constructed from the parse tree of INP by the semantic actions in GRAM.
    '''
    if type == 'cyk':
        return CYKParser (gram)
    else:
        raise TypeError, 'Unknown parser type specified'


##-----------------------------------------------------------------------------
## Parse tree representation
##
class ParseTreeNode:
    '''A node in the parse tree.
    Has a synthetic attribute, VAL, and an inherited attribute, INH.
    Also contains the children of this node.
    '''

    def __init__ (self, symbol, actions=[None], children=[], value=None):
        '''Create a new parse tree node.
        SYMBOL is the LHS of the production represented by this node.
        ACTIONS is a sequence of I-actions, followed by an S-action.
        CHILDREN is the children of this node.
        VALUE is the initial synthetic attribute of this node.
        '''
        self.val = value
        self.inh = None
        self.symbol = symbol
        self.actions = actions
        self.children = children


    def evaluate (self):
        '''Compute and return the synthetic attribute of this node.'''
        for i, child in enumerate (self.children):
            if self.actions[i]:         # I-action for child
                self.actions[i] (self, *(self.children))
            child.evaluate ()

        if self.actions[-1]:            # S-action for self
            self.val = self.actions[-1] (self, *(self.children))
        elif self.symbol:               # default S-action
            self.val = self.children[0].val

        return self.val


    def dump (self, out=sys.stdout, level=0):
        '''Print a string representation of this parse tree'''
        if not self.symbol:
            print >>out, '%s"%s"'% (' '*level*2, self.val)
        else:
            print >>out, '%s(%s'% (' '*level*2, self.symbol)
            for child in self.children:
                child.dump (out, level + 1)
            print >>out, '%s)'% (' '*level*2)


##-----------------------------------------------------------------------------
## CYK Parser
##
class CYKParser:
    '''A parser implementing the CYK algorithm.'''

    def __init__ (self, gram):
        '''Create a new CYK parser.'''
        self.startSymbol = gram.startSymbol
        self.terminals, self.epsilons, self.singles, self.doubles = CYKParser.toCNF (gram)


    def parse (self, inp):
        '''Return the result of parsing INP.'''
        #
        # For efficiency reasons, this function is much uglier than it should
        # be.  Each edge is represented as the list:
        #
        #   SYM: the symbol this edge reduces to
        #   FROM: the start node of the edge
        #   TO: the end node of the edge
        #   INFO: information about the production
        #
        # All edges taken are stored in the set EDGES, which maps
        # (sym, from, to) to an edge.
        #
        # The parse graph is stored in the list P.  Each node in the list
        # is a dictionary containing the dictionaries 'inc' and 'out'.
        # The 'inc' dictionary is a set of incoming edges into that node,
        # and 'out' is the outgoing edges.
        #
        # The worklist is a list of the edge "keys," the tuple (sym, from, to).
        #
        SYM = 0; FROM = 1; TO = 2; CHILDREN = 3; INFO = 4

        P = []                          # graph representation of parse tree
        edges = {}                      # edges reduced during parsing
        worklist = []                   # edges current being considered
        inputLen = 0                    # the number of non-optional terminals
        
        # Tokenize the input
        try:
            tokens = self.tokenize (inp)
        except Exception, pos:
            util.error ('error tokenizing at position %s'% (pos))
            return

        # Initialize the parse graph with nodes for each non-optional
        # terminal, plus 1 for fence post considerations
        for token, lexeme in tokens:
            if CYKParser.__isTermSymbol (token):
                P.append ({'inc': {}, 'out': {}})
                inputLen += 1
        P.append ({'inc': {}, 'out': {}})

        # Create edges for each terminal matched in the input stream.
        # Optional terminals get self-edges.
        pos = 0
        for token, lexeme in tokens:
            frm = pos
            if CYKParser.__isTermSymbol (token):
                to = pos + 1
                pos += 1
            else:
                to = pos
            edge = (token, frm, to, lexeme, None)
            key = (edge[SYM], edge[FROM], edge[TO])
            edges[key] = edge
            worklist.append (key)
            P[edge[FROM]] ['out'][key] = edge
            P[edge[TO]] ['inc'][key] = edge

        # Add a self-edge for each nullable nonterminal.
        for i in xrange (len (P)):
            for lhs, info in self.epsilons:
                edge = (lhs, i, i, grammar.Grammar.EPSILON, info)
                key = (edge[SYM], edge[FROM], edge[TO])
                edges[key] = edge
                worklist.append(key)
                P[edge[FROM]] ['out'][key] = edge
                P[edge[TO]] ['inc'][key] = edge


        def addToWorklist (sym, frm, to, children, info):
            '''Add the edge (SYM, FRM, TO) to the worklist, if it is
            not already there.
            '''
            key = (sym, frm, to)
            if key not in edges:
                edge = [sym, frm, to, children, info]
                edges[key] = edge
                worklist.append (key)
                P[frm]['out'][key] = edge
                P[to]['inc'][key] = edge

            else:
                # Parse conflict
                replaceEdge = False

                (newOpPrec, newAssoc, newDprec, newProduction) = info

                oldEdge = edges[key]
                (oldOpPrec, oldAssoc, oldDprec, oldProduction) = oldEdge[INFO]

                if (newOpPrec is not None) and (oldOpPrec is not None):
                    # Have operator precedence information
                    if newOpPrec < oldOpPrec:
                        # Take the lower-precedence production
                        replaceEdge = True
                    elif newOpPrec == oldOpPrec:
                        # Use associativity
                        lop1 = children[0]
                        lop2 = oldEdge[CHILDREN][0]
                        leftLarger = (lop1[TO]-lop1[FROM]) > (lop2[TO]-lop2[FROM])
                        if newAssoc == grammar.Grammar.LEFT_ASSOCIATIVE:
                            # Left associative: take larger left subtree
                            replaceEdge = leftLarger
                        else:
                            # Right associative: take smaller left subtree
                            replaceEdge = not leftLarger
                                
                elif (newDprec is not None) and (oldDprec is not None):
                    # Have %dprec declarations; take the larger
                    replaceEdge = newDprec > oldDprec

                # else: Either duplicate edge, or no disambig info

                if replaceEdge:
                    edges[key][CHILDREN] = children
                    edges[key][INFO] = info


        # Core of parsing algorithm:
        #   while there's an edge E we haven't tried reducing:
        while len (worklist) > 0:
            edge = worklist.pop ()

            # consider all reductions E --> LHS
            for lhs, info in self.singles.get (edge[SYM], []):
                addToWorklist (lhs, edge[FROM], edge[TO], (edge,), info)

            # consider all reductions E OUT --> LHS
            for outEdge in P[edge[TO]] ['out'].values ():
                for lhs, info in self.doubles.get ((edge[SYM], outEdge[SYM]), ''):
                    addToWorklist (lhs, edge[FROM], outEdge[TO], (edge, outEdge), info)

            # consider all reductions IN E --> LHS
            for inEdge in P[edge[FROM]] ['inc'].values ():
                for lhs, info in self.doubles.get ((inEdge[SYM], edge[SYM]), ''):
                    addToWorklist (lhs, inEdge[FROM], edge[TO], (inEdge, edge), info)

        theParse = edges.get ((self.startSymbol, 0, inputLen), None)
        if not theParse:
            util.error ('invalid input')


        def reconstruct (tree):
            '''Build an original-grammar parse tree from CYKs.
            Returns a ParseTreeNode representing this parse tree.
            '''
            if tree[CHILDREN] is grammar.Grammar.EPSILON:
                return ParseTreeNode (symbol=tree[SYM],
                                      actions=tree[INFO][3]['actions'],
                                      children=[ParseTreeNode (None)])
            if isinstance (tree[CHILDREN], types.StringType):
                return ParseTreeNode (symbol=None, value=tree[CHILDREN])

            children = tree[CHILDREN]

            # Put the reconstructed left subtree into the children array
            newChildren = [reconstruct (edges [(children[0][SYM],
                                                children[0][FROM],
                                                children[0][TO])])]

            if len (children) == 2:
                rchild = reconstruct (edges [(children[1][SYM],
                                              children[1][FROM],
                                              children[1][TO])])
                if isinstance (rchild, ParseTreeNode):
                    newChildren.append (rchild)
                else:
                    newChildren.extend (rchild)

            if tree[SYM][0].isalpha ():
                # "Real" grammar symbol
                return ParseTreeNode (symbol=tree[SYM],
                                      actions=tree[INFO][3]['actions'],
                                      children=newChildren)
            else:
                # "Artificial" symbol introduced by CNF rewrite
                return newChildren


        # Build an equivalent parse tree in the original grammar from CYK's
        theParse = reconstruct (theParse)

        # And finally, execute semantic actions on the parse tree
        try:
            return theParse.evaluate ()
        except Exception, e:
            util.error ('error while executing semantic actions: %s'% (e))


    def tokenize (self, inp):
        '''Return the tokenized version of INP, a sequence of
        (token, lexeme) pairs.
        '''
        tokens = []
        pos = 0

        while True:
            matchLHS = 0
            matchText = None
            matchEnd = -1

            for regex, lhs in self.terminals:
                match = regex.match (inp, pos)
                if match and match.end () > matchEnd:
                    matchLHS = lhs
                    matchText = match.group ()
                    matchEnd = match.end ()

            if pos == len (inp):
                if matchLHS:  tokens.append ((matchLHS, matchText))
                break
            elif pos == matchEnd:       # 0-length match
                raise Exception, pos
            elif matchLHS is None:      # 'Ignore' tokens
                pass
            elif matchLHS:              # Valid token
                tokens.append ((matchLHS, matchText))
            else:                       # no match
                raise Exception, pos

            pos = matchEnd

        return tokens


    def dump (self, f=sys.stdout):
        '''Print a representation of the CNF grammar to F.'''

        for (rhs1, rhs2) in self.doubles:
            for lhs in self.doubles[(rhs1, rhs2)]:
                print lhs, '->', rhs1, rhs2

        for rhs in self.singles:
            for lhs in self.singles[rhs]:
                print lhs, '->', rhs

        for lhs in self.epsilons:
            print lhs, '->', '_'

        for regex, lhs in self.terminals:
            if lhs is None:  lhs = '(ignore)'
            print lhs, '->', regex.pattern


    ##---  STATIC  ------------------------------------------------------------

    TERM_PFX = '*'     # prefix of nonterminals replacing terminals
    NONTERM_PFX = '@'  # prefix of nonterminals replacing RHSs with > 2 symbols

    @staticmethod
    def toCNF (gram):
        '''Returns the tuple:
        
        (
          [ (regex, lhs) ],             # pattern/token list
          [ epsilonLHS ],               # LHSs that have epsilon productions
          { rhs --> [lhs] },            # one-symbol RHSs mapped to LHSs
          { (rhs1, rhs2) --> [lhs] }    # two-symbol RHSs mapped to LHSs
        )

        WARNING: modifies GRAM argument.
        '''

        REGEX = re.compile ('')
        
        terminals = []
        renamedTerminals = {}
        epsilons = []
        singles = {}
        doubles = {}

        # Import all the grammar's modules into a new global object
        try:
            glob = util.doImports (gram.imports)
        except:
            util.error ('problem importing %s'% (gram.imports))
        
        # Add 'ignore' patterns to the terminals list
        for regex in gram.ignores:
            terminals.append ((regex, None))

        # Add 'optional' patterns to the terminals list
        for sym, regex in gram.optionals:
            terminals.append ((regex, sym))

        # Build a lookup table for operator associavitiy/precedences
        operators = {}
        for op, prec, assoc in gram.getAssocDecls ():
            operators [op.pattern] = (prec, assoc)

        # First pass -- pull out epsilon productions, add terminal rules
        # and take care of semantic actions
        ruleNum = 0                     # newly-created rules
        for rule in gram.rules:
            lhs = rule.lhs
            for production in rule.productions:
                actions = production['actions']
                rhs = production['rhs']

                # Create the S-action, if specified
                if actions[len (rhs)]:
                    actions[len (rhs)] = CYKParser.makeSemantFunc (
                        actions[len (rhs)], len (rhs), glob)

                # Pull out epsilons and terminals
                for i, sym in enumerate (rhs):
                    if sym == grammar.Grammar.EPSILON:
                        # Epsilon
                        info = (None, None, None, production)
                        epsilons.append ((lhs, info))
                        assert len (rhs) == 1

                    elif type (sym) == type (REGEX):
                        # Terminal symbol
                        if sym.pattern in renamedTerminals:
                            # Terminal was already factored out
                            termSym = renamedTerminals[sym.pattern]
                        else:
                            # Add *N -> sym rule, replace old symbol
                            termSym = '%s%d'% (CYKParser.TERM_PFX, ruleNum)
                            ruleNum += 1
                            renamedTerminals[sym.pattern] = termSym
                            terminals.append ((sym, termSym))

                        if sym.pattern in operators:
                            # This pattern has a global assoc/prec declaration
                            # (which might be overridden later)
                            prec, assoc = operators[sym.pattern]
                            production['opPrec'] = prec
                            production['opAssoc'] = assoc
                        rhs[i] = termSym

                    if actions[i]:
                        # I-action for this symbol
                        actions[i] = CYKParser.makeSemantFunc (
                            actions[i], len (rhs), glob)

        # Second pass -- build the symbol mapping and collect parsing info
        ruleNum = 0
        for rule in gram.rules:
            for production in rule.productions:
                lhs = rule.lhs
                rhs = production['rhs']

                if len (rhs) == 1 and rhs[0] == grammar.Grammar.EPSILON:
                    # Epsilon production, skip it
                    continue

                # Collect precedence/associativity info
                if production['assoc']:
                    # This production had a %prec declaration
                    opPrec, assoc = operators[production['assoc'].pattern]
                elif 'opPrec' in production:
                    # This production had a terminal symbol with an assoc/prec
                    # declaration
                    opPrec = production['opPrec']
                    assoc = production['opAssoc']
                else:
                    # No declarations ==> undefined prec, assoc
                    opPrec, assoc = None, None

                # Collect dprec info
                if production['prec'] != -1:
                    # Production had a %dprec declaration
                    dprec = production['prec']
                else:
                    # No declaration ==> undefined dprec
                    dprec = None

                # Information about this production to be used during parsing
                info = (opPrec, assoc, dprec, production)

                # Rewrite the grammar into CYK form
                while True:
                    if len (rhs) == 1:
                        singles[rhs[0]] = singles.get (rhs[0], []) + [(lhs, info)]
                        break
                    elif len (rhs) == 2:
                        key = (rhs[0], rhs[1])
                        doubles[key] = doubles.get (key, []) + [(lhs, info)]
                        break
                    else:
                        # add '@N' --> rhs, and "recurse"
                        newRuleLHS = '%s%d'% (CYKParser.NONTERM_PFX, ruleNum)
                        ruleNum += 1
                        key = (rhs[0], newRuleLHS)
                        doubles[key] = doubles.get (key, []) + [(lhs, info)]
                        lhs = newRuleLHS
                        rhs = rhs[1:]
                    info = (None, None, None, None)

        return terminals, epsilons, singles, doubles


    @staticmethod
    def makeSemantFunc (code, numArgs, globalObject):
        args = ['n0']
        for i in xrange (numArgs):
            args.append ('n%d'% (i+1))
        try:
            return util.createFunction (util.uniqueIdentifier (),
                                        args, code, globalObject)
        except:
            util.error ("""couldn't create function""")


    @staticmethod
    def __isTermSymbol (sym):
        '''Return TRUE iff SYM is a 'virtual' nonterminal for a
        terminal symbol, created during grammar normalization.
        '''
        return sym[0] == CYKParser.TERM_PFX


    @staticmethod
    def dumpEdges (edges):
        '''Print a representation of the edge set EDGES to stdout.'''
        for sym, frm, to in edges:
            print '(%d)--%s--(%d)'% (frm, sym, to)


    @staticmethod
    def dumpTree (tree, edges, level=0):
        '''Print a representation of the parse tree TREE to stdout.'''
        sym, frm, to = tree[0:3]
        if len (tree) > 3:
            children = tree[3]
        else:
            children = edges[(sym, frm, to)][3]
        if (isinstance (children, types.StringType) or
            children is grammar.Grammar.EPSILON):
            print '%s%s "%s")'% ('-'*level*2, sym, children)
        else:
            print '%s%s %d-%d'% ('-'*level*2, sym, frm, to)
            for child in children:
                CYKParser.dumpTree (child, edges, level + 1)


##-----------------------------------------------------------------------------

if __name__ == '__main__':
    pass
