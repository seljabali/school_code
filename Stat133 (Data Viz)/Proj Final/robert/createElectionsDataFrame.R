createElectionsDataFrame = function(b1, b3, b4, state, votes2004, votes2008, countyLoc, bigCities) {

	# -------------------- Preparation ------------------------------------------

	# This is not a "robust" function in the sense that it is designed only to
	# work with the correct b1, b3 and b4.

	nObs = nrow(b1) #3200
	
	# which rows are counties?

	# First, split all the counties
	countiesSplit = sapply(1:nObs, FUN=function(row) {
		strsplit(as.character(b1$County[row]),split=", ")
	})

	whichCounty=which(sapply(1:nObs, FUN=function(row) {
		length(countiesSplit[[row]])==2
	}))
	# whichCounty is now a numeric vector, each entry of which corresponds to a row
	# that is a county in b1, b3 and b4

	# extract the county names and states into separate vectors...
	# note the use of whichCounty
	County = sapply(whichCounty, FUN = function(row) {
		gsub("[[:punct:]]","",tolower(countiesSplit[[row]][1]))
	})
	State = sapply(whichCounty, FUN = function(row) {
		substr(countiesSplit[[row]][2], start=1, stop=2)
	})

	# County State pairs for the demographic data
	CountyStateDemo = sapply(1:length(County), FUN=function(row) {
		paste(County[row],tolower(State[row]))
	})

	# --------------- Votes 2004 ---------------------------

	# make state into a matrix
	stateMatrix=matrix(unlist(sapply(1:length(state), FUN=function(row) {
		temp=strsplit(state[row], split=" ")[[1]]
		c( paste(temp[1:(length(temp)-1)], collapse=" ") ,temp[length(temp)])
	})), ncol=2, byrow=T)

	# County state pairs for the voting data
	CountyStateVote2004 = sapply(1:nrow(votes2004), FUN=function(row) {
		temp=strsplit(as.character(votes2004[row,1]), split=",")[[1]]
		paste(temp[2], stateMatrix[which(stateMatrix[,1]==temp[1]),2], collapse=" ")
	})

	# Now we need a map from CountyStateVote2004 to CountyStateDemo so as to put it into
	# the data frame
	# there are some counties with missing voting data from 2004
	# map2004[i] has the value of the voting data index that corresponds to the ith
	# county in demographic data

	map2004=sapply(1:length(County), FUN=function(i) {
		temp=which(CountyStateDemo[i] == CountyStateVote2004)
		if (length(temp) > 0) temp[1]
		else as.numeric(NA)
	})

	#> map2004[1]
	#[1] 16
	#> CountyStateDemo[1]
	#[1] "autauga al"
	#> CountyStateVote2004[16]
	#[1] "autauga al"

	# there is no data for virginia. Why? Could it be George Allen's doing?
	BushKerry = matrix(unlist(sapply(1:length(County), FUN=function(row) {
		bush=as.numeric(votes2004[map2004[row],2])
		kerry=as.numeric(votes2004[map2004[row],3])

		winner=NA
		if(is.na(bush)) winner=NA
		else if (bush > kerry) winner="Bush"
		else if(bush < kerry) winner="Kerry"

		c(winner,100*bush/(bush+kerry))
	})), ncol=2, byrow=T)
	colnames(BushKerry) = c("2004.winner","Bush.vote.percent")

	# -------------------------- Votes 2008 ---------------------------

	# first step is to format the counties correctly. After that, we can create
	# a map
	CountyStateVote2008=sapply(1:nrow(votes2008), FUN=function(row) {
		temp=gsub("[[:punct:]]","",tolower(strsplit(rownames(votes2008)[row], split=", ")[[1]]))
		paste(temp[1],temp[2],collapse=" ")
	})

	map2008=sapply(1:length(County), FUN=function(i) {
		temp=which(CountyStateDemo[i] == CountyStateVote2008)
		if (length(temp) > 0) temp[1]
		else as.numeric(NA)
	})

	# as last time, map2008[i] has the value of the voting2008 data index that corresponds
	# to the ith row in the demographic data	

	# There are counties where Obama is NA but clinton has votes. I don't understand
	ClintonObama = matrix(unlist(sapply(1:length(County), FUN=function(row) {
		clinton=as.numeric(votes2008[map2008[row],2])
		obama=as.numeric(votes2008[map2008[row],1])

		winner=NA
		if (is.na(obama)) winner=NA
		else if (clinton > obama) winner="Clinton"
		else if (clinton < obama) winner="Obama"

		c(winner,100*clinton/(clinton+obama))
	})),ncol=2,byrow=T)
	colnames(ClintonObama) = c("2008.Primary.winner","Clinton.vote.percent")

	# ----------------------- County Locations and nearest big city ---
	# I'll be the first to admit I couldn't get the xml version to work
	# so I did it all through readlines and parsing the lines

	stateStart = grep("^   <gml",countyLoc)
	# conveniently, they're in order

	stateStart[52] = length(countyLoc) + 2

	nCounties = sapply(1:51, FUN=function(i) { (stateStart[i+1]-stateStart[i]-5)/15 })
	# for the most part, this is the same as the number of occurances of each state
	# in master[,2] but not quite. Why? Who knows.

	# create an unmapped matrix
	unmappedLoc=matrix(unlist(sapply(1:51, FUN=function(n) {
		state=stateMatrix[n,2]
		matrix(sapply(0:(nCounties[n]-1), FUN=function(whichCounty) {
			countyName=gsub("[[:punct:]]","",tolower(strsplit(substr(countyLoc[stateStart[n]+4 + 15*whichCounty],start=5,stop=500),split=" ")[[1]]))
	
			countyX=as.numeric(substr(countyLoc[stateStart[n]+9+15*whichCounty],start=7,stop=100))/1000000
			countyY=as.numeric(substr(countyLoc[stateStart[n]+12+15*whichCounty],start=7,stop=100))/1000000

			return(c(
				paste(paste(countyName[-length(countyName)], collapse=" "),state),
				countyX,
				countyY,
				min(sapply(1:nrow(bigCities), FUN=function(city) {
					sqrt((countyX-bigCities[city,2])^2+(countyY-bigCities[city,1])^2)
				}))
			))
		}), ncol=4)
	})),ncol=4, byrow=T)
	
	# locmap[i] contains the row of unmappedLoc that corresponds to the ith county
	# in demographic data
	locmap=sapply(1:length(County), FUN=function(i) {
		temp=which(CountyStateDemo[i] == unmappedLoc[,1])
		if (length(temp) > 0) temp[1]
		else as.numeric(NA)
	})
	# this is mostly in order, with a few exceptions (in the end, the lists are 3 off)

	mappedLoc=matrix(unlist(sapply(1:length(County), FUN=function(row) {
		unmappedLoc[locmap[row],2:4]
	})), ncol=3,byrow=T)
	colnames(mappedLoc) = c("Longitude","Latitude","Distance.to.big.city") # could also be c("X","Y")


	# ----------------------- Data frame ------------------------------

	# finally, make the data frame

	toReturn= data.frame(cbind(County, State,
		mappedLoc,
		b1[whichCounty, c(4,6,8,15,16)],
		b3[whichCounty, 2:17],
		b4[whichCounty, c(2,3,5:13)],
		BushKerry,
		ClintonObama
	))
	colnames(toReturn) = c("County","State","Longitude","Latitude","Distance.to.big.city",
		"Total.Area","Pop.06","Pop.00","Dens.06","Dens.00",
		"Age.5","Age.5.14","Age.15.24","Age.25.34","Age.35.44","Age.45.54","Age.55.64","Age.65.74",
		"Age.75","White","Black","Asian","Nat.Am","Hawaiian","Hispanic","Male.100.Female",
		"Households.00","Households.w.under.18.00","HS.Percent.00","Bachelor.Percent.00",
		"Foreign.Born.00","No.English.00","Not.Moved.00","No.Carpool.00","Income.75k.00",
		"Poverty.04","Poverty.00","Winner.2004","Bush.vote.percent","Primary.Winner.2008",
		"Clinton.vote.percent")
	
	# We need to change the rownames to be the actual names instead of the old ones from the full
	# county list that included UNITED STATES, ALABAMA, etc.
	rownames(toReturn) = 1:nrow(toReturn)

	# There is one column (Households.00) that uses commas. Before doing the next step,
	# I need to remove those commas. Col num = 24. This also makes it have no levels
	toReturn[,26]=gsub(",","",toReturn[,26])

	# The numeric columns currently are stored as factors. We need to convert them to
	# factors.
	toConvert = c(3:25, 28:37,39,41)
	numerics=matrix(unlist(sapply(toConvert, FUN=function(x) {
		temp=as.numeric(levels(toReturn[,x])[as.numeric(toReturn[,x])])
		if(length(temp)==0) print(x)
		temp
	} )),ncol=length(toConvert))
	colnames(numerics) = colnames(toReturn)[toConvert]

	# this line isn't pretty:
	toReturn2 = cbind(toReturn[,1:2],numerics[,1:25],Male.100.Female=as.numeric(toReturn[,26]),
		Households.00=as.numeric(toReturn[,27]),numerics[,26:34],Winner.2004=toReturn[,38],
		Clinton.percent=numerics[,35],Primary.Winner.2008=toReturn[,40])

	return(toReturn2)
}

