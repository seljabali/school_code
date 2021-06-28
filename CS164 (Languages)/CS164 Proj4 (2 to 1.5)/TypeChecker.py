from preTypeChecker import *
import ast
import tables
import util

class TypeCheck (ast.Visitor):
    def __init__ (self, emitter):
        self.out=emitter
        self.map={}
        self.type=[]
        self.classTable=classTable
        self.globalTable=globalTable
        self.envTable=envTable
        self.Stack=[]; self.Stack.append(self.envTable)

    def visitAtomType(self, atom):
        self.type.append(atom.value.value)

    def visitArrowType(self, arrow):
        temp = [1]
        arrow.lhs.accept(self)
        lhs = self.type.pop()
        if not isinstance(lhs, list) == 1: lhs = [0, lhs]  
        temp.append(lhs)
        arrow.rhs.accept(self)
        temp.append(self.type.pop())
        self.type.append(temp)
            
    def visitArrayInit (self, array):
        for child in array.children:
            child.accept (self)
            if self.type.pop() != 'Number':
                self.out.error('// Error: Arrays can only contain numbers.\n')
        self.type.append('Array')
        
    def visitAssignment (self, assn):
        assn.lhs.accept (self)
        lhs = self.type.pop() 
        assn.rhs.accept (self)
        rhs = self.type.pop() 
        self.compareTypeAssn (lhs, rhs)
        self.validExpr (assn.operator, lhs)
    
    def visitArgumentList (self, ls):
        temp = [0]
        for child in ls.children:
            child.accept (self)
            temp.append(self.type.pop()) 
        self.type.append(temp)               
    
    def visitBlock (self, block):
        for child in block.children:
            child.accept (self)    
    
    def visitBreak (self, brek):
        pass
    
    def visitContinue (self, cont):
        pass    

    def compareReturn (self, typeFunction, stackLen1, stackLen2):
        count = stackLen2 - stackLen1
        if count == 0:
            if len(typeFunction) < 3 or self.printType(typeFunction[2]) == 'Null':
                return True
            else:
                self.out.error("// Error: Mal return statement\n")
        typeFunctionReturn = [0]
        if len(typeFunction) == 3:
            typeFunctionReturn = typeFunction[2]
        while (count>0):
            typeStatementReturn = self.type.pop()
            if typeFunctionReturn != 'dynamic' and typeStatementReturn != 'dynamic' and typeFunctionReturn != 'String' and (typeFunctionReturn != typeStatementReturn or self.printOutType (typeFunction)==''):
                self.out.error("// Error: Mal return statement\n")
            count-=1
        return True
    
    def compareType (self, type1, type2):
        if self.printType(type1) == 'dynamic' or self.printType(type1) == 'Dynamic' or self.printType(type2) == 'dynamic' or self.printType(type2) == 'Dynamic' or self.printType(type1)=='String' or  self.printType(type1)=='string' or self.printType(type2)=='String' or self.printType(type2)=='string':
            return True
        if type1 != type2:
            self.out.error("// Error: Operator Type Mismatch\n")
        return True    
    
    def visitConditional (self, cond):
        cond.condition.accept (self)
        cond.thenPart.accept (self) 
        part1 = self.type.pop()    
        cond.elsePart.accept (self)
        part2 = self.type.pop()   
        self.compareType(part1, part2)
        self.type.append(part1)    
            
    def visitCall (self, call):
        call.function.accept (self)  
        func = self.type.pop()       
        if isinstance(func, list):
            inp = func[1]
            outp = func[2]
        else: 
            inp = 'dynamic'
            outp = func
        call.arguments.accept (self)  
        arg = self.type.pop()        
        self.compareInputs (inp, arg)
        self.type.append(outp) 

    def visitCaseList (self, case):
        for child in case.children:
            child.accept(self)

    def compareTypeAssn (self, type1, type2):
        if self.printType(type1) == 'dynamic' or self.printType(type1) == 'Dynamic' or self.printType(type2) == 'dynamic' or self.printType(type2) == 'Dynamic' or self.printType(type1)=='String' or self.printType(type1)=='string':
            return True
        if type1 != type2:
            self.out.error("// Error: Assignment Type Mismatch\n")
        return True
            
    def visitCase (self, c):
        if c.label:
            c.label.accept(self)
        c.statements.accept(self)

    def visitClassA(self, a_):
        self.Stack.append (self.Stack[-1].envof[a_.cname.value])
        a_.cbody.accept(self)
        self.Stack.pop()  
        
    def visitCBlock(self, cb_):
        for o in cb_.children:
            o[0].accept(self)
            self.type = []

    def visitComma (self, comma):
        for child in comma.children:
            child.accept (self)
        
    def compareInputs (self, funcIn, arg):
        if funcIn == 'dynamic':
            return
        if funcIn != arg:
            self.out.error("// Error: Parameters don't match\n")

    def visitCatch (self, c):
        c.exception.accept(self)
        c.body.accept(self)

    def visitDelete (self, delete_):
        delete_.value.accept (self)
                
    def visitDefault (self, de):
        de.statements.accept(self)            
    
    def visitDynamicType (self, dynamic):
        self.type.append('dynamic')    
    
    def visitDo (self, do):
        do.condition.accept (self)
        do.body.accept (self)    
    
    def visitEmptyStatement(self, e):
        pass
    
    def validExpr (self, operator, type):
        result = ['===', '==', '==', '!=', '=']
        if not operator in result:
            if (type != 'String' and type != 'Number') and (operator =='+=' or operator =='+'): 
                self.out.error('// Error: '+operator+" can't be preformed on those types\n")
            if not type=='Number':
                self.out.error('// Error: '+operator+" can't be preformed on those types\n")
                
    def visitExpressionStatement (self, stmt):
        stmt.expression.accept (self)        
    
    def visitFalse (self, false):
        self.type.append('Boolean')

    def visitFor (self, for_):
        for_.setup.accept (self)
        for_.condition.accept (self)
        for_.update.accept (self)
        for_.body.accept (self)

    def visitForIn (self, fin):
        fin.iterator.accept (self)
        fin.object.accept (self)
        fin.body.accept (self)
        if fin.decl:
            fin.decl.accept (self)
    
    def visitFunctionDecl (self, decl):
        decl.name.accept (self)
        decl.function.accept (self)
    
    def visitFunction (self, func):
        self.Stack.append(tables.Environment(self.Stack[-1]))   
        temp = [1]
        temp.append([0])
        for e in func.parameters.children:   
            if e[1] != None:                                                    
                e[1].accept(self) 
                inParam = self.type.pop()
                temp[1].append(inParam)  
                self.Stack[-1].typeof[e[0].value] = inParam
        if (func.typeDecorator):   
            func.typeDecorator.accept(self)
            temp.append(self.type.pop())   
        self.type.append(temp) 
        stackLen1 = len (self.type)
        func.body.accept(self)     
        stackLen2 = len (self.type)
        self.compareReturn (temp, stackLen1, stackLen2)  
        self.Stack.pop()

    def visitIdentifier (self, id):
        type = self.Stack[-1].lookup(id.value)
        if type == None:
            type = 'dynamic'
        self.type.append(type)

    def visitIndex (self, index):
        index.property.accept (self)
        ind = self.type.pop()       
        if ind != 'Number': self.out.error('// Error: Array indices must be Numbers\n')
        index.object.accept (self)
        ind = self.type.pop()   
        self.type.append(ind)
        
    def visitInfixExpression (self, expr):
        expr.lhs.accept (self)   
        lhs = self.type.pop()    
        expr.rhs.accept (self)   
        rhs = self.type.pop()    
        self.compareType (lhs, rhs)
        self.validExpr (expr.operator, lhs)
        self.type.append(lhs)

    def visitInstanceof (self, instof):
        instof.value.accept (self)
        instof.type.accept (self)        

    def visitIf (self, if_):
        if_.condition.accept (self)
        if_.thenPart.accept (self)
        if if_.elsePart:
            if_.elsePart.accept (self)   

    def visitNodeList (self, node):
        for child in node.children:
            child.accept (self)
    
    def visitNew (self, new):
        new.object.accept (self)  
        className = self.type.pop()
        new.arguments.accept (self)
        arg = self.type.pop()      
        if className != self.envTable.typeof[className]:
            self.out.error('// Error: Inproper class ', className, '\n')
        self.type.append(className)
        
    def visitNumber (self, number):
        self.type.append('Number')

    def visitNull (self, null):
        self.type.append('Null')

    def visitObjectInit (self, obj):
        for child in obj.children:
            child.accept (self)
            self.type.pop()
        self.type.append('dynamic')

    def visitPropertyInit (self, prop):
        prop.property.accept (self)
        prop.value.accept (self)

    def visitPrefixExpression (self, expr):
        expr.operand.accept (self)
        rhs = self.type.pop()    
        self.validExpr (expr.operator, rhs)
        self.type.append(rhs)

    def visitPostfixExpression (self, expr):
        expr.operand.accept (self)  
        lhs = self.type.pop()    
        self.validExpr (expr.operator, lhs) 
        self.type.append(lhs)

    def printOutType (self, type):
        strType =''
        if type==None or type==[]:
            return 'None'
        elif not isinstance(type, list):
            strType += type
        elif len(type)==1:
            if isinstance(type, list):
                temp = self.printType (type[0])
                strType += temp
        else:
            if len(type)>2 and type[0]==1:
                strType += '(' + self.printType(type[2]) + ')'
            elif  len(type)>1 and type[0]==0:
                for j in range(1,len(type)):
                    strType += '(' + self.printType(type[j]) + ') * '
                strType = strType[:-3]
        return strType

    def printType (self, type):
        strType =''        
        if type==None or type==[]:
            return 'None'
        elif type==[0]:
            return ''
        elif not isinstance(type, list):
            strType += type
        elif len(type)==1:
            if isinstance(type, list):
                temp = self.printType (type[0])
                strType += temp
        else:
            if len(type)>2 and type[0]==1:  
                strType += '(' + self.printType(type[1]) + ') -> (' + self.printType(type[2]) + ')'
            elif  len(type)>1 and type[0]==0:
                for j in range(1,len(type)):
                    strType += '(' + self.printType(type[j]) + ') * '
                strType = strType[:-3]
        return strType

    def visitRegex (self, regex):
        self.type.append('String')
        
    def visitString (self, string):
        self.type.append('String')

    def visitScript (self, script):
        script.statements.accept (self)

    def visitSelection (self, sel):
        sel.object.accept (self)
        obj = self.type.pop()   
        if obj == "dynamic":
            self.out.error("// Error: Need type of object before accessing its attributes\n")
        if self.Stack[0].envof[obj].lookup(sel.property.value) == None:
            self.out.error("// Error: Class "+obj+" doesn't have that attribute\n")   
        type = self.Stack[0].envof[obj].lookup(sel.property.value) 
        self.type.append(type)

    def visitTrue (self, true):
        self.type.append('Boolean')

    def visitVarDecl (self, decl):
        typeDec = 'dynamic'      
        if decl.typeDecorator:   
            decl.typeDecorator.accept(self)
            typeDec = self.type.pop()      
        if typeDec == 'dynamic':
            self.out.warning('// Warning: Dynamic variable ' + decl.name.value + '\n')
        if decl.initializer:   
            decl.initializer.accept (self)   
            self.compareType(typeDec, self.type.pop())  
        self.Stack[-1].typeof[decl.name.value] = typeDec

    def visitVarDecls (self, decls):
        for child in decls.children:
            child.accept (self)

    def visitReturn (self, ret):
        if ret.value:
            ret.value.accept (self)
        else:
            self.type.append(None)
            
    def visitSwitch (self, sw):
        sw.discriminant.accept(self)
        sw.cases.accept(self)            

    def visitThis (self, this):
        this = self.Stack[-1]
        while (this.parent != self.envTable):
            this = this.parent
        for key,val in this.parent.envof.items():
            if val == this:
                this = key
                break
        if isinstance(this, str):
            self.type.append(this)
        else: 
            self.type.append('dynamic')
            
    def visitTupleType(self, tuple_):
        temp = [0]
        for e in tuple_.children:
            e.accept(self)
            temp.append(self.type.pop())
        self.type.append(temp)            

    def visitThrow (self, thrw):
        if thrw.exception:
            thrw.exception.accept(self)

    def visitTypeof (self, typeof):
        typeof.value.accept (self)

    def visitTryCatchFinally (self, t_c_f):
        t_c_f.tryBlock.accept(self)
        if t_c_f.catch:
            t_c_f.catch.accept(self)
        if t_c_f.finallyBlock:
            t_c_f.finallyBlock.accept(self)
         
    def visitVoid (self, void):
        void.value.accept (self)
        self.type.pop()
        self.type.append('Void')

    def visitWith (self, w):
        w.object.accept (self)
        w.body.accept (self)

    def visitWhile (self, while_):
        while_.condition.accept (self)
        while_.body.accept (self)