// ==UserScript==
// @name           part1
// @namespace      c:\
// @description    AirBears Auto Logon
// @include        https://wireless-gw1.berkeley.edu/logon*
// ==/UserScript==

var usr = "username";	// Replace with CalNet ID
var pw = "password";	// Replace with CalNet Passphrase
var forms = document.forms;
var form = forms.namedItem("logonForm");
form.elements[10].value = usr;
form.elements[11].value = pw;
form.elements[12].click();

