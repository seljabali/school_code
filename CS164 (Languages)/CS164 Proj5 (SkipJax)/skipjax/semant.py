from ast import *
import util


def analyzeJS (AST):
    return JSAnalyzer (AST).analyze ()


def analyzeSkipjax (AST):
    return SkipjaxAnalyzer (AST).analyze ()


##
# XXX/TODO: check for incr/decr expressions as lvalues?
#
class JSAnalyzer (MutatingVisitor):
    # Mutating because we might do optimizations
    def __init__ (self, AST):
        self.AST = AST
        self.canBreak = False
        self.canContinue = False
        self.canReturn = False


    def analyze (self):                 # analyze THIS
        return self.AST.accept (self)


    def visitAssignment (self, assn):
        assn = self.defaultVisit (assn)
        if hasattr (assn.lhs, 'notAssignable'):
            util.error ('"Invalid left-hand side of assignment.')
        return assn


    def visitBreak (self, brek):
        if not self.canBreak:
            util.error('Break statement outside loop or switch statement')
        return brek


    def visitContinue (self, cont):
        if not self.canContinue:
            util.error('Continue statement outside loop.');
        return cont


    def visitReturn (self, ret):
        if not self.canReturn:
            util.error('Return statement outside function body.')
        return ret


    def visitFunction (self, function):
        couldReturn = self.canReturn
        self.canReturn = True

        couldBreak = self.canBreak;  couldContinue = self.canContinue
        self.canBreak = False;       self.canContinue = False;

        function = self.defaultVisit (function)

        self.canBreak = couldBreak;  self.canContinue = couldContinue
        self.canReturn = couldReturn

        return function


    def _visitLoop (self, loop):
        couldBreak = self.canBreak;  couldContinue = self.canContinue
        self.canBreak = self.canContinue = True
        loop = self.defaultVisit (loop)
        self.canBreak = couldBreak;  self.canContinue = couldContinue
        return loop


    def visitWhile (self, while_):
        return self._visitLoop (while_)

    def visitDo (self, do):
        return self._visitLoop (do)
        
    def visitFor (self, for_):
        return self._visitLoop (for_)

    def visitForIn (self, forin):
        return self._visitLoop (forin)

    def visitSwitch (self, switch):
        couldBreak = self.canBreak
        self.canBreak = True
        switch = self.defaultVisit (switch)
        self.canBreak = couldBreak
        return switch



class SkipjaxAnalyzer (JSAnalyzer):
    pass
