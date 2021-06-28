##
 # @file template_parser.py
 #
 # $Id: template_parser.py,v 1.2 2007/04/28 04:31:31 cgjones Exp $
 #
import re, sys
from sgmllib import SGMLParser, SGMLParseError
import xml.dom

__all__ = ['TemplateParser', 'parse', 'parseFile']

D = xml.dom.getDOMImplementation ()


def parse (template):
    tp = TemplateParser (template)
    return tp.close ()


def parseFile (templateFile):
    return parse (open (templateFile).read ())


# XXX: this is really cheap, since we're ignoring '!}' and '|||' that might
# appear in strings.  Also, this method requires initializers to be only
# textual; any HTML will be parsed away by the SGMLParser.

_templatePattern = re.compile (r'\{\!((?:.|\n)*?)\!\}')
_attrPattern = re.compile (r'(\w+)\s*\=\s*\{\!((?:.|\n)*?)\!\}')
_initializerPattern = re.compile (r'((?:.|\n)*?)\s*\|\|\|\s*((?:.|\n)*)$')

class TemplateParser (SGMLParser):
    '''A parser of HTML templates for the Skipjax language.

    The HTML is parsed into a DOM tree, returned by the close() method.

    This class can be used to parse raw HTML that may be "quirky."  This
    parser is fairly forgiving.

    The parser treats <script> tags specially.  The known types of
    scripts are:
    
      o type="text/javascript"
      o type="text/skipjax"
      o lang="javascript"
      o lang="skipjax"

    If one of the above script types is not found, the parser defaults to
    type "skipjax."

    Additionally, the HTML can contain templated Skipjax code.  These
    templates look like:

      {! Expression_v ['|||' Expression_i] !}

    Expression_v is the value to be inserted in the DOM.  Expression_i
    is the optional initial value for the text of the DOM node, since
    Expression_v may not be defined at all points in time.

    '''
    
    def __init__ (self, inp=None):
        '''Create a new TemplateParser, optionally feeding it the text INP.'''
        SGMLParser.__init__ (self)
        self.script = None              # script currently being parsed
        self.doc = D.createDocument (None, None, None) # document
        self.elt = self.doc             # DOM element we're currently building

        if inp:
            self.feed (inp)


    def close (self):
        '''Force the parsing of all buffered input, and return a DOM tree
        representing the parsed HTML.
        '''
        SGMLParser.close (self)
        return self.doc

    
    def unknown_starttag (self, tag, attrs):
        '''Default tag handler.  Creates a new DOM node.'''
        raw = self.get_starttag_text ()

        if self.script:
            self.script.addText (raw)
        else:
            elt, attrScripts = self.createElement (tag, attrs, raw)
            self.elt.appendChild (elt)

            for script in attrScripts:
                self.elt.appendChild (script)

            if not self.isSingleton (raw):
                self.elt = elt


    def unknown_endtag (self, tag):
        '''Default end tag handler.  Closes off the current tag.'''
        if self.script:
            self.script.addText ('</%s>'% (tag))
        else:
            self.elt.normalize ()
            self.elt = self.elt.parentNode


    def start_script (self, attrs):
        '''Start parsing a <script> tag.'''
        if self.script:
            self.unknown_starttag ('script', attrs)
        else:
            self.script = Script (attrs)



    def end_script (self):
        '''Close off the current script.'''
        if not self.script:
            raise SGMLParseError, 'Unbalanced </script> tag'
        self.elt.appendChild (self.script.toDOMNode (self.doc))
        self.script = None


    def handle_comment (self, comment):
        '''Ignore HTML comments.'''
        # Stripping comments
        pass
    

    def handle_data (self, text):
        '''Parse raw data in the HTML.

        If a script is being parsed, directly adds the raw text to the
        open <script> node.

        Otherwise, looks for templates in TEXT and adds them to the
        currently open DOM node.
        '''

        if self.elt is self.doc:
            return
        elif self.script:
            self.script.addText (text)
            return

        # Look for templates, {! ... !}
        pos = 0
        match = _templatePattern.search (text, pos)
        while match:
            template = match.group (1)
            templateEnd = match.end ()
            textEnd = match.start ()
            self.elt.appendChild (self.doc.createTextNode (text[pos:textEnd]))
            self.elt.appendChild (self.createTemplateNode (template))
            pos = templateEnd
            match = _templatePattern.search (text, pos)

        self.elt.appendChild (self.doc.createTextNode (text[pos:]))


    def report_unbalanced (self, tag):
        '''There is a closing </TAG> without an opening <TAG>.  Raise an error.
        '''
        raise SGMLParseError, 'Unbalanced tag:', tag


    def createElement (self, tag, attrs, raw=''):
        '''Create a DOM element of type TAG with attributes ATTRS.'''
        n = self.doc.createElement (tag)

        for name, value in attrs:
            n.setAttribute (name, value)

        attrScripts = []
        for name, value in self.parseTemplatedAttributes (raw):
            as = self.createTemplateNode (value, type='text/attrsetter')
            as.setAttribute ('attr', name)
            attrScripts.append (as)

        return n, attrScripts


    def createTemplateNode (self, template, type='text/template'):
        '''Create a template node.

        Template nodes are <script> nodes of type "text/template".  The script
        node has two textual children:

          (1) The value to be inserted in the template
          (2) The initial value of (1)

        '''
        n, attrScripts = self.createElement ('script', (('type', type),))

        code, initialValue = self.parseTemplate (template)

        n.appendChild (self.doc.createComment (code))
        n.appendChild (self.doc.createComment (initialValue))

        return n

    def isSingleton (self, tagText):
        '''Return True iff tagText is a singleton tag, e.g., "<br />."'''
        rbrace = False
        for c in reversed (tagText):
            if c.isspace ():               continue
            elif not rbrace and c == '>':  rbrace = True
            elif rbrace and c == '/':      return True
            else:                          return False


    def parseTemplate (self, template):
        match = _initializerPattern.match (template)
        if match:
            code = match.group (1)
            initialValue = match.group (2)
        else:
            code = template
            initialValue = ''
        return code, initialValue


    def parseTemplatedAttributes (self, attrs):
        return _attrPattern.findall (attrs)


class Script:
    '''A class to simplify the parsing of <script> tags.

    This class determines the type of the <script> tag and keeps track of
    the contained code.
    '''
    
    SKIPJAX = 'text/skipjax'
    JS = 'text/javascript'
    DEFAULT_TYPE = SKIPJAX

    TYPE_MAP = {
        ('type', 'text/javascript'): JS,
        ('type', 'text/skipjax'): SKIPJAX,
        ('lang', 'javascript'): JS,
        ('lang', 'skipjax'): SKIPJAX
    }
    
    def __init__ (self, attrs):
        '''Create a new <script> node with attributes ATTRS.'''
        self.scriptType = self.getType (attrs) # the type of this script
        self.src = self.getSrc (attrs)  # source of this script, or None
        self.code = ''                  # the code contained within


    def toDOMNode (self, doc):
        '''Return a DOM element representing this script object.'''
        n = doc.createElement ('script')
        n.setAttribute ('type', self.scriptType)
        if self.src:
            n.setAttribute ('src', self.src)
        n.appendChild (doc.createComment (self.code))
        return n


    def addText (self, text):
        '''Add TEXT to the code of this script.'''
        self.code += text


    def getType (self, attrs):
        '''Determine the canonical type of the script described by ATTRS.'''
        for name, value in attrs:
            t = Script.TYPE_MAP.get ((name, value.lower ()), None)
            if t:  return t
        return Script.DEFAULT_TYPE


    def getSrc (self, attrs):
        for name, value in attrs:
            if name == 'src':
                return value
        return None


if __name__ == '__main__':
    testhtml = '''
<html>
  <head>
    <title>Foo</title>
    <script type="text/javascript" src="foo.js"></script>
  </head>

  <body>
    <input id="input" type="text" />

    {! value ('input') !}
    {! value ('input') ||| hello !}

    <script TYPE="TEXT/JAVASCRIPT">
var x = 2
   x += 2
+ 3

var y = x > 2;

var y = 1 <x ? 10 / x > x : z;
var h = '<script> <foo> </ bar  >';
    </script>

    <SCRIPT LANG="skipjax">
var x = timer (1000) + 10
    </script>

    <pre> Hello

    there! &gt;  &#42;


you</pre>

   <script> var x = '{! foo ||| foo !}';</script>

   {! changes (timer (10000)) ||| <div></div> !}
    
  </body>
</html>
'''

    sp = TemplateParser (testhtml)
    document = sp.close ()
    document.writexml (sys.stdout)
