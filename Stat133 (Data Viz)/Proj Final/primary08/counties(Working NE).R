#source("/Users/samieljabali/Desktop/Stat Final Proj/counties.R")
#Remove all spaces within the county names
removeSpace = function(x){
	x = gsub("(^ +)", "", x)
	x = gsub("( +$)", "", x)
	return(x)
}		
votes = function(countyState){	
	votes08 = data.frame(row.names = c("County","State","Obama","Hillary"))
	#For each unique state
	ustates = unique(countyState[,3])
	for (i in 1:length(ustates)){
		
		indicies = which(countyState[,3] == as.character(ustates[i]))
		
		#Get its all of its counties
		stateCounties = countyState[indicies,]

		#Filter the repeated ones
		stateCounties  = sapply(stateCounties, removeSpace)
		stateCounties = unique(stateCounties[,2])
		
		#For each county add to data.frame
		for (j in 1:length(stateCounties)){
			c = as.character(stateCounties[j])
			s = as.character(ustates[i])
			temp = data.frame("County" = c, "State" = s,"Obama" = 0, "Hillary" = 0)
			votes08 = rbind(temp,votes08)
		}
	}
	return (votes08)
}

lookup = function(city, state, dictionary){
	#Find cities that have the same name
	res = which(dictionary[,1] == city)
	res = dictionary[res,]

	#Find states with the same name
	row	= which(res[,3] == state)[1] #in case of bad case
	return (as.character(res[row,2]))
	
	#Bad case
	#1252 Troy    Waldo ME
	#1457 Troy Cheshire VT
	#1694 Troy  Orleans VT	
}

cs  = read.csv(file = ("/Users/samieljabali/Desktop/Stat Final Proj/Part 1/counties_complete.csv"),header = FALSE)
v = read.csv(file = ("/Users/samieljabali/Desktop/Stat Final Proj/Part 1/DemPrimary2008.txt"),header = TRUE)
NE = votes(cs)

for (i in 1:length(v[,])){
	#Parsing the '08 elections
	loc = regexpr("[,]", v[i,1])
	county = substring(v[i,1], 1,loc - 1)
	state = substring(v[i,1], loc + 2,loc + 3)
	
	loc = regexpr("[[:digit:]]+ ", v[i,1])
	votes = substring(v[i,1], loc, regexpr("[[:digit:]]$", v[i,1]))
	
	loc = regexpr(" ", votes)
	obama = as.numeric(substring(votes, 1, loc-1))
	
	hillary = as.numeric(sub(obama, "", votes))
	
	#If we found a New England state
	foundNE = which(c("MA","ME","NH","CT","RI","VT") == state)[1]
	if (!is.na(foundNE)){
		realCounty = lookup(county,state,cs)
		realCounty = sapply(realCounty,removeSpace)
		res = which(NE[,1] == realCounty)
		NE[res,]$Obama = NE[res,]$Obama + obama
		NE[res,]$Hillary = NE[res,]$Hillary + hillary

		#Find states with the same name
		#row	= which(NE[,3] == stat
	}
}
