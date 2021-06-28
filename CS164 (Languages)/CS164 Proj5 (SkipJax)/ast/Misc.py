import sys
from Node import Node


class Script (Node):
    def __init__ (self, statements):
        Node.__init__ (self, statements)
        self.statements = statements


class Identifier (Node):
    '''An Identifier.'''
    def __init__ (self, identifier):
        Node.__init__ (self, identifier)
        self.value = identifier

    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '(%s "%s")'% (self.getName (), self.value))
        return out


class This (Node):
    '''The "this" reference.'''
    def __init__ (self):
        Node.__init__ (self)

    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '(This)')
        return out


class Index (Node):
    '''An index reference: object[property].'''
    def __init__ (self, prop, object):
        Node.__init__ (self, prop, object)
        self.property = prop
        self.object = object


class Selection (Index):
    '''A property selection: object.property.'''
    pass
