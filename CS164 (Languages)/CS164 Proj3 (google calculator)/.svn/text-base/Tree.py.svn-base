class Tree:
    def __init__(self, lhs, action, level):
        self.lhs = lhs
        if action == None:
            self.action = "return n1.val"
        else:
            self.action = action
        self.children = []
        self.level = level
        self.val = ''
        self.function = ''
        self.type = "tree_node"
        
    def addChild(self, child):
        self.children.append(child)
        
    def printMe(self):
        print '\t'* (self.level) + 'lhs:', self.lhs#, "lvl" , self.level
        print '\t'* (self.level) + 'actions:', self.action
        #print '\t'* (self.level) + 'children:', self.children
        if len(self.children)==0:
            pass;
        else:
            for child in self.children:
                child.printMe()
    
    def getType(self):
        return "tree_node"
    
    def getChildren(self):
        return self.children  #0].lhs, self.children[0].action, self.children[0].level

class Leaf:
    def __init__(self, lhs, level):
        self.lhs = lhs
        self.val = lhs
        self.level = level
        self.type = "leaf_node"
        
    def getValue():
        return self.lhs

    def getType(self):
        return "leaf_node"
    
    def printMe(self):
        print '\t'* (self.level) + 'lhs:', self.lhs#, "lvl" , self.level        