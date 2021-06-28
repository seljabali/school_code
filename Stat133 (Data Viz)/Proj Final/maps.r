load("~/Desktop/master")
#install.packages("maps",lib="~/Library/R/R-2.0.0")
#R_LIBS="$HOME/Library/R
#library("maps")
#map('usa')
#map('state', add = TRUE)
# This line is the important one. (remove the "add = TRUE" if you plan to run it by itself)
#map('county', add = TRUE, fill = FALSE, col = c('red', 'blue'))

bluered2 <- function(B,K,S=1,graded=F) {
  if (is.na(B))
	B = 1
  if (is.na(K))
	K = 1
  if (graded) {
    ## Suggested by Gregoire Thomas:
    Kn <- K/(B+K)
    red   <- ifelse(Kn<0.5, 1, 2-2*Kn)
    blue  <- ifelse(Kn<0.5, 2*Kn, 1)
    green <- ifelse(Kn<0.5, blue, red)
    rgb(red, green, blue, S)
  } else {
    ## All or none
    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
  }
}

bluered <- function(B,K,S=1,graded=F) {
  if (is.na(B))
	B = 1
  if (is.na(K))
	K = 1
  if (graded) {
    ## Purple plot
    rgb(B/(B+K),0,K/(B+K),S);
  } else {
    ## All or none
    ifelse(B>K,rgb(1,0,0,S),rgb(0,0,1,S))
  }
}


indicies = which(nchar(as.character(master$state)) > 2)
remove = function (index){
	for (i in index)
		master = master[-i,]
	return (master)
}

master = remove(indicies)

library("maps")
map('usa',fill=T,col="white",bg="darkgray")
order=1:length(master$county)
col <- rep(rgb(.1,.1,.1,.2),length(master$state))
col[order] <- suppressWarnings(bluered(master$Bush,master$Kerry,.4,graded=T))

m <- map('county',fill=T,plot=F)
polygon(m$x,m$y,col=col,border=NA)
## Draw county borders
map('county',col="darkgrey",add=T)
## Draw state borders
map('state',col="black",add=T,lwd=1)
## Color for circles
col <- suppressWarnings(bluered(master$Bush,master$Kerry,.6))
## Symbols is the easiest way to draw circles that have the right aspect ratio

#symbols(master$Bush, master$Kerry,circles=log(length(master$state)+1)*3,fg=col,bg=col,add=T,inches=F)
