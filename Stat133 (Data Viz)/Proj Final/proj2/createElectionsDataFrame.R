createElectionsDataFrame = function(b1, b3, b4, state, votes2004, votes2008, countyLoc, bigCities, countiesComplete, verbose) {

	# -------------------- Preparation ------------------------------------------

	if (verbose) print("Preparing list of counties...")


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
		countiesSplit[[row]][1]
	})

	countyFormat = gsub(" ","",gsub("[[:punct:]]","",tolower(County)))


	State = sapply(whichCounty, FUN = function(row) {
		substr(countiesSplit[[row]][2], start=1, stop=2)
	})

	# County State pairs for the demographic data
	CountyStateDemo = sapply(1:length(countyFormat), FUN=function(row) {
		paste(countyFormat[row],tolower(State[row]))
	})

	# --------------- Votes 2004 ---------------------------
	# Some errors in the data: Mono is a tie, but actually Kerry won by 7 votes.
	# The results themselves don't line up with what I see on wikipedia. Perhaps
	# my vote tallies (which are lower than those on wikipedia) don't include write-in
	# etc. ballots. CA is notorious for those ballots.
	# however, there's only one tie so I'll fix only mono
	votes2004[183,3]= 2201 # Not the actual number, but just so that Kerry wins

	if (verbose) print("Preparing 2004 election...")

	# make state into a matrix
	stateMatrix=matrix(unlist(sapply(1:length(state), FUN=function(row) {
		temp=strsplit(state[row], split=" ")[[1]]
		c( gsub(" ", "", paste(temp[1:(length(temp)-1)], collapse=" ")), temp[length(temp)])
	})), ncol=2, byrow=T)

	# County state pairs for the voting data
	CountyStateVote2004 = sapply(1:nrow(votes2004), FUN=function(row) {
		temp=gsub(" ","",strsplit(as.character(votes2004[row,1]), split=",")[[1]])
		paste(temp[2], stateMatrix[which(stateMatrix[,1]==temp[-length(temp)]),2], collapse=" ")
	})

	# Miami-Dade is referred to as Dade, FL so we fix that
	CountyStateVote2004[326]="miamidade fl"

	# Also, Yellowstone National Park has no data. But it has no vote, so it doesn't matter.

	# Now we need a map from CountyStateVote2004 to CountyStateDemo so as to put it into
	# the data frame
	# there are some counties with missing voting data from 2004
	# map2004[i] has the value of the voting data index that corresponds to the ith
	# county in demographic data

	map2004=sapply(1:length(countyFormat), FUN=function(i) {
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
	BushKerry = matrix(unlist(sapply(1:length(countyFormat), FUN=function(row) {
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
	if (verbose) print("Preparing 2008 primary data...")

	# ND had a caucus. I will leave that be (for now, at least.)
	# 

	# some preparation: replace Saint by St, as it is in the demographic data
	rownames(votes2008) = gsub("Saint","St",rownames(votes2008))

	rownames(votes2008) = gsub(" County","",rownames(votes2008))

	# add cook, illinois
	votes2008[742,] = colSums(votes2008[742:743,])
	rownames(votes2008)[742] = "Cook, IL"

	# do the same for St. Louis
	votes2008[1725,] = colSums(votes2008[1724:1725,])
#	rownames(votes2008)[1724] = "St. Louis, MO"

	# Fix NY similarly
	votes2008[2023,] = colSums(votes2008[c(2023,2047),])
	rownames(votes2008)[2023] = "New York, NY"

	# Change Staten Island to Richmond
	rownames(votes2008)[2069] = "Richmond, NY"

	# Fix Jefferson Davis, LA and MS
	rownames(votes2008)[958] = "Jefferson Davis, LA"
	rownames(votes2008)[1573] = "Jefferson Davis, MS"

	# first step is to format the counties correctly. After that, we can create
	# a map
	CountyStateVote2008=sapply(1:nrow(votes2008), FUN=function(row) {
		temp=gsub("[[:punct:]]","",gsub(" ","",tolower(strsplit(rownames(votes2008)[row], split=", ")[[1]])))
		paste(temp[1],temp[2],collapse=" ")
	})

	states2008=c(sapply(CountyStateVote2008, FUN=function(word) { strsplit(word, split=" ")[[1]][2] }))

	# fix new england
	# there are some errors in the data :(
#	badCounties=c("belknap VT","cheshire VT","coos VT","grafton VT","hillsborough VT","merrimack VT","rockingham VT", "strafford VT","sullivan VT")

#	countiesComplete = matrix(unlist(sapply(1:nrow(countiesComplete), FUN=function(x) {
#		if (!any(paste(as.character(countiesComplete[x,2]),as.character(countiesComplete[x,3]),sep=" ")==badCounties))
#			c(as.character(countiesComplete[x,1]),as.character(countiesComplete[x,2]),as.character(countiesComplete[x,3]))
#	})),ncol=3, byrow=T)
# The above is unnecessary because I cleaned the data
	
	countiesComplete[,1] = gsub("[[:punct:]]","",gsub(" ","",tolower(as.character(countiesComplete[,1]))))
	countiesComplete[,2] = gsub(" ","",tolower(as.character(countiesComplete[,2])))
	neCounty = unique(paste(countiesComplete[,2],countiesComplete[,3]))

	resultsByCounty = matrix(unlist(sapply(neCounty, FUN= function(co) {
		temp=which(paste(countiesComplete[,2],countiesComplete[,3])==co)
		cities = countiesComplete[ temp ,1]
		curState = tolower(countiesComplete[ temp[1] ,3])

		unlisted=unlist(sapply(which(states2008==curState), FUN=function(x) {
			if (any(cities == strsplit(CountyStateVote2008[x],split=" ")[[1]][1] ))
				c(votes2008[x,1], votes2008[x,2])
		}))
		if (!is.null(unlisted)) colSums(matrix(unlisted, ncol=2, byrow=T))
		else c(NA,NA)
	})), ncol=2, byrow=T)

	#votes2008= rbind(votes2008, resultsByCounty)  # For some reason this does not work
								     # but this is just as good:
	temprownames=rownames(votes2008)
	votes2008=cbind(c(votes2008[,1],resultsByCounty[,1]),c(votes2008[,2],resultsByCounty[,2]))
	# we don't need rownames because we have CountyStateVote2008
	rownames(votes2008) = c(temprownames, paste(neCounty, sep=", "))
	# adding row names is actually unnecessary, but it was easier to develop that way

	CountyStateVote2008 = c(CountyStateVote2008, neCounty)

	map2008=sapply(1:length(countyFormat), FUN=function(i) {
		temp=which(CountyStateDemo[i] == CountyStateVote2008)
		if (length(temp) > 0) temp[1]
		else as.numeric(NA)
	})

	map2008[307:314]   = 3347:3354 # Connecticut
	map2008[1215:1228] = 3355:3368 # MA
	map2008[1175:1190] = NA # ME
	map2008[2310:2314] = 3385:3389 # RI
	map2008[2805:2818] = 3390:3403 # VT. but who cares about VT?
	map2008[1763:1772] = 3404:3413 # NH

	# as last time, map2008[i] has the value of the voting2008 data index that corresponds
	# to the ith row in the demographic data	

	# There are counties where Obama is NA but clinton has votes. I don't understand
	ClintonObama = matrix(unlist(sapply(1:length(countyFormat), FUN=function(row) {
		clinton=as.numeric(votes2008[map2008[row],2])
		obama=as.numeric(votes2008[map2008[row],1])

		winner=NA
		percent=NA
		if (!is.na(obama) | !is.na(clinton)) {
		if (is.na(obama)) { winner="Clinton"; percent=100 }
		else if (is.na(clinton)) { winner="Obama"; percent=0 }
		else { winner=ifelse(clinton>obama, "Clinton","Obama")
			percent = 100*clinton/(clinton+obama) }
		}

		c(winner,percent)
	})),ncol=2,byrow=T)
	colnames(ClintonObama) = c("2008.Primary.winner","Clinton.vote.percent")

	

	# ----------------------- County Locations and nearest big city ---
	# I'll be the first to admit I couldn't get the xml version to work
	# so I did it all through readlines and parsing the lines

	if (verbose) print("Preparing county locations and nearest big city...")

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
			countyName=gsub("[[:punct:]]","",tolower(strsplit(substr(countyLoc[stateStart[n]+5 + 15*whichCounty],start=5,stop=500),split=" ")[[1]]))
	
			countyX=as.numeric(substr(countyLoc[stateStart[n]+10+15*whichCounty],start=7,stop=100))/1000000
			countyY=as.numeric(substr(countyLoc[stateStart[n]+13+15*whichCounty],start=7,stop=100))/1000000

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
	locmap=sapply(1:length(countyFormat), FUN=function(i) {
		temp=which(CountyStateDemo[i] == unmappedLoc[,1])
		if (length(temp) > 0) temp[1]
		else as.numeric(NA)
	})
	# this is mostly in order, with a few exceptions (in the end, the lists are 3 off)

	mappedLoc=matrix(unlist(sapply(1:length(countyFormat), FUN=function(row) {
		unmappedLoc[locmap[row],2:4]
	})), ncol=3,byrow=T)
	colnames(mappedLoc) = c("Longitude","Latitude","Distance.to.big.city") # could also be c("X","Y")


	# ----------------------- Data frame ------------------------------

	if (verbose) print("Preparing data frame...")

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

	if (verbose) print("Storing factors as numeric data...")

	# The numeric columns currently are stored as factors. We need to convert them to
	# factors.
	toConvert = c(3:25, 28:37,39,41)
	numerics=matrix(unlist(sapply(toConvert, FUN=function(x) {
		as.numeric(levels(toReturn[,x])[as.numeric(toReturn[,x])])
	} )),ncol=length(toConvert))
	colnames(numerics) = colnames(toReturn)[toConvert]

	# this line isn't pretty:
	toReturn = cbind(toReturn[,1:2],numerics[,1:25],Male.100.Female=as.numeric(toReturn[,26]),
		Households.00=as.numeric(toReturn[,27]),numerics[,26:34],Winner.2004=toReturn[,38],
		Clinton.percent=numerics[,35],Primary.Winner.2008=toReturn[,40])

	# Now we fix the 2008 votes that were done by congressional district by pretending that nebraska
	# kansas and new mexico are each a single county
			   # NM	    #NE        #KS
	begEndInDemo = c(1794,1826, 1653,1745, 886,990)
	begEndInVote = c(2017,2019, 1739,1741, 929,932)
	howToCombine = c("state.name","state.name","mean","mean","min","sum","sum","sum",
		"weighted.mean.06", "weighted.mean.00",rep("weighted.mean.06",18), "sum",rep("weighted.mean.06",8),"elections")

	statesToAdd = matrix(unlist(sapply(1:3, FUN=function(stateNum) {
		curState = data.frame(toReturn[begEndInDemo[stateNum*2-1]:begEndInDemo[stateNum*2],],stringsAsFactors=F)
		curVotes = votes2008[begEndInVote[stateNum*2-1]:begEndInVote[stateNum*2],]
		
		# unfortunately, curState is in characters...
		numerics=matrix(unlist(sapply(toConvert, FUN=function(x) {
			as.numeric(curState[,x])
		} )),ncol=length(toConvert))
		colnames(numerics) = colnames(toReturn)[toConvert]

		# this line isn't pretty:
		curState = cbind(curState[,1:2],numerics[,1:25],Male.100.Female=as.numeric(curState[,26]),
			Households.00=as.numeric(curState[,27]),numerics[,26:34],Bush.vote.percent=curState[,38],
			Clinton.percent=numerics[,35],Primary.Winner.2008=curState[,40])

		

		matrix(unlist(sapply(1:length(howToCombine),FUN = function(col) {
			method = howToCombine[col]
			if (method == "state.name") return(as.character(curState[1,2]))
			if (method == "mean") return(mean(curState[,col], na.rm=T))
			if (method == "min") return(min(curState[,col], na.rm=T))
			if (method == "sum") return(sum(curState[,col], na.rm=T))
			if (method == "weighted.mean.00") return(sum(curState[,col]*curState$Pop.00, na.rm=T)/sum(curState$Pop.00, na.rm=T))
			if (method == "weighted.mean.06") return(sum(curState[,col]*curState$Pop.06, na.rm=T)/sum(curState$Pop.06, na.rm=T))
			if (method == "elections") {
				# we need to return winner.2004, bush.vote.percent, primary.winner.2008 and then clinton.vote.percent
				bush.pct = sum(curState$Bush.vote.percent * curState$Pop.06, na.rm=T)/sum(curState$Pop.06, na.rm=T)
					# not exactly true, good enough for now
				winner.2004 = ifelse (bush.pct > 50, "Bush", "Kerry")

				clinton = sum(curVotes[,2])
				obama = sum(curVotes[,1])
				clinton.pct = 100*clinton/(clinton + obama)
				winner.2008 = ifelse(clinton.pct > 50, "Clinton","Obama")
				return(matrix(data=c(bush.pct, winner.2004, clinton.pct, winner.2008), nrow=1))
			}

		})), nrow=1)
	
				

	})), nrow=3, byrow=T)

	# isn't the above just elegantly coded? I think so.
	# now we add them on, and rerun the factors->numeric stuff

	#toReturn.backup = toReturn
	colnames(statesToAdd) = colnames(toReturn)
	toReturn = rbind(toReturn[-c(1794:1826, 1653:1745, 886:990),], statesToAdd)

	numerics=matrix(unlist(sapply(toConvert, FUN=function(x) {
		as.numeric(toReturn[,x])
	} )),ncol=length(toConvert))
	colnames(numerics) = colnames(toReturn)[toConvert]

	# this line isn't pretty:
	toReturn = cbind(toReturn[,1:2],numerics[,1:25],Male.100.Female=as.numeric(toReturn[,26]),
		Households.00=as.numeric(toReturn[,27]),numerics[,26:34],Winner.2004=toReturn[,38],
		Clinton.percent=numerics[,35],Primary.Winner.2008=toReturn[,40])

	# due to moving of columns around, we need to fix the columns
	colnames(toReturn) = c("County","State","Longitude","Latitude","Distance.to.big.city",
		"Total.Area","Pop.06","Pop.00","Dens.06","Dens.00",
		"Age.5","Age.5.14","Age.15.24","Age.25.34","Age.35.44","Age.45.54","Age.55.64","Age.65.74",
		"Age.75","White","Black","Asian","Nat.Am","Hawaiian","Hispanic","Male.100.Female",
		"Households.00","Households.w.under.18.00","HS.Percent.00","Bachelor.Percent.00",
		"Foreign.Born.00","No.English.00","Not.Moved.00","No.Carpool.00","Income.75k.00",
		"Poverty.04","Poverty.00","Winner.2004","Bush.vote.percent","Primary.Winner.2008",
		"Clinton.vote.percent")
	# and change winner.2004 and Primary.Winner.2008 back to strings

	toReturn$Winner.2004 = gsub("1","Bush", gsub("2","Kerry", as.character(toReturn$Winner.2004)))
	toReturn$Primary.Winner.2008 = gsub("1","Clinton", gsub("2","Obama", as.character(toReturn$Primary.Winner.2008)))

	if (verbose) print("Finished!")

	return(toReturn)
}

