from ast import *


def rewriteJS (AST):
    print 'rewriteJs'
    return JSRewrite (AST).rewrite ()


def rewriteSkipjax (AST):
    print 'rewriteSkipjax'
    return SkipjaxRewrite (AST).rewrite ()


class JSRewrite (MutatingVisitor):
    def __init__ (self, AST):
        self.AST = AST


    def rewrite (self):
        return self.AST.accept (self)


    def visitAssignment (self, assn):
        self.defaultVisit (assn)
        
        if isinstance (assn.lhs, Index):
            return IndexAssignment (
                assn.operator,
                assn.lhs.property, assn.lhs.object, assn.rhs).accept (self)
        else:
            return assn


    def visitCall (self, call):
        self.defaultVisit (call)

        if isinstance (call.function, Index):
            return MethodCall (call.function.property,
                               call.function.object,
                               call.arguments).accept (self)
        else:
            return call


    def visitSelection (self, sel):
        self.defaultVisit (sel)
        return Index (String (sel.property.value), sel.object)



class SkipjaxRewrite (JSRewrite):

    def visitAssignment (self, assn):
        self.defaultVisit (assn)
        if isinstance (assn.lhs, Index):
            return IndexAssignment (
                assn.operator,
                assn.lhs.property, assn.lhs.object, assn.rhs).accept (self)
        elif len(assn.operator) > 1:
            return Assignment('=',
                              assn.lhs,
                              InfixExpression(assn.operator[0:1], assn.lhs, assn.rhs)
                              ).accept(self)
        else:    
            return assn

                

    def visitPrefixExpression (self, e):
        self.defaultVisit(e)
        return self._handleUnaryExpr(e)

    def visitPostfixExpression (self, e):
        self.defaultVisit(e)
        return self._handleUnaryExpr(e)

    def _handleUnaryExpr (self, e):
        if e.operator == '++':
            operator = '+'
        elif e.operator == '--':
            operator = '-'
        else:
            return e
        infixExpression = InfixExpression(operator, e.operand, Number('1'))
        return Assignment('=', e.operand, InfixExpression(operator, e.operand, Number('1'))).accept(self)
