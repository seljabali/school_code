library(XML)
tree=xmlTreeParse("new_counties.gml",useInternal=TRUE)
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
# gml.county.num=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/county") #check to see if each 'county' node has the same number of   children
# gml.county.num=sapply(gml.county.num,xmlSize)
# length(which(gml.county.num!=5)) # they do! each has 5. Using this, count # counties per state
# gml.county.num=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state")
# gml.county.num=sapply(gml.county.num,xmlSize)
# gml.county.num=(gml.county.num-1)/2-1  # counting up the number of counties per state
# gml.state.counties=rep(gml.state.abbrev,times=gml.county.num)

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
# gml.county=gsub(" city, VA",", VA",gml.county)
coord=data.frame(gml.county,gml.X,gml.Y)
coord[,1]=as.character(coord[,1])
names(coord)=c("county","long","lat")

# gml.state.count=getNodeSet(tree, namespaces = c(gml= "http://www.opengis.net/gml"), "/doc/state/county")
# x=sapply(gml.state.count,xmlParent)
# y=sapply(x,xmlChildren)
# z=sapply(y,function(L){xmlGetAttr(L[[1]],"abbreviation")})


B1=read.csv("B1 cleaner.csv")
B1$County=as.character(B1$County)
# tst=sapply(coord$county,function(name){length(grep(name,B1$County))})
# ind.cities=sapply(names(which(unlist(tst)==2)[6:15]),function(name){grep(name,B1$County)[2]})
# B1$County[ind.cities]=gsub(","," city,",B1$County[ind.cities])
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
tst=sapply(coord$county,function(name){length(grep(name,B1$County))})
# tst.ind=sapply(coord$county,function(name){grep(name,B1$County)})
tst.w=sapply(coord$county,function(name){length(which(B1$County==name))})
# names(coord$county)=coord$county

unlist(tst)[which(unlist(tst)==2)]
unlist(tst)[which(unlist(tst)==0)]

unlist(tst.w)[which(unlist(tst.w)==0)]
unlist(tst.w)[which(unlist(tst.w)==2)]

tst.rev=sapply(B1$County,function(name){length(grep(name,coord$county))})
# tst.ind=sapply(coord$county,function(name){grep(name,B1$County)})
tst.w.rev=sapply(B1$County,function(name){length(which(coord$county==name))})
# names(coord$county)=coord$county

unlist(tst.rev)[which(unlist(tst.rev)==2)]
unlist(tst.rev)[which(unlist(tst.rev)==0)]

unlist(tst.w.rev)[which(unlist(tst.w.rev)==0)]
unlist(tst.w.rev)[which(unlist(tst.w.rev)==2)]

length(which(coord$county!=B1$County))
length(which(coord$county!=coord$county[B1$County]))


#
# Indeed, they are equivalent.
#
length(which(coord$county!=B1$County))
# Now to rearrange the coordinates' order to match that of B1

row.names(coord)=coord$county
names(B1$County)=B1$County
coord=coord[B1$County,]
length(which(coord$county!=B1$County))
#
#
#
#
#
#
#
# Now to check that the available '08 primary counties correspond to those of B1 etc. 
# 
#
#
#

prim08=read.table("DemPrimary2008.txt",sep=" ")
prim08=cbind(row.names(prim08),prim08)
prim08[,1]=as.character(prim08[,1])
names(prim08)[1]="county"

# to disregard NE city data for now:
sox=c(", VT",", ME",", MA",", RI",", CT",", NH")
sox=sapply(sox,function(name){grep(name,prim08.county)})
sox=unlist(sox)
temp.prim08=prim08$county[-sox]


temp.prim08=gsub("Saint Francis, AR","St. Francis, AR",temp.prim08)
temp.prim08=gsub(", DC","",temp.prim08)
temp.prim08=gsub("Idaho County, ID","Idaho, ID",temp.prim08)
temp.prim08=gsub("DeWitt, IL","De Witt, IL",temp.prim08)
temp.prim08=gsub("JoDaviess, IL","Jo Daviess, IL",temp.prim08)
temp.prim08=gsub("DeSoto, LA","De Soto, LA",temp.prim08)
temp.prim08=gsub("Jeff Davis, LA","Jefferson Davis, LA",temp.prim08)
temp.prim08=gsub("LaSalle, LA","La Salle, LA",temp.prim08)
temp.prim08=gsub("Baltimore City, MD","Baltimore city, MD",temp.prim08)
temp.prim08=gsub("Lac Qui Parle, MN","Lac qui Parle, MN",temp.prim08)
temp.prim08=gsub("Jeff Davis, MS","Jefferson Davis, MS",temp.prim08)
temp.prim08=gsub("LaClede, MO","Laclede, MO",temp.prim08)
temp.prim08=gsub("St. Louis City, MO","St. Louis city, MO",temp.prim08)
temp.prim08=gsub("St. Louis County, MO","St. Louis, MO",temp.prim08)
temp.prim08=gsub("Saint Lawrence, NY","St. Lawrence, NY",temp.prim08)
temp.prim08=gsub("LeFlore, OK","Le Flore, OK",temp.prim08)
temp.prim08=gsub("De Witt, TX","DeWitt, TX",temp.prim08)
temp.prim08=gsub("La Vaca, TX","Lavaca, TX",temp.prim08)
temp.prim08=gsub(" County, NV",", NV",temp.prim08)

virginia=gsub(" +$","",virginia)
virginia=virginia[-grep("[[:digit:]]",virginia)] # get rid of two former coun ties

virginia=gsub(","," City,",virginia)
v.d.ind=unlist(sapply(virginia,function(name){which(temp.prim08==name)}))
v.notd=virginia[-unlist(sapply(names(v.d.ind),function(name){which(virginia==name)}))]
temp.prim08[v.d.ind]=gsub("City","city",temp.prim08[v.d.ind])
v.notd=gsub(" City","",v.notd)
v.notd=unlist(sapply(v.notd,function(name){which(temp.prim08==name)}))
temp.prim08[v.notd]=gsub(","," city,",temp.prim08[v.notd])
temp.prim08=gsub(" City, VA"," city, VA",temp.prim08)

prim08$county[-sox]=temp.prim08

tst=sapply(prim08$county,function(name){length(grep(name,coord$county))})
# tst.ind=sapply(coord$county,function(name){grep(name,B1$County)})
tst.w=sapply(temp.prim08,function(name){length(which(coord$county==name))})
# names(coord$county)=coord$county


unlist(tst)[which(unlist(tst)==2)]
unlist(tst)[which(unlist(tst)==0)]


tst=sapply(coord$county,function(name){length(grep(name,prim08$county))})

unlist(tst)[which(unlist(tst)==2)]
unlist(tst)[which(unlist(tst)==0)]


ind=grep("Cook ",prim08$county)
prim08[ind,c(2,3)]=rep(apply(prim08[ind,c(2,3)],2,sum),each=2)
prim08=prim08[-ind[2],]
prim08$county=gsub("Cook \\(Chicago)","Cook",prim08$county)



ind=sapply(c("Brooklyn, NY","Manhattan, NY","Staten Island, NY"), function(name){grep(name,prim08$county)})
prim08[ind,c(2,3)]=rep(apply(prim08[ind,c(2,3)],2,sum),each=3)
prim08=prim08[-ind[c(2,3)],]
prim08$county=gsub("Brooklyn","New York",prim08$county)


ind=unlist(sapply(c(", KS",", NE",", NM",", ND"),function(name){grep(name,prim08$county)}))

cong.dists=prim08[ind,]

prim08=prim08[-ind,]

ind1=grep(", KS",coord$county)
ind2=grep(", NE",coord$county)
ind3=grep(", NM",coord$county)
ind4=grep(", ND",coord$county)
ind=c(ind1,ind2,ind3,ind4)

temp=data.frame(coord$county[ind],rep(NA,length(ind)),rep(NA,length(ind)))
names(temp)=names(prim08)
prim08=rbind(prim08,temp)







