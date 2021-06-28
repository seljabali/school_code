mytext = readLines("stateoftheunion1790-2008.txt")

TOC = mytext[11:228]
oldPres = strsplit(TOC, ",")
Pres = c()
TOC[[1]][1]
TOC[[1]][[1]]
oldPres[[1]][1]
oldPres[[1]][[1]]
for (i in 1:218) {
	Pres = c(Pres, substring(oldPres[[i]][[1]], 3))
}

loc = regexpr("[[:alpha:]]+[ ][1-3]?[[:digit:]][,][[:blank:]][[:digit:]]{4}", mytext)
stringDates = substring(mytext, loc, loc + attr(loc, "match.length"))[11:228]
Dates = strptime(stringDates[1:218], format = %b %d, %Y)
Dates = strptime(stringDates[1:218], format = "%b %d, %Y")

stringText = paste(mytext, collapse= " ")
speeches = strsplit(stringText, split = "\\*\\*\\*")[[1]]
speeches = speeches[2:(length(speeches) -1)]
speeches = strsplit(speeches, split = "\\.")
for (i in 1:length(speeches)) {
	speeches[[i]] = speeches[[i]][1:(length(speeches[[i]])-1)]
}

source("count.R")

sort(avgWordsInSent)
tail (avgWordsInSent)
avgWordsInSent = sort(avgWordsInSent)
tail (avgWordsInSent)
Pres
Pres[21]
Pres[25]
Pres[28]
Pres[23]
Pres[52]
Pres[27]
savehistory("shit1.R")
