##
 # @file grammar_parser.py
 #
 # $Id: grammar_parser.py,v 1.5 2007/04/04 23:13:54 cgjones Exp $
import grammar, re, sys, types

##-----------------------------------------------------------------------------
## Simple tokenizer
##
class Tokenizer:
    '''A very simple stream tokenizer.'''

    def __init__ (self, input, whitespace='[ ]', comments='#'):
        '''Create a new Tokenizer on INPUT.  Optionally accepts regexes
        for WHITESPACE and COMMENTS to be ignored.'''
        self.input = input
        self.__pos = 0
        self.whitespace = re.compile (whitespace, re.VERBOSE)
        self.comments = re.compile (comments, re.VERBOSE)


    def checkpoint (self):
        '''Make a checkpoint of the current scanning state.'''
        return self.__pos


    def restore (self, checkpoint):
        '''Restore a checkpoint made by the checkpoint() method.'''
        self.__pos = checkpoint


    def token (self, regex):
        '''Try to match REGEX against the input at the current position,
        ignoring whitespace and comments.
        Returns the part of the input that matches, or None if there is
        no match.
        
        REGEX can be either a String or compiled regular expression.
        
        If there is a match, updates the current position within
        the input string.
        '''
        # Skip whitespace and comments
        while (self.__matchToken (self.whitespace)
               or self.__matchToken (self.comments)
               or self.__matchToken(re.compile('//'))):
            pass

        # Return the match of REGEX
        if isinstance (regex, types.StringType):
            return self.__matchToken (re.compile (regex, re.MULTILINE))
        else:
            return self.__matchToken (regex)


    def __matchToken (self, regex):
        '''Try to match the compiled regular expression REGEX against
        the input at the current position.  Returns the part of the
        input that matches, or None if there is no match.

        If there is a match, updates the current position within
        the input string.
        '''
        ##
        ## IMPLEMENT ME
        ##
        r = regex.pattern
        out = regex.match(self.input, self.__pos)
        if self.__pos > (len(self.input)-1):
            return None
        if (self.input[self.__pos]==r or self.input[self.__pos]=='\n'
            or self.input[self.__pos]=='\t' or self.input[self.__pos]=='\r') and r==' ':
            self.__pos += 1
            return True
        elif self.input[self.__pos]==r and r=='#':
            pattern = re.compile('#.*')
            ret = pattern.match(self.input, self.__pos)
            self.__pos += len(ret.group())+1
            return True
        elif (out!=None and len(out.group(0))>0):
            if r=='//':
                rgx = re.compile('//.*')
                ret = rgx.match(self.input, self.__pos)
                self.__pos += len(ret.group())+1
                return True
            self.__pos += len(out.group())
            return out.group()
        else:
            return None

##-----------------------------------------------------------------------------
## The Grammar Parser API
##
def parseFile (filename):
    '''Construct a new Grammar from the specification in FILENAME.'''
    return parse (open (filename).read (), filename)


def parse (spec, filename='stdin'):
    '''Construct a new Grammar from the specification SPEC.'''

    def error (msg):
        '''Prints MSG to stderr and exits with a non-zero error code.'''
        print >>sys.stderr, 'Error: %s'% (msg)
        sys.exit (1)

    def checkpoint ():
        '''Create a parser checkpoint.'''
        return (lexer.checkpoint (), len (stack))

    def restore (checkpoint):
        '''Restore a parser checkpoint.'''
        lexer.restore (checkpoint[0])
        stack.__setslice__(0, len (stack), stack[0:checkpoint[1]])
        return True

    lexer = Tokenizer (spec, r' ', '#') # tokenizer
    stack = []                          # semantic stack


    def printMe(x):
        if x != None:
            print x
            
    startSymbolStack = []

    def S ():
        cp = checkpoint ()
        g = gram()
        stack.append(g)
        return True

    def gram():
        oc = openComment()
        g = grammar.Grammar()
        decl = d(g)
        pp = lexer.token('%%')
        rR = r(g)
        if ( oc and decl and pp and rR):
            return g
        else:
            error('malformed grammar')
    
    def openComment():
        oc = lexer.token('//')
        return True
    
    def d(g):
        decl = declaration(g)
        if not decl:
            return True
        rD = d(g)
        return True
    
    def r(g):
        rul = rule(g)
        if rul:
            r(g)
            return True
        else:
            return False
    
    def declaration(g):
        assoc = assocDecl(g)
        if assoc:
            return True
        else:
            ignore = ignoreDecl(g) #ADD IGNORE
            if ignore:
                return True
            else:                
                imp = importDecl(g)
                if imp:
                    return True
                else:
                    return False
        
    def assocDecl(g):
        stackLen = len(stack)
        left = lexer.token('%left')
        if left:
            ret = assocHelper()
            g.declareOperatorAssocs(ret, grammar.Grammar.LEFT_ASSOCIATIVE)
            return True
        else:
            right = lexer.token('%right')
            if right:
                ret = assocHelper()
                g.declareOperatorAssocs(ret, grammar.Grammar.RIGHT_ASSOCIATIVE)
                return True
        return False

    def ignoreDecl(g): #ADDED
        stackLen = len(stack)
        ignore = lexer.token('%ignore')
        if ignore:
            term = terminal()
            if term:
                term = toCompiled(term)
                g.declareOperatorIgnore(term, grammar.Grammar.IGNORE)
                return True
            else:
                error('%ignore not followed by terminal')
        else:
            return False
    
    def importDecl(g):
        imp = lexer.token('%import')
        if imp:
            modName = pyModName()
            if modName:
                g.declareImport(modName)
                return True
            else:
                error('bad module name given to %import')
        else:
            return False
    
    def assocHelper():
        stackLen = len(stack)
        term = t()
        if term:
            list = []
            num = len(stack) - stackLen
            for x in range(num):
                item = stack.pop()
                item = toCompiled(item)
                list.insert(0, item)
            return list
        else:
            error('%left requires at least one terminal')
    
    def t():
        term = terminal()
        if term:
            ret = t()
            return True
        else:
            return False
        
    def rule(g):
        stackLen = len(stack)
        nonTerm = nonTerminal()
        if nonTerm:
            r = grammar.Rule(nonTerm)
            stack.pop()
            arrow = lexer.token('\->')
            prod = production(r)
            rP = p(r)
            semi = lexer.token(';')
            if (arrow and prod and rP and semi):
                g.addRule(r)
                if len(startSymbolStack)==0:
                    g.setStartSymbol(nonTerm)
                    startSymbolStack.append(1)
                return g
            else:
                error('malformed rule')
        else:
            return False
    
    def p(r):
        curPos = checkpoint()
        stackLen = len(stack)
        vertBar = lexer.token('\|')
        if not vertBar:
            return True
        prod = production(r)
        rP = p(r)
        if not (vertBar and prod and rP):
            restore(curPos)
        return True

    def production(r):
        cp = checkpoint()
        empty = emptyProd()
        if empty:
            act = action()
            if act:
                r.addProduction(['_'], act)
                return True
            else:             
                r.addProduction(['_'])
                return True
        else:
            n = nonEmptyProd()
            toAdd = True
            if (n):
                num = len(stack) - cp[1]
                list = []
                for x in range(num):
                    list.insert(0, stack.pop())
                if toAdd:
                    for x in range(list.__len__()):
                        list[x] = toCompiled(list[x])
                    prod = prodDecl()
                    if prod:
                        prodList = []
                        prodList.append(stack.pop())
                        prodList.append(stack.pop())
                        prodList.reverse()
                    act = action()
                    if act:
                        actionList = stack.pop()
                        if prod:
                            if prodList[0] == '%prec':
#                                for x in prodList:
#                                    print x
                                r.addProduction(list, actionList, -1, toCompiled(prodList[1]))
                                return True
                            elif prodList[0] == '%dprec':
#                                for x in prodList:
#                                    print x
                                r.addProduction(list, actionList,int(prodList[1]), None)
                                return True
                        else:
                            r.addProduction(list, actionList, None, None)
                            return True
                    elif prod:
                            if prodList[0] == '%prec':
#                                for x in prodList:
#                                    print x
                                r.addProduction(list,None , -1, toCompiled(prodList[1]))
                                return True
                            elif prodList[0] == '%dprec':
#                                for x in prodList:
#                                    print x
                                r.addProduction(list, None, int(prodList[1]), None)
                                return True
                    else:
#                        for x in prodList:
#                            print x                        
                        r.addProduction(list, None, None, None)
                        return True
                else:
                    error("could not make sense of the production")
                    sys.exit(1)
            else:
                return None

    def emptyProd():
        eps = epsilon()
        if eps:
            return True
        else:
            return False
    
    def epsilon():
        eps = lexer.token("_")
        if eps:
            return True
        else:
            return False
            
    def nonEmptyProd():
        sym = symbol()
        if (sym==None):
            return None
        while symbol():
            pass
        return True
    
    def prodDecl():
        prec = precDecl()
        if prec:
            return True
        else:
            tempAssoc = tempAssocDecl()
            if tempAssoc:
                return True
            else:
                return False
            
    def precDecl():
        dprec = lexer.token('%dprec')
        if dprec:
            num = number()
            if num:
                stack.append(dprec)
                stack.append(num)
                return True
            else:
                error('no number after %dprec')
        else:
            return False
    
    def tempAssocDecl():
        prec = lexer.token('%prec')
        if prec:
            term = terminal()
            if term:
                stack.append(prec)
                stack.append(term)
                return True
            else:
                error('no terminal after %prec')
        else:
            return False
     
    def symbol():
        t = terminal()
        if (t != None):
            return t
        else:
            n = nonTerminal()
            if (n != None):
                return n
        return None
    
    def pyModName():
        ident = id()
        if (ident): 
            ret = recursiveId()
            if ret:
                return ident + ret
            else:
                return ident
        else:
            error('pyModuleName incorrect')
    
    def recursiveId():
        dot = lexer.token('\.')
        if dot:
            ident = id()
            if ident:
                r = recursiveId()
                if r:
                    return '.' + ident + r
                else:
                    return '.' + ident
            else:
                error('malformed pyModuleName')
        else:
            return None

    def terminal():
        #ret = lexer.token("(/.*?/)|('.*?')")
        ret = lexer.token("(/(\\/|.)*/)|('.*?')")
        if (ret): 
            stack.append (ret)
            return ret
        return None

    def nonTerminal():
        ret = lexer.token('([A-Z]|[a-z])(_|[A-Z]|[a-z]|[0-9])*')
        if (ret): 
            stack.append (ret)
            return ret
        return None
    
    def number():
        num = lexer.token('[0-9]+')
        if num:
            stack.append(num)
            return num
        return None

    def action():
        ret = lexer.token('%{(.)*%}')
        if (ret):
            ret = re.sub('%{', '', ret)
            ret = re.sub('%}', '', ret)
            stack.append (ret)
            return ret
        return None

    def id():
        ret = lexer.token('(_|[A-Z]|[a-z])(_|[A-Z]|[a-z]|[0-9])+')
        if (ret): 
            stack.append (ret)
            return ret
        return None
    
    def isOp( str ):
        if (str == "'+'" or str == "'-'" or str == "'*'" or str == "'!'" or str == "'/'"):
            return True
        else:
            return False
    
    def isWord( str ):
        p = re.compile('([A-Z]|[a-z])(_|[A-Z]|[a-z]|[0-9])*')
        out = p.match(str)
        if (out != None):
            return True
        else:
            return False        

    def isIf(str):
        if str == "'if'":
            return True
        else:
            return False
        
    def isElse(str):
        if str == "'else'":
            return True
        else:
            return False
        
    def isThen(str):
        if str == "'then'":
            return True
        else:
            return False
    
    def toCompiled(str):
#        print ''
#        print 'compiling: ', str
#        print 'strlen: ', len(str)
        if str[0] == "'": # or str[0] == '"':
            str = re.sub("^'", '', str)
            str = re.sub("'", '', str)
            return re.compile(re.escape(str))
        elif str[0] == '/': 
            out = ''
            for x in range(str.__len__() - 1):
                if x == 0:
                    pass
                else:
                    out = out + str[x]
            return re.compile(out)
        else:
            return str


    if not S ():
        error ('invalid input!')
    else:
#        print 'Successful input!'
        return stack.pop ()

##-----------------------------------------------------------------------------

def main (argv):
    print 'Hello from grammar_parser.py!'

if __name__ == '__main__':
    main (sys.argv)
