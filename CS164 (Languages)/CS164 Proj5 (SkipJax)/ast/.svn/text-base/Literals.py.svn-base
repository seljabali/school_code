import sys
from Node import *

class _Leaf (Node):
    '''The base class of "leaf" literals: those that appear at the
    bottom of an AST.

    A _Leaf may or may not have an actual value, but it always has a
    VALUE field.  VALUE may be None.
    '''
    def __init__ (self, value=None):
        Node.__init__ (self, value)
        self.value = value
        self.notAssignable = True


    def dump (self, out=sys.stdout, level=0):
        if self.value is not None:  value = ' "%s"'% (self.value)
        else:                       value = ''
        self.printdent (out, level, '(%s%s)'% (self.getName (), value))
        return out


class Number (_Leaf):
    '''A Number.  The (string) value is in the field "value."'''
    def __init__ (self, number):
        _Leaf.__init__ (self, number)


class String (_Leaf):
    '''A String.  The string is in the field "value."'''
    def __init__ (self, string):
        _Leaf.__init__ (self, string)


class Regex (_Leaf):
    '''A regular expression.  The (string) regex is in the field "value."'''
    def __init__ (self, pattern):
        _Leaf.__init__ (self, pattern)


class True_ (_Leaf):
    '''The "true" literal.'''
    def __init__ (self):
        _Leaf.__init__ (self)

    def getName (self):
        return 'True'


class False_ (_Leaf):
    '''The "false" literal.'''
    def __init__ (self):
        _Leaf.__init__ (self)

    def getName (self):
        return 'False'


class Null (_Leaf):
    '''The "null" literal.'''
    def __init__ (self):
        _Leaf.__init__ (self)


class ArrayInit (Node):
    '''An array initializer.  The array items are stored in self.children.'''
    def __init__ (self, *args):
        Node.__init__ (self, *args)
        self.notAssignable = True


class ObjectInit (Node):
    '''An object initializer.  The properties are stored in self.children.'''
    def __init__ (self, *args):
        Node.__init__ (self, *args)
        self.notAssignable = True


class PropertyInit (Node):
    '''Initializer of self.property to self.value.'''
    def __init__ (self, prop, value):
        Node.__init__ (self, prop, value)
        self.property = prop
        self.value = value


class Function (Node):
    '''A function literal.'''
    def __init__ (self, parameters, body):
        Node.__init__ (self, parameters, body)
        self.parameters = parameters
        self.body = body
        self.notAssignable = True
