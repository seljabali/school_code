GreatCircKML = function(longitdue, latitude) {
#load the ML package 
  library(XML)
# The paste function creates a character string of the numeric vlaues
# in longitude and latitude - to be used as the text value in the coordinates node
  coordGC =  paste(longitude,",", latitude, ",0 ", sep ="", paste = " ")

# Create a character string with the URL of the name space.
# you need to name the element in the character vector or you get error
  kml.ns= c(kml = "http://earth.google.com/kml/2.2")

# The root node is a kml node. Create this first.
  kml = newXMLNode("kml", namespaceDefinitions = kml.ns)

# The Document node contains the meta information about the data.
# It is a child of the kml node, and parent of the name and description tags.
  doc = newXMLNode("Document", parent=kml)
  newXMLNode("name", "Great Circle", parent=doc)
  newXMLNode("description", "This should be a great circle.", parent=doc)

# Select the window for viewing the animation
# When Google Earth processes these kml instructions, it zooms into that part
  lookat = newXMLNode("LookAt", parent=doc)
  newXMLNode("longitude", "-135.0", parent = lookat)
  newXMLNode("latitude", "42.0", parent = lookat)
  newXMLNode("altitude", "4100000", parent = lookat)
  newXMLNode("tilt", "0", parent = lookat)
  newXMLNode("heading", "0", parent = lookat)

# The path is contained in a Placemark node 
  pm = newXMLNode("Placemark", parent=doc)
  style = newXMLNode("Style", parent=pm)
  lsty = newXMLNode("LineStyle", parent=style)
  
# Colors are specified using the RGB hex codes and an alpha transparency.
# Note that they are specified in the order alpha - Blue - green - red  
  newXMLNode("color", "ff0000ff", parent=lsty)
  newXMLNode("width", "2", parent=lsty)
  lstr = newXMLNode("LineString", parent = pm)  
  newXMLNode("tesselate", "1", parent=lstr)
  newXMLNode("altitudeMode", "absolute", parent=lstr)
# The coordinates tag contains all of the lat,lon,alt triplets of the path
  newXMLNode("coordinates", coordGC, parent=lstr)

# Save the tree that we have created as a xml document
  saveXML(kml,"~/XMLBook/XMLTechnologies/KML/Examples/greatCircle.kml")
}
