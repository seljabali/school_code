import sys

class Emitter:
    def __init__ (self, out=sys.stdout):
        self.level = 0
        self.startOfLine = True
        self.out = out
        self.string = ''

    def indent (self):
        self.level += 1

    def dedent (self):
        self.level -= 1
        if self.level < 0:
            self.level = 0
            raise 'Cannot dedent further.'

    def printdent (self, s, endLine=False):
        string = ''
        if self.startOfLine:
            string = '    ' * self.level
        string += s
        self.string += string
        self.startOfLine = False
        if endLine:
            self.endline ()

    def endline (self):
        print >>self.out, self.string
        self.startOfLine = True
        self.string = ''

    def comment (self, text):
        if self.startOfLine:
            space = ''
        else:
            space = ' '
        self.printdent (space + '// ' + text, True)


    # XXX more??
