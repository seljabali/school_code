combineBs = function(b1,b3,b4){
	seperate = function(){
	main = data.frame()
		for (i in 1:nrow(b1)){
			y = strsplit(as.character(b1$County[i]), split = ",")
			if (length(y[[1]]) == 1)
				dynamic = data.frame(state = y[[1]][1],county = "")
			else
				dynamic = data.frame(state = gsub(" ","",y[[1]][2]), county = y[[1]][1])
			main = rbind(main, dynamic)
		}
		return(main)
	}
	master = seperate()
	master = cbind(master,b1[,c(3,16)])
	master = cbind(master,b3[,-3])
	master = cbind(master,b4[,-3])
	master$County = sapply(master$County, removeSpace)
	master$County = sapply(master$County, toupper)
	return (master)
}