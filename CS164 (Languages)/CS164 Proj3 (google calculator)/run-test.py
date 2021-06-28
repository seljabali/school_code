import sys
import grammar_parser, parser_generator, lexer

args = sys.argv[1:]

if len (args) != 2: #ADDED
    print >>sys.stderr, 'Usage: python run-test.py GRAMMAR-FILE INPUT-FILE'
    sys.exit (1)


grammarFile = args[0]
inputFile = args[1]

grammar = grammar_parser.parseFile (grammarFile)
(ok, msg) = grammar.validate ()

if not ok:
    print >>sys.stderr, 'Invalid grammar:', msg
    sys.exit (1)


parser = parser_generator.makeParser (grammar)
result = parser.parse ((open (inputFile)).read ())

print result