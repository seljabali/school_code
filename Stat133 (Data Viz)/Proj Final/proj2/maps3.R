#map('usa')
#map('state', add = TRUE)
# This line is the important one. (remove the "add = TRUE" if you plan to run it by itself)



data = "~/sp08/stat133/proj3/Part2/data/"


#  WARNING
#  There are only two Maine counties with votes- all others 0/0 ?!?!?
#

bluered <- function(B,K,S=1,graded=F) {
 if (length(B)==0|length(K)==0)
	{
	rgb(0,0,0,0)
	}
	else
	{
 if (graded) {
  if (is.na(B)|is.na(K)|(B==0&K==0)){
	rgb(0,0,0,1)
	} else {
    ## Suggested by Gregoire Thomas:
    Kn <- K/(B+K)
    red   <- ifelse(Kn<0.5, 1, 2-2*Kn)
    blue  <- ifelse(Kn<0.5, 2*Kn, 1)
    green <- ifelse(Kn<0.5, blue, red)
    rgb(red, green, blue, S)
	}
  } else {
    ## All or none
    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
  }
	}
}

#bluered <- function(B,K,S=1,graded=F) {
#  if (is.na(B))
#	B = 1
#  if (is.na(K))
#	K = 1
#  if (graded) {
#    ## Purple plot
#    rgb(B/(B+K),0,K/(B+K),S);
#  } else {
#    ## All or none
#    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
#  }
#}


indicies = which(nchar(as.character(master$state)) > 2)
remove = function (index){
	for (i in index)
		master = master[-i,]
	return (master)
}

master = remove(indicies)


pop.=as.character(master$X.00.Total.People)
pop.=gsub(",","",pop.)
pop.=as.numeric(pop.)

library("maps")

#
# match map-counties with master-counties
#

nam=map('county', plot=FALSE)$names

sta=readLines(paste(data,"stateAbbrevs2.txt",sep = ""))
states=gsub(" [A-Z][A-Z]$","",sta)
abbrevs=sta

for(j in 1:51){
	abbrevs=gsub(states[j],"",abbrevs)
	}
abbrevs=gsub(" ","",abbrevs)


ind1=NULL
ind2=rep(NULL,length(master$County))
for(k in 1:51){
	ind1=grep(paste(",",abbrevs[k]),master$County)
	ind2[ind1]=gsub(paste(",",abbrevs[k]),"",master$County[ind1])
	ind2[ind1]=paste(states[k],sep=",",ind2[ind1])
}
ind2=tolower(ind2)

#also worry about spaces?
ind3=sapply(nam,function(w){which(ind2==w)})




pdf("US08Primary.pdf",version="1.4",width=10,height=6.5)
map('usa',fill=F,col="white",bg="darkgray")
order=1:length(nam)
col <- rep(NA,length(nam))
col.abs <- rep(NA,length(nam))
lat <- rep(NA,length(nam))
long <- rep(NA,length(nam))
pop <- rep(NA,length(nam))

# (formerly)
#col[order] <- suppressWarnings(bluered(master$Hillary,master$Obama,.6,graded=T))


# (now)
for (i in order){
	col[i]<-bluered(master$Hillary[ind3[[i]][1]],master$Obama[ind3[[i]][1]],.8,graded=T)
	col.abs[i]<-bluered(master$Hillary[ind3[[i]][1]],master$Obama[ind3[[i]][1]],.8,graded=F)
	lat[i]<-master$Latitdue[ind3[[i]][1]]
	long[i]<-master$Longitude[ind3[[i]][1]]
	pop[i]<-pop.[ind3[[i]][1]]
		}

m <- map('county',fill=T,plot=F)
polygon(m$x,m$y,col=col,border=NA)
## Draw county borders
map('county',col="darkgrey",add=T)
## Draw state borders
map('state',col="black",add=T,lwd=1)
## Color for circles
#col <- suppressWarnings(bluered(master$Bush,master$Kerry,.6))
## Symbols is the easiest way to draw circles that have the right aspect ratio


symbols(x=long/1000000, y=lat/1000000,circles=sqrt(pop)/1000,fg=col.abs,bg=col.abs,add=T,inches=F)

dev.off()






