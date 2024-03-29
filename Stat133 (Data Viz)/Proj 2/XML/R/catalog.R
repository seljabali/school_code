catalogResolve =
function(id, type = "uri", asIs = FALSE, debug = FALSE)
{
   type = rep(type, length = length(id))
  
   types = c("uri", "public", "system")
   i = pmatch(tolower(type), types, duplicates.ok = TRUE)
   if(any(is.na(i)))
     stop("don't recognize type. Must be one of ", paste(types, collapse = ", "))

   ans = .Call("R_xmlCatalogResolve", as.character(id), i, as.logical(debug))

   if(asIs)
     ans[is.na(ans)] = id[is.na(ans)]

   ans
}  


catalogLoad =
function(fileNames)
{
  .Call("RS_XML_loadCatalog", path.expand(fileNames))
}  

catalogClearTable =
function()
{
  .Call("RS_XML_clearCatalog")
}


XMLCatalogTypes = c("public", "system", "rewriteSystem", "rewriteURI")


catalogAdd =
function(orig, replace, type = "rewriteURI")
{
  if(missing(replace)) {
     replace = orig
     orig = names(replace)
  }
  else
     length(replace) = length(orig)
  
  idx = pmatch(type, XMLCatalogTypes)
  if(any(is.na(idx))) {
    stop("unrecognized XML catalog type(s) ", type[is.na(idx)], ". Must be one of ",
           paste("'", XMLCatalogTypes, "'", sep = "", collapse = ", "))
  }
  type = XMLCatalogTypes[idx]
  type = rep(as.character(type), length = length(orig))

  .Call("RS_XML_catalogAdd", as.character(orig), as.character(replace), as.character(type))
}  

catalogDump =
  #
  # Get a snapshot of the current contents of the global catalog table
  # parsing it or writing it to a file for further use 
  # If asText = TRUE and you don't specify a value for fileName,
  # it returns the XML content as a string for easier viewing.
  
function(fileName = tempfile(), asText = TRUE)
{
  ans = .Call("RS_XML_catalogDump", as.character(fileName))
  if(missing(fileName)) {
    ans = xmlTreeParse(fileName, useInternal = TRUE)
    if(asText)
      ans = saveXML(ans)
    unlink(fileName)
  }

  ans
}  

