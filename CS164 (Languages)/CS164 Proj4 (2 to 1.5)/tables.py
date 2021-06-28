class Environment:
    def __init__(self, parent):
        self.parent = parent
        self.typeof = {}
        self.envof = {}
        self.static = {}

    def lookup(self, id):
        if id in self.typeof.keys():
            return self.typeof[id]
        elif self.parent:
            return self.parent.lookup(id)
        else:
            return None

    def staticlookup(self, id):
        if id in self.static.keys():
            return self.typeof[id]
        elif self.parent:
            return self.parent.staticlookup(id)
        else:
            return None

    def toString(self):
        s = ''
        if self.parent:
            s += 'Parent: '
            s += str(self.parent)
            s += ';'
        s += '\nTypeof: '
        for t in self.typeof.keys():
            s += t + ', ' + str(self.typeof[t]) + '; '
        s += '\nEnvof: '
        for e in self.envof.keys():
            s += e + '= {' + self.envof[e].toString() + '}' + '; '
        s += '\nStatic: '
        for c in self.static.keys():
            s += c + ';'
        return s