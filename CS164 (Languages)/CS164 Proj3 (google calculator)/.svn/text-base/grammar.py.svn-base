##
 # @file grammar.py
 #
 # $Id: grammar.py,v 1.2 2007/02/12 08:10:12 cgjones Exp $
import re
from sys import stdout

class Rule:
    '''A mapping from Symbol -> [RHSs].

    Also keeps track of associativity declarations for each
    production, and the precedences of ambiguous production (if any).
    '''

    def __init__ (self, symbol):
        '''Create a new rule for SYMBOL.'''
        self.lhs = symbol
        self.productions = []

    def __repr__ (self): return str (self)

    def __str__ (self):
        return '<grammar.Rule lhs="%s" ...>' % (self.lhs)


    def dump (self, file=stdout, i=0):
        '''Print a pretty version of this rule to FILE at indent level I'''

        REGEX = re.compile ('a')        # so we simulate isinstance()
        
        print >>file, (i*' ')+'(Rule %s'% (self.lhs)
        i += 4
        for prod in self.productions:
            print >>file, (i*' ')+'(production [',

            for sym in prod['rhs']:
                if sym == Grammar.EPSILON:
                    print >>file, '(epsilon),',
                elif type (sym) == type (REGEX):
                    print >>file, '%s,'% (sym.pattern),
                else:
                    print >>file, '%s,'% (sym),
            print >>file, ']'
            
            if prod['prec'] >= 0:
                print >>file, ((i+4)*' ')+'(precedence %d)'% (prod['prec'])
            if prod['assoc']:
                print >>file, ((i+4)*' ')+'(assoc %s)'% (prod['assoc'].pattern)
            if prod['action']:
                print >>file, ((i+4)*' ')+'(action {%s})'% (prod['action'])

            print >>file, (i*' ')+ ')'

        i -= 4
        print >>file, (i*' ')+')'


    def addProduction (self, rhs, action=None, prec=-1, assoc=None):
        '''Add a production self.lhs -> RHS, with an optional precedence,
        semantic action, and associativity override.

        RHS is an array of symbols; e.g., ["E", "+", "E"].

        ACTION is the text of a function to execute after reducing with
        this production.

        PREC is the precedence of this production among all the ones for
        this rule.

        ASSOC is a terminal symbol whose precedence should be used
        in this rule, overriding that of any other terminals with
        associativity declarations.
        '''
        self.productions.append (
            { 'rhs': rhs, 'action': action, 'prec': prec, 'assoc': assoc })

##-----------------------------------------------------------------------------

class Grammar:
    '''The data structure representing an abstract grammar.'''

    EPSILON = '_'

    LEFT_ASSOCIATIVE = 'left'
    RIGHT_ASSOCIATIVE = 'right'
    
    IGNORE = 'ignore' #ADDED
    
    def __init__ (self):
        '''Create a new Grammar.'''
        self.rules = []                 # list of Rules
        self.startSymbol = ''           # the start symbol of this grammar
        self.imports = []               # modules to be imported

        self.__opAssocDecls = []        # operator associativity declarations
        self.opIgnoreDecls = []       # ADDED IGNORE
        self.__currOpPrec = 0           # the current operator precedence

    def getAssocs(self):
        return self.__opAssocDecls
    
    def __repr__ (self): return str (self)

    def __str__ (self):
        return '<grammar.Grammar startSymbol="%s" ...>'% (self.startSymbol)


    def dump (self, file=stdout):
        '''Print a pretty version of this grammar to FILE'''
        print >>file, '(Grammar'

        print >>file, (4*' ')+'(Declarations'
        for mod in self.imports:
            print >>file, (8*' ')+'(import %s)'% (mod)
        for (op, ignore) in self.opIgnoreDecls: #ADDED
            print >>file, (8*' ')+'(ignore %s)'% (op.pattern)        
        for (op, prec, assoc) in self.__opAssocDecls:
            print >>file, (8*' ')+'(assoc %s %d %s)'% (op.pattern, prec, assoc)
        print >>file, (4*' ')+')'
        print >>file, (4*' ')+'(Rules'
        for rule in self.rules:
            rule.dump (file, 8)
        print >>file, (4*' ')+')'

        print >>file, (4*' ')+'(StartSymbol %s)'% (self.startSymbol)

        print >>file, ')'


    def setStartSymbol (self, startSymbol):
        '''Set the start symbol of this grammar.'''
        self.startSymbol = startSymbol


    def declareImport (self, module):
        '''Declare that MODULE should be imported by this grammar.'''
        self.imports.append (module)


    def declareOperatorAssocs (self, operators, assoc):
        '''Declare the associativity of the sequence OPERATORS to be ASSOC.

        Also sets the precedence of these operators; the last set of
        operators passed to declareAssociativities() will have highest
        precedence, and so on.
        '''
        if len (operators) == 0:
            raise Exception             # XXX
        for op in operators:
            self.__opAssocDecls.append ((op, self.__currOpPrec, assoc))
        self.__currOpPrec += 1

    def declareOperatorIgnore (self, operator, ignore): #ADDED
        self.opIgnoreDecls.append ((operator, ignore))

    def addRule (self, rule):
        '''Add RULE to the set of rules for this grammar.'''
        self.rules.append (rule)


    def validate (self):
        '''Run semantic checks against this grammar and its
        constituent rules.  Returns the tuple (valid?, message).

        "valid?" is True if the grammar is valid, False otherwise.

        "message" is a description of the semantic validations, and is
        only interesting when valid? is False.
        '''
        ##
        ## IMPLEMENT ME!
        
        REGEX = re.compile ('a')  
        lhs = []      # so we simulate isinstance()
        numRules = len(self.rules)
        for x in range(numRules):
            lhs.append(self.rules[x].lhs)
            for y in range(x+1, numRules):
                if self.rules[x].lhs==self.rules[y].lhs:
                    errMsg = 'Error: Duplicate rules for nonterminal: ' + self.rules[x].lhs
                    return (False, errMsg)
        for rule in self.rules:
            for prod in rule.productions:
                for sym in prod['rhs']:
                    if sym == Grammar.EPSILON:
                        pass
                    elif type(sym) == type (REGEX):
                        pass
                    else:
                        count = 1;
                        for left in lhs:
                            if sym==left:
                                break
                            elif sym!=left and count==len(lhs):
                                errMsg = 'Error: nonterminal does not appear on the left hand side of any rule: ' + sym
                                return (False, errMsg)
                            else:
                                count += 1
        return (True, 'Passed semantic analysis')

##-----------------------------------------------------------------------------

def main ():
    print 'Hello from grammar.py!'
    ##
    ## IMPLEMENT ME, IF YOU WANT
    ##

if __name__ == '__main__':
    main ()
