import ast
import tables
import util

global classTable; classTable = {}
global globalTable ;globalTable = {}
global table;table = {}
global envTable; envTable = tables.Environment(None)

class preTypes (ast.Visitor):
    def __init__ (self, emitter):
        self.out = emitter
        self.map = {}
        self.type = []
        self.stkClass=[]

    def visitAtomType(self, atom):
        self.type.append(atom.value.value)

    def visitArrowType(self, arrow):
        temp=[1]
        arrow.lhs.accept(self)
        temp.append(self.type.pop())
        arrow.rhs.accept(self)
        temp.append(self.type.pop())
        self.type.append(temp)
        
    def visitClassA(self, c_):
        envTable.typeof[c_.cname.value] = c_.cname.value
        if c_.csuper:
            if c_.csuper.value in envTable.envof.keys():
                envTable.envof[c_.cname.value] = tables.Environment(envTable.envof[c_.csuper.value])
            else:
                self.out.error('// Error: Superclass not defined\n')
        else:
            envTable.envof[c_.cname.value] = tables.Environment(envTable)
        classTable[c_.cname.value]={}
        self.stkClass.append(c_.cname.value)        
        c_.cbody.accept(self)
        if c_.csuper:
            c_.csuper.accept(self)
            table[c_.cname.value]= c_.csuper.value
        
        self.stkClass.pop()

    def visitCBlock(self, b_):
        for o in b_.children:
            o[0].accept(self)
            if (o[1]):
                if isinstance(o[0], ast.VarDecls):
                    for c in o[0].children:
                        envTable.envof[self.stkClass[-1]].static[c.name.value] = True
                else:
                    envTable.envof[self.stkClass[-1]].static[o[0].name.value] = True
                    globalTable [self.stkClass[-1]+'.'+o[0].name.value] = classTable[self.stkClass[-1]][o[0].name.value]        

    def visitDelete (self, del_):
        del_.value.accept (self)

    def visitDynamicType (self, dynamic):
        self.type.append('dynamic')

    def visitFunction (self, func):
        temp = [1]
        temp.append([])
        temp[1].append(0)
        for e in func.parameters.children:
            e[0].accept(self)    
            if (e[1] != None): 
                e[1].accept(self)
            if (self.type != []):
                temp[1].append(self.type.pop())
        if (func.typeDecorator):
            func.typeDecorator.accept(self)
            temp.append(self.type.pop())
        self.type.append(temp)
        self.stkClass.append(-1);
        func.body.accept(self)
        self.stkClass.pop();
    
    def visitFunctionDecl (self, decl):
        decl.name.accept (self)
        decl.function.accept (self)
        type = self.type.pop()
        if (self.stkClass != [] and self.stkClass[-1] != -1):
            envTable.envof[self.stkClass[-1]].typeof[decl.name.value] = type
            classTable[self.stkClass[-1]][decl.name.value] = self.printType(type)
        else:
            envTable.typeof[decl.name.value] = type
            globalTable[decl.name.value] = self.printType(type)
        
    def printOutType (self, type):
        strType =''
        if type==None or type==[] or type ==[0]:
            return 'Null'
        elif not isinstance(type, list):
            strType += str(type)
        elif len(type)==1:
            if isinstance(type, list):
                temp = self.printType (type[0])
                strType += temp
        else:
            if len(type)>2:
                if type[0]==1:
                    strType += '(' + self.printType(type[2]) + ')'
                else:
                    for j in range(1,len(type)):
                        strType += '(' + self.printType(type[j]) + ') * '
                    strType = strType[:-3]
        return strType

    def visitReturn (self, ret):
        if ret.value:
            ret.value.accept (self)
        else:
           pass

    def printType (self, type):
        strType =''
        if type==None or type==[] or type ==[0]:
            return 'Null'
        elif not isinstance(type, list):
            strType += str(type)
        elif len(type)==1:
            if isinstance(type, list):
                temp = self.printType (type[0])
                strType += temp
        else:
            if len(type)>2:
                if type[0]==1:
                    strType += '(' + self.printType(type[1]) + ') -> (' + self.printType(type[2]) + ')'
                else:
                    for j in range(1,len(type)):
                        strType += '(' + self.printType(type[j]) + ') * '
                    strType = strType[:-3]
        return strType


 
    def visitTupleType(self, tuple_):
        temp=[0]
        for e in tuple_.children:
            e.accept(self)
            temp.append(self.type.pop())
        self.type.append(temp)
                
    def visitVarDecl (self, decl):
        typeDec = 'dynamic'
        if (decl.typeDecorator):
            decl.typeDecorator.accept(self)
            typeDec = self.type.pop()
        if (self.stkClass != [] and self.stkClass[-1] != -1): 
            envTable.envof[self.stkClass[-1]].typeof[decl.name.value] = typeDec
            classTable[self.stkClass[-1]][decl.name.value] = self.printType(typeDec)
        elif (self.stkClass == []):
            envTable.typeof[decl.name.value] = typeDec
            globalTable[decl.name.value] = self.printType(typeDec)
        if decl.initializer:
            decl.initializer.accept (self)