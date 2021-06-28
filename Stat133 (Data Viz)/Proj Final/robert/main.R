# YOU MUST MANUALLY CHANGE THESE LINES:
data = "C:\\Users\\Robert\\Documents\\Homework and Notes\\Stats 133\\Final Project\\data\\"
code = "C:\\Users\\Robert\\Documents\\Homework and Notes\\Stats 133\\Final Project\\code\\"
	

main = function() {
	#COMBING B1-4
	b1 = read.csv(file = paste(data,"B1 cleaner.csv",sep = ""))
	b3 = read.csv(file = paste(data,"B3 cleaner.csv",sep = ""))
	b4 = read.csv(file = paste(data,"B4 cleaner.csv",sep = ""))
	
	state = tolower(readLines(paste(data,"stateAbbrevs2.txt",sep = "")))
	votes2004 = read.table(paste(data,"countyVotes2004.txt",sep = ""), header = TRUE)
	votes2008 = read.table(file = paste(data,"DemPrimary2008.txt", sep=""),header = TRUE)
	countyLoc = readLines(paste(data,"counties.gml",sep=""))
	bigCities = read.csv(paste(data,"top30cities.csv.txt",sep=""),header=T)[,3:4]

	source(paste(code,"createElectionsDataFrame.R",sep=""))
	return(suppressWarnings(createElectionsDataFrame(b1, b3, b4, state, votes2004, votes2008, countyLoc, bigCities)))
}

master=main()

# clean up
rm(main)
rm(data)
rm(code)
rm(createElectionsDataFrame)