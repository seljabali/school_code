import parser_generator, grammar_parser, sys, getopt
from semant import *
from cgen import *
from emit import *
from TypeChecker import *

USAGE_STRING = """USAGE:
python js2p.py INPUT-FILE.js [-o OUPUT-FILE-NAME]"""
def usage ():
    print USAGE_STRING
    sys.exit (2)


def main (argv):
    try:
        opts, args = getopt.gnu_getopt (argv, 'o:')
    except getopt.GetoptError:
        usage ()

    if len (opts) > 1 or len (args) < 1:
        usage ()

    grammarFile = './javascript2.grm'
    inputFileName = args[0]
    if len(opts) > 0:
        outputFileName = opts[0][1]
    else:
        outputFileName = None

    parser = parser_generator.makeParser (grammar_parser.parseFile (grammarFile))
    
    ast = parser.parse (open (inputFileName).read ())

    if outputFileName:
        emitter = Emitter (open (outputFileName, 'w'))
    else:
        emitter = Emitter ()


#    emitter.comment ('==Pre-Type Checking==')
#    pretypes = preTypes (emitter)
#    ast.accept (pretypes)
#
#    emitter.comment ('==Type Checking==')
#    types = TypeCheck(emitter)
#    ast.accept (types)
    

    emitter.comment ('==Pre-Cgen==')
    semant = SemanticAnalyzer (emitter)
    ast.accept (semant)
                
    #print semant.classes['B']     
        
    emitter.comment ('==Code Gen Phase==')
    ast.accept (CodeGenerator (emitter, semant))

if __name__ == '__main__':
    main (sys.argv[1:])
