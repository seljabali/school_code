#include "Utils.h"

/*
  Utilities used in the R XML parsing facilities for invoking user-level functions from C.

 * See Copyright for the license status of this software.

 */

#include "Rinternals.h" /* Macros, etc. */


USER_OBJECT_
R_makeXMLContextRef(xmlParserCtxtPtr ctx)
{
  USER_OBJECT_ ans;
  PROTECT(ans = R_MakeExternalPtr(ctx, Rf_install(XML_PARSER_CONTEXT_TYPE_NAME), R_NilValue));
  SET_CLASS(ans, mkString(XML_PARSER_CONTEXT_TYPE_NAME));
  UNPROTECT(1); 
  return(ans);
}

USER_OBJECT_ R_InternalRecursiveApply(USER_OBJECT_ top, USER_OBJECT_ func, USER_OBJECT_ klasses);

USER_OBJECT_
RS_XML(invokeFunction)(USER_OBJECT_ fun, USER_OBJECT_ opArgs, USER_OBJECT_ data, xmlParserCtxtPtr context)
{
  int i;
  long n;
  USER_OBJECT_ c, call;
  USER_OBJECT_ ans;
  int addContext = 0;

  if(context && TYPEOF(fun) == CLOSXP && OBJECT(fun) && R_isInstanceOf(fun, XML_PARSE_CONTEXT_FUNCTION))
      addContext = 1;

  n = Rf_length(opArgs) + addContext + 1;
  if(data)
    n++;


  if(n  > 0) {
#if 1
    PROTECT(call = allocVector(LANGSXP, n));      
    c = call;
    SETCAR(call, fun); c = CDR(c);

    if(addContext)  {
	SETCAR(c, R_makeXMLContextRef(context));
	c = CDR(c);
    }

    for (i = 0; i < Rf_length(opArgs); i++) {
      SETCAR(c, VECTOR_ELT(opArgs, i));
      c = CDR(c);
    }


    if(data) {
       SETCAR(c, data);
       SET_TAG(c, Rf_install(".state"));
    }    
#else
    PROTECT(c = call = allocList(n));
    if(addContext)  {
	SETCAR(c, R_makeXMLContextRef(context));
	c = CDR(c);
    }

    for (i = 0; i < GET_LENGTH(opArgs); i++) {
      SETCAR(c, VECTOR_ELT(opArgs, i));
      c = CDR(c);
    }
    if(data) {
       SETCAR(c, data);
       SET_TAG(c, Rf_install(".state"));
    }

    call = LCONS(fun, call);
    UNPROTECT(1);
#endif
  } else  {
     PROTECT(call = allocVector(LANGSXP, 1 + addContext));
     SETCAR(call, fun);
     if(addContext)
	 SETCAR(CDR(call), R_makeXMLContextRef(context));
  }  


  ans = eval(call, R_GlobalEnv);
  UNPROTECT(1);

  return(ans);
}

USER_OBJECT_
RS_XML(RecursiveApply)(USER_OBJECT_ top, USER_OBJECT_ func, USER_OBJECT_ klasses)
{
  USER_OBJECT_ ans;
  PROTECT(top = duplicate(top));
  ans = R_InternalRecursiveApply(top, func, klasses);
  UNPROTECT(1);
  return(ans);
}

USER_OBJECT_
R_InternalRecursiveApply(USER_OBJECT_ top, USER_OBJECT_ func, USER_OBJECT_ klasses)
{
  int CHILD_NODE = 2, i;
  USER_OBJECT_ kids;
  int numChildren;
  USER_OBJECT_ args, tmp;


  if(GET_LENGTH(top) > CHILD_NODE) {
    kids = VECTOR_ELT(top, CHILD_NODE);
    numChildren = GET_LENGTH(kids);
        /* Do the children first. */
    PROTECT(args = NEW_LIST(1));
    PROTECT(tmp = NEW_LIST(numChildren));  
    for(i = 0; i < numChildren; i++) {
      SET_VECTOR_ELT(tmp, i, R_InternalRecursiveApply(VECTOR_ELT(kids, i), func, klasses));
    }
    SET_VECTOR_ELT(top, CHILD_NODE, tmp);
    UNPROTECT(2);
  }

  PROTECT(args = NEW_LIST(1));
  SET_VECTOR_ELT(args, 0, top);
  tmp =  RS_XML(invokeFunction)(func, args, NULL, NULL); /*XXX get the context and user data!!! */
  UNPROTECT(1);

  return(tmp);
}

USER_OBJECT_
RS_XML_SubstituteEntitiesDefault(USER_OBJECT_ replaceEntities)
{
    int value;
    USER_OBJECT_ ans;
    value = xmlSubstituteEntitiesDefault(LOGICAL_DATA(replaceEntities)[0]);   
    ans = NEW_LOGICAL(1);
    LOGICAL_DATA(ans)[0] = value;
    return(ans);
}

#include <R_ext/Rdynload.h>

/* Simple macro for expanding ENTRY(x, n) to {"<x>", (DL_FUNC) &<x>, <n>} */

#define ENTRY(name, n)  { #name, (DL_FUNC) &name, n }

static R_CallMethodDef callMethods[] = {
	ENTRY(RS_XML_RecursiveApply, 3),
	ENTRY(RS_XML_HtmlParseTree, 7),
	ENTRY(RS_XML_getDTD, 5),
	ENTRY(RS_XML_libxmlVersion, 0),
	ENTRY(RS_XML_Parse, 15),
	ENTRY(RS_XML_ParseTree, 18),
	ENTRY(R_newXMLDtd, 4),
	ENTRY(R_newXMLDoc, 2),
	ENTRY(R_newXMLNode, 5),
	ENTRY(R_newXMLTextNode, 2),
	ENTRY(R_xmlNewComment, 2),
	ENTRY(R_newXMLCDataNode, 2),
	ENTRY(R_newXMLPINode, 3),
	ENTRY(R_xmlNewNs, 3),
	ENTRY(R_xmlSetNs, 3),
	ENTRY(R_insertXMLNode, 4),
	ENTRY(R_saveXMLDOM, 6),
	ENTRY(R_xmlCatalogResolve, 3),
	ENTRY(RS_XML_xmlNodeNumChildren, 1),
        ENTRY(RS_XML_unsetDoc, 3),
        ENTRY(RS_XML_setDoc, 2),
        ENTRY(RS_XML_printXMLNode, 5),
        ENTRY(RS_XML_removeChildren, 3),
        ENTRY(RS_XML_clone, 2),
        ENTRY(RS_XML_addNodeAttributes, 2),
        ENTRY(RS_XML_removeNodeAttributes, 3),
        ENTRY(RS_XML_getNsList, 2),
        ENTRY(RS_XML_setNodeName, 2),
        ENTRY(R_xmlNsAsCharacter, 1),
        ENTRY(RS_XML_SubstituteEntitiesDefault, 1),
        ENTRY(RS_XML_getNextSibling, 2),
        ENTRY(R_getXMLNodeDocument, 1),
        ENTRY(RS_XML_createDocFromNode, 1),
        ENTRY(R_removeInternalNode, 2),
	ENTRY(RS_XML_replaceXMLNode, 2),
	ENTRY(RS_XML_xmlAddSiblingAt, 3),
	ENTRY(RS_XML_loadCatalog, 1),
	ENTRY(RS_XML_clearCatalog, 0),
	ENTRY(RS_XML_catalogAdd, 3),
	ENTRY(RS_XML_catalogDump, 1),
	ENTRY(RS_XML_setDocumentName, 2),
	ENTRY(RS_XML_setKeepBlanksDefault, 1),
	{NULL, NULL, 0}
};

static R_CMethodDef cmethods[] = {
    ENTRY(RSXML_setErrorHandlers, 0),
    {NULL, NULL, 0}
};

void
R_init_XML(DllInfo *dll)
{
   R_useDynamicSymbols(dll, FALSE);
   R_registerRoutines(dll, cmethods, callMethods, NULL, NULL);
}





Rboolean
R_isInstanceOf(USER_OBJECT_ obj, const char *klass)
{

    USER_OBJECT_ klasses;
    int n, i;

    klasses = GET_CLASS(obj);
    n = GET_LENGTH(klasses);
    for(i = 0; i < n ; i++) {
	if(strcmp(CHAR_DEREF(STRING_ELT(klasses, i)), klass) == 0)
	    return(TRUE);
    }


    return(FALSE);
}


SEXP
RS_XML_getStructuredErrorHandler()
{
    SEXP ans;
    PROTECT(ans = NEW_LIST(2));
    SET_VECTOR_ELT(ans, 0, R_MakeExternalPtr(xmlGenericErrorContext, Rf_install("xmlGenericErrorContext"), R_NilValue));
    SET_VECTOR_ELT(ans, 1, R_MakeExternalPtr(xmlStructuredError, Rf_install("xmlStructuredErrorFunc"), R_NilValue));
    UNPROTECT(1);
    return(ans);
}

SEXP
RS_XML_setStructuredErrorHandler(SEXP els)
{
    void *ctx;
    xmlStructuredErrorFunc handler;
    SEXP fun, sym;
    
    fun = VECTOR_ELT(els, 0);
    sym = VECTOR_ELT(els, 1);

    if(sym != R_NilValue & TYPEOF(sym) != EXTPTRSXP) {
	PROBLEM "invalid symbol object for XML error handler. Need an external pointer, e.g from getNativeSymbolInfo"
        ERROR;
    }

    if(ctx == R_NilValue)
	ctx = NULL;
    else
	ctx = fun;


    handler = sym == R_NilValue ? NULL : (xmlStructuredErrorFunc) R_ExternalPtrAddr(sym);
    xmlSetStructuredErrorFunc(ctx, handler);

    return(ScalarLogical(TRUE));
}
