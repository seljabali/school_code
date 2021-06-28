


# uses master and DemPrimary2008.txt

prim08=read.table("DemPrimary2008.txt",sep=" ")
prim08=cbind(row.names(prim08),prim08)
prim08[,1]=as.character(prim08[,1])
names(prim08)[1]="county"

master$county.1=as.character(master$county.1)
ind.indep=grep("Independent Cities",master$county.1)
ind.Wash=grep("WASHINGTON",master$county.1)
virginia=master$county.1[(ind.indep+1):(ind.Wash-1)]



# to disregard NE city data for now:
sox=c(", VT",", ME",", MA",", RI",", CT",", NH")
sox=sapply(sox,function(name){grep(name,prim08$county)})
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

virginia=virginia[-grep("[[:digit:]]",virginia)] # get rid of two former counties
virginia=gsub(" +$","",virginia)


virginia=gsub(","," City,",virginia)
v.d.ind=unlist(sapply(virginia,function(name){which(temp.prim08==name)}))
v.notd=unlist(sapply(names(v.d.ind),function(name){which(virginia==name)}))
v.notd=virginia[-v.notd]
temp.prim08[v.d.ind]=gsub("City","city",temp.prim08[v.d.ind])
v.notd=gsub(" City","",v.notd)
v.notd=unlist(sapply(v.notd,function(name){which(temp.prim08==name)}))
temp.prim08[v.notd]=gsub(","," city,",temp.prim08[v.notd])
temp.prim08=gsub(" City, VA"," city, VA",temp.prim08)

prim08$county[-sox]=temp.prim08

#tst=sapply(prim08$county,function(name){length(grep(name,coord$county))})
#tst.w=sapply(temp.prim08,function(name){length(which(coord$county==name))})
#unlist(tst)[which(unlist(tst)==2)]
#unlist(tst)[which(unlist(tst)==0)]
#tst=sapply(coord$county,function(name){length(grep(name,prim08$county))})
#unlist(tst)[which(unlist(tst)==2)]
#unlist(tst)[which(unlist(tst)==0)]


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

ind=c(", WV",", SD",", OR",", NC",", MT",", KY",", IN",", AK")
ind=unlist(sapply(ind,function(name){grep(name,coord$county)}))

temp=data.frame(coord$county[ind],rep(NA,length(ind)),rep(NA,length(ind)))
names(temp)=names(prim08)
prim08=rbind(prim08,temp)
rownam=prim08$county
prim08=prim08[,c(2,3)]
row.names(prim08)=rownam

# NOW 'prim08' is a data frame with columns 'county', 'Obama', and 'Clinton'. NE state rows are as they appeared in DemPrimary2008.txt .

# this is saved in 'modDemPrimary2008.txt' in the working directory.
write.table(prim08,"modDemPrimary2008.txt")
