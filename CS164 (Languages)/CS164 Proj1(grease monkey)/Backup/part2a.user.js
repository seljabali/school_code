{\rtf1\mac\ansicpg10000\cocoartf824\cocoasubrtf420
{\fonttbl\f0\fmodern\fcharset77 Courier;\f1\fswiss\fcharset77 Helvetica;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww12220\viewh9820\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\ql\qnatural\pardirnatural

\f0\fs22 \cf0 // ==UserScript== \
// @name          Hello World \
// @namespace     http://diveintogreasemonkey.org/download/ \
// @description   example script to alert "Hello world!" on every page \
// @include       * \
// @exclude       http://diveintogreasemonkey.org/* \
// @exclude       http://www.diveintogreasemonkey.org/* \
// ==/UserScript==
\f1\fs28  \

\fs32 \
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\ql\qnatural\pardirnatural

\fs24 \cf0 //We'd want to look for
\fs32  
\fs24 javascript:printThis('20602791')
\fs32 \
\
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\ql\qnatural\pardirnatural

\f0\fs22 \cf0 window.helloworld = function() \{ \
    alert('Hello world!'); \
\} \
window.setTimeout("helloworld()", 60);
\f1\fs28  \
}