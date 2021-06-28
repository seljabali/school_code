import util, Tree, re

class evaluator:
    def __init__(self, imports):
        self.glob = util.doImports (imports)
        
    def evaluate(self,node):
        
        name = util.uniqueIdentifier()
        args = getArgs(node.action)
                
        node.function = util.createFunction (name, args, node.action, self.glob)
        
        for child in node.children:
            if child.type != "leaf_node":
                self.evaluate(child)
        
        argList = []
        
        for child in node.children:
            if child.type == "tree_node":
                argList.append(child)
        if len(argList)==0:
            node.val = node.function(node.children[0])
        else:
            node.val = node.function(*argList)
        
def getArgs(actionStr):
    argList = re.findall('n[0-9]+', actionStr)
    return argList 