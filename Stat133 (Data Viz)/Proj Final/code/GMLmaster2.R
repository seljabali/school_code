

# uses master
#B1=read.csv("B1 cleaner.csv")

addLocation = function(master,B1){

	library(XML)
	tree=xmlTreeParse("/Users/samieljabali/Desktop/Stat Final Proj/data/new_counties.gml",useInternal=TRUE)
	gml.X=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "//gml:X")
	gml.X=sapply(gml.X,xmlValue)
	gml.X=as.numeric(gml.X)
	gml.Y=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "//gml:Y")
	gml.Y=sapply(gml.Y,xmlValue)
	gml.Y=as.numeric(gml.Y)
	gml.state=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/gml:name")
	gml.state=sapply(gml.state,xmlValue)
	gml.county=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/county/gml:name")
	gml.county=sapply(gml.county,xmlValue)
	gml.county=gsub("\n    ","",gml.county)
	gml.state=gsub("\n   ","",gml.state)
	gml.county=gsub(" Borough","",gml.county)
	gml.county=gsub(" Census Area","",gml.county)
	gml.county=gsub(" Parish","",gml.county)
	gml.county=gsub(" County","",gml.county)
	gml.county=gsub("\n\t","",gml.county)
	gml.county=gsub("   ","",gml.county)
	gml.county=gsub("[[1:9]]","",gml.county)
	gml.state.abbrev=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/gml:name")
	gml.state.abbrev=sapply(gml.state.abbrev,function(v){xmlGetAttr(v,"abbreviation")})
	gml.state.abbrev[[9]]="DC" #Washington DC did't have an abbreviation!
	gml.state.abbrev=unlist(gml.state.abbrev)

	gml.state.count=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/county")
	gml.state.count=sapply(gml.state.count,xmlParent)
	gml.state.count=sapply(gml.state.count,xmlChildren)
	gml.state.count=sapply(gml.state.count,function(L){xmlGetAttr(L[[2]],"abbreviation")})

	gml.county=paste(gml.county,gml.state.count,sep=", ")
	gml.county=gsub(", NULL", "",gml.county) # deal with DC
	gml.county=as.character(gml.county)
	gml.county=gsub("Mc Kean, PA","McKean, PA",gml.county)
	gml.county=gsub("La Salle, IL","LaSalle, IL",gml.county)
	gml.county=gsub("Skagway-Yakutat-Angoon, AK","Skagway-Hoonah-Angoon, AK",gml.county)
	coord=data.frame(gml.county,gml.X,gml.Y)
	coord[,1]=as.character(coord[,1])
	names(coord)=c("county","long","lat")




	B1$County=as.character(B1$County)
	ind.indep=grep("Independent Cities",B1$County)
	ind.Wash=grep("WASHINGTON",B1$County)
	virginia=B1$County[(ind.indep+1):(ind.Wash-1)]
	B1$County[(ind.indep+1):(ind.Wash-1)]=gsub(","," city,",virginia)
	B1$County=gsub("[[:digit:]]","",B1$County)

	I = grep(",",B1$County)
	dc=grep("District of Columbia",B1$County)
	B1=B1[c(I[I<dc],dc,I[I>dc]),]
	B1$County=gsub(" +$","",B1$County)

	dump=c("Yellowstone National Park","Clifton Forge","South Boston")
	dump=sapply(dump,function(name){grep(name,B1$County)})
	B1=B1[-dump,]

	#
	# Now, to compare the two county vectors
	#
	# tst=sapply(coord$county,function(name){length(grep(name,B1$County))})
	# tst.w=sapply(coord$county,function(name){length(which(B1$County==name))})
	#unlist(tst)[which(unlist(tst)==2)]
	#unlist(tst)[which(unlist(tst)==0)]
	#unlist(tst.w)[which(unlist(tst.w)==0)]
	#unlist(tst.w)[which(unlist(tst.w)==2)]
	#tst.rev=sapply(B1$County,function(name){length(grep(name,coord$county))})
	#tst.w.rev=sapply(B1$County,function(name){length(which(coord$county==name))})
	#unlist(tst.rev)[which(unlist(tst.rev)==2)]
	#unlist(tst.rev)[which(unlist(tst.rev)==0)]
	#unlist(tst.w.rev)[which(unlist(tst.w.rev)==0)]
	#unlist(tst.w.rev)[which(unlist(tst.w.rev)==2)]
	#
	# Indeed, they are equivalent.
	#
	#length(which(coord$county!=B1$County))

	# Now to rearrange the coordinates' order to match that of B1

	#row.names(coord)=coord$county
	#names(B1$County)=B1$County
	#coord=coord[B1$County,]

	# to add GML geog. data to master



	mas1=as.character(master$county.1)
	ind.indep=grep("Independent Cities",mas1)
	ind.Wash=grep("WASHINGTON",mas1)
	virginia1=mas1[(ind.indep+1):(ind.Wash-1)]
	mas1[(ind.indep+1):(ind.Wash-1)]=gsub(","," city,",virginia1)
	mas1=gsub("[[:digit:]]","",mas1)
	mas1=gsub(" +$","",mas1)
	l=length(mas1)
	ind=unlist(sapply(coord$county,function(name){which(mas1==name)}))

	Long=rep(NA,l)
	Long[ind]=coord$long
	Lat=rep(NA,l)
	Lat[ind]=coord$lat
	Geog=data.frame(Long,Lat)
	names(Geog)=c("Longitude","Latitdue")
	master=cbind(master,Geog)
	
	return(master)
}
