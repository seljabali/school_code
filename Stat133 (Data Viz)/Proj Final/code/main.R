#source("/Users/samieljabali/Desktop/Stat Final Proj/code/main.R")

removeSpace = function(x){
	x = gsub("(^ +)", "", x)
	x = gsub("( +$)", "", x)
	x = gsub("( +)", " ", x)
	return(x)
}


main = function(){
	data = "/Users/samieljabali/Desktop/Stat Final Proj/data/"
	code = "/Users/samieljabali/Desktop/Stat Final Proj/code/"
	
	#COMBING B1-4
	b1 = read.csv(file = paste(data,"B1 cleaner.csv",sep = ""))
	b3 = read.csv(file = paste(data,"B3 cleaner.csv",sep = ""))
	b4 = read.csv(file = paste(data,"B4 cleaner.csv",sep = ""))
	source(paste(code,"combineBs.R",sep = ""))
	
	master = combineBs(b1, b3, b4)


	#ADDING '04 ELECTIONS
	state = readLines(paste(data,"stateAbbrevs2.txt",sep = ""))
	cv2004 = read.table(paste(data,"countyVotes2004.txt",sep = ""), header = TRUE)
	source(paste(code,"add04.R",sep = ""))
		
	master = add04(master, state, cv2004)


	#ADDING '08 ELECTIONS
	cs  = read.csv(file = paste(data,"counties_complete.csv", sep=""),header = FALSE)
	v = read.csv(file = paste(data,"DemPrimary2008.txt", sep=""),header = TRUE)
	source(paste(code,"add08.R",sep=""))

	master2 = add08(master,cs,v)


	#ADDING COUNTY LOCATIONS
	#source(paste(code,"GMLmaster3.R",sep=""))
	#master = addLocation(master,data)
	
	return(master)
}
