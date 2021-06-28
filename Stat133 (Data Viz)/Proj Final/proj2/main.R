

main = function(verbose = FALSE) {

	# YOU MUST MANUALLY CHANGE THESE LINES:
	data = "C:\\Users\\Robert\\Documents\\Homework and Notes\\Stats 133\\Final Project\\data\\"
	code = "C:\\Users\\Robert\\Documents\\Homework and Notes\\Stats 133\\Final Project\\code\\"


	#COMBING B1-4

	if (verbose) print("Loading data...")
	b1 = read.csv(file = paste(data,"B1 cleaner.csv",sep = ""))
	b3 = read.csv(file = paste(data,"B3 cleaner.csv",sep = ""))
	b4 = read.csv(file = paste(data,"B4 cleaner.csv",sep = ""))
	
	state = tolower(readLines(paste(data,"stateAbbrevs2.txt",sep = "")))
	votes2004 = read.table(paste(data,"countyVotes2004.txt",sep = ""), header = TRUE)
	votes2008 = read.table(file = paste(data,"DemPrimary2008.txt", sep=""),header = TRUE)
	countyLoc = readLines(paste(data,"counties.gml",sep=""))
	bigCities = read.csv(paste(data,"top30cities.csv.txt",sep=""),header=T)[,3:4]

	# fix connecticut
	countiesComplete = read.csv(file=paste(data,"counties_complete_cleaned.csv", sep=""))
	
	source(paste(code,"createElectionsDataFrame.R",sep=""))
	return(suppressWarnings(createElectionsDataFrame(b1, b3, b4, state, votes2004, votes2008, countyLoc, bigCities, countiesComplete, verbose)))

	#ADDING COUNTY LOCATIONS (Need Andy's girlfriend's mac to get this working! LoL!)
	#names(master)[5] <- "county.1"
	#	tree=xmlTreeParse(paste(data,"new_counties.gml",sep=""),useInternal=TRUE)	
	#master=data.frame(b1$County)
#	b1 = read.csv(file = paste(data,"B1 cleaner2.csv",sep = ""))
#	names(master)="county.1"
#	source(paste(code,"GMLmaster2.R",sep=""))
#	master = addLocation(master,b1)	
}

master=main(verbose=F)

# clean up
rm(main)
rm(createElectionsDataFrame)