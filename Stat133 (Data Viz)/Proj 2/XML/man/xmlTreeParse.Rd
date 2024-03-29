\name{xmlTreeParse}
\alias{xmlTreeParse}
\alias{htmlTreeParse}
\alias{xmlInternalTreeParse}
\title{XML Parser}
\description{
 Parses an XML or HTML file or string containing XML/HTML content, and generates an R 
 structure representing the XML/HTML tree.  Use \code{htmlTreeParse} when the content is known
 to be (potentially malformed) HTML.
 This function has numerous parameters/options and operates quite differently
 based on  their values.
  It can create trees in R or using internal C-level nodes, both of
  which are useful in different contexts.
 It can perform conversion of the nodes into R objects using
 caller-specified  handler functions and this can be used to 
 map the XML document directly into R data structures,
 by-passing the conversion to an R-level tree which would then
 be processed recursively or with multiple descents to extract the
 information of interest.

 \code{xmlInternalTreeParse} is identical to \code{xmlTreeParse}
 except it has no \code{useInternalNodes} parameter and 
  uses \code{TRUE} for its operation, i.e. working with internal nodes.
}
\usage{
xmlTreeParse(file, ignoreBlanks=TRUE, handlers=NULL, replaceEntities=FALSE,
             asText=FALSE, trim=TRUE, validate=FALSE, getDTD=TRUE,
             isURL=FALSE, asTree = FALSE, addAttributeNamespaces = FALSE,
             useInternalNodes = FALSE, isSchema = FALSE,
             fullNamespaceInfo = FALSE, encoding = character(),
             useDotNames = length(grep("^\\.", names(handlers))) > 0,
             xinclude = TRUE, addFinalizer = TRUE, error = xmlErrorCumulator())

xmlInternalTreeParse(file, ignoreBlanks=TRUE, handlers=NULL, replaceEntities=FALSE,
             asText=FALSE, trim=TRUE, validate=FALSE, getDTD=TRUE,
             isURL=FALSE, asTree = FALSE, addAttributeNamespaces = FALSE,
             useInternalNodes = TRUE, isSchema = FALSE,
             fullNamespaceInfo = FALSE, encoding = character(),
             useDotNames = length(grep("^\\.", names(handlers))) > 0,
             xinclude = TRUE, addFinalizer = TRUE, error = xmlErrorCumulator())

htmlTreeParse(file, ignoreBlanks = TRUE, handlers = NULL,
              replaceEntities = FALSE, asText = FALSE, trim = TRUE,
              isURL = FALSE, asTree = FALSE, 
              useInternalNodes = FALSE, encoding = character(),
              useDotNames = length(grep("^\\.", names(handlers))) > 0,
              xinclude = FALSE, addFinalizer = TRUE, 
              error = xmlErrorCumulator()) 
}

\arguments{
 \item{file}{ The name of the file containing the XML contents.
This can contain \~ which is expanded to the user's
home directory.
It can also be a URL. See \code{isURL}.
Additionally, the file can be compressed (gzip)
and is read directly without the user having
to de-compress (gunzip) it.}
 \item{ignoreBlanks}{ logical value indicating whether
text elements made up entirely of white space should be included
in the resulting `tree'. }
 \item{handlers}{Optional collection of functions
  used to map the different XML nodes to R
  objects. Typically, this is a named list of functions,
   and a closure can be used to provide local data.
  This provides a way of filtering the tree as it is being
  created, adding or removing nodes, and generally processing
  them as they are constructed in the C code.

   In a recent addition to the package (version 0.99-8),
   if this is specified as a single function object,
   we call that function for each node in the underlying DOM tree.
   It is invoked with the new node and its parent node.
  }
  \item{replaceEntities}{
   logical value indicating whether to substitute entity references
    with their text directly. This should be left as False.
    The text still appears as the value of the node, but there
    is more information about its source, allowing the parse to be reversed
    with full reference information.
    }
  \item{asText}{logical value indicating that the first argument,
    `file', 
     should be treated as the XML text to parse, not the name of 
     a file. This allows the contents of documents to be retrieved 
     from different sources (e.g. HTTP servers, XML-RPC, etc.) and still
     use this parser.}
 \item{trim}{
  whether to strip white space from the beginning and end of text strings.
}
\item{validate}{
logical indicating whether to use a validating parser or not, or in other words
check the contents against the DTD specification. If this is true, warning
messages will be displayed about errors in the DTD and/or document, but the parsing 
will proceed except for the presence of terminal errors.
}
\item{getDTD}{
logical flag indicating whether the DTD (both internal and external)
should be returned along with the document nodes. This changes the 
return type.
}
 \item{isURL}{
   indicates whether the \code{file}  argument refers to a URL
  (accessible via ftp or http) or a regular file on the system.
  If \code{asText} is TRUE, this should not be specified.
  The function attempts to determine whether the 
  data source is a URL by using \code{\link{grep}}
  to look for http or ftp at the start of the string.
  The libxml parser handles the connection to servers,
  not the R facilities (e.g. \code{\link{scan}}).
 }
 \item{asTree}{this only applies when on passes a value for
   the  \code{handlers} argument and is used then to determine
   whether the DOM tree should be returned or the \code{handlers}
   object.
 }
 \item{addAttributeNamespaces}{a logical value indicating whether to
   return the namespace in the names of the attributes within a node
   or to omit them. If this is \code{TRUE}, an attribute such as
   \code{xsi:type="xsd:string"} is reported with the name
     \code{xsi:type}.
    If it is \code{FALSE}, the name of the attribute is \code{type}.}
 \item{useInternalNodes}{a logical value indicating whether 
  to call the converter functions with objects of class
   \code{XMLInternalNode} rather than \code{XMLNode}.
   This should make things faster as we do not convert  the 
  contents of the internal nodes to R explicit objects.
  Also, it allows one to access the parent and ancestor nodes.
  However, since the objects refer to volatile C-level objects,
  one cannot store these nodes for use in further computations within R.
  They \dQuote{disappear} after the processing the XML document is completed.

  If this argument is \code{TRUE} and no handlers are provided, the
  return value is a reference to the internal C-level document pointer.
  This can be used to do post-processing via XPath expressions using
  \code{\link{getNodeSet}}.
}
\item{isSchema}{a logical value indicating whether the document
  is an XML schema (\code{TRUE}) and should be parsed as such using
  the built-in schema parser in libxml.}
\item{fullNamespaceInfo}{a logical value indicating whether
  to provide the namespace URI and prefix on each node
  or just the prefix.  The latter (\code{FALSE}) is
  currently the default as that was the original way the
  package behaved.   However, using
  \code{TRUE} is more informative and we will make this
  the default in the future.
}
\item{encoding}{ a character string (scalar) giving the encoding for the
  document.  This is optional as the document should contain its own
  encoding information. However, if it doesn't, the caller can specify
  this for the parser.
}

\item{useDotNames}{a logical value
  indicating whether to use the
  newer format for identifying general element function handlers
  with the '.' prefix, e.g. .text, .comment, .startElement.
  If this is \code{FALSE}, then the older format
  text, comment, startElement, ...
  are used. This causes problems when there are indeed nodes
  named text or comment or startElement as a
  node-specific handler are confused with the corresponding
  general handler of the same name. Using \code{TRUE}
  means that your list of handlers should have names that use
  the '.' prefix for these general element handlers.
  This is the preferred way to write new code.
}
\item{xinclude}{a logical value indicating whether
  to process nodes of the form \code{<xi:include xmlns:xi="http://www.w3.org/2001/XInclude">}
  to insert content from other parts of (potentially different)
  documents. \code{TRUE} means resolve the external references;
  \code{FALSE} means leave the node as is.
  Of course, one can process these nodes oneself after document has
  been parse using handler functions or working on the DOM.
  Please note that the syntax for inclusion using XPointer
  is not the same as XPath and the results can be a little
  unexpected and confusing. See the libxml2 documentation for more details.
}
 \item{addFinalizer}{a logical value indicating whether the
   default finalizer routine should be registered to
   free the internal xmlDoc when R no longer has a reference to this
   external pointer object. This is only relevant when
   \code{useInternalNodes} is \code{TRUE}.
 }

  \item{error}{a function that is invoked when the XML parser reports
    an error.
    When an error is encountered, this is called with 7 arguments.
   See \code{\link{xmlStructuredStop}} for information about these

   If parsing completes and no document is generated, this function is
   called again with only argument which is a character vector of
   length 0.  This gives the function an opportunity to report all the 
   errors and raise an exception rather than doing this when it sees
   th first one.

    This function can do what it likes with the information.
    It can raise an R error or let parser continue and potentially
    find further errors.

    The default value of this argument supplies a function that 
    cumulates the errors

    If this is \code{NULL}, the default error handler function in the
    package  \code{\link{xmlStructuredStop}} is invoked and this will 
    raise an error in R at that time in R.
}
}
\details{
 The \code{handlers} argument is used similarly
to those specified in \link{xmlEventParse}.
 When an XML tag (element) is processed,
  we look for a function in this collection 
  with the same name as the tag's name. 
  If this is not found, we look for one named
  \code{startElement}. If this is not found, we use the default
  built in converter.
  The same works for comments, entity references, cdata, processing instructions,
  etc.
 The default entries should be named
\code{comment}, \code{startElement},
\code{externalEntity},
\code{processingInstruction},
\code{text}, \code{cdata} and \code{namespace}.
All but the last should take the XMLnode as their first argument.
In the future, other information may be passed via \dots,
for example, the depth in the tree, etc.
Specifically, the second argument will be the parent node into which they
are being added, but this is not currently implemented,
so should have a default value (\code{NULL}).

The \code{namespace} function is called with a single argument which
is an object of class \code{XMLNameSpace}.  This contains
\begin{description} 
\item[id] the namespace identifier as used to
qualify tag names; 
\item[uri] the value of the namespace identifier,
i.e. the URI
 identifying the namespace.
\item[local] a logical value indicating whether the definition
is local to the document being parsed.
\end{description}

One should note that the \code{namespace} handler is called before the
node in which the namespace definition occurs and its children are
processed.  This is different than the other handlers which are called
after the child nodes have been processed.

Each of these functions can return arbitrary values that are then
entered into the tree in place of the default node passed to the
function as the first argument.  This allows the caller to generate
the nodes of the resulting document tree exactly as they wish.  If the
function returns \code{NULL}, the node is dropped from the resulting
tree. This is a convenient way to discard nodes having processed their
contents.

}
\value{
 By default ( when \code{useInternalNodes} is \code{FALSE}, 
  \code{getDTD} is \code{TRUE},  and no
 handler functions are provided), the return value is, an object of
 (S3) class \code{XMLDocument}.
 This has two fields named \code{doc} and \code{dtd}
 and are of class \code{DTDList} and \code{XMLDocumentContent} respectively.

 If \code{getDTD} is \code{FALSE},  only the \code{doc} object is returned.
 
 The \code{doc} object has three fields of its own:
  \code{file}, \code{version} and \code{children}.
  \item{\code{file}}{The (expanded) name of the file  containing the XML.}
  \item{\code{version}}{A string identifying the  version of XML used by the document.}
  \item{\code{children}}{
 A list of the XML nodes at the top of the document.
 Each of these is of class \code{XMLNode}.
 These are made up of 4 fields.
   \item{\code{name}}{The name of the element.}
   \item{\code{attributes}}{For regular elements, a named list
     of XML attributes converted from the 
       <tag x="1" y="abc">}
   \item{\code{children}}{List of sub-nodes.}
   \item{\code{value}}{Used only for text entries.}
 Some nodes specializations of \code{XMLNode}, such as 
 \code{XMLComment}, \code{XMLProcessingInstruction},
 \code{XMLEntityRef} are used.

 If the value of the argument getDTD is TRUE and the document refers
 to a DTD via a top-level DOCTYPE element, the DTD and its information
 will be available in the \code{dtd} field.  The second element is a
 list containing the external and internal DTDs. Each of these
 contains 2 lists - one for element definitions and another for entities. See
 \code{\link{parseDTD}}. 


 If a list of functions is given via \code{handlers}, 
 this list is returned. Typically, these handler functions
 share state via a closure and the resulting updated data structures
 which contain the extracted and processed values from the XML
 document can be retrieved via a function in this handler list.

 If \code{asTree} is \code{TRUE}, then the converted tree is returned.
 What form this takes depends on what the handler functions have
 done to process the XML tree.

 If \code{useInternalNodes} is \code{TRUE} and no handlers are
 specified, an object of S3 class \code{XMLInternalDocument} is
 returned. This can be used in much the same ways as an
 \code{XMLDocument}, e.g. with \code{\link{xmlRoot}},
 \code{\link{docName}} and so on to traverse the tree.
  It can also be used with XPath queries via \code{\link{getNodeSet}},
 \code{\link{xpathApply}} and \code{doc["xpath-expression"]}.

 If internal nodes are used and the internal tree returned directly,
 all the nodes are returned as-is and no attempt to 
  trim white space, remove ``empty'' nodes (i.e. containing only white
 space), etc. is done. This is potentially quite expensive and so is
 not done generally, but should  be done during the processing
 of the nodes.  When using XPath queries, such nodes are easily
 identified and/or ignored and so do not cause any difficulties.
 They do become an issue when dealing with a node's chidren
 directly and so one can use simple filtering techniques such as
 \code{ xmlChildren(node)[ ! xmlSApply(node, inherits,  "XMLInternalTextNode")]}
 and even check the \code{\link{xmlValue}} to determine if it contains only
 white space.
 \code{ xmlChildren(node)[ ! xmlSApply(node, function(x) inherit(x,
              "XMLInternalTextNode")] && trim(xmlValue(x)) == "")}
  
 } }

 \references{\url{http://xmlsoft.org}, \url{http://www.w3.org/xml}}

 \author{Duncan Temple Lang <duncan@wald.ucdavis.edu>} 

\note{Make sure  that the necessary 3rd party libraries are available.}

\seealso{ \link{xmlEventParse},
  \code{\link{free}} for releasing the memory when
  an \code{XMLInternalDocument} object is returned.
}

\examples{
 fileName <- system.file("exampleData", "test.xml", package="XML")
   # parse the document and return it in its standard format.

 xmlTreeParse(fileName)

   # parse the document, discarding comments.
  
 xmlTreeParse(fileName, handlers=list("comment"=function(x,...){NULL}), asTree = TRUE)

   # print the entities
 invisible(xmlTreeParse(fileName,
            handlers=list(entity=function(x) {
                                    cat("In entity",x$name, x$value,"\n")
                                    x}
                                  ), asTree = TRUE
                          )
          )

 # Parse some XML text.
 # Read the text from the file
 xmlText <- paste(readLines(fileName), "\n", collapse="")

 print(xmlText)
 xmlTreeParse(xmlText, asText=TRUE)


    # with version 1.4.2 we can pass the contents of an XML
    # stream without pasting them.
 xmlTreeParse(readLines(fileName), asText=TRUE)


 # Read a MathML document and convert each node
 # so that the primary class is 
 #   <name of tag>MathML
 # so that we can use method  dispatching when processing
 # it rather than conditional statements on the tag name.
 # See plotMathML() in examples/.
 fileName <- system.file("exampleData", "mathml.xml",package="XML")
m <- xmlTreeParse(fileName, 
                  handlers=list(
                   startElement = function(node){
                   cname <- paste(xmlName(node),"MathML", sep="",collapse="")
                   class(node) <- c(cname, class(node)); 
                   node
                }))



  # In this example, we extract _just_ the names of the
  # variables in the mtcars.xml file. 
  # The names are the contents of the <variable>
  # tags. We discard all other tags by returning NULL
  # from the startElement handler.
  #
  # We cumulate the names of variables in a character
  # vector named `vars'.
  # We define this within a closure and define the 
  # variable function within that closure so that it
  # will be invoked when the parser encounters a <variable>
  # tag.
  # This is called with 2 arguments: the XMLNode object (containing
  # its children) and the list of attributes.
  # We get the variable name via call to xmlValue().

  # Note that we define the closure function in the call and then 
  # create an instance of it by calling it directly as
  #   (function() {...})()

  # Note that we can get the names by parsing
  # in the usual manner and the entire document and then executing
  # xmlSApply(xmlRoot(doc)[[1]], function(x) xmlValue(x[[1]]))
  # which is simpler but is more costly in terms of memory.
 fileName <- system.file("exampleData", "mtcars.xml", package="XML")
 doc <- xmlTreeParse(fileName,  handlers = (function() { 
                                 vars <- character(0) ;
                                list(variable=function(x, attrs) { 
                                                vars <<- c(vars, xmlValue(x[[1]])); 
                                                NULL}, 
                                     startElement=function(x,attr){
                                                   NULL
                                                  }, 
                                     names = function() {
                                                 vars
                                             }
                                    )
                               })()
                     )

  # Here we just print the variable names to the console
  # with a special handler.
 doc <- xmlTreeParse(fileName, handlers = list(
                                  variable=function(x, attrs) {
                                             print(xmlValue(x[[1]])); TRUE
                                           }), asTree=TRUE)


  # This should raise an error.
  try(xmlTreeParse(
            system.file("exampleData", "TestInvalid.xml", package="XML"),
            validate=TRUE))

\dontrun{
 # Parse an XML document directly from a URL.
 # Requires Internet access.
 xmlTreeParse("http://www.omegahat.org/Scripts/Data/mtcars.xml", asText=TRUE)
}

  counter = function() {
              counts = integer(0)
              list(startElement = function(node) {
                                     name = xmlName(node)
                                     if(name \%in\% names(counts))
                                          counts[name] <<- counts[name] + 1
                                     else
                                          counts[name] <<- 1
                                  },
                    counts = function() counts)
            }

   h = counter()
   xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"),  handlers = h, useInternalNodes = TRUE)
   h$counts()



 f = system.file("examples", "index.html", package = "XML")
 htmlTreeParse(readLines(f), asText = TRUE)
 htmlTreeParse(readLines(f))

  # Same as 
 htmlTreeParse(paste(readLines(f), collapse = "\n"), asText = TRUE)


 getLinks = function() { 
       links = character() 
       list(a = function(node, ...) { 
                   links <<- c(links, xmlGetAttr(node, "href"))
                   node 
                }, 
            links = function()links)
     }

 h1 = getLinks()
 htmlTreeParse(system.file("examples", "index.html", package = "XML"), handlers = h1)
 h1$links()

 h2 = getLinks()
 htmlTreeParse(system.file("examples", "index.html", package = "XML"), handlers = h2, useInternalNodes = TRUE)
 all(h1$links() == h2$links())

  # Using flat trees
 tt = xmlHashTree()
 f = system.file("exampleData", "mtcars.xml", package="XML")
 xmlTreeParse(f, handlers = tt[[".addNode"]])
 xmlRoot(tt)



 doc = xmlTreeParse(f, useInternalNodes = TRUE)

 sapply(getNodeSet(doc, "//variable"), xmlValue)
         
 #free(doc) 


  # character set encoding for HTML
 f = system.file("exampleData", "9003.html", package = "XML")
   # we specify the encoding
 d = htmlTreeParse(f, encoding = "UTF-8")
   # get a different result if we do not specify any encoding
 d.no = htmlTreeParse(f)
   # document with its encoding in the HEAD of the document.
 d.self = htmlTreeParse(system.file("exampleData", "9003-en.html",package = "XML"))
   # XXX want to do a test here to see the similarities between d and
   # d.self and differences between d.no


  # include
 f = system.file("exampleData", "nodes1.xml", package = "XML")
 xmlRoot(xmlTreeParse(f, xinclude = FALSE))
 xmlRoot(xmlTreeParse(f, xinclude = TRUE))

 f = system.file("exampleData", "nodes2.xml", package = "XML")
 xmlRoot(xmlTreeParse(f, xinclude = TRUE))

  # Errors
  try(xmlTreeParse("<doc><a> & < <?pi > </doc>"))

    # catch the error by type.
 tryCatch(xmlTreeParse("<doc><a> & < <?pi > </doc>"),
                "XMLParserErrorList" = function(e) {
                                                      cat("Errors in XML document\n", e$message, "\n")
                                                    })

    #  terminate on first error            
  try(xmlTreeParse("<doc><a> & < <?pi > </doc>", error = NULL))

    #  see xmlErrorCumulator in the XML package 


  f = system.file("exampleData", "book.xml", package = "XML")
  doc.trim = xmlInternalTreeParse(f, trim = TRUE)
  doc = xmlInternalTreeParse(f, trim = FALSE)
  xmlSApply(xmlRoot(doc.trim), class)
      # note the additional XMLInternalTextNode objects
  xmlSApply(xmlRoot(doc), class)


  top = xmlRoot(doc)
  textNodes = xmlSApply(top, inherits, "XMLInternalTextNode")
  sapply(xmlChildren(top)[textNodes], xmlValue)
}

\keyword{file}
\keyword{IO}

