import Tree, helpers, re

class TreeHelper:
    def __init__(self, metaTable):
        self.metaTable = metaTable
        
    def makeNode(self, edge, lvl):
        
        str = 'dummy'
        # not sure if type(edge[0]) will always work
#        print 'before returnedge'
#        print edge
#        print ''
        if type(edge[0])==type(str):
            return Tree.Leaf(edge[0], lvl) #CHANGE
        elif edge[0]==re.compile('_'):
            return Tree.Leaf(edge[0], lvl) #CHANGE
#        print 'metatable'
#        edges = self.metaTable[edge[0], edge[1], edge[2][0]]
#        for e in edges:
#            print e
#            print ''
        edge = returnEdge(edge, self.metaTable) 
#        print 'after returnedge'
#        print edge
#        print ''
        if (getV(edge) - getU(edge) <= 1): #Don't need to recurse on it's children
            node = Tree.Tree(getLHS(edge), edge[0][2][1]['action'], lvl) #CHANGE
            predict, cause = self.lookUp(getEdge(edge, None))
            node.addChild(self.makeNode(cause, lvl+1))
            return node
    
        node = Tree.Tree(getLHS(edge), edge[0][2][1]['action'], lvl) #CHANGE
        
        childList = []
        rightChild = getCause(edge)
        #print 'rightchild:', rightChild
        childList.append(rightChild)
        
        prodCounter = len(getRHS(edge)) - 1
        #print 'prodcounter:', prodCounter
        self.prodHelper(getPrediction(edge), prodCounter, childList)
        
        for child in childList:
            ret = self.makeNode(child, lvl +1)
            if ret == None:
                node.addChild(child)
            else:
                node.addChild(ret)
                
        return node
    
    def prodHelper(self, edge, counter, list):
        if counter == 0:
            return None
        else:
            e = self.lookUp(edge)
            if e != None:
                predict, cause = e
                list.insert(0, cause)
                self.prodHelper(predict, counter -1, list)
    
    def lookUp(self, edge):
#        print 'edge'
#        print edge
#        print ''
        edge = returnEdge(edge, self.metaTable) #CHANGE
#        print 'returnedge'
#        print edge
#        print ''
        cedge  = getCause(edge)
#        print 'cedge'
#        print cedge
#        print ''
        regexType = type(re.compile('str'))
        if type(cedge[0])!=regexType and type(cedge[0])!=type('str') and cedge[1] - cedge[0]>=5 and cedge[2][2]==len(cedge[2][1]['rhs']):
            edges = self.metaTable[(cedge[0],cedge[1],cedge[2][0])]
            for e in edges:
                if e[0][2][2]==len(e[0][2][1]['rhs']):
                    return (getPrediction(edge), e[0])
        if type(cedge[0])==regexType:
            return (getPrediction(edge), cedge)
        if isTerminal(getCause(edge)) or isCompleted(getCause(edge)):
            return (getPrediction(edge), getCause(edge))
        else:
            return None
        
def isTerminal(cause):
    str = 'dummy'
    if type(cause[0])==type(str):
        return True
    else:
        return False
        
def isCompleted(cause):
    if cause[2][2]==len(cause[2][1]['rhs']):
        return True
    else:
        return False
    
def returnEdge(edge, metaTable):
    match = metaTable[(edge[0],edge[1],edge[2][0])]
    if len(match) > 1: #type(match) == type([]):
        for e in match:
            if edge == e[0]:
                return  e
    else:
        return match[0] 
    #may need to take care of case when len(match)==0
    
#------------------------Helper Functions----------------------
#Assuming in the form [u,v,[]] [Predictions, Cause]
def getEdge(edge, num):
    if num == None:
        e = edge[0]
        return e
    else:
        e = edge[0][num]
        return e

def getU(edge):
    u = getEdge(edge, 0)
    return u 

def getV(edge):
    v = getEdge(edge,1)
    return v 

def getState(edge,num):
    if num ==None:
        return edge[0][2]
    else:
        return edge[0][2][num]
    
def getLHS(edge):
    return getState(edge,0)

def getRHS(edge):
    return getState(edge,1)['rhs']

def getPrediction(edge):
    return edge[1][0]

def getCause(edge):
    return edge[1][1]
