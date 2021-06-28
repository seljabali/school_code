// Also works on the following URLS
// http://sfbay.craigslist.org/eby/zip/420308172.html
// 

// ==UserScript==
// @name           part3
// @namespace      c:\
// @description    Geolocater
// @include        *

// ==/UserScript==

var lat, long, latLong;
var addressList = new Array();
var i = 0;
var textElements = document.evaluate("//text()", document, null, XPathResult.ANY_TYPE, null);
var text = textElements.iterateNext();
while (text) {
	var regex = /[0-9]+ (East 14th St|(([A-Z][a-z]*( )?)+((Street|Avenue|Boulevard|Road|Way|Circle|Court)|(St|Ave|Blvd|Rd|Cir|Ct))|(([A-Z][a-z]* [A-Z][a-z]*)|[A-Z][a-z]*)))((\.,)|(\.)|(,))?( )?(in )?([A-Z]?[a-z]+( )?)*/g;    
	var str = text.nodeValue.match(regex);
	var address;
	if (str) {
		if (/ in /.test(str[0]))
			str[0] = str[0].replace(/in /, '');
		if (/1701 Stockton St/.test(str[0]))
			str[0] = str[0] + " San Francisco";
		if (/Ellsworth/.test(str[0]))
			str[0] = str[0] + "Berkeley";
		if (str[0].length < 5)
			str[0] = "not an address";
		var months = /(( )(January|February|March|April|May|June|July|August|September|October|November|December))|(( )(Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sept|Oct|Nov|Dec))/gi;
		if (!months.test(str[0])) {
			address = str[0].replace(/ /g, '+');
			addressList[i] = new Array();
			addressList[i][0] = text;
			addressList[i][1] = address;
			i++;
		}
	}
	text = textElements.iterateNext();
}
var addr;
for (var x in addressList) {
    GM_xmlhttpRequest( {
		method: "GET",
		url: "http://maps.google.com/maps/geo?q=" +  addressList[x][1] + "&output=xml&key=ABQIAAAAil0OP_HQg8TRlJzOEzhXIBQBPyR4RYg4BkqS0o0RYMygr8i0DhS9uQpYYxj9RH00NN8u71lgpteNdg",
		onload: function (responseDetails) {
			var j = 0;
			var s = responseDetails.responseText;
			addr = s.match(/<name>(.)+<\/name>/);
			addr = addr[0].replace(/<name>/, '');
			addr = addr.replace(/<\/name>/, '');
			addr = addr.replace(/ /g, '+');
			var regLatLong = /(-)*[0-9]+\.[0-9]+/g;
			latLong = s.match(regLatLong);
			if (latLong.length > 2) {
				lat = latLong[4];
				lat = lat.replace(/\./, '');
				long = parseFloat(latLong[3]);
				long = 4294.967296 + long;
				long = long.toFixed(6);
				long = long.toString().replace(/\./, '');
				var newElement = document.createElement("a");
				for (j in addressList) {
					if (addr == addressList[j][1]) {
						break;
					}
				}
				newElement.href = "http://maps.google.com/maps?q=" + addressList[j][1] + "&sa=X&oi=map&ct=image";
				newElement.innerHTML = "<table><tr><td><img src=http://www.google.com/mapdata?Point=b&Point.latitude_e6=" + lat + "&Point.longitude_e6=" + long + "&Point.iconid=4294967295&Point=e&latitude_e6=" + lat + "&longitude_e6=" + long + "&zm=19200&w=304&h=156&cc=US&min_priority=1></td></tr></table>";
				addressList[j][0].parentNode.appendChild(newElement);
			}
		}
	});
}





