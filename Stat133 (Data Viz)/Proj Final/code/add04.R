add04 = function (master,state, cv2004){
	#state = readLines("/Users/samieljabali/Desktop/Stat Final Proj/data/stateAbbrevs2.txt") ########

	myState = function(){
		main = data.frame()
		for (i in 1:length(state)){
			y = strsplit(state[i], split=" ")
			dynamic = data.frame(state = paste(y[[1]][-length(y[[1]])], collapse= " "), abbrev = y[[1]][length(y[[1]])])
			main = rbind(main, dynamic)
		}
		return (main)
	}
	#### create a df for state and abbrev for countyVote 04 
	allState = myState()
	#cv2004 = read.table("/Users/samieljabali/Desktop/Stat Final Proj/data/countyVotes2004.txt", header = TRUE) ##########

	countyState=NA
	cv2004 = cbind(countyState, cv2004)
	vote04 = function(){
		for (i in 1:nrow(cv2004)){
			key = toupper(substring(cv2004[i,]$countyName, 1,regexpr("[,]", cv2004[i,]$countyName)-1))
			index = which(as.character(allState$state) == key)[1]
			if (!is.na(index)){
				cv2004[i,]$countyState = paste(toupper(substring(cv2004[i,]$countyName, regexpr("[,]", cv2004[i,]$countyName)+1)), as.character(allState[index,]$abbrev), sep=", ")
			}
		}

		cv2004 = cv2004[,-2]
		return(cv2004)
	}

	v04 = vote04()
	Bush = NA
	Kerry = NA
	master = cbind(master, Bush)
	master = cbind(master, Kerry)
	for (i in 1:nrow(v04)){
		key = as.character(v04[i,]$countyState)
		index = which(master$County == key)[1]
		if(!is.na(index)){
			master[index,]$Bush = v04[i,]$bushVote
			master[index,]$Kerry = v04[i,]$kerryVote
		}
	}
	return (master)
}