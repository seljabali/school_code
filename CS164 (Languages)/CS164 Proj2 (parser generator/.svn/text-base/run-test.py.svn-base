import sys
import grammar_parser

args = sys.argv[1:]

if len (args) != 1:
    print >>sys.stderr, 'Usage: python run-test.py TEST-FILE'
    sys.exit (1)

grammar = grammar_parser.parseFile (args[0])
(ok, msg) = grammar.validate ()

if not ok:
    print >>sys.stderr, 'Invalid grammar:', msg
    sys.exit (1)

grammar.dump (sys.stdout)
