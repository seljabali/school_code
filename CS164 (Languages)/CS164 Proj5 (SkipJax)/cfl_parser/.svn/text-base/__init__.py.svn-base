import grammar_parser, parser_generator, util

__all__ = ['makeParser', 'makeParserFromFile']


def makeParser (grammarString):
    grammar = grammar_parser.parse (grammarString)
    ok, msg = grammar.validate ()

    if not ok:
        util.error ('Invalid grammar: %s'% (msg))

    return parser_generator.makeParser (grammar)


def makeParserFromFile (grammarFile):
    return makeParser (open (grammarFile).read ())
