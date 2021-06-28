import sys
from Node import *

class _Statement (Node):
    def __init__ (self, *args):
        Node.__init__ (self, *args)
        self.labels = []


    def addLabel (self, label):
        self.labels.append (label)

    
    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '(%s '% (self.getName ()))
        self.dumpLabels (out, level + 1)
        for child in self.children:
            child.dump (out, level + 1)
        self.printdent (out, level, ')')
        return out

    def dumpLabels (self, out=sys.stdout, level=0):
        if len (self.labels) > 0:
            self.printdent (out, level, '(Labels ')
            for label in self.labels:
                label.dump (out, level + 1)
            self.printdent (out, level, ')')
        return out


class _StatementList (_Statement):
    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '[')
        self.dumpLabels (out, level + 1)
        for child in self.children:
            if not isinstance (child, EmptyStatement):
                child.dump (out, level + 1)
        self.printdent (out, level, ']')
        return out


class Block (_StatementList):
    pass
    

class EmptyStatement (_Statement):
    def __init__ (self):
        _Statement.__init__ (self)

    
    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '(Empty)')
        return out


class ExpressionStatement (_Statement):
    def __init__ (self, expression):
        _Statement.__init__ (self, expression)
        self.expression = expression


class VarDecls (_StatementList):
    pass


class VarDecl (Node):
    def __init__ (self, name, initializer=None):
        if initializer: Node.__init__ (self, name, initializer)
        else:           Node.__init__ (self, name)
        self.name = name
        self.initializer = initializer


class FunctionDecl (_Statement):
    def __init__ (self, name, function):
        _Statement.__init__ (self, name, function)
        self.name = name
        self.function = function


class Return (_Statement):
    def __init__ (self, value=None):
        if value:  _Statement.__init__ (self, value)
        else:      _Statement.__init__ (self)
        self.value = value

    def dump (self, out=sys.stdout, level=0):
        if self.value or len (self.labels) > 0:
            return _Statement.dump (self, out, level)
        else:
            self.printdent (out, level, '(Return)')
            return out


class If (_Statement):
    def __init__ (self, condition, thenPart, elsePart=None):
        if elsePart:  _Statement.__init__ (self, condition, thenPart, elsePart)
        else:         _Statement.__init__ (self, condition, thenPart)
        self.condition = condition
        self.thenPart = thenPart
        self.elsePart = elsePart


class With (_Statement):
    def __init__ (self, obj, body):
        _Statement.__init__ (self, obj, body)
        self.object = obj
        self.body = body


class Break (_Statement):
    def __init__ (self, goto=None):
        if goto:  _Statement.__init__ (self, goto)
        else:     _Statement.__init__ (self)
        self.goto = goto
    
    def dump (self, out=sys.stdout, level=0):
        if self.goto or len (self.labels) > 0:
            _Statement.dump (self, out, level)
        else:
            self.printdent (out, level, '(%s)'% (self.getName ()))
        return out


class Continue (Break):
    pass


class While (_Statement):
    def __init__ (self, condition, body):
        _Statement.__init__ (self, condition, body)
        self.condition = condition
        self.body = body


class Do (While):
    pass


class For (_Statement):
    def __init__ (self, setup, condition, update, body):
        _Statement.__init__ (self, setup, condition, update, body)
        self.setup = setup
        self.condition = condition
        self.update = update
        self.body = body


class ForIn (_Statement):
    def __init__ (self, iterator, object, body, decl=None):
        if decl:  _Statement.__init__ (self, decl, iterator, object, body)
        else:     _Statement.__init__ (self, iterator, object, body)
        self.iterator = iterator
        self.object = object
        self.body = body
        self.decl = decl


class Switch (_Statement):
    def __init__ (self, discriminant, cases):
        _Statement.__init__ (self, discriminant, cases)
        self.discriminant = discriminant
        self.cases = cases


class CaseList (NodeList):
    pass


class Case (Node):
    def __init__ (self, label, statements):
        if label:  Node.__init__ (self, label, statements)
        else:      Node.__init__ (self, statements)
        self.label = label
        self.statements = statements


class Default (Case):
    def __init__ (self, statements):
        Case.__init__ (self, None, statements)


class Throw (_Statement):
    def __init__ (self, exception):
        _Statement.__init__ (self, exception)
        self.exception = exception


class Catch (Node):
    def __init__ (self, exception, block):
        Node.__init__ (self, exception, block)
        self.exception = exception
        self.body = block


class TryCatchFinally (_Statement):
    def __init__ (self, tryBlock, catch=None, finallyBlock=None):
        if catch and finallyBlock:
            _Statement.__init__ (self, tryBlock, catch, finallyBlock)
        elif catch:
            _Statement.__init__ (self, tryBlock, catch)
        elif finallyBlock:
            _Statement.__init__ (self, tryBlock, finallyBlock)
        else:
            _Statement.__init__ (self, tryBlock)
        self.tryBlock = tryBlock
        self.catch = catch
        self.finallyBlock = finallyBlock
