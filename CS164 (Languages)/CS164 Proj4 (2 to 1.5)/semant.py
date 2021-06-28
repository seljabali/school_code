import ast
import util

class SemanticAnalyzer (ast.Visitor):    

    def __init__ (self, emitter):
        self.out = emitter
        self.e = emitter
        self.classes = {}
        self.static = False
        self.curClassName = None
        self.inFuncDecl = False
        self.inClassFuncDecl = False
        self.construct = False
        self.inClass = False

    def visitClassA(self, c_):
        cname = c_.cname.value                  
        self.classes[cname] = {
            'super': None,
            'fields':[], 
            'statics':[], 
            'cargs':[], 
            'methods':[],
            'smethods': [],
            }
        self.curClassName = cname
        super = None
        if c_.csuper:
            super = c_.csuper.value
            self.classes[cname]['super'] = c_.csuper.value
        else:
            self.classes[cname]['super'] = None
        self.inClass = True
        c_.cbody.accept(self)
        self.inClass = False

    def visitCBlock(self, b_):
        for o in b_.children:
            self.static = o[1]
            o[0].accept(self)

    def visitFunctionDecl (self, decl):
        if self.inClass:
            oldClassFuncDecl = self.inClassFuncDecl
            self.inClassFuncDecl = True
            if self.static:
                self.classes[self.curClassName]['smethods'].append(
                    (decl.name.value, decl.function, True))
                self.static = False
            else:
                if decl.name.value == self.curClassName:
                    self.classes[self.curClassName]['methods'].append(
                        (decl.name.value,decl.function, False))
                    self.construct = True
                else:
                    self.classes[self.curClassName]['methods'].append(
                        (decl.name.value,decl.function, False))
        decl.name.accept (self)
        oldfunc = self.inFuncDecl
        self.inFuncDecl = True
        decl.function.accept (self)
        self.inFuncDecl = oldfunc
        if self.inClass:
            self.inClassFuncDecl = oldClassFuncDecl
        
    def visitFunction (self, function):
        if self.inClass:
            chilun = function.parameters.children
            if self.construct:
                self.construct = False
                cargs = []
                if len(chilun) > 0:
                    first = True
                    for c in function.parameters.children:
                        if c:
                            cargs.append(c[0].value)
                            #if c[1]:
                                #print "1:",c[1]
                                #c[1].accept(self)
                self.classes[self.curClassName]['cargs'] = cargs

            oldfunc = self.inFuncDecl
            self.inFuncDecl = False
            function.body.accept (self)
            self.inFuncDecl = oldfunc
       
    #-----Variables-------#      
    def visitVarDecl (self, decl):
        if self.inClass and (not self.inClassFuncDecl):
            if self.static:
                self.classes[self.curClassName]['statics'].append(
                    (decl.name.value,decl.initializer))
            else:
                if decl.initializer == None: 
                    val = 'null'
                else:
                    val = decl.initializer.value
                #print decl.initializer, type(decl.initializer)
                #print type(decl.initializer) == "instance"
                self.classes[self.curClassName]['fields'].append(
                    (decl.name.value,val))
            if decl.initializer:
                decl.initializer.accept (self) 


    def visitNew (self, new):
        new.object.accept (self)
        new.arguments.accept (self)

    def visitAssignment (self, assn):
        assn.lhs.accept (self)
        assn.rhs.accept (self)
        
    def visitIn(self, decl):
        pass
