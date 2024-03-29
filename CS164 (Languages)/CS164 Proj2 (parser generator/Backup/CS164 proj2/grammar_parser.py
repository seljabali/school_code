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
               or self.__matchToken (self.comments)):
            pass

        # Return the match of REGEX
        if isinstance (regex, types.StringType):
            return self.__matchToken (re.compile (regex, re.VERBOSE))
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
        if (self.input[self.__pos]==r or self.input[self.__pos]=='\n') and r==' ':
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

    ##
    ## IMPLEMENT ME
    ##
    ## THE CODE BELOW IS AN EXAMPLE RECURSIVE-DESCENT PARSER WITH A SEMANTIC
    ## STACK.  PLEASE REPLACE IT WITH YOUR SOLUTION.
    ##

    startSymbolStack = []

    def S ():
        cp = checkpoint ()
        g = gram()
        g.dump();
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
            print 'Error: malformed grammar'
            sys.exit(1)
    
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
    
    def importDecl(g):
        imp = lexer.token('%import')
        if imp:
            modName = pyModName()
            if modName:
                g.declareImport(modName)
                return True
            else:
                print 'Error: malformed import statement'
                sys.exit(1)
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
            print 'Error: %left requires at least one terminal'
            sys.exit(1)
    
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
                print 'Error: malformed rule'
                sys.exit(1)
        else:
            return False
    
    def p(r):
        curPos = lexer.checkpoint()
        stackLen = len(stack)
        vertBar = lexer.token('\|')
        if not vertBar:
            return True
        prod = production(r)
        rP = p(r)
        if not (vertBar and prod and rP):
            self.__pos = curPos
            num = len(stack) - stackLen
            for x in rnage(num):
                pop.stack()
        return True
            
    def production(r):
        cp = checkpoint()
        n = nonEmptyProd()
        toAdd = True ######CHANGED
        if (n):
            num = len(stack) - cp[1]
            list = []
            for x in range(num):
                list.insert(0, stack.pop())
            if num == 2:
#                print ''
#                print list[0], isOp(list[0])
#                print list[1], isWord(list[1])
#                print ''
                if (isOp(list[0]) and isWord(list[1])):
                    toAdd = True
                else:
                    print("It's not in the '+ E' form")
            elif num == 3:
#                print ''
#                print list[0]
#                print list[1]
#                print list[2]
#                print ''
                if isWord(list[0]) and isOp(list[1]) and isWord(list[2]):
                    toAdd = True
                else:
                    print("It's not in the 'E + E' form")
            elif num == 4:
#                print ''
#                print list[0], isIf(list[0]), len(list[0])
#                print list[1], isWord(list[1])
#                print list[2], isThen(list[2])
#                print list[3], isWord(list[3])
#                print ''
                if isIf(list[0]) and isWord(list[1]) and isThen(list[2]) and isWord(list[3]):
                    toAdd = True
                else:
                    print("It's not in the ''if' E 'then' E form")
            elif num == 6:
                if isIf(list[0]) and isWord(list[1]) and isThen(list[2]) and isWord(list[3]) and isElse(list[4]) and isWord(list[5]):
                    toAdd = True
                else:
                    print("It's not in the ''if' E 'then' E 'else' E form")
            else:
                print "Error: ", list, ' is not recognized'
            if toAdd:
                for x in range(list.__len__()):
                    list[x] = toCompiled(list[x])
                prod = prodDecl()
                if prod:
                    second = stack.pop()
                    first = stack.pop()
                    list.append(first)
                    list.append(second)
                act = action()
                if act:
                    r.addProduction(list, stack.pop())
                else:
                    r.addProduction(list)
                return True
            else:
                print "Error couldn't make sense of the production"
                sys.exit(1)
        else:
            return None

    def isOp( str ):
        if (str == "'+'" or str == "'-'" or str == "'*'" or str == "'!'" or str == "'/'"):
            #print(str, 'is an Operator')
            return True
        else:
            return False
    
    def isWord( str ):
        p = re.compile('([A-Z]|[a-z])(_|[A-Z]|[a-z]|[0-9])*')
        out = p.match(str)
        if (out != None): #out.group(0)
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
        if str[0] == "'" or str[0] == '"':
            if '+' in str:
                return re.compile ('\+')
            elif '-' in str:
                return re.compile ('\-')
            elif '*' in str:
                return re.compile ('\*')
            elif '/' in str: #str.count('/') == 1:
                return re.compile ('\/')
            elif '!' in str:            
                return re.compile ('\!')
            elif (str == "'if'"):
                return re.compile ('if')
            elif (str == "'then'"):
                re.compile ('then')
            elif (str == "'else'"):
                re.compile ('else')
            else:
                print 'Uh oh, a string but not an operator', str
                return re.compile(str)
        elif str[0] == '/': #Regular Expressions
            out = ''
            for x in range(str.__len__() - 1):
                if x == 0:
                    pass
                else:
                    out = out + str[x]
            print 'regex', str
            return re.compile(out)
        else:
            return str

    def emptyProd():
        eps = epsilon()
        if eps:
            return True
        else:
            return False
    
    def epsilon():
        eps = lexer.token("'_'")
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
                print 'Error: no number after %dprec'
                sys.exit(1)
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
                print 'Error: not a terminal after %prec'
                sys.exit(1)
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
            print 'Error: pyModuleName incorrect'
            sys.exit(1)
    
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
                print 'Error: malformed pyModuleName'
                sys.exit(1)
        else:
            return None

    def terminal():
        ret = lexer.token("(/.*/)|('.*?')")
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

    if not S ():
        error ('invalid input!')
    else:
        print 'Successful input!'
        return stack.pop ()

##-----------------------------------------------------------------------------

def main (argv):
    print 'Hello from grammar_parser.py!'
    ##
    ## IMPLEMENT ME, IF YOU WANT
    ##

if __name__ == '__main__':
    main (sys.argv)
