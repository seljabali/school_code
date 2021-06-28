import StringIO
import cfl_parser, template_parser
import cgen, rewrite, semant, template_parser


__all__ = ['compileJavaScript',  'compileJavaScriptFile',
           'compileSkipjax',     'compileSkipjaxFile',
           'compileTemplate',    'compileTemplateFile',
           ]


def compileJavaScriptFile (inFile, outFile):
    '''Compile the JavaScript file INFILE, writing it to OUTFILE.'''
    print 'Compiling javascript source "%s" to "%s"'% (inFile, outFile)    
    return compileJavaScript (open (inFile).read (), open (outFile, 'w'))


def compileSkipjaxFile (inFile, outFile):
    '''Compile the Skipjax file INFILE, writing it to OUTFILE.'''
    print 'Compiling skipjax source "%s" to "%s"'% (inFile, outFile)    
    return compileSkipjax (open (inFile).read (), open (outFile, 'w'))


def compileJavaScript (js, out):
    '''Compile the JavaScript text JS, printing the result to OUT.'''
    ast = _jsparser.parse (js)
    ast = rewrite.rewriteJS (ast)
    ast = semant.analyzeJS (ast)        # dies if there's an error
    cgen.codegenJS (ast, out)


def compileSkipjax (sjx, out):
    '''Compile the Skipjax text SJX, printing the result to OUT.'''
    ast = _jsparser.parse (sjx)
    ast = rewrite.rewriteSkipjax (ast)
    ast = semant.analyzeSkipjax (ast)   # dies if there's an error
    cgen.codegenSkipjax (ast, out)


##-----------------------------------------------------------------------------


def _compileSkipjaxExpression (expr, out):
    ast = _exprparser.parse (expr)
    ast = rewrite.rewriteSkipjax (ast)
    ast = semant.analyzeSkipjax (ast)
    cgen.codegenSkipjax (ast, out)


def compileTemplateFile (inFile, outFile, libpath):
    print 'Compiling template "%s" to "%s"...'% (inFile, outFile)
    return compileTemplate (open (inFile).read (), open (outFile, 'w'),
                            libpath)


def compileTemplate (template, out, libpath):
    print '  parsing template ...'

    dom = template_parser.parse (template)
    scripts = dom.getElementsByTagName ('script')

    for i, script in enumerate (scripts):
        print '  compiling script', i, '...'
        script.parentNode.replaceChild (_compileScript (script, dom), script)

    _insertSkipjaxLibrary (dom, libpath)

    print '  writing out HTML ...'
    dom.writexml (out)


def _insertSkipjaxLibrary (dom, libpath):
    head = dom.getElementsByTagName ('head')
    if len (head) == 0:
        html = dom.getElementsByTagName ('html')[0]
        html.insertBefore (dom.createElement ('head'), html.firstChild)
        head = html.firstChild
    else:
        head = head[0]

    skipjaxLib = dom.createElement ('script')
    skipjaxLib.setAttribute ('type', 'text/javascript')
    skipjaxLib.setAttribute ('src', libpath)
    skipjaxLib.appendChild (dom.createTextNode (''))

    head.insertBefore (skipjaxLib, head.firstChild)


def _compileScript (script, dom):
    if script.getAttribute ('src'):     # nothing to see here
        return script

    scriptType = script.getAttribute ('type')
    out = StringIO.StringIO ()

    if scriptType == 'text/javascript':
        compileJavaScript (script.firstChild.data, out)
        return _mkScript (dom, out.getvalue ())

    elif scriptType == 'text/skipjax':
        compileSkipjax (script.firstChild.data, out)
        return _mkScript (dom, out.getvalue ())

    elif scriptType == 'text/template':
        return _compileTemplate (dom,
                                 script.firstChild.data, script.lastChild.data)

    elif scriptType == 'text/attrsetter':
        elt = script.previousSibling
        while elt.localName == 'script' or not elt.localName:
            elt = elt.previousSibling
        return _compileAttrsetter (dom, script, elt)

    else:
        raise TypeError, 'Unknown script type "%s"'% (scriptType)


def _compileTemplate (dom, code, init):
    container = dom.createElement ('span')

    value = dom.createElement ('span')
    valueId = _nextDOMId ()
    value.setAttribute ('id', valueId)
    value.appendChild (dom.createTextNode (init))
    container.appendChild (value)

    compiled = StringIO.StringIO ()
    _compileSkipjaxExpression (code, compiled)
    script = _mkScript (dom, 'insertDom (%s, "%s", "over");'% (
        compiled.getvalue(), valueId))

    container.appendChild (script)

    return container


def _compileAttrsetter (dom, script, elt):
    # Get the Skipjax code and text init
    code = script.firstChild.data
    init = script.lastChild.data
    attr = script.getAttribute ('attr')
    
    # Make sure elt has an ID
    nodeId = elt.getAttribute ('id')
    if not nodeId:
        nodeId = _nextDOMId ()
        elt.setAttribute ('id', nodeId)

    # Set the initial value of the attributes
    elt.setAttribute(attr, init)

    # Replace the text of the script with compiled Skipjax
    compiled = StringIO.StringIO ()
    _compileSkipjaxExpression (code, compiled)

    return _mkScript (dom, 'insertValue (%s, "%s", "%s");'% (
        compiled.getvalue(), nodeId, attr))


def _mkScript (dom, code):
    script = dom.createElement ('script')
    script.setAttribute ('type', 'text/javascript')
    script.appendChild (dom.createComment ('\n'+ code +'\n'))
    return script


__eltCounter = 0
def _nextDOMId ():
    global __eltCounter
    __eltCounter += 1
    return '__skipjax_id_%d'% (__eltCounter)

##-----------------------------------------------------------------------------
## Full JavaScript grammar and parser object
##

_jsgrammar = r'''
%import ast
%import util

%ignore       /[ \t\v\f]+/ 
%ignore       /\/\/[^\n\r]*?(?:[\n\r]|$)/
%ignore       /\/\*(?:\n\r|\r|\n|.)*?\*\//
%optional NL  /\r\n|\r|\n/

%left  ','
%right '='  '+='  '-='  '*='  '/='  '%='  '<<='  '>>=' '>>>='  '&='  '^='  '|='
%left  '||'
%left  '&&'
%left  '|'
%left  '^'
%left  '&'
%left  '=='   '!='  '==='  '!=='
%left  '<'  '<='  '>'  '>='  'in'  'instanceof'
%left  '<<'  '>>'  '>>>'
%left  '+'  '-'
%left  '*'  '/'  '%'
%right '!'  '~'  'typeof'  'void'  'delete'
%left  '++'  '--'  // these are non-associative, but we can catch that later

%%

Script -> Stmts                 %{ return ast.Script (n1.val) %} ;

//-----------------------------------------------------------------------------
// Statements (modulo Lambda)
//

Stmts -> _                      %{ return ast.Block (ast.EmptyStatement ()) %}
       | Stmt                  %dprec 2
                                %{ return ast.Block (n1.val) %}
       | TerminatedStmt        %dprec 3
                                %{ return ast.Block (n1.val) %}
       | TerminatedStmt Stmts  %dprec 1
                                %{ n2.val.add (n1.val, 0); return n2.val %}
       ;

StmtBlock -> '{' Stmts '}'      %{ return n2.val %} ;

Stmt -> ExprStmt
      | VarDecls
      | Throw
      | Return
      | Break
      | Continue
      | DoWhile
      | For
      | ForIn
      | If
      | While
      | With
      ;

TerminatedStmt -> DisambigTermStmt
                | NormalTermStmt
                ;

TermStmtNoSemicolonBlock -> DisambigTermStmtNoSemicolonBlock
                          | NormalTermStmt
                          ;

NormalTermStmt -> ';'           %{ return ast.EmptyStatement () %}
                | FuncDecl
                | DoWhile
                | Switch
                | TryCatch
                | TerminatedFor
                | TerminatedForIn  
                | TerminatedIf
                | TerminatedWith
                | TerminatedWhile  
                | Lambda        %{ return ast.ExpressionStatement (n1.val) %}
                ;

DisambigTermStmt -> StmtBlock      %dprec 2
                  | StmtBlock ';'  %dprec 2
                  | Stmt EOS       %dprec 1
                  | ObjectLiteral  %dprec 1
                                %{ return ast.ExpressionStatement (n1.val) %}
                  ;

DisambigTermStmtNoSemicolonBlock -> StmtBlock      %dprec 2
                                  | Stmt EOS       %dprec 1  %{
    ##
    ## Firefox rejects "if (1) {}; else 2;".  For Spidermonkey-parser
    ## compatibility, uncomment the hack below.
    ##
#    if isinstance (n1.val, ast.ExpressionStatement):
#        e = n1.val.expression
#        if (isinstance (e, ast.ObjectInit) and len (e.children) == 0 
#            and n2.val == ';'):
#            util.error ("blocks cannot be ended with ';' here")
#        else:
#            return n1.val
#    else:
        return n1.val
%}
                                  | ObjectLiteral  %dprec 1
                                %{ return ast.ExpressionStatement (n1.val) %}
                                  ;

Suite -> Stmt                   %{ return ast.Block (n1.val) %} ;
TerminatedSuite -> TerminatedStmt   %{ 
    if isinstance (n1.val, ast.Block):
        return n1.val
    else:
        return ast.Block (n1.val) 
%} ;
TermSuiteNoSemicolonBlock -> TermStmtNoSemicolonBlock %{
    if isinstance (n1.val, ast.Block):
        return n1.val
    else:
        return ast.Block (n1.val) 
%} ;

If -> 'if' '(' E ')' Suite                                  %dprec 2
                                %{ return ast.If (n3.val, n5.val) %}
    | 'if' '(' E ')' TermSuiteNoSemicolonBlock 'else' Suite  %dprec 1
                                %{ return ast.If (n3.val, n5.val, n7.val) %}
    ;

TerminatedIf -> 'if' '(' E ')' TerminatedSuite                                   %dprec 2
                                %{ return ast.If (n3.val, n5.val) %}
              | 'if' '(' E ')' TermSuiteNoSemicolonBlock 'else' TerminatedSuite  %dprec 1
                                %{ return ast.If (n3.val, n5.val, n7.val) %}
              ;

For -> 'for' '(' ForInit ';' LoopTest ';' ForUpdate ')' Suite
                                %{ return ast.For (n3.val, n5.val, n7.val, n9.val) %} ;
TerminatedFor -> 'for' '(' ForInit ';' LoopTest ';' ForUpdate ')' TerminatedSuite
                                %{ return ast.For (n3.val, n5.val, n7.val, n9.val) %} ;
ForInit -> _                    %{ return ast.EmptyStatement () %}
         | VarDecls
         | E
         ;
LoopTest -> _                   %{ return ast.EmptyStatement () %}
          | E
          ;
ForUpdate -> _                  %{ return ast.EmptyStatement () %}
           | E
           ;

// Laziness here.  Having all the AssgnENotIn crap is a waste of space and
// computation, so we can just do what Firefox does and claim the first
// 'in' for the ForIn expression.
ForIn -> 'for' '(' LhsE 'in' E ')' Suite
                                %{ return ast.ForIn (n3.val, n5.val, n7.val) %}
       | 'for' '(' ForInDecl 'in' AssnE ')'  Suite
                                %{ return ast.ForIn (n3.val.name, n5.val, n7.val, n3.val) %}
           ;
TerminatedForIn -> 'for' '(' LhsE 'in' E ')' TerminatedSuite
                                %{ return ast.ForIn (n3.val, n5.val, n7.val) %}
                 | 'for' '(' ForInDecl 'in' AssnE ')'  TerminatedSuite
                                %{ return ast.ForIn (n3.val.name, n5.val, n7.val, n3.val) %}
             ;
ForInDecl -> 'var' ID           %{ return ast.VarDecl (n2.val) %} 
           | 'var' ID '=' AssnE
                                %{ return ast.VarDecl (n2.val, n4.val) %}
           ;

While -> 'while' '(' E ')'  Suite
                                %{ return ast.While (n3.val, n5.val) %} ;
TerminatedWhile -> 'while' '(' E ')'  TerminatedSuite
                                %{ return ast.While (n3.val, n5.val) %} ;

With -> 'with' '(' E ')' Suite
                                %{ return ast.With (n3.val, n5.val) %} ;
TerminatedWith -> 'with' '(' E ')' TerminatedSuite
                                %{ return ast.With (n3.val, n5.val) %} ;

DoWhile -> 'do' TerminatedSuite 'while' '(' E ')' 
                                %{ return ast.Do (n5.val, n2.val) %} ;

ExprStmt -> E                   %{ return ast.ExpressionStatement (n1.val) %} ;

VarDecls -> 'var' DeclList      %{ return n2.val %} ;
DeclList -> Decl                %{ return ast.VarDecls (n1.val) %}
          | Decl ',' DeclList   %{ n3.val.add (n1.val, 0); return n3.val %}
          ;
Decl -> ID                      %{ return ast.VarDecl (n1.val) %}
      | ID '=' AssnE            %{ return ast.VarDecl (n1.val, n3.val) %}
      ;

FuncDecl -> 'function' ID FuncVal
                                %{ return ast.FunctionDecl (n2.val, n3.val) %} ;
Lambda     -> 'function' FuncVal
                                %{ return n2.val %} ;
FuncVal  ->  '(' IDParams ')'  StmtBlock 
                                %{ return ast.Function (n2.val, n4.val) %} ;
IDParams -> _                   %{ return ast.NodeList () %}
          | IDList 
          ;
IDList    -> ID                   %{ return ast.NodeList (n1.val) %}
         | ID ',' IDList        %{ n3.val.add (n1.val, 0); return n3.val %}
         ;

Switch    -> 'switch' '(' E ')' '{' CaseBlock '}' 
                                %{ return ast.Switch (n3.val, n6.val) %} ;
CaseBlock -> _                  %{ return ast.CaseList () %}
           | CaseList
           ;
CaseList -> CaseItem            %{ return ast.CaseList (n1.val) %}
          | CaseItem CaseList   %{ n2.val.add (n1.val, 0); return n2.val %}
          ;
CaseItem  -> 'case' E ':'  Stmts
                                %{ return ast.Case (n2.val, n4.val) %}
           | 'default' ':'  Stmts 
                                %{ return ast.Default (n3.val) %}
           ;

Throw -> 'throw' E              %{ return ast.Throw (n2.val) %} ;

TryCatch -> Try Catch           %{ return ast.TryCatchFinally (n1.val, n2.val) %}
          | Try Finally         %{ return ast.TryCatchFinally (n1.val, finallyBlock=n2.val) %}
          | Try Catch Finally   %{ return ast.TryCatchFinally (n1.val, n2.val, n3.val) %}
          ;
Try -> 'try' StmtBlock          %{ return n2.val %} ;
Catch -> 'catch' '(' ID ')' StmtBlock 
                                %{ return ast.Catch (n3.val, n5.val) %} ;
Finally -> 'finally' StmtBlock  %{ return n2.val %} ;

Return -> 'return'              %{ return ast.Return () %}
        | 'return' E            %{ return ast.Return (n2.val) %}
        ;
Break     -> 'break'              %{ return ast.Break () %} ;
Continue -> 'continue'          %{ return ast.Continue () %} ;

//-----------------------------------------------------------------------------
// Expressions
//

E -> E ',' E  %{
    if isinstance (n1.val, ast.Comma):
        n1.val.add (n3.val)
        return n1.val
    else:
        return ast.Comma (n1.val, n3.val)
%}
   | AssnE
   ;

AssnE -> AssnE '=' AssnE     %{ return ast.Assignment ('=', n1.val, n3.val) %}
       | AssnE '|=' AssnE    %{ return ast.Assignment ('|=', n1.val, n3.val) %}
       | AssnE '^=' AssnE    %{ return ast.Assignment ('^=', n1.val, n3.val) %}
       | AssnE '&=' AssnE    %{ return ast.Assignment ('&=', n1.val, n3.val) %}
       | AssnE '<<=' AssnE   %{ return ast.Assignment ('<<=', n1.val, n3.val)%}
       | AssnE '>>>=' AssnE  %{return ast.Assignment ('>>>=', n1.val, n3.val)%}
       | AssnE '>>=' AssnE   %{ return ast.Assignment ('>>=', n1.val, n3.val)%}
       | AssnE '+=' AssnE    %{ return ast.Assignment ('+=', n1.val, n3.val) %}
       | AssnE '-=' AssnE    %{ return ast.Assignment ('-=', n1.val, n3.val) %}
       | AssnE '*=' AssnE    %{ return ast.Assignment ('*=', n1.val, n3.val) %}
       | AssnE '/=' AssnE    %{ return ast.Assignment ('/=', n1.val, n3.val) %}
       | AssnE '%=' AssnE    %{ return ast.Assignment ('%=', n1.val, n3.val) %}
       | ConditionalE
       ;

ConditionalE -> OpE '?' AssnE ':' AssnE
                            %{return ast.Conditional (n1.val, n3.val, n5.val)%}
              | OpE
              ;

OpE -> OpE '||' OpE     %{ return ast.InfixExpression ('||', n1.val, n3.val) %}
     | OpE '&&' OpE     %{ return ast.InfixExpression ('&&', n1.val, n3.val) %}

     | OpE '|' OpE      %{ return ast.InfixExpression ('|', n1.val, n3.val) %}
     | OpE '^' OpE      %{ return ast.InfixExpression ('^', n1.val, n3.val) %}
     | OpE '&' OpE      %{ return ast.InfixExpression ('&', n1.val, n3.val) %}

     | OpE '===' OpE    %{ return ast.InfixExpression ('===', n1.val, n3.val)%}
     | OpE '==' OpE     %{ return ast.InfixExpression ('==', n1.val, n3.val) %}
     | OpE '!==' OpE    %{ return ast.InfixExpression ('!==', n1.val, n3.val)%}
     | OpE '!=' OpE     %{ return ast.InfixExpression ('!=', n1.val, n3.val) %}

     | OpE '<=' OpE     %{ return ast.InfixExpression ('<=', n1.val, n3.val) %}
     | OpE '>=' OpE     %{ return ast.InfixExpression ('>=', n1.val, n3.val) %}
     | OpE '<' OpE      %{ return ast.InfixExpression ('<', n1.val, n3.val) %}
     | OpE '>' OpE      %{ return ast.InfixExpression ('>', n1.val, n3.val) %}
     | OpE 'in' OpE     %{ return ast.In (n1.val, n3.val) %}
     | OpE 'instanceof' OpE
                        %{ return ast.Instanceof (n1.val, n3.val) %}

     | OpE '<<' OpE     %{ return ast.InfixExpression ('<<', n1.val, n3.val) %}
     | OpE '>>>' OpE    %{ return ast.InfixExpression ('>>>', n1.val, n3.val)%}
     | OpE '>>' OpE     %{ return ast.InfixExpression ('>>', n1.val, n3.val) %}

     | OpE '+' OpE      %{ return ast.InfixExpression ('+', n1.val, n3.val) %}
     | OpE '-' OpE      %{ return ast.InfixExpression ('-', n1.val, n3.val) %}
     | OpE '*' OpE      %{ return ast.InfixExpression ('*', n1.val, n3.val) %}
     | OpE '/' OpE      %{ return ast.InfixExpression ('/', n1.val, n3.val) %}
     | OpE '%' OpE      %{ return ast.InfixExpression ('%', n1.val, n3.val) %}

     | '+' OpE  %prec '!'
                        %{ return ast.PrefixExpression ('+', n2.val) %}
     | '-' OpE  %prec '!'
                        %{ return ast.PrefixExpression ('-', n2.val) %}
     | '!' OpE          %{ return ast.PrefixExpression ('!', n2.val) %}
     | '~' OpE          %{ return ast.PrefixExpression ('~', n2.val) %}
     | 'typeof' OpE     %{ return ast.Typeof (n2.val) %}
     | 'void' OpE       %{ return ast.Void (n2.val) %}
     | 'delete' OpE     %{ return ast.Delete (n2.val) %}

     | OpE '++'         %{ return ast.PostfixExpression ('++', n1.val) %}
     | '++' OpE         %{ return ast.PrefixExpression ('++', n2.val) %}
     | OpE '--'         %{ return ast.PostfixExpression ('--', n1.val) %}
     | '--' OpE         %{ return ast.PrefixExpression ('--', n2.val) %}

     | LhsE
     ;

LhsE -> NewE
      | CallE
      ;

NewE -> MemberE
      | 'new' NewE              %{ return ast.New (n2.val, ast.ArgumentList ()) %}
      ;

MemberE -> Primary
         | MemberE '[' E ']'    %{ return ast.Index (n3.val, n1.val) %}
         | MemberE '.' ID       %{ return ast.Selection (n3.val, n1.val) %}
         | 'new' MemberE Arguments
                                %{ return ast.New (n2.val, n3.val) %}
         ;

CallE -> MemberE Arguments      %{ return ast.Call (n1.val, n2.val) %}
       | CallE Arguments        %{ return ast.Call (n1.val, n2.val) %}
       | CallE '[' E ']'        %{ return ast.Index (n3.val, n1.val) %}
       | CallE '.' ID           %{ return ast.Selection (n3.val, n1.val) %}
       ;

Arguments -> '(' ')'            %{ return ast.ArgumentList () %}
           | '(' ArgList ')'    %{ return n2.val %}
           ;

ArgList -> AssnE                %{ return ast.ArgumentList (n1.val) %}
         | AssnE ',' ArgList    %{ n3.val.add (n1.val, 0); return n3.val %}
         ;

Primary -> 'this'               %{ return ast.This () %}
         | ID
         | Literal
         | '(' E ')'            %{ return n2.val %}
         ;

Literal -> NumLiteral
         | StringLiteral
         | RegExpLiteral
         | ArrayLiteral
         | ObjectLiteral
         | Lambda
         | 'true'               %{ return ast.True_ () %}
         | 'false'              %{ return ast.False_ () %}
         | 'null'               %{ return ast.Null () %}
         ;

NumLiteral -> ExpLiteral
            | FloatLiteral
            | OctalLiteral
            | IntLiteral
            | HexLiteral
            ;
ExpLiteral -> /[1-9][0-9]*[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            | /\.[0-9]+[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            | /[0-9]+\.[0-9]*[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            ;
FloatLiteral -> /\.[0-9]+/      %{ return ast.Number (n1.val) %}
              | /[0-9]+\.[0-9]*/
                                %{ return ast.Number (n1.val) %}
              ;
OctalLiteral -> /[0][0-7]*/     %{ return ast.Number (n1.val) %} ;
IntLiteral   -> /[1-9][0-9]*/   %{ return ast.Number (n1.val) %} ;
HexLiteral   -> /0[xX][0-9a-fA-F]+/ 
                                %{ return ast.Number (n1.val) %} ;

StringLiteral -> /\'(?:\\\\|\\\'|\\\r\n|\\\r|\\\n|[^\'\r\n])*\'/
                                %{ return ast.String (n1.val[1:-1]) %}
               | /\"(?:\\\\|\\\"|\\\r\n|\\\r|\\\n|[^\"\r\n])*\"/
                                %{ return ast.String (n1.val[1:-1]) %}
               ;

RegExpLiteral -> /\/(?:\\\\|\\\/|[^\/\r\n])*\/[a-zA-Z]*/ 
                                %{ return ast.Regex (n1.val) %} ;

ArrayLiteral -> '[' ArrayElements ']'
                                %{ return n2.val %} ;
ArrayElements -> ArrayElement   %{
    if isinstance (n1.val, ast.EmptyStatement):
        return ast.ArrayInit ()
    else:
        return ast.ArrayInit (n1.val)
%}
               | ArrayElement ',' ArrayElements
                                %{ n3.val.add (n1.val, 0); return n3.val %}
               ;
ArrayElement -> _               %{ return ast.EmptyStatement () %}
              | AssnE
              ;


ObjectLiteral -> '{' Properties '}'
                                %{ return n2.val %}
               | '{' PropertyList ',' '}'
                                %{ return n2.val %}
               ;
Properties -> _                 %{ return ast.ObjectInit () %}
            | PropertyList
            ;
PropertyList -> Property        %{ return ast.ObjectInit (n1.val) %}
              | Property ',' PropertyList
                                %{ n3.val.add (n1.val, 0); return n3.val %}
              ;
Property -> PropertyName ':' E  %{ return ast.PropertyInit (n1.val, n3.val) %};
PropertyName -> ID
              | StringLiteral
              | NumLiteral
              ;

//-----------------------------------------------------------------------------
// Sundry tokens
//

EOS     -> ';' | NL ;

ID -> /[_$a-zA-Z][_$a-zA-Z0-9]*/
                                %{ return ast.Identifier (n1.val) %} ;
'''

_jsparser = cfl_parser.makeParser (_jsgrammar)


##-----------------------------------------------------------------------------
## JavaScript expression parser

_exprgrammar = r'''
%import ast
%import util

%ignore       /[ \t\v\f]+/ 
%ignore       /\/\/[^\n\r]*?(?:[\n\r]|$)/
%ignore       /\/\*(?:\n\r|\r|\n|.)*?\*\//
%optional NL  /\r\n|\r|\n/

%left  ','
%right '='  '+='  '-='  '*='  '/='  '%='  '<<='  '>>=' '>>>='  '&='  '^='  '|='
%left  '||'
%left  '&&'
%left  '|'
%left  '^'
%left  '&'
%left  '=='   '!='  '==='  '!=='
%left  '<'  '<='  '>'  '>='  'in'  'instanceof'
%left  '<<'  '>>'  '>>>'
%left  '+'  '-'
%left  '*'  '/'  '%'
%right '!'  '~'  'typeof'  'void'  'delete'
%left  '++'  '--'  // these are non-associative, but we can catch that later

%%

// Start symbol: expressions or expression statements.

S -> E | E EOS ;

//-----------------------------------------------------------------------------
// Statements (modulo Lambda)
//

Stmts -> _                      %{ return ast.Block (ast.EmptyStatement ()) %}
       | Stmt                  %dprec 2
                                %{ return ast.Block (n1.val) %}
       | TerminatedStmt        %dprec 3
                                %{ return ast.Block (n1.val) %}
       | TerminatedStmt Stmts  %dprec 1
                                %{ n2.val.add (n1.val, 0); return n2.val %}
       ;

StmtBlock -> '{' Stmts '}'      %{ return n2.val %} ;

Stmt -> ExprStmt
      | VarDecls
      | Throw
      | Return
      | Break
      | Continue
      | DoWhile
      | For
      | ForIn
      | If
      | While
      | With
      ;

TerminatedStmt -> DisambigTermStmt
                | NormalTermStmt
                ;

TermStmtNoSemicolonBlock -> DisambigTermStmtNoSemicolonBlock
                          | NormalTermStmt
                          ;

NormalTermStmt -> ';'           %{ return ast.EmptyStatement () %}
                | FuncDecl
                | DoWhile
                | Switch
                | TryCatch
                | TerminatedFor
                | TerminatedForIn  
                | TerminatedIf
                | TerminatedWith
                | TerminatedWhile  
                | Lambda        %{ return ast.ExpressionStatement (n1.val) %}
                ;

DisambigTermStmt -> StmtBlock      %dprec 2
                  | StmtBlock ';'  %dprec 2
                  | Stmt EOS       %dprec 1
                  | ObjectLiteral  %dprec 1
                                %{ return ast.ExpressionStatement (n1.val) %}
                  ;

DisambigTermStmtNoSemicolonBlock -> StmtBlock      %dprec 2
                                  | Stmt EOS       %dprec 1  %{
    ##
    ## Firefox rejects "if (1) {}; else 2;".  For Spidermonkey-parser
    ## compatibility, uncomment the hack below.
    ##
#    if isinstance (n1.val, ast.ExpressionStatement):
#        e = n1.val.expression
#        if (isinstance (e, ast.ObjectInit) and len (e.children) == 0 
#            and n2.val == ';'):
#            util.error ("blocks cannot be ended with ';' here")
#        else:
#            return n1.val
#    else:
        return n1.val
%}
                                  | ObjectLiteral  %dprec 1
                                %{ return ast.ExpressionStatement (n1.val) %}
                                  ;

Suite -> Stmt                   %{ return ast.Block (n1.val) %} ;
TerminatedSuite -> TerminatedStmt   %{ 
    if isinstance (n1.val, ast.Block):
        return n1.val
    else:
        return ast.Block (n1.val) 
%} ;
TermSuiteNoSemicolonBlock -> TermStmtNoSemicolonBlock %{
    if isinstance (n1.val, ast.Block):
        return n1.val
    else:
        return ast.Block (n1.val) 
%} ;

If -> 'if' '(' E ')' Suite                                  %dprec 2
                                %{ return ast.If (n3.val, n5.val) %}
    | 'if' '(' E ')' TermSuiteNoSemicolonBlock 'else' Suite  %dprec 1
                                %{ return ast.If (n3.val, n5.val, n7.val) %}
    ;

TerminatedIf -> 'if' '(' E ')' TerminatedSuite                                   %dprec 2
                                %{ return ast.If (n3.val, n5.val) %}
              | 'if' '(' E ')' TermSuiteNoSemicolonBlock 'else' TerminatedSuite  %dprec 1
                                %{ return ast.If (n3.val, n5.val, n7.val) %}
              ;

For -> 'for' '(' ForInit ';' LoopTest ';' ForUpdate ')' Suite
                                %{ return ast.For (n3.val, n5.val, n7.val, n9.val) %} ;
TerminatedFor -> 'for' '(' ForInit ';' LoopTest ';' ForUpdate ')' TerminatedSuite
                                %{ return ast.For (n3.val, n5.val, n7.val, n9.val) %} ;
ForInit -> _                    %{ return ast.EmptyStatement () %}
         | VarDecls
         | E
         ;
LoopTest -> _                   %{ return ast.EmptyStatement () %}
          | E
          ;
ForUpdate -> _                  %{ return ast.EmptyStatement () %}
           | E
           ;

// Laziness here.  Having all the AssgnENotIn crap is a waste of space and
// computation, so we can just do what Firefox does and claim the first
// 'in' for the ForIn expression.
ForIn -> 'for' '(' LhsE 'in' E ')' Suite
                                %{ return ast.ForIn (n3.val, n5.val, n7.val) %}
       | 'for' '(' ForInDecl 'in' AssnE ')'  Suite
                                %{ return ast.ForIn (n3.val.name, n5.val, n7.val, n3.val) %}
           ;
TerminatedForIn -> 'for' '(' LhsE 'in' E ')' TerminatedSuite
                                %{ return ast.ForIn (n3.val, n5.val, n7.val) %}
                 | 'for' '(' ForInDecl 'in' AssnE ')'  TerminatedSuite
                                %{ return ast.ForIn (n3.val.name, n5.val, n7.val, n3.val) %}
             ;
ForInDecl -> 'var' ID           %{ return ast.VarDecl (n2.val) %} 
           | 'var' ID '=' AssnE
                                %{ return ast.VarDecl (n2.val, n4.val) %}
           ;

While -> 'while' '(' E ')'  Suite
                                %{ return ast.While (n3.val, n5.val) %} ;
TerminatedWhile -> 'while' '(' E ')'  TerminatedSuite
                                %{ return ast.While (n3.val, n5.val) %} ;

With -> 'with' '(' E ')' Suite
                                %{ return ast.With (n3.val, n5.val) %} ;
TerminatedWith -> 'with' '(' E ')' TerminatedSuite
                                %{ return ast.With (n3.val, n5.val) %} ;

DoWhile -> 'do' TerminatedSuite 'while' '(' E ')' 
                                %{ return ast.Do (n5.val, n2.val) %} ;

ExprStmt -> E                   %{ return ast.ExpressionStatement (n1.val) %} ;

VarDecls -> 'var' DeclList      %{ return n2.val %} ;
DeclList -> Decl                %{ return ast.VarDecls (n1.val) %}
          | Decl ',' DeclList   %{ n3.val.add (n1.val, 0); return n3.val %}
          ;
Decl -> ID                      %{ return ast.VarDecl (n1.val) %}
      | ID '=' AssnE            %{ return ast.VarDecl (n1.val, n3.val) %}
      ;

FuncDecl -> 'function' ID FuncVal
                                %{ return ast.FunctionDecl (n2.val, n3.val) %} ;
Lambda     -> 'function' FuncVal
                                %{ return n2.val %} ;
FuncVal  ->  '(' IDParams ')'  StmtBlock 
                                %{ return ast.Function (n2.val, n4.val) %} ;
IDParams -> _                   %{ return ast.NodeList () %}
          | IDList 
          ;
IDList    -> ID                   %{ return ast.NodeList (n1.val) %}
         | ID ',' IDList        %{ n3.val.add (n1.val, 0); return n3.val %}
         ;

Switch    -> 'switch' '(' E ')' '{' CaseBlock '}' 
                                %{ return ast.Switch (n3.val, n6.val) %} ;
CaseBlock -> _                  %{ return ast.CaseList () %}
           | CaseList
           ;
CaseList -> CaseItem            %{ return ast.CaseList (n1.val) %}
          | CaseItem CaseList   %{ n2.val.add (n1.val, 0); return n2.val %}
          ;
CaseItem  -> 'case' E ':'  Stmts
                                %{ return ast.Case (n2.val, n4.val) %}
           | 'default' ':'  Stmts 
                                %{ return ast.Default (n3.val) %}
           ;

Throw -> 'throw' E              %{ return ast.Throw (n2.val) %} ;

TryCatch -> Try Catch           %{ return ast.TryCatchFinally (n1.val, n2.val) %}
          | Try Finally         %{ return ast.TryCatchFinally (n1.val, finallyBlock=n2.val) %}
          | Try Catch Finally   %{ return ast.TryCatchFinally (n1.val, n2.val, n3.val) %}
          ;
Try -> 'try' StmtBlock          %{ return n2.val %} ;
Catch -> 'catch' '(' ID ')' StmtBlock 
                                %{ return ast.Catch (n3.val, n5.val) %} ;
Finally -> 'finally' StmtBlock  %{ return n2.val %} ;

Return -> 'return'              %{ return ast.Return () %}
        | 'return' E            %{ return ast.Return (n2.val) %}
        ;
Break     -> 'break'              %{ return ast.Break () %} ;
Continue -> 'continue'          %{ return ast.Continue () %} ;


//-----------------------------------------------------------------------------
// Expressions
//

E -> E ',' E  %{
    if isinstance (n1.val, ast.Comma):
        n1.val.add (n3.val)
        return n1.val
    else:
        return ast.Comma (n1.val, n3.val)
%}
   | AssnE
   ;

AssnE -> AssnE '=' AssnE     %{ return ast.Assignment ('=', n1.val, n3.val) %}
       | AssnE '|=' AssnE    %{ return ast.Assignment ('|=', n1.val, n3.val) %}
       | AssnE '^=' AssnE    %{ return ast.Assignment ('^=', n1.val, n3.val) %}
       | AssnE '&=' AssnE    %{ return ast.Assignment ('&=', n1.val, n3.val) %}
       | AssnE '<<=' AssnE   %{ return ast.Assignment ('<<=', n1.val, n3.val)%}
       | AssnE '>>>=' AssnE  %{return ast.Assignment ('>>>=', n1.val, n3.val)%}
       | AssnE '>>=' AssnE   %{ return ast.Assignment ('>>=', n1.val, n3.val)%}
       | AssnE '+=' AssnE    %{ return ast.Assignment ('+=', n1.val, n3.val) %}
       | AssnE '-=' AssnE    %{ return ast.Assignment ('-=', n1.val, n3.val) %}
       | AssnE '*=' AssnE    %{ return ast.Assignment ('*=', n1.val, n3.val) %}
       | AssnE '/=' AssnE    %{ return ast.Assignment ('/=', n1.val, n3.val) %}
       | AssnE '%=' AssnE    %{ return ast.Assignment ('%=', n1.val, n3.val) %}
       | ConditionalE
       ;

ConditionalE -> OpE '?' AssnE ':' AssnE
                            %{return ast.Conditional (n1.val, n3.val, n5.val)%}
              | OpE
              ;

OpE -> OpE '||' OpE     %{ return ast.InfixExpression ('||', n1.val, n3.val) %}
     | OpE '&&' OpE     %{ return ast.InfixExpression ('&&', n1.val, n3.val) %}

     | OpE '|' OpE      %{ return ast.InfixExpression ('|', n1.val, n3.val) %}
     | OpE '^' OpE      %{ return ast.InfixExpression ('^', n1.val, n3.val) %}
     | OpE '&' OpE      %{ return ast.InfixExpression ('&', n1.val, n3.val) %}

     | OpE '===' OpE    %{ return ast.InfixExpression ('===', n1.val, n3.val)%}
     | OpE '==' OpE     %{ return ast.InfixExpression ('==', n1.val, n3.val) %}
     | OpE '!==' OpE    %{ return ast.InfixExpression ('!==', n1.val, n3.val)%}
     | OpE '!=' OpE     %{ return ast.InfixExpression ('!=', n1.val, n3.val) %}

     | OpE '<=' OpE     %{ return ast.InfixExpression ('<=', n1.val, n3.val) %}
     | OpE '>=' OpE     %{ return ast.InfixExpression ('>=', n1.val, n3.val) %}
     | OpE '<' OpE      %{ return ast.InfixExpression ('<', n1.val, n3.val) %}
     | OpE '>' OpE      %{ return ast.InfixExpression ('>', n1.val, n3.val) %}
     | OpE 'in' OpE     %{ return ast.In (n1.val, n3.val) %}
     | OpE 'instanceof' OpE
                        %{ return ast.Instanceof (n1.val, n3.val) %}

     | OpE '<<' OpE     %{ return ast.InfixExpression ('<<', n1.val, n3.val) %}
     | OpE '>>>' OpE    %{ return ast.InfixExpression ('>>>', n1.val, n3.val)%}
     | OpE '>>' OpE     %{ return ast.InfixExpression ('>>', n1.val, n3.val) %}

     | OpE '+' OpE      %{ return ast.InfixExpression ('+', n1.val, n3.val) %}
     | OpE '-' OpE      %{ return ast.InfixExpression ('-', n1.val, n3.val) %}
     | OpE '*' OpE      %{ return ast.InfixExpression ('*', n1.val, n3.val) %}
     | OpE '/' OpE      %{ return ast.InfixExpression ('/', n1.val, n3.val) %}
     | OpE '%' OpE      %{ return ast.InfixExpression ('%', n1.val, n3.val) %}

     | '+' OpE  %prec '!'
                        %{ return ast.PrefixExpression ('+', n2.val) %}
     | '-' OpE  %prec '!'
                        %{ return ast.PrefixExpression ('-', n2.val) %}
     | '!' OpE          %{ return ast.PrefixExpression ('!', n2.val) %}
     | '~' OpE          %{ return ast.PrefixExpression ('~', n2.val) %}
     | 'typeof' OpE     %{ return ast.Typeof (n2.val) %}
     | 'void' OpE       %{ return ast.Void (n2.val) %}
     | 'delete' OpE     %{ return ast.Delete (n2.val) %}

     | OpE '++'         %{ return ast.PostfixExpression ('++', n1.val) %}
     | '++' OpE         %{ return ast.PrefixExpression ('++', n2.val) %}
     | OpE '--'         %{ return ast.PostfixExpression ('--', n1.val) %}
     | '--' OpE         %{ return ast.PrefixExpression ('--', n2.val) %}

     | LhsE
     ;

LhsE -> NewE
      | CallE
      ;

NewE -> MemberE
      | 'new' NewE              %{ return ast.New (n2.val, ast.ArgumentList ()) %}
      ;

MemberE -> Primary
         | MemberE '[' E ']'    %{ return ast.Index (n3.val, n1.val) %}
         | MemberE '.' ID       %{ return ast.Selection (n3.val, n1.val) %}
         | 'new' MemberE Arguments
                                %{ return ast.New (n2.val, n3.val) %}
         ;

CallE -> MemberE Arguments      %{ return ast.Call (n1.val, n2.val) %}
       | CallE Arguments        %{ return ast.Call (n1.val, n2.val) %}
       | CallE '[' E ']'        %{ return ast.Index (n3.val, n1.val) %}
       | CallE '.' ID           %{ return ast.Selection (n3.val, n1.val) %}
       ;

Arguments -> '(' ')'            %{ return ast.ArgumentList () %}
           | '(' ArgList ')'    %{ return n2.val %}
           ;

ArgList -> AssnE                %{ return ast.ArgumentList (n1.val) %}
         | AssnE ',' ArgList    %{ n3.val.add (n1.val, 0); return n3.val %}
         ;

Primary -> 'this'               %{ return ast.This () %}
         | ID
         | Literal
         | '(' E ')'            %{ return n2.val %}
         ;

Literal -> NumLiteral
         | StringLiteral
         | RegExpLiteral
         | ArrayLiteral
         | ObjectLiteral
         | Lambda
         | 'true'               %{ return ast.True_ () %}
         | 'false'              %{ return ast.False_ () %}
         | 'null'               %{ return ast.Null () %}
         ;

NumLiteral -> ExpLiteral
            | FloatLiteral
            | OctalLiteral
            | IntLiteral
            | HexLiteral
            ;
ExpLiteral -> /[1-9][0-9]*[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            | /\.[0-9]+[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            | /[0-9]+\.[0-9]*[eE][+-]?[0-9]+/
                                %{ return ast.Number (n1.val) %}
            ;
FloatLiteral -> /\.[0-9]+/      %{ return ast.Number (n1.val) %}
              | /[0-9]+\.[0-9]*/
                                %{ return ast.Number (n1.val) %}
              ;
OctalLiteral -> /[0][0-7]*/     %{ return ast.Number (n1.val) %} ;
IntLiteral   -> /[1-9][0-9]*/   %{ return ast.Number (n1.val) %} ;
HexLiteral   -> /0[xX][0-9a-fA-F]+/ 
                                %{ return ast.Number (n1.val) %} ;

StringLiteral -> /\'(?:\\\\|\\\'|\\\r\n|\\\r|\\\n|[^\'\r\n])*\'/
                                %{ return ast.String (n1.val[1:-1]) %}
               | /\"(?:\\\\|\\\"|\\\r\n|\\\r|\\\n|[^\"\r\n])*\"/
                                %{ return ast.String (n1.val[1:-1]) %}
               ;

RegExpLiteral -> /\/(?:\\\\|\\\/|[^\/\r\n])*\/[a-zA-Z]*/ 
                                %{ return ast.Regex (n1.val) %} ;

ArrayLiteral -> '[' ArrayElements ']'
                                %{ return n2.val %} ;
ArrayElements -> ArrayElement   %{
    if isinstance (n1.val, ast.EmptyStatement):
        return ast.ArrayInit ()
    else:
        return ast.ArrayInit (n1.val)
%}
               | ArrayElement ',' ArrayElements
                                %{ n3.val.add (n1.val, 0); return n3.val %}
               ;
ArrayElement -> _               %{ return ast.EmptyStatement () %}
              | AssnE
              ;


ObjectLiteral -> '{' Properties '}'
                                %{ return n2.val %}
               | '{' PropertyList ',' '}'
                                %{ return n2.val %}
               ;
Properties -> _                 %{ return ast.ObjectInit () %}
            | PropertyList
            ;
PropertyList -> Property        %{ return ast.ObjectInit (n1.val) %}
              | Property ',' PropertyList
                                %{ n3.val.add (n1.val, 0); return n3.val %}
              ;
Property -> PropertyName ':' E  %{ return ast.PropertyInit (n1.val, n3.val) %};
PropertyName -> ID
              | StringLiteral
              | NumLiteral
              ;

//-----------------------------------------------------------------------------
// Sundry tokens
//

EOS     -> ';' | NL ;

ID -> /[_$a-zA-Z][_$a-zA-Z0-9]*/
                                %{ return ast.Identifier (n1.val) %} ;

'''

_exprparser = cfl_parser.makeParser (_exprgrammar)