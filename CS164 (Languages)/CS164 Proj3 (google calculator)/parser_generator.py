##
 # @file parser_generator.py
 #
 # $Id: parser_generator.py,v 1.3 2007/03/03 10:20:02 cgjones Exp $
import grammar, grammar_parser, validator, lexer, tree_create,semantic, re


def makeRecognizer (gram):
    '''Construct and return a "recognizer" of GRAM.

    A recognizer is an object with a method recognize(inp), returning
    True if INP is a valid string in GRAM, and False otherwise.
    '''
    ##
    ## IMPLEMENT ME!
    ##
    ## THE CODE BELOW IS AN EXAMPLE OF HOW YOUR RECOGNIZERS COULD LOOK.
    ## PLEASE REPLACE IT WITH YOUR SOLUTION.
    ##
    class Recognizer:
        def recognize (self, inp):
            #gram.dump()
            lexemes = lexer.lex(gram, inp)
            if lexemes==None:
                return None
            #print lexemes
            valid, metaTable, finalEdge = validator.parse(gram, lexemes)
#            print '\n\t******** Before disambiguate ********\n'
#            edges = metaTable[(0, len(lexemes), gram.startSymbol)]
#            for edge in edges:
#                if edge[0][2][2]==len(edge[0][2][1]['rhs']):
#                    finalEdge = edge[0]
#                    print edge
#                    print ''
            assocDict = createAssocDict(gram.getAssocs())
            disambiguate(metaTable, assocDict, 0, len(lexemes), gram.startSymbol)
#            print '\n\t******** After disambiguate ********\n'
#            edges = metaTable[(0, len(lexemes), gram.startSymbol)]
#            for edge in edges:
#                if edge[0][2][2]==len(edge[0][2][1]['rhs']):
#                    finalEdge = edge[0]
#                    print edge
#                    print ''
            treeHelper = tree_create.TreeHelper(metaTable)
            tree = treeHelper.makeNode(finalEdge, 0)
            #tree.printMe()
            sem = semantic.evaluator()
            sem.evaluate(tree) #CHANGE
            print tree.val
            return valid
    return Recognizer ()

def makeParser (gram):
    class Parser:
        def parse (self, inp):
            lexemes = lexer.lex(gram, inp)
            if lexemes==None:
                return None
            #print lexemes
            valid, metaTable, finalEdge = validator.parse(gram, lexemes)
            if valid==False:
                print "Couldn't Parse"
#                print "Final edge",finalEdge
#                for m in metaTable:
#                    print m
                return None
#            print 'valid:', valid
            assocDict = createAssocDict(gram.getAssocs())
#            edges = metaTable[(0, 2, 'S')]
#            for edge in edges:
#                print '*************************************'
#                print edge
#                print ''
            disambiguate(metaTable, assocDict, 0, len(lexemes), gram.startSymbol)
            edges = metaTable[(0, len(lexemes), gram.startSymbol)]
            for edge in edges:
                if edge[0][2][2]==len(edge[0][2][1]['rhs']):
                    finalEdge = edge[0]
            treeHelper = tree_create.TreeHelper(metaTable)
            tree = treeHelper.makeNode(finalEdge, 0)
            #tree.printMe()
            sem = semantic.evaluator(gram.imports)
            sem.evaluate(tree) #CHANGE
            return tree.val 
    return Parser ()


def createAssocDict(assocList):
    assocDict = {}
    for assoc in assocList:
        assocDict[assoc[0]] = assoc
    return assocDict

def disambiguate(metaTable, assocDict, start, end, lhs):
    removalList = []
    isLeftAssoc = True
    winningEdge = None
    edges = metaTable[(start, end, lhs)]
#    for edge in edges:
#        if edge[0][2][2]==len(edge[0][2][1]['rhs']):
#        print edge
#        print ''
#    print 'len of edges:', len(edges)
#    for e in edges:
#        print e
#        print ''
    if len(edges)<=1:
        return True
    for edge in edges:
        if isCompletedProd(edge):
            if winningEdge==None:
                winningEdge=edge
            else:
                term1 = findAssoc(edge)
                if not term1:
                    term1 = findTerminal(edge)
                term2 = findAssoc(winningEdge)
                if not term2:
                    term2 = findTerminal(winningEdge)
                if assocDict.has_key(term1) and assocDict.has_key(term2):
                    prec1 = assocDict[term1][1]
                    prec2 = assocDict[term2][1]
                    if prec1==prec2:
                        assoc = assocDict[term1][2]
                        if assoc == "right":
                            isLeftAssoc = False
                            if (edge[1][0][1]-edge[1][0][0]) < (winningEdge[1][0][1]-winningEdge[1][0][0]):
                                removalList.append(edge)
                            else:
                                removalList.append(winningEdge)
                                winningEdge = edge
                        else:
                            if (edge[1][0][1]-edge[1][0][0]) > (winningEdge[1][0][1]-winningEdge[1][0][0]):
                                removalList.append(winningEdge)
                                winningEdge = edge
                            else:
                                removalList.append(edge)
                    else:
                        if prec1>prec2:
                            removalList.append(edge)
                        else:
                            removalList.append(winningEdge)
                            winningEdge = edge
                elif winningEdge[0][2][1]['prec']!=None and edge[0][2][1]['prec']!=None:
                    if winningEdge[0][2][1]['prec']>edge[0][2][1]['prec']:
                        removalList.append(edge)
                    else:
                        removalList.append(winningEdge)
                        winningEdge = edge
                else:
                    removeEdge(edges, edge)
#    print 'winningEdge'
#    print winningEdge
#    print ''

    for remove in removalList:
        removeEdge(edges, remove)

    strType = type('a')
    if isLeftAssoc:
        uLeft = winningEdge[1][0][0]
        vLeft =  winningEdge[1][0][1] - 1
        lhsLeft = winningEdge[1][0][2][0]
        if (vLeft - uLeft) > 3: 
            disambiguate(metaTable, assocDict, uLeft, vLeft, lhsLeft)
        if strType!=type(winningEdge[1][1][0]) and winningEdge[1][1][0]!=re.compile('_'):
            uRight = winningEdge[1][1][0]
            vRight =  winningEdge[1][1][1]
            lhsRight = winningEdge[1][1][2][0]
            if (vRight - uRight) > 3:
                disambiguate(metaTable, assocDict, uRight, vRight, lhsRight)

def removeEdge(list, edge):
    for i in range(len(list)-1):
        if edge==list[i]:
            list.pop(i)

def findAssoc(edge):
    if edge[0][2][1]['assoc']!=None:
        return edge[0][2][1]['assoc']
    else:
        return None

def findTerminal(edge):
    #print edge
    dotPos = edge[0][2][2] - 1
    regexType = type(re.compile('a'))
    while dotPos>=0:
        if type(edge[0][2][1]['rhs'][dotPos])==regexType:
            return edge[0][2][1]['rhs'][dotPos]
        else:
            dotPos-=1
    return None
        
                                   
        
def isCompletedProd(edge):
#    print '******** unkown completion ********'
#    print edge
#    print ''
    if edge[0][2][2]==len(edge[0][2][1]['rhs']):
#        print 'completed'
#        print edge
#        print ''
        return True
    else:
#        print 'not completed'
#        print edge
#        print ''
        return False
        

