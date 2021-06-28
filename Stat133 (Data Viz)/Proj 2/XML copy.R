### Name: addChildren
### Title: Add child nodes to an XML node
### Aliases: addChildren removeChildren removeNodes replaceNodes
###   addAttributes removeAttributes addChildren,XMLInternalNode-method
###   addChildren,XMLNode-method
###   addAttributes,XMLInternalElementNode-method
###   addAttributes,XMLNode-method
###   removeAttributes,XMLInternalElementNode-method
###   removeAttributes,XMLNode-method
### Keywords: IO programming

### ** Examples


b = newXMLNode("bob", namespace = c(r = "http://www.r-project.org", omg = "http://www.omegahat.org"))

cat(saveXML(b), "\n")

addAttributes(b, a = 1, b = "xyz", "r:version" = "2.4.1", "omg:len" = 3)
cat(saveXML(b), "\n")

removeAttributes(b, "a", "r:version")
cat(saveXML(b), "\n")

removeAttributes(b, .attrs = names(xmlAttrs(b)))

addChildren(b, newXMLNode("el", "Red", "Blue", "Green",
                           attrs = c(lang ="en")))

k = lapply(letters, newXMLNode)
addChildren(b, kids = k)

cat(saveXML(b), "\n")

removeChildren(b, "a", "b", "c", "z")

  # can mix numbers and names
removeChildren(b, 2, "e")  # d and e

cat(saveXML(b), "\n")

i = xmlChildren(b)[[5]]
xmlName(i)

 # have the identifiers
removeChildren(b, kids = c("m", "n", "q"))


x <- xmlNode("a", 
               xmlNode("b", "1"),
               xmlNode("c", "1"),
               "some basic text")

v = removeChildren(x, "b")

  # remove c and b
v = removeChildren(x, "c", "b")

  # remove the text and "c" leaving just b
v = removeChildren(x, 3, "c")

## Not run: 
##D     # this won't work as the 10 gets coerced to a 
##D     # character vector element to be combined with 'w'
##D     # and there is no node name 10.
##D  removeChildren(b, kids = c(10, "w"))
## End(Not run)

 # for R-level nodes (not internal)

z = xmlNode("arg", attrs = c(default="TRUE"),
              xmlNode("name", "foo"), xmlNode("defaultValue","1:10"))

o = addChildren(z,
                "some text",
                xmlNode("a", "a link", attrs = c(href = "http://www.omegahat.org/RSXML")))
o




### Name: addNode
### Title: Add a node to a tree
### Aliases: addNode addNode.XMLHashTree
### Keywords: IO

### ** Examples


  tt = xmlHashTree()

  top = addNode(xmlNode("top"), character(), tt)
  addNode(xmlNode("a"), top, tt)
  b = addNode(xmlNode("b"), top, tt)
  c = addNode(xmlNode("c"), b, tt)
  addNode(xmlNode("c"), top, tt)
  addNode(xmlNode("c"), b, tt)    
  addNode(xmlTextNode("Some text"), c, tt)

  xmlElementsByTagName(tt$top, "c")

  tt




### Name: getSibling
### Title: Manipulate sibling XML nodes
### Aliases: getSibling addSibling
### Keywords: IO

### ** Examples

  
          # Reading Apple's iTunes files
     # 
     #           Here we read  a "censored" "database" of songs from Apple's  iTune application
     #           which is stored in a property list.  The format is quite generic and 
     #            the fields for each song are given in the form
     #           
     #             <key>Artist</key><string>Person's name</string>
     #    
     #           So to find the names of the artists for all the songs, we want to 
     #           find all the <key>Artist<key> nodes and then get their next sibling
     #           which has the actual value.
     #         
     #           More information can be found in .
     #  
           fileName = system.file("exampleData", "iTunes.plist", package = "XML")

           doc = xmlTreeParse(fileName, useInternal = TRUE)
           nodes = getNodeSet(doc, "//key[text() = 'Artist']")
           sapply(nodes, function(x)  xmlValue(getSibling(x)))
        
   




### Name: append.xmlNode
### Title: Add children to an XML node
### Aliases: append.xmlNode append.XMLNode
### Keywords: file IO

### ** Examples

  # Create a very simple representation of a simple dataset.
  # This is just an example. The result is
   # <data numVars="2" numRecords="3">
   # <varNames>
   #  <string>
   #   A
   #  </string>
   #  <string>
   #   B
   #  </string>
   # </varNames>
   # <record>
   #  1.2 3.5
   # </record>
   # <record>
   #  20.2 13.9
   # </record>
   # <record>
   #  10.1 5.67
   # </record>
   # </data>

 n = xmlNode("data", attrs = c("numVars" = 2, numRecords = 3))
 n = append.xmlNode(n, xmlNode("varNames", xmlNode("string", "A"), xmlNode("string", "B")))
 n = append.xmlNode(n, xmlNode("record", "1.2 3.5"))
 n = append.xmlNode(n, xmlNode("record", "20.2 13.9"))
 n = append.xmlNode(n, xmlNode("record", "10.1 5.67"))

 print(n)

## Not run: 
##D    tmp <-  lapply(references, function(i) {
##D                                   if(!inherits(i, "XMLNode"))
##D                                     i <- xmlNode("reference", i)
##D                                   i
##D                               })
##D 
##D    r <- xmlNode("references")
##D    r[["references"]] <- append.xmlNode(r[["references"]], tmp)
## End(Not run)




### Name: [<-.XMLNode
### Title: Assign sub-nodes to an XML node
### Aliases: [<-.XMLNode [[<-.XMLNode
### Keywords: IO file

### ** Examples

 top <- xmlNode("top", xmlNode("next","Some text"))
 top[["second"]] <- xmlCDataNode("x <- 1:10")
 top[[3]] <- xmlNode("tag",attrs=c(id="name"))




### Name: asXMLNode
### Title: Converts non-XML node objects to XMLTextNode objects
### Aliases: asXMLNode coerce,XMLInternalNode,XMLNode-method
### Keywords: file

### ** Examples

   # creates an XMLTextNode.
 asXMLNode("a text node")

   # unaltered.
 asXMLNode(xmlNode("p"))




### Name: catalogResolve
### Title: Look up an element via the XML catalog mechanism
### Aliases: catalogResolve
### Keywords: IO

### ** Examples


if(!exists("Sys.setenv")) Sys.setenv = Sys.putenv

Sys.setenv("XML_CATALOG_FILES" = system.file("exampleData", "catalog.xml", package = "XML"))


catalogResolve("-//OASIS//DTD DocBook XML V4.4//EN", "public")

catalogResolve("http://www.omegahat.org/XSL/foo.xsl")

catalogResolve("http://www.omegahat.org/XSL/article.xsl", "uri")
catalogResolve("http://www.omegahat.org/XSL/math.xsl", "uri")

  # This one does not resolve anything, returning an empty value.
catalogResolve("http://www.oasis-open.org/docbook/xml/4.1.2/foo.xsl", "uri")

   # Vectorized and returns NA for the first and /tmp/html.xsl
   # for the second.

 catalogAdd("http://made.up.domain", "/tmp")
 catalogResolve(c("ddas", "http://made.up.domain/html.xsl"), asIs = TRUE)




### Name: catalogLoad
### Title: Manipulate XML catalog contents
### Aliases: catalogLoad catalogClearTable catalogAdd
### Keywords: IO

### ** Examples

  
          # Add a rewrite rule
     # 
     #  
          catalogAdd(c("http://www.omegahat.org/XML" = system.file("XML", package = "XML")))
          catalogAdd("http://www.omegahat.org/XML", system.file("XML", package = "XML"))
          catalogAdd("http://www.r-project.org/doc/", paste(R.home(), "doc", "", sep = .Platform$file.sep))
        
          # 
     #          This shows how we can load a catalog and then resolve a system identifier 
     #           that it maps.
     #  
          catalogLoad(system.file("exampleData", "catalog.xml", package = "XML"))

          catalogResolve("docbook4.4.dtd", "system")
          catalogResolve("-//OASIS//DTD DocBook XML V4.4//EN", "public")
        
   




### Name: docName
### Title: Accessors for name of XML document
### Aliases: docName docName<- docName<-,XMLInternalDocument-method
### Keywords: IO programming

### ** Examples

  f = system.file("exampleData", "catalog.xml",  package = "XML")
  doc = xmlInternalTreeParse(f)
  docName(doc)

  doc = xmlInternalTreeParse("<a><b/></a>", asText = TRUE)
      # an NA
  docName(doc)
  docName(doc) = "Simple XML example"
  docName(doc)




### Name: Doctype-class
### Title: Class to describe a reference to an XML DTD
### Aliases: Doctype-class
### Keywords: classes

### ** Examples

  d = Doctype(name = "section", public = c("-//OASIS//DTD DocBook XML V4.2//EN", "http://oasis-open.org/docbook/xml/4.2/docbookx.dtd"))  




### Name: Doctype
### Title: Constructor for DTD reference
### Aliases: Doctype coerce,Doctype,character-method
### Keywords: IO

### ** Examples


  d = Doctype(name = "section", public = c("-//OASIS//DTD DocBook XML V4.2//EN", "http://oasis-open.org/docbook/xml/4.2/docbookx.dtd"))
  as(d, "character")

   # this call switches the system to the URI associated with the PUBLIC element.
  d = Doctype(name = "section", public = c("-//OASIS//DTD DocBook XML V4.2//EN"), system = "http://oasis-open.org/docbook/xml/4.2/docbookx.dtd")




### Name: dtdElement
### Title: Gets the definition of an element or entity from a DTD.
### Aliases: dtdElement dtdEntity
### Keywords: file

### ** Examples

 dtdFile <- system.file("exampleData","foo.dtd", package="XML")
 foo.dtd <- parseDTD(dtdFile)
 
   # Get the definition of the `entry1' element
 tmp <- dtdElement("variable", foo.dtd)
 xmlAttrs(tmp)

 tmp <- dtdElement("entry1", foo.dtd)

  # Get the definition of the `img' entity
 dtdEntity("img", foo.dtd)




### Name: dtdElementValidEntry
### Title: Determines whether an XML element allows a particular type of
###   sub-element.
### Aliases: dtdElementValidEntry.character
###   dtdElementValidEntry.XMLElementContent
###   dtdElementValidEntry.XMLElementDef dtdElementValidEntry.XMLOrContent
###   dtdElementValidEntry.XMLSequenceContent dtdElementValidEntry
### Keywords: file

### ** Examples

 dtdFile <- system.file("exampleData", "foo.dtd",package="XML")
 dtd <- parseDTD(dtdFile) 
 
  dtdElementValidEntry(dtdElement("variables",dtd), "variable")




### Name: dtdIsAttribute
### Title: Query if a name is a valid attribute of a DTD element.
### Aliases: dtdIsAttribute
### Keywords: file

### ** Examples

 dtdFile <- system.file("exampleData", "foo.dtd", package="XML")
 foo.dtd <- parseDTD(dtdFile)

    # true
  dtdIsAttribute("numRecords", "dataset", foo.dtd)

    # false
  dtdIsAttribute("date", "dataset", foo.dtd)




### Name: dtdValidElement
### Title: Determines whether an XML tag is valid within another.
### Aliases: dtdValidElement
### Keywords: file

### ** Examples

 dtdFile <- system.file("exampleData", "foo.dtd", package="XML")
 foo.dtd <- parseDTD(dtdFile)

  # The following are true.
 dtdValidElement("variable","variables", dtd = foo.dtd)
 dtdValidElement("record","dataset", dtd = foo.dtd)

  # This is false.
 dtdValidElement("variable","dataset", dtd = foo.dtd)




### Name: free
### Title: Release the specified object and clean up its memory usage
### Aliases: free free,XMLInternalDocument-method
### Keywords: IO

### ** Examples

 f = system.file("exampleData", "boxplot.svg", package = "XML")
 doc = xmlTreeParse(f, useInternalNodes = TRUE)
 nodes = getNodeSet(doc, "//path")
 rm(nodes)
 # free(doc)




### Name: genericSAXHandlers
### Title: SAX generic callback handler list
### Aliases: genericSAXHandlers
### Keywords: file

### ** Examples

## Don't show:
# .InitSAXMethods()
names(genericSAXHandlers())
names(genericSAXHandlers(inc=c("startElement", "endElement", "text")))
names(genericSAXHandlers(ex=c("startElement", "endElement", "text")))
## End Don't show




### Name: getNodeSet
### Title: Find matching nodes in an internal XML tree/DOM
### Aliases: getNodeSet xpathApply xpathSApply matchNamespaces
### Keywords: file IO

### ** Examples

 doc = xmlTreeParse(system.file("exampleData", "tagnames.xml", package = "XML"), useInternalNodes = TRUE)
 
 els = getNodeSet(doc, "/doc//a[@status]")
 sapply(els, function(el) xmlGetAttr(el, "status"))

   # use of namespaces on an attribute.
 getNodeSet(doc, "/doc//b[@x:status]", c(x = "http://www.omegahat.org"))
 getNodeSet(doc, "/doc//b[@x:status='foo']", c(x = "http://www.omegahat.org"))

   # Because we know the namespace definitions are on /doc/a
   # we can compute them directly and use them.
 nsDefs = xmlNamespaceDefinitions(getNodeSet(doc, "/doc/a")[[1]])
 ns = structure(sapply(nsDefs, function(x) x$uri), names = names(nsDefs))
 getNodeSet(doc, "/doc//b[@omegahat:status='foo']", ns)[[1]]

 # free(doc) 

 #####
 f = system.file("exampleData", "eurofxref-hist.xml.gz", package = "XML") 
 e = xmlTreeParse(f, useInternal = TRUE)
 ans = getNodeSet(e, "//o:Cube[@currency='USD']", "o")
 sapply(ans, xmlGetAttr, "rate")

  # or equivalently
 ans = xpathApply(e, "//o:Cube[@currency='USD']", xmlGetAttr, "rate", namespaces = "o")
 # free(e)


  # Using a namespace
 f = system.file("exampleData", "SOAPNamespaces.xml", package = "XML") 
 z = xmlTreeParse(f, useInternal = TRUE)
 getNodeSet(z, "/a:Envelope/a:Body", c("a" = "http://schemas.xmlsoap.org/soap/envelope/"))
 getNodeSet(z, "//a:Body", c("a" = "http://schemas.xmlsoap.org/soap/envelope/"))
 # free(z)

  # Get two items back with namespaces
 f = system.file("exampleData", "gnumeric.xml", package = "XML") 
 z = xmlTreeParse(f, useInternalNodes = TRUE)
 getNodeSet(z, "//gmr:Item/gmr:name", c(gmr="http://www.gnome.org/gnumeric/v2"))

 #free(z)

 #####
 # European Central Bank (ECB) exchange rate data

  # Data is available from "http://www.ecb.int/stats/eurofxref/eurofxref-hist.xml"
  # or locally.

 uri = system.file("exampleData", "eurofxref-hist.xml.gz", package = "XML")
 doc = xmlTreeParse(uri, useInternalNodes = TRUE)

   # The default namespace for all elements is given by
 namespaces <- c(ns="http://www.ecb.int/vocabulary/2002-08-01/eurofxref")

     # Get the data for Slovenian currency for all time periods.
     # Find all the nodes of the form <Cube currency="SIT"...>

 slovenia = getNodeSet(doc, "//ns:Cube[@currency='SIT']", namespaces )

    # Now we have a list of such nodes, loop over them 
    # and get the rate attribute
 rates = as.numeric( sapply(slovenia, xmlGetAttr, "rate") )
    # Now put the date on each element
    # find nodes of the form <Cube time=".." ... >
    # and extract the time attribute
 names(rates) = sapply(getNodeSet(doc, "//ns:Cube[@time]", namespaces ), 
                      xmlGetAttr, "time")

    #  Or we could turn these into dates with strptime()
 strptime(names(rates), "%Y-%m-%d")

   #  Using xpathApply, we can do
 rates = xpathApply(doc, "//ns:Cube[@currency='SIT']", xmlGetAttr, "rate", namespaces = namespaces )
 rates = as.numeric(unlist(rates))

   # Using an expression rather than  a function and ...
 rates = xpathApply(doc, "//ns:Cube[@currency='SIT']", quote(xmlGetAttr(x, "rate")), namespaces = namespaces )

 #free(doc)

   #
  uri = system.file("exampleData", "namespaces.xml", package = "XML")
  d = xmlTreeParse(uri, useInternalNodes = TRUE)
  getNodeSet(d, "//c:c", c(c="http://www.c.org"))

  getNodeSet(d, "/o:a//c:c", c("o" = "http://www.omegahat.org", "c" = "http://www.c.org"))

   # since http://www.omegahat.org is the default namespace, we can
   # just the prefix "o" to map to that.
  getNodeSet(d, "/o:a//c:c", c("o", "c" = "http://www.c.org"))

   # the following, perhaps unexpectedly but correctly, returns an empty
   # with no matches
   
  getNodeSet(d, "//defaultNs", "http://www.omegahat.org")

   # But if we create our own prefix for the evaluation of the XPath
   # expression and use this in the expression, things work as one
   # might hope.
  getNodeSet(d, "//dummy:defaultNs", c(dummy = "http://www.omegahat.org"))

   # And since the default value for the namespaces argument is the
   # default namespace of the document, we can refer to it with our own
   # prefix given as 
  getNodeSet(d, "//d:defaultNs", "d")

   # And the syntactic sugar is 
  d["//d:defaultNs", namespaces = "d"]

   # this illustrates how we can use the prefixes in the XML document
   # in our query and let getNodeSet() and friends map them to the
   # actual namespace definitions.
   # "o" is used to represent the default namespace for the document
   # i.e. http://www.omegahat.org, and "r" is mapped to the same
   # definition that has the prefix "r" in the XML document.

  tmp = getNodeSet(d, "/o:a/r:b/o:defaultNs", c("o", "r"))
  xmlName(tmp[[1]])

  #free(d)

   # Work with the nodes and their content (not just attributes) from the node set.
   # From bondsTables.R in examples/

  doc = htmlTreeParse("http://finance.yahoo.com/bonds/composite_bond_rates", useInternalNodes = TRUE)
  if(is.null(xmlRoot(doc))) 
     doc = htmlTreeParse("http://finance.yahoo.com/bonds", useInternalNodes = TRUE)

     # Use XPath expression to find the nodes 
     #  <div><table class="yfirttbl">..
     # as these are the ones we want.

  if(!is.null(xmlRoot(doc))) {

   o = getNodeSet(doc, "//div/table[@class='yfirttbl']")

    # Write a function that will extract the information out of a given table node.
   readHTMLTable =
   function(tb)
    {
          # get the header information.
      colNames = sapply(tb[["thead"]][["tr"]]["th"], xmlValue)
      vals = sapply(tb[["tbody"]]["tr"],  function(x) sapply(x["td"], xmlValue))
      matrix(as.numeric(vals[-1,]),
              nrow = ncol(vals),
              dimnames = list(vals[1,], colNames[-1]),
              byrow = TRUE
            )
    }  

     # Now process each of the table nodes in the o list.
    tables = lapply(o, readHTMLTable)
    names(tables) = lapply(o, function(x) xmlValue(x[["caption"]]))
  }

     # this illustrates an approach to doing queries on a sub tree
     # within the document.
     # Note that there is a memory leak incurred here as we create a new
     # XMLInternalDocument in the getNodeSet().

    f = system.file("exampleData", "book.xml", package = "XML")
    doc = xmlTreeParse(f, useInternal = TRUE)
    ch = getNodeSet(doc, "//chapter")
    xpathApply(ch[[2]], "//section/title", xmlValue)

      # To fix the memory leak, we explicitly create a new document for
      # the subtree, perform the query and then free it _when_ we are done
      # with the resulting nodes.
    subDoc = xmlDoc(ch[[2]])
    xpathApply(subDoc, "//section/title", xmlValue)
    free(subDoc)

    txt = '<top xmlns="http://www.r-project.org" xmlns:r="http://www.r-project.org"><r:a><b/></r:a></top>'
    doc = xmlInternalTreeParse(txt, asText = TRUE)

## Not run: 
##D      # Will fail because it doesn't know what the namespace x is
##D      # and we have to have one eventhough it has no prefix in the document.
##D     xpathApply(doc, "//x:b")
## End(Not run)    
      # So this is how we do it - just  say x is to be mapped to the
      # default unprefixed namespace which we shall call x!
    xpathApply(doc, "//x:b", namespaces = "x")

       # Here r is mapped to the the corresponding definition in the document.
    xpathApply(doc, "//r:a", namespaces = "r")
       # Here, xpathApply figures this out for us, but will raise a warning.
    xpathApply(doc, "//r:a")

       # And here we use our own binding.
    xpathApply(doc, "//x:a", namespaces = c(x = "http://www.r-project.org"))




### Name: getXMLErrors
### Title: Get XML/HTML document parse errors
### Aliases: getXMLErrors
### Keywords: IO programming

### ** Examples

     # Get the "errors" in the HTML that was generated from this Rd file
  getXMLErrors(system.file("html", "getXMLErrors.html", package = "XML"))

## Not run: 
##D   getXMLErrors("http://www.omegahat.org/index.html")
## End(Not run)





### Name: length.XMLNode
### Title: Determine the number of children in an XMLNode object.
### Aliases: length.XMLNode
### Keywords: file

### ** Examples

  doc <- xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"))
  r <- xmlRoot(doc, skip=TRUE)
  length(r)
    # get the last entry
  r[[length(r)]]




### Name: libxmlVersion
### Title: Get the version of the libxml library.
### Aliases: libxmlVersion
### Keywords: IO

### ** Examples

 ver <- libxmlVersion()
 if(is.null(ver)) {
   cat("Relly old version of libxml\n")
 } else {
   if(ver$major > 1) {
     cat("Using libxml2\n")
   }
 }




### Name: names.XMLNode
### Title: Get the names of an XML nodes children.
### Aliases: names.XMLNode
### Keywords: file

### ** Examples

 doc <- xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"))
 names(xmlRoot(doc))

 r <- xmlRoot(doc)
 r[names(r) == "variables"]




### Name: newXMLDoc
### Title: Create internal XML node or document object
### Aliases: newXMLDoc newXMLNode newXMLPINode newXMLCDataNode
###   newXMLCommentNode newXMLTextNode newXMLDTDNode xmlDoc
###   coerce,vector,XMLInternalNode-method
### Keywords: IO

### ** Examples


doc = newXMLDoc()

 # Simple creation of an XML tree using these functions
top = newXMLNode("a")
newXMLNode("b", attrs = c(x = 1, y = 'abc'), parent = top)
newXMLNode("c", "With some text", parent = top)
d = newXMLNode("d", newXMLTextNode("With text as an explicit node"), parent = top)
newXMLCDataNode("x <- 1\n x > 2", parent = d)

newXMLPINode("R", "library(XML)", top)
newXMLCommentNode("This is a comment", parent = top)

o = newXMLNode("ol", parent = top)

kids = lapply(letters[1:3],
               function(x)
                  newXMLNode("li", x))
addChildren(o, kids)

cat(saveXML(top))

x = newXMLNode("block", "xyz", attrs = c(id = "bob"),
                      namespace = "fo",
                      namespaceDefinitions = c("fo" = "http://www.fo.org"))

xmlName(x, TRUE) == "fo"

  # a short cut to define a name space and make it the prefix for the
  # node, thus avoiding repeating the prefix via the namespace argument.
x = newXMLNode("block", "xyz", attrs = c(id = "bob"),
                      namespace = c("fo" = "http://www.fo.org"))

 # name space on the attribute
x = newXMLNode("block", attrs = c("fo:id" = "bob"),
                      namespaceDefinitions = c("fo" = "http://www.fo.org"))



x = summary(rnorm(1000))
d = xmlTree()
d$addNode("table", close = FALSE)

d$addNode("tr", .children = sapply(names(x), function(x) d$addNode("th", x)))
d$addNode("tr", .children = sapply(x, function(x) d$addNode("td", format(x))))

d$closeNode()

# Just doctype
z = xmlTree("people", dtd = "people")
# no public element
z = xmlTree("people", dtd = c("people", "", "http://www.omegahat.org/XML/types.dtd"))
# public and system
z = xmlTree("people", dtd = c("people", "//a//b//c//d", "http://www.omegahat.org/XML/types.dtd"))

# Using a DTD node directly.
dtd = newXMLDTDNode(c("people", "", "http://www.omegahat.org/XML/types.dtd"))
z = xmlTree("people", dtd = dtd)

x = rnorm(3)
z = xmlTree("r:data", namespaces = c(r = "http://www.r-project.org"))
z$addNode("numeric", attrs = c("r:length" = length(x)), close = FALSE)
lapply(x, function(v) z$addNode("el", x))
z$closeNode()
# should give   <r:data><numeric r:length="3"/></r:data>

# shows namespace prefix on an attribute, and different from the one on the node.
z = xmlTree()
z$addNode("r:data",  namespace = c(r = "http://www.r-project.org", omg = "http://www.omegahat.org"), close = FALSE)
x = rnorm(3)
z$addNode("r:numeric", attrs = c("omg:length" = length(x)))

z = xmlTree("people", namespaces = list(r = "http://www.r-project.org"))
z$setNamespace("r")

z$addNode("person", attrs = c(id = "123"), close = FALSE)
z$addNode("firstname", "Duncan")
z$addNode("surname", "Temple Lang")
z$addNode("title", "Associate Professor")
z$addNode("expertize", close = FALSE)
z$addNode("topic", "Data Technologies")
z$addNode("topic", "Programming Language Design")
z$addNode("topic", "Parallel Computing")
z$addNode("topic", "Data Visualization")
z$closeTag()
z$addNode("address", "4210 Mathematical Sciences Building, UC Davis")




### Name: parseDTD
### Title: Read a Document Type Definition (DTD)
### Aliases: parseDTD
### Keywords: file IO

### ** Examples

 dtdFile <- system.file("exampleData", "foo.dtd",package="XML")
 parseDTD(dtdFile)

    # Read from text
 txt <- readLines(dtdFile)
 txt <- paste(txt, "\n", collapse="")
 d <- parseDTD(txt, asText=TRUE)

## Not run: 
##D  url <- "http://www.omegahat.org/XML/DTDs/DatasetByRecord.dtd"
##D  d <- parseDTD(url, asText=FALSE)  
## End(Not run)




### Name: parseURI
### Title: Parse a URI string into its elements
### Aliases: parseURI URI-class
### Keywords: IO

### ** Examples

  parseURI("http://www.omegahat.org:8080/RCurl/index.html")
  parseURI("ftp://duncan@www.omegahat.org:8080/RCurl/index.html") 




### Name: print.XMLAttributeDef
### Title: Methods for displaying XML objects
### Aliases: print.XMLAttributeDef print.XMLCDataNode
###   print.XMLElementContent print.XMLElementDef print.XMLEntity
###   print.XMLEntityRef print.XMLNode print.XMLTextNode print.XMLComment
###   print.XMLOrContent print.XMLSequenceContent
###   print.XMLProcessingInstruction
### Keywords: IO file

### ** Examples

  fileName <- system.file("exampleData", "event.xml", package ="XML")

     # Example of how to get faithful copy of the XML.
  doc = xmlRoot(xmlTreeParse(fileName, trim = FALSE, ignoreBlanks = FALSE))
  print(doc, indent = FALSE, tagSeparator = "")

     # And now the default mechanism
  doc = xmlRoot(xmlTreeParse(fileName))
  print(doc)




### Name: saveXML
### Title: Output internal XML Tree
### Aliases: saveXML saveXML.XMLInternalDocument saveXML.XMLInternalDOM
###   saveXML.XMLInternalNode saveXML.XMLNode saveXML.XMLOutputStream
###   coerce,XMLInternalDocument,character-method
###   coerce,XMLInternalDOM,character-method
###   coerce,XMLInternalNode,character-method
### Keywords: IO file

### ** Examples

con <- xmlOutputDOM()
con$addTag("author", "Duncan Temple Lang")
con$addTag("address",  close=FALSE)
con$addTag("office", "2C-259")
con$addTag("street", "Mountain Avenue.")
con$addTag("phone", close=FALSE)
con$addTag("area", "908", attrs=c(state="NJ"))
con$addTag("number", "582-3217")
con$closeTag() # phone
con$closeTag() # address

saveXML(con$value(), file="out.xml")

# Work with entities

 f = system.file("exampleData", "test1.xml", package = "XML")
 doc = xmlRoot(xmlTreeParse(f))
 outFile = tempfile()
 saveXML(doc, outFile)
 alt = xmlRoot(xmlTreeParse(outFile))
 if(! identical(doc, alt) )
  stop("Problems handling entities!")

 con = textConnection("test1.xml", "w")
 saveXML(doc, con)
 close(con)
 alt = get("test1.xml")
 identical(doc, alt)


 x = newXMLNode("a", "some text", newXMLNode("c", "sub text"), "more text")

 cat(saveXML(x), "\n")

 cat(as(x, "character"), "\n")




### Name: SAXState-class
### Title: A virtual base class defining methods for SAX parsing
### Aliases: SAXState-class
### Keywords: classes

### ** Examples


# For each element in the document, grab the node name
# and increment the count in an vector for this name.

# We define an S4 class named ElementNameCounter which
# holds the vector of frequency counts for the node names.

 setClass("ElementNameCounter",
             representation(elements = "integer"), contains = "SAXState")

# Define a method for handling the opening/start of any XML node
# in the SAX streams.

 setMethod("startElement.SAX",  c(.state = "ElementNameCounter"),
           function(name, atts, .state = NULL) {

             if(name %in% names(.state@elements))
                 .state@elements[name] = as.integer(.state@elements[name] + 1)
             else
                 .state@elements[name] = as.integer(1)
             .state
           })

 filename = system.file("exampleData", "eurofxref-hist.xml.gz", package = "XML")

# Parse the file, arranging to have our startElement.SAX method invoked.
 z = xmlEventParse(filename, genericSAXHandlers(), state = new("ElementNameCounter"), addContext = FALSE)

 z@elements

  # Get the contents of all the comments in a character vector.

 setClass("MySAXState",
             representation(comments = "character"), contains = "SAXState")

 setMethod("comment.SAX",  c(.state = "MySAXState"),
           function(content, .state = NULL) {
             cat("comment.SAX called for MySAXState\n")
             .state@comments <- c(.state@comments, content)
             .state
           })

 filename = system.file("exampleData", "charts.svg", package = "XML")
 st = new("MySAXState")
 z = xmlEventParse(filename, genericSAXHandlers(useDotNames = TRUE), state = st)
 z@comments





### Name: supportsExpat
### Title: Determines which native XML parsers are being used.
### Aliases: supportsExpat supportsLibxml
### Keywords: file

### ** Examples

     # use Expat if possible, otherwise libxml
  fileName <- system.file("exampleData", "mtcars.xml", package="XML")
  xmlEventParse(fileName, useExpat = supportsLibxml())




### Name: toHTML
### Title: Create an HTML representation of the given R object, using
###   internal C-level nodes
### Aliases: toHTML toHTML,vector-method toHTML,matrix-method
###   toHTML,call-method
### Keywords: IO programming

### ** Examples

 cat(as(toHTML(rnorm(10)), "character"))




### Name: toString.XMLNode
### Title: Creates string representation of XML node
### Aliases: toString.XMLNode
### Keywords: file

### ** Examples

 x <- xmlRoot(xmlTreeParse(system.file("exampleData", "gnumeric.xml",
package = "XML")))

 toString(x)




### Name: xmlApply
### Title: Applies a function to each of the children of an XMLNode
### Aliases: xmlApply xmlApply.XMLNode xmlApply.XMLDocument
###   xmlApply.XMLDocumentContent xmlSApply xmlSApply.XMLNode
###   xmlSApply.XMLDocument xmlSApply.XMLDocumentContent
### Keywords: file

### ** Examples

 doc <- xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"))
 r <- xmlRoot(doc)
 xmlSApply(r[[2]], xmlName)

 xmlApply(r[[2]], xmlAttrs)

 xmlSApply(r[[2]], xmlSize)





### Name: xmlAttrs
### Title: Get the list of attributes of an XML node.
### Aliases: xmlAttrs xmlAttrs<- xmlAttrs.XMLElementDef xmlAttrs<-,XMLNode
###   xmlAttrs<-,XMLInternalNode xmlAttrs<-,XMLNode-method
###   xmlAttrs<-,XMLInternalElementNode-method xmlAttrs.XMLNode
###   xmlAttrs.XMLInternalNode
### Keywords: IO file

### ** Examples

 fileName <- system.file("exampleData", "mtcars.xml", package="XML") 
 doc <- xmlTreeParse(fileName)

 xmlAttrs(xmlRoot(doc))

 xmlAttrs(xmlRoot(doc)[["variables"]])

 doc <- xmlTreeParse(fileName, useInternalNodes = TRUE)
 d = xmlRoot(doc)
   # skip over the comment
 d = XML:::getSibling(d)

 xmlAttrs(d)
 xmlAttrs(d) <- c(name = "Motor Trend fuel consumption data",
                  author = "Motor Trends")
 xmlAttrs(d)

   # clear all the attributes and then set new ones.
 removeAttributes(d)
 xmlAttrs(d) <- c(name = "Motor Trend fuel consumption data",
                  author = "Motor Trends")



### Name: xmlChildren
### Title: Gets the sub-nodes within an XMLNode object.
### Aliases: xmlChildren xmlChildren<- xmlChildren.XMLNode
###   xmlChildren.XMLInternalNode
### Keywords: file

### ** Examples

  fileName <- system.file("exampleData", "mtcars.xml", package="XML")
  doc <- xmlTreeParse(fileName)
  names(xmlChildren(doc$doc$children[["dataset"]]))




### Name: xmlContainsEntity
### Title: Checks if an entity is defined within a DTD.
### Aliases: xmlContainsEntity xmlContainsElement
### Keywords: file

### ** Examples

 dtdFile <- system.file("exampleData", "foo.dtd", package="XML")
 foo.dtd <- parseDTD(dtdFile)
 
  # Look for entities.
 xmlContainsEntity("foo", foo.dtd)
 xmlContainsEntity("bar", foo.dtd)

  # Now look for an element
 xmlContainsElement("record", foo.dtd)




### Name: xmlDOMApply
### Title: Apply function to nodes in an XML tree/DOM.
### Aliases: xmlDOMApply
### Keywords: file

### ** Examples

 dom <- xmlTreeParse(system.file("exampleData","mtcars.xml", package="XML"))
 tagNames <- function() {
    tags <- character(0)
    add <- function(x) {
      if(inherits(x, "XMLNode")) {
        if(is.na(match(xmlName(x), tags)))
           tags <<- c(tags, xmlName(x))
      }

      NULL
    }

    return(list(add=add, tagNames = function() {return(tags)}))
 }

 h <- tagNames()
 xmlDOMApply(xmlRoot(dom), h$add) 
 h$tagNames()




### Name: xmlElementsByTagName
### Title: Retrieve the children of an XML node with a specific tag name
### Aliases: xmlElementsByTagName
### Keywords: IO file

### ** Examples

## Not run: 
##D  doc <- xmlTreeParse("http://www.omegahat.org/Scripts/Data/mtcars.xml")
##D  xmlElementsByTagName(doc$children[[1]], "variable")
## End(Not run)

 doc <- xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"))
 xmlElementsByTagName(xmlRoot(doc)[[1]], "variable")




### Name: xmlEventHandler
### Title: Default handlers for the SAX-style event XML parser
### Aliases: xmlEventHandler
### Keywords: file IO

### ** Examples

 xmlEventParse(system.file("exampleData", "mtcars.xml", package="XML"),
               handlers=xmlEventHandler())




### Name: xmlEventParse
### Title: XML Event/Callback element-wise Parser
### Aliases: xmlEventParse
### Keywords: file IO

### ** Examples

 fileName <- system.file("exampleData", "mtcars.xml", package="XML")

   # Print the name of each XML tag encountered at the beginning of each
   # tag.
   # Uses the libxml SAX parser.
 xmlEventParse(fileName,
                list(startElement=function(name, attrs){
                                    cat(name,"\n")
                                  }),
                useTagName=FALSE, addContext = FALSE)

## Not run: 
##D   # Parse the text rather than a file or URL by reading the URL's contents
##D   # and making it a single string. Then call xmlEventParse
##D xmlURL <- "http://www.omegahat.org/Scripts/Data/mtcars.xml"
##D xmlText <- paste(scan(xmlURL, what="",sep="\n"),"\n",collapse="\n")
##D xmlEventParse(xmlText, asText=TRUE)
## End(Not run)

    # Using a state object to share mutable data across callbacks
f <- system.file("exampleData", "gnumeric.xml", package = "XML")
zz <- xmlEventParse(f,
                    handlers = list(startElement=function(name, atts, .state) {
                                                     .state = .state + 1
                                                     print(.state)
                                                     .state
                                                 }), state = 0)
print(zz)



    # Illustrate the startDocument and endDocument handlers.
xmlEventParse(fileName,
               handlers = list(startDocument = function() {
                                                 cat("Starting document\n")
                                               },
                               endDocument = function() {
                                                 cat("ending document\n")
                                             }),
               saxVersion = 2)



if(libxmlVersion()$major >= 2) {

 startElement = function(x, ...) cat(x, "\n")

 xmlEventParse(file(f), handlers = list(startElement = startElement))

 # Parse with a function providing the input as needed.
 xmlConnection = 
  function(con) {

   if(is.character(con))
     con = file(con, "r")
  
   if(isOpen(con, "r"))
     open(con, "r")

   function(len) {

     if(len < 0) {
        close(con)
        return(character(0))
     }

      x = character(0)
      tmp = ""
    while(length(tmp) > 0 && nchar(tmp) == 0) {
      tmp = readLines(con, 1)
      if(length(tmp) == 0)
        break
      if(nchar(tmp) == 0)
        x = append(x, "\n")
      else
        x = tmp
    }
    if(length(tmp) == 0)
      return(tmp)
  
    x = paste(x, collapse="")

    x
  }
 }

 ff = xmlConnection(f)
 xmlEventParse(ff, handlers = list(startElement = startElement))

  # Parse from a connection. Each time the parser needs more input, it
  # calls readLines(<con>, 1)
 xmlEventParse(file(f),  handlers = list(startElement = startElement))

  # using SAX 2
 h = list(startElement = function(name, attrs, namespace, allNamespaces){ 
                                 cat("Starting", name,"\n")
                                 if(length(attrs))
                                     print(attrs)
                                 print(namespace)
                                 print(allNamespaces)
                         },
          endElement = function(name, uri) {
                          cat("Finishing", name, "\n")
            }) 
 xmlEventParse(system.file("exampleData", "namespaces.xml", package="XML"), handlers = h, saxVersion = 2)

 # This example is not very realistic but illustrates how to use the
 # branches argument. It forces the creation of complete nodes for
 # elements named <b> and extracts the id attribute.
 # This could be done directly on the startElement, but this just
 # illustrates the mechanism.
 filename = system.file("exampleData", "branch.xml", package="XML")
 b.counter = function() {
                nodes <- character()
                f = function(node) { nodes <<- c(nodes, xmlGetAttr(node, "id"))}
                list(b = f, nodes = function() nodes)
             }

  b = b.counter()
  invisible(xmlEventParse(filename, branches = b["b"]))
  b$nodes()

  filename = system.file("exampleData", "branch.xml", package="XML")
   
  invisible(xmlEventParse(filename, branches = list(b = function(node) {print(names(node))})))
  invisible(xmlEventParse(filename, branches = list(b = function(node) {print(xmlName(xmlChildren(node)[[1]]))})))
}

  
  ############################################
  # Stopping the parser mid-way and an example of using XMLParserContextFunction.

  startElement =
  function(ctxt, name, attrs, ...)  {
    print(ctxt)
      print(name)
      if(name == "rewriteURI") {
           cat("Terminating parser\n")
           xmlStopParser(ctxt)
      }
  }
  class(startElement) = "XMLParserContextFunction"  
  endElement =
  function(name, ...) 
    cat("ending", name, "\n")

  fileName = system.file("exampleData", "catalog.xml", package = "XML")
  xmlEventParse(fileName, handlers = list(startElement = startElement, endElement = endElement))




### Name: xmlFlatListTree
### Title: Constructors for trees stored as flat list of nodes with
###   information about parents and children.
### Aliases: xmlFlatListTree xmlHashTree
### Keywords: IO

### ** Examples

 f = system.file("exampleData", "dataframe.xml", package = "XML")
 tr  = xmlHashTree()
 xmlTreeParse(f, handlers = tr[[".addNode"]])

 tr # print the tree on the screen

  # Get the two child nodes of the dataframe node.
 xmlChildren(tr$dataframe)

  # Find the names of all the nodes.
 objects(tr)
  # Which nodes have children
 objects(tr$.children)

  # Which nodes are leaves, i.e. do not have children
 setdiff(objects(tr), objects(tr$.children))

  # find the class of each of these leaf nodes.
 sapply(setdiff(objects(tr), objects(tr$.children)),
         function(id) class(tr[[id]]))

  # distribution of number of children
 sapply(tr$.children, length)

  # Get the first A node
 tr$A

  # Get is parent node.
 xmlParent(tr$A)




### Name: xmlGetAttr
### Title: Get the value of an attribute in an XML node
### Aliases: xmlGetAttr
### Keywords: file

### ** Examples

 node <- xmlNode("foo", attrs=c(a="1", b="my name"))

 xmlGetAttr(node, "a")
 xmlGetAttr(node, "doesn't exist", "My own default value")

 xmlGetAttr(node, "b", "Just in case")




### Name: xmlHandler
### Title: Example XML Event Parser Handler Functions
### Aliases: xmlHandler
### Keywords: file IO

### ** Examples

## Not run: 
##D xmlURL <- "http://www.omegahat.org/Scripts/Data/mtcars.xml"
##D xmlText <- paste(scan(xmlURL, what="", sep="\n"),"\n",collapse="\n")
## End(Not run)

xmlURL <- system.file("exampleData", "mtcars.xml", package="XML")
xmlText <- paste(readLines(xmlURL), "\n", collapse="")
xmlEventParse(xmlText, handlers = NULL, asText=TRUE)
xmlEventParse(xmlText, xmlHandler(), useTagName=TRUE, asText=TRUE)




### Name: XMLInternalDocument-class
### Title: Class to represent reference to C-level data structure for an
###   XML document
### Aliases: XMLInternalDocument-class
###   coerce,XMLInternalNode,XMLInternalDocument-method
###   coerce,XMLInternalDocument,XMLInternalNode-method
### Keywords: classes

### ** Examples


 f = system.file("exampleData", "mtcars.xml", package="XML")
 doc = xmlTreeParse(f, useInternalNodes = TRUE)
 getNodeSet(doc, "//variables[@count]")
 getNodeSet(doc, "//record")

 getNodeSet(doc, "//record[@id='Mazda RX4']")

 # free(doc)




### Name: xmlName
### Title: Extraces the tag name of an XMLNode object.
### Aliases: xmlName xmlName<- xmlName.XMLComment xmlName.XMLNode
###   xmlName.XMLInternalNode
### Keywords: file

### ** Examples

 fileName <- system.file("exampleData", "test.xml", package="XML") 
 doc <- xmlTreeParse(fileName)
 xmlName(xmlRoot(doc)[[1]])

 tt = xmlRoot(doc)[[1]]
 xmlName(tt)
 xmlName(tt) <- "bob"

  # We can set the node on an internal object also.
 n = newXMLNode("x")

 xmlName(n)
 xmlName(n) <- "y"

 
 xmlName(n) <- "r:y"





### Name: xmlNamespace
### Title: Retrieve the namespace value of an XML node.
### Aliases: xmlNamespace xmlNamespace.XMLNode xmlNamespace.XMLInternalNode
###   xmlNamespace.character XMLNamespace-class
### Keywords: file

### ** Examples

  doc <- xmlTreeParse(system.file("exampleData", "job.xml", package="XML"))
  xmlNamespace(xmlRoot(doc))
  xmlNamespace(xmlRoot(doc)[[1]][[1]])

  node <- xmlNode("arg", xmlNode("name", "foo"), namespace="R")
  xmlNamespace(node)




### Name: xmlNamespaceDefinitions
### Title: Get definitions of any namespaces defined in this XML node
### Aliases: xmlNamespaceDefinitions getDefaultNamespace
### Keywords: IO

### ** Examples

  f = system.file("exampleData", "longitudinalData.xml", package = "XML")
  n = xmlRoot(xmlTreeParse(f))
  xmlNamespaceDefinitions(n)
  xmlNamespaceDefinitions(n, recursive = TRUE)

    # Now using internal nodes.
  f = system.file("exampleData", "namespaces.xml", package = "XML")
  n = xmlRoot(xmlInternalTreeParse(f))
  xmlNamespaceDefinitions(n)

  xmlNamespaceDefinitions(n, recursive = TRUE)




### Name: XMLNode-class
### Title: Classes to describe an XML node object.
### Aliases: XMLNode-class XMLInternalNode-class XMLInternalTextNode-class
###   XMLInternalElementNode-class XMLInternalCommentNode-class
###   XMLInternalPINode-class XMLInternalCDataNode-class XMLDTDNode-class
### Keywords: classes

### ** Examples


 # An R-level XMLNode object
a <- xmlNode("arg", attrs = c(default="T"),
               xmlNode("name", "foo"), xmlNode("defaultValue","1:10"))
  




### Name: xmlNode
### Title: Create an XML node
### Aliases: xmlNode xmlTextNode xmlPINode xmlCDataNode xmlCommentNode
### Keywords: file

### ** Examples


 # node named arg with two children: name and defaultValue
 # Both of these have a text node as their child.
a <- xmlNode("arg", attrs = c(default="TRUE"),
               xmlNode("name", "foo"), xmlNode("defaultValue","1:10"))

  # internal C-level node.
 newXMLNode("arg", attrs = c(default = "TRUE"),
             newXMLNode("name", "foo"),
             newXMLNode("defaultValue", "1:10"))





### Name: xmlOutputBuffer
### Title: XML output streams
### Aliases: xmlOutputBuffer xmlOutputDOM
### Keywords: file IO

### ** Examples

 con <- xmlOutputDOM()
con$addTag("author", "Duncan Temple Lang")
con$addTag("address",  close=FALSE)
 con$addTag("office", "2C-259")
 con$addTag("street", "Mountain Avenue.")
 con$addTag("phone", close=FALSE)
   con$addTag("area", "908", attrs=c(state="NJ"))
   con$addTag("number", "582-3217")
 con$closeTag() # phone
con$closeTag() # address

con$addTag("section", close=FALSE)
 con$addNode(xmlTextNode("This is some text "))
 con$addTag("a","and a link", attrs=c(href="http://www.omegahat.org"))
 con$addNode(xmlTextNode("and some follow up text"))

 con$addTag("subsection", close=FALSE)
   con$addNode(xmlTextNode("some addtional text "))
   con$addTag("a", attrs=c(href="http://www.omegahat.org"), close=FALSE)
     con$addNode(xmlTextNode("the content of the link"))
   con$closeTag() # a
 con$closeTag() # "subsection"
con$closeTag() # section

 d <- xmlOutputDOM()
 d$addPI("S", "plot(1:10)")
 d$addCData('x <- list(1, a="&");\nx[[2]]')
 d$addComment("A comment")
 print(d$value())
 print(d$value(), indent = FALSE, tagSeparator = "")




### Name: xmlParent
### Title: Get parent node of XMLInternalNode or ancestor nodes
### Aliases: xmlParent xmlAncestors xmlParent.XMLInternalNode
### Keywords: file IO

### ** Examples


  top = newXMLNode("doc")
  s = newXMLNode("section", attr = c(title = "Introduction"))
  a = newXMLNode("article", s)
  addChildren(top, a)

  xmlName(xmlParent(s))
  xmlName(xmlParent(xmlParent(s)))

    # Find the root node.
  root = a
  while(!is.null(xmlParent(root)))
      root = xmlParent(root)

   # find the names of the parent nodes of each 'h' node.
   # use a global variable to "simplify" things and not use a closure.

  filename = system.file("exampleData", "branch.xml", package = "XML")
  parentNames <- character()
  xmlTreeParse(filename,
                handlers =
                  list(h = function(x) {
                   parentNames <<- c(parentNames, xmlName(xmlParent(x)))
                  }), useInternalNodes = TRUE)

  table(parentNames)




### Name: xmlRoot
### Title: Get the top-level XML node.
### Aliases: xmlRoot xmlRoot.XMLDocument xmlRoot.XMLInternalDocument
###   xmlRoot.XMLInternalDOM xmlRoot.XMLDocumentRoot
###   xmlRoot.XMLDocumentContent xmlRoot.HTMLDocument
### Keywords: file

### ** Examples

  doc <- xmlTreeParse(system.file("exampleData", "mtcars.xml", package="XML"))
  xmlRoot(doc)




### Name: xmlSize
### Title: The number of sub-elements within an XML node.
### Aliases: xmlSize xmlSize.default xmlSize.XMLDocument xmlSize.XMLNode
### Keywords: file

### ** Examples

  fileName <- system.file("exampleData", "mtcars.xml", package="XML") 
  doc <- xmlTreeParse(fileName)
  xmlSize(doc)
  xmlSize(doc$doc$children[["dataset"]][["variables"]])




### Name: xmlSource
### Title: Source the R code, examples, etc. from an XML document
### Aliases: xmlSource xmlSource,character-method
###   xmlSource,XMLNodeSet-method
### Keywords: IO programming

### ** Examples

 xmlSource(system.file("exampleData", "Rsource.xml", package="XML"))

  # This illustrates using r:frag nodes.
  # The r:frag nodes are not processed directly, but only
  # if referenced in the contents/body of a r:code node
 f = system.file("exampleData", "Rref.xml", package="XML")
 xmlSource(f)




### Name: xmlStopParser
### Title: Terminate an XML parser
### Aliases: xmlStopParser
### Keywords: IO programming

### ** Examples


  ############################################
  # Stopping the parser mid-way and an example of using XMLParserContextFunction.

  startElement =
  function(ctxt, name, attrs, ...)  {
    print(ctxt)
      print(name)
      if(name == "rewriteURI") {
           cat("Terminating parser\n")
           xmlStopParser(ctxt)
      }
  }
  class(startElement) = "XMLParserContextFunction"  
  endElement =
  function(name, ...) 
    cat("ending", name, "\n")

  fileName = system.file("exampleData", "catalog.xml", package = "XML")
  xmlEventParse(fileName, handlers = list(startElement = startElement, endElement = endElement))




### Name: xmlStructuredStop
### Title: Condition/error handler functions for XML parsing
### Aliases: xmlStructuredStop xmlErrorCumulator
### Keywords: IO programming

### ** Examples

  tryCatch( xmlTreeParse("<a><b></a>", asText = TRUE, error = NULL),
                 XMLError = function(e) {
                    cat("There was an error in the XML at line", 
                          e$line, "column", e$col, "\n",
                         e$message, "\n")
                })




### Name: [.XMLNode
### Title: Convenience accessors for the children of XMLNode objects.
### Aliases: [.XMLNode [[.XMLNode [[.XMLDocumentContent
### Keywords: IO file

### ** Examples


 f = system.file("exampleData", "gnumeric.xml", package = "XML")

 top = xmlRoot(xmlTreeParse(f))

  # Get the first RowInfo element.
 top[["Sheets"]][[1]][["Rows"]][["RowInfo"]]

  # Get a list containing only the first row element
 top[["Sheets"]][[1]][["Rows"]]["RowInfo"]
 top[["Sheets"]][[1]][["Rows"]][1]

  # Get all of the RowInfo elements by position
 top[["Sheets"]][[1]][["Rows"]][1:xmlSize(top[["Sheets"]][[1]][["Rows"]])]

  # But more succinctly and accurately, get all of the RowInfo elements
 top[["Sheets"]][[1]][["Rows"]]["RowInfo", all = TRUE]





### Name: xmlTree
### Title: An internal, updatable DOM object for building XML trees
### Aliases: xmlTree
### Keywords: IO

### ** Examples


z = xmlTree("people", namespaces = list(r = "http://www.r-project.org"))
z$setNamespace("r")

z$addNode("person", attrs = c(id = "123"), close = FALSE)
  z$addNode("firstname", "Duncan")
  z$addNode("surname", "Temple Lang")
  z$addNode("title", "Associate Professor")
  z$addNode("expertize", close = FALSE)
     z$addNode("topic", "Data Technologies")
     z$addNode("topic", "Programming Language Design")
     z$addNode("topic", "Parallel Computing")
     z$addNode("topic", "Data Visualization")
     z$addNode("topic", "Meta-Computing")
     z$addNode("topic", "Inter-system interfaces")
  z$closeTag()
  z$addNode("address", "4210 Mathematical Sciences Building, UC Davis")
z$closeTag()

  tr <- xmlTree("CDataTest")
  tr$addTag("top", close=FALSE)
  tr$addCData("x <- list(1, a='&');\nx[[2]]")
  tr$addPI("S", "plot(1:10)")
  tr$closeTag()
  cat(saveXML(tr$value()))

  f = tempfile()
  saveXML(tr, f, encoding = "UTF-8")

  # Creating a node
x = rnorm(3)
z = xmlTree("r:data", namespaces = c(r = "http://www.r-project.org"))
z$addNode("numeric", attrs = c("r:length" = length(x)))

  # shows namespace prefix on an attribute, and different from the one on the node.
  z = xmlTree()
z$addNode("r:data",  namespace = c(r = "http://www.r-project.org", omg = "http://www.omegahat.org"), close = FALSE)
x = rnorm(3)
z$addNode("r:numeric", attrs = c("omg:length" = length(x)))

z = xmlTree("examples")
z$addNode("example", namespace = list(r = "http://www.r-project.org"), close = FALSE)
z$addNode("code", "mean(rnorm(100))", namespace = "r")

x = summary(rnorm(1000))
d = xmlTree()
d$addNode("table", close = FALSE)

d$addNode("tr", .children = sapply(names(x), function(x) d$addNode("th", x)))
d$addNode("tr", .children = sapply(x, function(x) d$addNode("td", format(x))))

d$closeNode()
cat(saveXML(d))

# Dealing with DTDs and system and public identifiers for DTDs.
# Just doctype
za = xmlTree("people", dtd = "people")
# no public element
zb = xmlTree("people", dtd = c("people", "", "http://www.omegahat.org/XML/types.dtd"))
# public and system
zc = xmlTree("people", dtd = c("people", "//a//b//c//d", "http://www.omegahat.org/XML/types.dtd"))






### Name: xmlTreeParse
### Title: XML Parser
### Aliases: xmlTreeParse htmlTreeParse xmlInternalTreeParse
### Keywords: file IO

### ** Examples

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

## Not run: 
##D  # Parse an XML document directly from a URL.
##D  # Requires Internet access.
##D  xmlTreeParse("http://www.omegahat.org/Scripts/Data/mtcars.xml", asText=TRUE)
## End(Not run)

  counter = function() {
              counts = integer(0)
              list(startElement = function(node) {
                                     name = xmlName(node)
                                     if(name %in% names(counts))
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




### Name: xmlValue
### Title: Extract the contents of a leaf XML node
### Aliases: xmlValue xmlValue.XMLCDataNode xmlValue.XMLNode
###   xmlValue.XMLProcessingInstruction xmlValue.XMLTextNode
###   xmlValue.XMLComment
### Keywords: file

### ** Examples

 node <- xmlNode("foo", "Some text")
 xmlValue(node)

 xmlValue(xmlTextNode("some more raw text"))



