import sys
from Node import *

class _OpExpr (Node):
    def __init__ (self, operator, *operands):
        Node.__init__ (self, *operands)
        self.operator = operator

    
    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '(%s %s'% (self.getName (), self.operator))
        self.children[0].dump (out, level + 1)
        if len (self.children) == 2:
            self.children[1].dump (out, level + 1)
        self.printdent (out, level, ')')
        return out

    
class InfixExpression (_OpExpr):
    def __init__ (self, operator, lhs, rhs):
        _OpExpr.__init__ (self, operator, lhs, rhs)
        self.lhs = lhs
        self.rhs = rhs


class Assignment (InfixExpression):
    pass


class IndexAssignment (_OpExpr):
    def __init__ (self, operator, prop, obj, rhs):
        _OpExpr.__init__ (self, operator, prop, obj, rhs)
        self.property = prop
        self.object = obj
        self.rhs = rhs


class PrefixExpression (_OpExpr):
    def __init__ (self, operator, operand):
        _OpExpr.__init__ (self, operator, operand)
        self.operand = operand


class PostfixExpression (_OpExpr):
    def __init__ (self, operator, operand):
        _OpExpr.__init__ (self, operator, operand)
        self.operand = operand


class Void (Node):
    def __init__ (self, value):
        Node.__init__ (self, value)
        self.value = value


class Delete (Node):
    def __init__ (self, value):
        Node.__init__ (self, value)
        self.value = value


class In (Node):
    def __init__ (self, prop, obj):
        Node.__init__ (self, prop, obj)
        self.property = prop
        self.object = obj


class Conditional (Node):
    def __init__ (self, condition, thenPart, elsePart):
        Node.__init__ (self, condition, thenPart, elsePart)
        self.condition = condition
        self.thenPart = thenPart
        self.elsePart = elsePart


class ArgumentList (NodeList):
    pass


class Call (Node):
    def __init__ (self, function, arguments):
        Node.__init__ (self, function, arguments)
        self.function = function
        self.arguments = arguments


class MethodCall (Node):
    def __init__ (self, prop, obj, arguments):
        Node.__init__ (self, prop, obj, arguments)
        self.property = prop
        self.obj = obj
        self.arguments = arguments


class New (Node):
    def __init__ (self, obj, arguments):
        Node.__init__ (self, obj, arguments)
        self.object = obj
        self.arguments = arguments


class Comma (Node):
    pass


class Instanceof (Node):
    def __init__ (self, value, typ):
        Node.__init__ (self, value, typ)
        self.value = value
        self.type = typ


class Typeof (Node):
    def __init__ (self, value):
        Node.__init__ (self, value)
        self.value = value
