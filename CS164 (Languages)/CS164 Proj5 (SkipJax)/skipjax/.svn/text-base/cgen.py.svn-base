import cStringIO, sys
from ast import *
import emit


def codegenJS (AST, out):
    return JSCodeGen (AST).cgen (out)


def codegenSkipjax (AST, out):
    return SkipjaxCodeGen (AST).cgen (out)


class JSCodeGen:
    def __init__ (self, AST):
        self.AST = AST


    def cgen (self, out=sys.stdout):
        self.out = emit.Emitter (out)
        self.AST.accept (self)
        self.out.printdent ('', endLine=True)


    def defaultVisit (self, node):
        raise 'Whoopsie!  No cgen() for the ast node:', node.__class__.__name__


    def visitScript (self, script):
        for stmt in script.statements.children:
            stmt.accept (self)


    def visitNumber (self, number):
        self.out.printdent (number.value)

    def visitString (self, string):
        buf = cStringIO.StringIO ()
        
        buf.write ('"')
        escape = False
        
        for c in string.value:
            if escape:
                escape = False
            elif c == '"':
                buf.write ('\\')
            elif c == '\\':
                escape = True
            buf.write (c)
        buf.write ('"')
        
        self.out.printdent (buf.getvalue ())

    def visitRegex (self, regex):
        self.out.printdent (regex.value)

    def visitTrue (self, t):
        self.out.printdent ('true')

    def visitFalse (self, t):
        self.out.printdent ('false')

    def visitNull (self, t):
        self.out.printdent ('null')


    def visitArrayInit (self, array):
        self.out.printdent ('[')
        for child in array.children:
            child.accept (self)
            self.out.printdent (', ')
        self.out.printdent (']')

    def visitObjectInit (self, obj):
        self.out.printdent ('{')

        self.out.indent ()
        for child in obj.children:
            child.accept (self)
            self.out.printdent (',', endLine=True)
        self.out.dedent ()

        self.out.printdent ('}')

    def visitPropertyInit (self, prop):
        prop.property.accept (self)
        self.out.printdent (': ')
        prop.value.accept (self)


    def visitIdentifier (self, id):
        self.out.printdent (id.value)

    def visitThis (self, this):
        self.out.printdent ('this')

    def visitIndex (self, index):
        index.object.accept (self)
        self.out.printdent ('[')
        index.property.accept (self)
        self.out.printdent (']')


    def visitAssignment (self, assn):
        assn.lhs.accept (self)
        self.out.printdent (' %s '% (assn.operator))
        assn.rhs.accept (self)

    def visitIndexAssignment (self, assn):
        assn.object.accept (self)
        self.out.printdent ('[')
        assn.property.accept (self)
        self.out.printdent (']')
        self.out.printdent (' %s '% (assn.operator))
        assn.rhs.accept (self)

    def visitInfixExpression (self, expr):
        self.out.printdent ('(')
        expr.lhs.accept (self)
        self.out.printdent (' %s '% (expr.operator))
        expr.rhs.accept (self)
        self.out.printdent (')')

    def visitPrefixExpression (self, expr):
        self.out.printdent ('%s'% (expr.operator))
        expr.operand.accept (self)

    def visitPostfixExpression (self, expr):
        expr.operand.accept (self)
        self.out.printdent ('%s'% (expr.operator))

    def visitVoid (self, void):
        self.out.printdent ('void (')
        void.value.accept (self)
        self.out.printdent (')')

    def visitDelete (self, delete):
        self.out.printdent ('delete ')
        delete.value.accept (self)

    def visitIn (self, inexpr):
        inexpr.property.accept (self)
        self.out.printdent (' in ')
        inexpr.object.accept (self)

    def visitConditional (self, cond):
        self.out.printdent ('(')
        cond.condition.accept (self)
        self.out.printdent (' ? ')
        cond.thenPart.accept (self)
        self.out.printdent (' : ')
        cond.elsePart.accept (self)
        self.out.printdent (')')

    def visitArgumentList (self, args):
        for i, arg in enumerate (args.children):
            arg.accept (self)
            if i < (len (args.children) - 1):
                self.out.printdent (', ')

    def visitCall (self, call):
        call.function.accept (self)
        self.out.printdent (' (')
        call.arguments.accept (self)
        self.out.printdent (')')

    def visitMethodCall (self, call):
        call.obj.accept (self)
        self.out.printdent ('[')
        call.property.accept (self)
        self.out.printdent (']')
        self.out.printdent (' (')
        call.arguments.accept (self)
        self.out.printdent (')')

    def visitNew (self, new):
        self.out.printdent ('new ');
        new.object.accept (self)
        self.out.printdent (' (')
        new.arguments.accept (self)
        self.out.printdent (')')

    def visitFunction (self, function, decl=False):
        if not decl:
            self.out.printdent ('function ')

        self.out.printdent ('(')
        function.parameters.accept (self)
        self.out.printdent (') ')

        function.body.accept (self)

    def visitNodeList (self, nl):
        # Assume they want a comma-separated list printed
       for i, node in enumerate (nl.children):
           node.accept (self)
           if i < (len (nl.children) - 1):
               self.out.printdent (', ')


    def visitComma (self, comma):
        for i, expr in enumerate (comma.children):
            expr.accept (self)
            if i < (len (comma.children) - 1):
                self.out.printdent (', ')

    def visitInstanceof (self, instof):
        instof.value.accept (self)
        self.out.printdent (' instanceof ')
        instof.type.accept (self)

    def visitTypeof (self, typeof):
        self.out.printdent ('typeof ')
        typeof.value.accept (self)



    def visitBlock (self, block):
        self.out.printdent ('{', endLine=True)
        self.out.indent ()

        for stmt in block.children:
            stmt.accept (self)

        self.out.dedent ()
        self.out.printdent ('}', endLine=True)

    def visitEmptyStatement (self, stmt):
        pass

    def visitExpressionStatement (self, stmt):
        stmt.expression.accept (self)
        self.out.printdent (';', endLine=True)

    def visitVarDecls (self, decls):
        self.out.printdent ('var ')
        for i, decl in enumerate (decls.children):
            decl.accept (self)
            if i < (len (decls.children) - 1):
                self.out.printdent (', ')
        self.out.printdent (';', endLine=True)

    def visitVarDecl (self, decl):
        decl.name.accept (self)
        if decl.initializer:
            self.out.printdent (' = ')
            decl.initializer.accept (self)

    def visitFunctionDecl (self, decl):
        self.out.printdent ('function ')
        decl.name.accept (self)
        self.out.printdent (' ')
        self.visitFunction (decl.function, decl=True)

    def visitBreak (self, b):
        self.out.printdent ('break;', endLine=True);

    def visitContinue (self, c):
        self.out.printdent ('continue;', endLine=True);

    def visitReturn (self, ret):
        self.out.printdent ('return')
        if ret.value:
            self.out.printdent (' ')
            ret.value.accept (self)
        self.out.printdent (';', endLine=True)

    def visitIf (self, if_):
        self.out.printdent ('if (')
        if_.condition.accept (self)
        self.out.printdent (') ')
        if_.thenPart.accept (self)
        if if_.elsePart:
            self.out.printdent (' else ')
            if_.elsePart.accept (self)

    def visitWith (self, with):
        self.out.printdent ('with (')
        with.object.accept (self)
        self.out.printdent (') ')
        with.body.accept (self)

    def visitWhile (self, while_):
        self.out.printdent ('while (')
        while_.condition.accept (self)
        self.out.printdent (') ')
        while_.body.accept (self)

    def visitDo (self, do):
        self.out.printdent ('do ')
        do.body.accept (self)
        self.out.printdent (' while (')
        do.condition.accept (self)
        self.out.printdent (');', endLine=True)

    def visitFor (self, for_):
        self.out.printdent ('for (')

        if isinstance (for_.setup, VarDecls):
            self.out.printdent ('var ')
            for i, decl in enumerate (for_.setup.children):
                decl.accept (self)
                if i < (len (for_.setup.children) - 1):
                    self.out.printdent (', ')
        elif for_.setup:
            for_.setup.accept (self)

        self.out.printdent ('; ')
        if for_.condition:  for_.condition.accept (self)
        self.out.printdent ('; ')
        if for_.update:     for_.update.accept (self)
        self.out.printdent (') ')
        for_.body.accept (self)

    def visitForIn (self, forin):
        self.out.printdent ('for (')
        if forin.decl:
            self.out.printdent ('var ')
            forin.decl.accept (self)
        else:
            forin.iterator.accept (self)
        self.out.printdent (' in ')
        forin.object.accept (self)
        self.out.printdent (') ')
        forin.body.accept (self)

    def visitSwitch (self, switch):
        self.out.printdent ('switch (')
        switch.discriminant.accept (self)
        self.out.printdent (') {', endLine=True)
        # conventional style says not to indent here
        switch.cases.accept (self)
        self.out.printdent ('}', endLine=True)

    def visitCaseList (self, cases):
        for case in cases.children:
            case.accept (self)

    def visitCase (self, case):
        self.out.printdent ('case ')
        case.label.accept (self)
        self.out.printdent (': ')
        case.statements.accept (self)

    def visitDefault (self, default):
        self.out.printdent ('default: ')
        default.statements.accept (self)


    def visitThrow (self, throw):
        self.out.printdent ('throw ')
        throw.exception.accept (self)

    def visitCatch (self, catch):
        self.out.printdent (' catch (')
        catch.exception.accept (self)
        self.out.printdent (') ')
        catch.body.accept (self)

    def visitTryCatchFinally (self, tcf):
        self.out.printdent ('try ')
        tcf.tryBlock.accept (self)
        if tcf.catch:
            tcf.catch.accept (self)
        if tcf.finallyBlock:
            self.out.printdent (' finally ')
            tcf.finallyBlock.accept (self)


##-----------------------------------------------------------------------------
            
class SkipjaxCodeGen (JSCodeGen):
    
    def visitIndex (self, index):
        self.out.printdent('lift (function (x1, x2) { return x1[x2]; },')    
        index.object.accept (self)
        self.out.printdent(',')
        index.property.accept (self) 
        self.out.printdent(')')  
        
    def visitInfixExpression (self, expr):
        self.out.printdent('lift (function (x1, x2) { return x1 %s x2; },'% expr.operator)
        expr.lhs.accept (self)
        self.out.printdent(',')
        expr.rhs.accept (self)
        self.out.printdent (')')
        
    def visitConditional (self, cond):
        self.out.printdent('lift (function (x1, x2, x3) { return x1 ? x2 : x3; },')
        cond.condition.accept (self)
        self.out.printdent (' , ')
        cond.thenPart.accept (self)
        self.out.printdent (' , ')
        cond.elsePart.accept (self)
        self.out.printdent (')')
        
    def visitIndexAssignment (self, assn):
        self.out.printdent('lift (function (x1, x2, x3) { return x1[x2] = x3; },')
        assn.object.accept (self)
        self.out.printdent(',')
        assn.property.accept (self)
        self.out.printdent(',')
        assn.rhs.accept (self)
        self.out.printdent (')')
        
    def visitCall (self, call):
        self.out.printdent('__maybeLiftCall (')
        call.function.accept (self)
        if len(call.arguments.children) > 0:
            self.out.printdent (' , ')
        call.arguments.accept (self)
        self.out.printdent (')')
               
    def visitVoid (self, void):
        self.out.printdent('lift (function (x1) { return void x1; },')
        void.value.accept (self)
        self.out.printdent(')')

    def visitDelete (self, delete):
        self.out.printdent('lift (function (x1) { return delete x1; },')
        delete.value.accept (self)
        self.out.printdent(')')
        
    def visitTypeof (self, typeof):
        self.out.printdent('lift (function (x1) { return typeof x1; },')
        typeof.value.accept (self)
        self.out.printdent(')')
        
    def visitMethodCall (self, call):
        '''lift (function (x1, x2, x3, ..., xn) { return x1[x2](x3, ..., xn); }, e1, ..., en)'''
        self.out.printdent('lift (function (x1, x2,')
        for i, arg in enumerate(call.arguments.children):
            self.out.printdent('x' + str(i + 3))
            if i < (len (call.arguments.children) - 1):
                self.out.printdent (', ')
        self.out.printdent(') { return x1[x2](')
        for i, arg in enumerate(call.arguments.children):
            self.out.printdent('x' + str(i + 3)) 
            if i < (len (call.arguments.children) - 1):
                self.out.printdent (', ')                   

        self.out.printdent('); },')
        call.obj.accept (self)
        self.out.printdent (', ')
        call.property.accept (self)
        self.out.printdent (', ')
        call.arguments.accept (self)
        self.out.printdent (')')
        
        
    def visitNew(self, new):
        '''lift (function (x1, x2, ..., xn) { return new x1 (x2, ..., xn); }, e1, e2, ..., en)'''
        self.out.printdent('lift (function (x1,')
        for i, arg in enumerate(new.arguments.children):
            self.out.printdent('x' + str(i + 2)) 
            if i < (len (new.arguments.children) - 1):
                self.out.printdent (', ')   
                
        self.out.printdent(') { return new x1 (')            

        for i, arg in enumerate(new.arguments.children):
            self.out.printdent('x' + str(i + 2)) 
            if i < (len (new.arguments.children) - 1):
                self.out.printdent (', ')   
                
        self.out.printdent('); },')

        new.object.accept (self)
        self.out.printdent (', ')
        new.arguments.accept (self)
        self.out.printdent (')')
        
    
    def visitArrayInit (self, array):
        self.out.printdent ('lift (mkArray,')
        for child in array.children:
            child.accept (self)
            if array.children.index(child) < len(array.children) - 1:            
                self.out.printdent (', ')
        self.out.printdent (')')
        
    def visitObjectInit (self, obj):
        self.out.printdent ('lift (mkObject,')

        self.out.indent ()
        for child in obj.children:
            child.accept (self)
            if obj.children.index(child) < len(obj.children) - 1:
                self.out.printdent (',', endLine=True)
        self.out.dedent ()

        self.out.printdent (')')

    def visitPropertyInit (self, prop):
        ident = Identifier('a')
        if type(ident) == type(prop.property):
            self.out.printdent('"')
        prop.property.accept (self)
        if type(ident) == type(prop.property):
            self.out.printdent('"')

        self.out.printdent (', ')
        prop.value.accept (self)
        
    def visitIf (self, if_):
        self.out.printdent ('if (')
        self.out.printdent('__JSValueOrDie (')
        if_.condition.accept (self)
        self.out.printdent(')')
        self.out.printdent (') ')
        if_.thenPart.accept (self)
        if if_.elsePart:
            self.out.printdent (' else ')
            if_.elsePart.accept (self)
            
    def visitWith (self, with):
        self.out.printdent ('with (')
        self.out.printdent('__JSValueOrDie (')       
        with.object.accept (self)
        self.out.printdent(')')
        self.out.printdent (') ')
        with.body.accept (self)
        
    def visitWhile (self, while_):
        self.out.printdent ('while (')
        self.out.printdent('__JSValueOrDie (')
        while_.condition.accept (self)
        self.out.printdent(')')
        self.out.printdent (') ')
        while_.body.accept (self)
        
    def visitDo (self, do):
        self.out.printdent ('do ')
        do.body.accept (self)
        self.out.printdent (' while (')
        self.out.printdent('__JSValueOrDie (')
        do.condition.accept (self)
        self.out.printdent(')')
        self.out.printdent (');', endLine=True)
        
    def visitFor (self, for_):
        self.out.printdent ('for (')

        if isinstance (for_.setup, VarDecls):
            self.out.printdent ('var ')
            for i, decl in enumerate (for_.setup.children):
                decl.accept (self)
                if i < (len (for_.setup.children) - 1):
                    self.out.printdent (', ')
        elif for_.setup:
            self.out.printdent('__JSValueOrDie (')
            for_.setup.accept (self)
            self.out.printdent(')')

        self.out.printdent ('; ')
        if for_.condition:  
            self.out.printdent('__JSValueOrDie (')
            for_.condition.accept (self)
            self.out.printdent(')')
        self.out.printdent ('; ')
        if for_.update:     
            self.out.printdent('__JSValueOrDie (')
            for_.update.accept (self)
            self.out.printdent(')')
        self.out.printdent (') ')
        for_.body.accept (self)

    def visitForIn (self, forin):
        self.out.printdent ('for (')
        if forin.decl:
            self.out.printdent ('var ')
            forin.decl.accept (self)
        else:
            forin.iterator.accept (self)
        self.out.printdent (' in ')
        self.out.printdent('__JSValueOrDie (')        
        forin.object.accept (self)
        self.out.printdent(')')
        self.out.printdent (') ')
        forin.body.accept (self)
    
    def visitVarDecl (self, decl):
        decl.name.accept (self)
        if decl.initializer:
            self.out.printdent (' = ')
            self.out.printdent('__JSValueOrDie (')
            decl.initializer.accept (self)
            self.out.printdent(')')
            
    def visitSwitch (self, switch):
        self.out.printdent ('switch (')
        self.out.printdent('__JSValueOrDie (')        
        switch.discriminant.accept (self)
        self.out.printdent(')')
        self.out.printdent (') {', endLine=True)
        # conventional style says not to indent here
        switch.cases.accept (self)
        self.out.printdent ('}', endLine=True)



    def visitCase (self, case):
        self.out.printdent ('case ')
        self.out.printdent('__JSValueOrDie (')         
        case.label.accept (self)
        self.out.printdent(')')
        self.out.printdent (': ')
        case.statements.accept (self)
