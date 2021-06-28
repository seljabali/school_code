##
 # @file util.py
 #
 # $Id: util.py,v 1.2 2007/04/04 23:08:52 cgjones Exp $
import re, sys

def doImports (moduleNames):
    '''Imports the modules named in the sequence MODULES into a new global
    object (dictionary).
    Returns the new global object.
    '''
    glob = {}
    for module in moduleNames:
        exec ('import %s'% (module), glob)
    return glob


def createFunction (name, args, code, env):
    '''Create and return the function NAME.
    NAME, ARGS, and CODE represent the function signature and body.  ENV
    is the environment in which to define the function NAME.

    The function will be created as:
      def NAME (arg0, arg1, ...): CODE
    '''
    strArgs = ','.join (args)
    code = re.sub (r'\r\n|\r', '\n', code) # windoze
    exec ('def %s(%s):%s'% (name, strArgs, code), env)
    return env[name]


_nextNum = 0
def uniqueIdentifier ():
    '''Return an identifier that has never before been returned by
    uniqueIdentifier ().
    '''
    global _nextNum
    _nextNum += 1
    return 'f%d'%(_nextNum)


def error (message):
    '''Print MESSAGE to stderr and exit with non-zero code.'''
    print >>sys.stderr, message
    sys.exit (1)
