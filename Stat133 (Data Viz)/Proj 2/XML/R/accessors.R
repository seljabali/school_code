if(!exists("Sys.setenv", baseenv()))
    Sys.setenv <- get("Sys.putenv", "package:base")


xmlRoot <-
function(x, ...)
{
 UseMethod("xmlRoot")
}

xmlRoot.XMLDocument <-
function(x, ...)
{
#  x$children[[1]]
# x$doc

  xmlRoot(x$doc, ...)
}

xmlRoot.XMLDocumentContent <-
function(x, ...)
{
  args <- list(...)
  if("skip" %in% names(args))
   skip <- args[["skip"]]
  else
   skip <- TRUE

  a <- x$children[[1]]
  if(skip & inherits(a, "XMLComment")) {
     which <- sapply(x$children, function(x) !inherits(x, "XMLComment"))
     if(any(which)) {
       which <- (1:length(x$children))[which]
       a <- x$children[[which[1]]]
     } 
  }

 a
}


xmlRoot.HTMLDocument <-
function(x, ...)
{
   x$children[[1]]
}

xmlApply <-
function(X, FUN, ...)
{
  UseMethod("xmlApply")
}

xmlSApply <-
function(X, FUN, ...)
{
  UseMethod("xmlSApply")
}

xmlApply.XMLNode <- 
function(X, FUN, ...) { 
  lapply(xmlChildren(X), FUN, ...) 
} 


xmlApply.XMLDocument <-
function(X, FUN, ...)
{
  xmlApply(xmlRoot(X), FUN, ...)
}

xmlSApply.XMLDocument <-
function(X, FUN, ...)
{
  xmlSApply(xmlRoot(X), FUN, ...)
}


xmlSApply.XMLNode <- 
function(X, FUN, ...) { 
  sapply(xmlChildren(X), FUN, ...) 
} 

xmlApply.XMLDocumentContent <-
function(X, FUN, ...)
{
  xmlSApply(X$children, FUN, ...)
}

xmlSApply.XMLDocumentContent <-
function(X, FUN, ...)
{
  xmlSApply(X$children, FUN, ...)
}


xmlValue <- 
function(x, ignoreComments = FALSE)
{
 UseMethod("xmlValue")
}

xmlValue.XMLNode <- 
function(x, ignoreComments = FALSE)
{
 if(xmlSize(x) == 1) # && (inherits(x[[1]], "XMLTextNode"))
    return(xmlValue(x[[1]], ignoreComments))

 x$value
}

xmlValue.XMLTextNode <- 
function(x, ignoreComments = FALSE)
{
 x$value
}

xmlValue.XMLComment <- 
function(x, ignoreComments = FALSE)
{
 if(ignoreComments)
   return("")

 x$value
}

xmlValue.XMLCDataNode <- 
function(x, ignoreComments = FALSE)
{
 x$value
}

xmlValue.XMLProcessingInstruction <- 
function(x, ignoreComments = FALSE)
{
 x$value
}

# "xmlValue.NULL" =
#  function(x, ignoreComments = FALSE)
#               character()


getSibling =
  # Access the next field in the xmlNodePtr object.
  # not exported.
function(node, after = TRUE)
{
  if(!inherits(node, "XMLInternalNode"))
    stop("can only operate on an internal node")

  .Call("RS_XML_getNextSibling", node, as.logical(after))
}

xmlNamespaceDefinitions <-
function(x, addNames = TRUE, recursive = FALSE, simplify = FALSE)
{
  UseMethod("xmlNamespaceDefinitions")
}

xmlNamespaceDefinitions.XMLInternalDocument =
function(x, addNames = TRUE, recursive = FALSE, simplify = FALSE)
{
  r = xmlRoot(x)
  while(!is.null(r) && !inherits(r, "XMLInternalElementNode")) 
     r = getSibling(r)

  if(is.null(r))
    return(if(simplify) character() else NULL)
  
  xmlNamespaceDefinitions(r, addNames, recursive, simplify)
}

xmlNamespaceDefinitions.XMLNode =
  function(x, addNames = TRUE, recursive = FALSE, simplify = FALSE) {
    ans = unclass(x)$namespaceDefinitions


    if(recursive == TRUE) {
                   #      warning("recursive facility not yet implemented.")
      f = function(node) {
            if(!inherits(node, "XMLNode") || xmlName(node) == "")
              return(FALSE)
            ans <<- append(ans, unclass(node)$namespaceDefinitions)
            xmlApply(node, f)
          }
      xmlApply(x, f)
    }

    if(addNames && length(ans) && length(names(ans)) == 0)
        names(ans) = sapply(ans, function(x) x$id)

    if(simplify) {
      if(length(ans) == 0)
        return(character())
      
      return(sapply(ans, function(x) x$uri))
    }
    
    ans
  }

xmlNamespaceDefinitions.XMLInternalNode =
  function(x, addNames = TRUE, recursive = FALSE, simplify = FALSE) {
    ans = .Call("RS_XML_internalNodeNamespaceDefinitions", x, as.logical(recursive))
    if(addNames && length(ans) > 0)
      names(ans) = sapply(ans, function(x) x$id)

    if(simplify) {
      if(length(ans) == 0)
        return(character(0))
      return(sapply(ans, function(x) x$uri))
    }
    
    ans
  }

xmlNamespace <-
function(x)
{
 UseMethod("xmlNamespace")
}


xmlNamespace.XMLNode <-
function(x)
{
  x$namespace
}

#setMethod("xmlNamespace", "character",
xmlNamespace.character = 
           function(x) {
             a = strsplit(x, ":")[[1]]
             if(length(a) == 1)
               character()
             else
               a[1]
          }
#)

verifyNamespace =
  # Check that the namespace prefix in tag (if any)
  # has a definition in def that matches the definition of the same prefix in node.
function(tag, def, node)
{
   # could have prefix: with no name, but that should never be allowed earlier than this.
  ns = strsplit(tag, ":")[[1]]
  if(length(ns) == 1)
    return(TRUE)

  if(! (ns[1] %in% names(def)) )
     TRUE  #??

  defs = xmlNamespaceDefinitions(node)

  if( defs[[ ns[1] ]]$uri == def[ ns[1] ]) 
      stop("name space prefix ", ns, " does not match ", namespaceDefinition[ns], " but ", defs[[ ns[1] ]] $uri)

  TRUE
}  


xmlGetAttr <-
  #Added support for name spaces.
function(node, name, default = NULL, converter = NULL, namespaceDefinition = character())
{
  a <- xmlAttrs(node)
  if(is.null(a) || is.na(match(name, names(a)))) 
    return(default)

  if(length(namespaceDefinition))
     verifyNamespace(name, namespaceDefinition, node)

  if(!is.null(converter))
    converter(a[[name]])
  else
    a[[name]]
}  


getXInclude =
function(node, parse = FALSE, sourceDoc = NULL)
{
  href = xmlGetAttr(node, "href")
  xpointer = xmlGetAttr(node, "xpointer")

  if(parse) {
     #
     # Perhaps just relod the original document
     # and see what the difference is. Not guaranteed
     # to work since people may have already altered
     # the source document.
    
    if(!is.na(href)) {
       fileName = paste(dirname(docName(sourceDoc)), href, sep = .Platform$file.sep)
       doc = xmlInternalTreeParse(fileName)
    } else
      doc = sourceDoc
    
    if(!is.na(xpointer)) {

    }
  } else 
    c(href = href, xpointer = xpointer)
}  

getInclude =
function(doc, parse = FALSE)
{
  xpathApply(doc, "//xi:include", getXIncludeInfo, parse, docName(doc), doc,
                 namespaces = c(xi="http://www.w3.org/2001/XInclude"))
}  
