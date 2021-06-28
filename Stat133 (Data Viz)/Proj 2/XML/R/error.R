xmlErrorCumulator =
function(class = "XMLParserErrorList", immediate = TRUE)
{
  messages = character()
  function(msg, ...) {
         # curently discards all the extra information.
    if(length(grep("\\\n$", msg)) == 0)
      paste(msg, "\n", sep = "")
    
     if(immediate)
       cat(msg)
    
     if(length(msg) == 0) {
          # collapse into string. Probably want to leave as separate elements of a character vector.
          # Make into real objects with the ... information.
       e = simpleError(paste(1:length(messages), messages, sep = ": ",collapse = ""))
       class(e) = c(class, class(e))
       stop(e)
     }

     messages <<- c(messages, msg)
  }
}


xmlStop =
  #
  # Never used anymore.
  # Related to the non-structed error handling.
function(msg, class = "XMLParserError")
{
  err = simpleError(msg)
  class(err) = c(class , class(err))
  stop(err)
}


xmlStructuredStop =
function(msg, code, domain, line, col, level, filename, class = "XMLError")
{
  err = simpleError(msg)
  err$code = code
  err$domain = domain
  err$line = line
  err$col = col
  err$level = level
  err$filename = filename
  
  class(err) = c(class, class(err))

  stop(err)
}  


xmlErrorFun =
function()
{
  errors = list()
  h = function(msg, code, domain, line, col, level, filename) {
    if(length(msg) == 0)
      return(TRUE)

    errors[[length(errors) + 1]] <<-
         structure(list(msg = msg, code = code,
                        domain  = domain, line = line,
                        col = col, level = level, filename = filename),
                   class = "XMLError")
  }

  list(handler = h, errors = function() errors, reset = function() errors <<- list)
}


getXMLErrors=
  #
  #  This attempts to read the specified file using the function given in parse
  # and then returns a list of the errors in the document.
  # This a somewhat convenient mechanism for fixing up, e.g., malformed HTML 
  # pages or other XML documents.
  
function(filename, parse = xmlInternalTreeParse, ...)
{
  f = xmlErrorFun()
  opts = options()
  options(error = NULL)
  on.exit(options(opts))
  tryCatch(parse(filename, ..., error = f$handler), error = function(e){})
  f$errors()                
}      



# Low level error handler
setXMLErrorHandler =
function(fun)
{
  prev = .Call("RS_XML_getStructuredErrorHandler")

  sym = getNativeSymbolInfo("R_xmlStructuredErrorHandler", "XML")$address

  .Call("RS_XML_setStructuredErrorHandler", list(fun, sym))
  
  prev
}

