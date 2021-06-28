import sys
import grammar_parser, parser_generator 

grammarFile = 'test/google.grm'
inputFile   = 'test/google_1.in'

f = open(inputFile)
for line in f:
    print line, ' -->',
    print ""
    
    grammar = grammar_parser.parseFile (grammarFile)
    (ok, msg) = grammar.validate ()
    
    if not ok:
        print >>sys.stderr, 'Invalid grammar:', msg
        sys.exit (1)

    parser = parser_generator.makeParser(grammar)
    print parser.parse(line)        
#    try:
#        parser = parser_generator.makeParser(grammar)
#        print parser.parse(line)
#    except gclib.GError, inst:  
#        print 'Error: ' + inst.msg()
#    except Exception, arg:
#        print 'Error: ' + str(arg)