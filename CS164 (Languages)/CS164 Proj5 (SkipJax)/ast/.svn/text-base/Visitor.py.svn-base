from Node import *

class MutatingVisitor:
    def defaultVisit (self, node):
        for i, child in enumerate (node.children):
            if not issubclass (child.__class__, Node):
                continue

            node.children[i] = child.accept (self)

            attr = self.findAttr (node, child)
            if attr:
                setattr (node, attr, node.children[i])

        return node


    def findAttr (self, node, child):
        for attr in dir (node):
            if child is getattr (node, attr):
                return attr
    

class Visitor:
    def visitScript (self, script):
        print 'Script'
        script.statements.accept (self)

    # === Leaf literals ===

    def visitNumber (self, number):
        print 'Number "%s"'% (number.value)

    def visitString (self, string):
        print 'String "%s"'% (string.value)

    def visitRegex (self, regex):
        print 'Regex "%s"'% (regex.value)

    def visitTrue (self, true):
        print 'True'

    def visitFalse (self, false):
        print 'False'

    def visitNull (self, null):
        print 'Null'


    # === Other literals ===

    def visitArrayInit (self, array):
        print 'Array init'
        for child in array.children:
            child.accept (self)

    def visitObjectInit (self, obj):
        print 'Object init'
        for child in obj.children:
            child.accept (self)

    def visitPropertyInit (self, prop):
        print 'Property init'
        prop.property.accept (self)
        prop.value.accept (self)


    # === Miscellaneous ===

    def visitIdentifier (self, id):
        print 'Identifier "%s"'% (id.value)

    def visitThis (self, this):
        print 'This'

    def visitIndex (self, index):
        print 'Index'
        index.property.accept (self)
        index.object.accept (self)

    def visitSelection (self, sel):
        print 'Selection'
        sel.property.accept (self)
        sel.object.accept (self)


    # === Expressions ===
    
    def visitAssignment (self, assn):
        print 'Assignment %s'% (assn.operator)
        assn.lhs.accept (self)
        assn.rhs.accept (self)
    
    def visitInfixExpression (self, expr):
        print 'Infix expression %s'% (expr.operator)
        expr.lhs.accept (self)
        expr.rhs.accept (self)

    def visitPrefixExpression (self, expr):
        print 'Prefix expression %s'% (expr.operator)
        expr.operand.accept (self)

    def visitPostfixExpression (self, expr):
        print 'Prefix expression %s'
        expr.operand.accept (self)

    def visitVoid (self, void):
        print 'Void'
        void.value.accept (self)

    def visitDelete (self, delete):
        print 'Delete'
        delete.value.accept (self)

    def visitIn (self, inexpr):
        print 'In'
        inexpr.property.accept (self)
        inexpr.object.accept (self)

    def visitConditional (self, cond):
        print 'Conditional'
        cond.condition.accept (self)
        cond.thenPart.accept (self)
        cond.elsePart.accept (self)

    def visitArgumentList (self, ls):
        print 'Argument list'
        for child in ls.children:
            child.accept (self)

    def visitCall (self, call):
        print 'Call'
        call.function.accept (self)
        call.arguments.accept (self)

    def visitNew (self, new):
        print 'New'
        new.object.accept (self)
        new.arguments.accept (self)

    def visitFunction (self, function):
        print 'Function'
        function.parameters.accept (self)
        function.body.accept (self)

    def visitComma (self, comma):
        print 'Comma'
        for child in comma.children:
            comma.children.accept (self)

    def visitInstanceof (self, instof):
        print 'Instanceof'
        instof.value.accept (self)
        instof.type.accept (self)

    def visitTypeof (self, typeof):
        print 'Typeof'
        typeof.value.accept (self)


    # === Statements ===

    def visitBlock (self, block):
        print 'Block'
        for child in block.children:
            child.accept (self)

    def visitEmptyStatement (self, stmt):
        print 'Empty statement'

    def visitExpressionStatement (self, stmt):
        print 'Expression statement'
        stmt.expression.accept (self)

    def visitVarDecls (self, decls):
        print 'Variable declarations'
        for child in decls.children:
            child.accept (self)

    def visitVarDecl (self, decl):
        print 'Declaration'
        decl.name.accept (self)
        decl.initializer.accept (self)

    def visitFunctionDecl (self, decl):
        print 'Function declaration'
        decl.name.accept (self)
        decl.function.accept (self)

    def visitBreak (self, brek):
        print 'Break'

    def visitContinue (self, cont):
        print 'Continue'

    def visitReturn (self, ret):
        print 'Return'
        ret.value.accept (self)

    def visitIf (self, if_):
        print 'If'
        if_.condition.accept (self)
        if_.thenPart.accept (self)
        if_.elsePart.accept (self)

    def visitWith (self, with):
        print 'With'
        with.object.accept (self)
        with.body.accept (self)

    def visitWhile (self, while_):
        print 'While'
        while_.condition.accept (self)
        while_.body.accept (self)

    def visitDo (self, do):
        print 'Do ... while'
        do.condition.accept (self)
        do.body.accept (self)

    def visitFor (self, for_):
        print 'For'
        for_.setup.accept (self)
        for_.condition.accept (self)
        for_.update.accept (self)
        for_.body.accept (self)

    def visitForIn (self, forin):
        print 'For ... in'
        forin.iterator.accept (self)
        forin.object.accept (self)
        forin.body.accept (self)
        forin.decl.accept (self)

    def visitSwitch (self, switch):
        print 'Switch'
        switch.discriminant.accept (self)
        switch.cases.accept (self)

    def visitCaseList (self, cases):
        print 'Case list'
        for child in cases.children:
            cases.children.accept (self)

    def visitCase (self, case):
        print 'Case'
        case.label.accept (self)
        cast.statements.accept (self)

    def visitDefault (self, default):
        print 'Default'
        default.statements.accept (self)


    # === Exception handling ===

    def visitThrow (self, throw):
        print 'Throw'
        throw.exception.accept (self)

    def visitCatch (self, catch):
        print 'Catch'
        if catch.exception:
            catch.exception.accept (self)
        catch.body.accept (self)

    def visitTryCatchFinally (self, tcf):
        print 'Try ... catch ... finally'
        tcf.tryBlock.accept (self)
        if tcf.catch:
            tcf.catch.accept (self)
        if tcf.finallyBlock:
            tcf.finallyBlock.accept (self)
