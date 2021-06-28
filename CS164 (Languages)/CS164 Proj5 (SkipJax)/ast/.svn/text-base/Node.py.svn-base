import sys
from cStringIO import StringIO

class Node:
    '''The base class of all AST nodes.'''
    
    def __init__ (self, *args):
        '''Assign self.children to a list created from args.'''
        self.children = list (args)     # the children of this node


    def add (self, node, idx=None):
        '''If idx is not specified, append node to
        self.children. Otherwise, insert node before idx.
        '''
        if idx is None:
            self.children.append (node)
        else:
            self.children.insert (idx, node)


    def accept (self, visitor):
        '''Call the visit[class name]() method of visitor. The [class
        name] is determined by self.getName().

        If visitor does not have this method, accept() raises an
        AttributeError.
        '''
        methodName = 'visit%s'% (self.getName ())
        method = getattr (visitor, methodName, None)
        if callable (method):
            return method (self)
        else:
            method = getattr (visitor, 'defaultVisit')
            if callable (method):
                return method (self)
            else:
                raise AttributeError, 'No %s or default method in visitor'% (
                    methodName)


    def getName (self):
        '''The "name" of this node; e.g., "InfixExpression." This
        default implementation returns self.__class__.__name__.
        '''
        return self.__class__.__name__


    def dump (self, out=sys.stdout, level=0):
        '''Print a representation of this node and its children to
        out, at "indentation level" level. The number of spaces
        printed in front of this node is 2*level.
        '''
        self.printdent (out, level, '(%s '% (self.getName ()))
        for child in self.children:
            child.dump (out, level + 1)
        self.printdent (out, level, ')')
        return out


    def printdent (self, out, level, s, newline=True):
        '''Print S to OUT at indentation level LEVEL.  Optionally
        print a newline after S.
        '''
        string ='%s%s'% (' ' * (2 * level), s)
        if newline:  print >>out, string
        else:        print >>out, string,


    def __str__ (self):
        s = StringIO ()
        ret = self.dump (s).getvalue ()
        s.close ()
        return ret


class NodeList (Node):
    def dump (self, out=sys.stdout, level=0):
        self.printdent (out, level, '[')
        for child in self.children:
            child.dump (out, level + 1)
        self.printdent (out, level, ']')
        return out
