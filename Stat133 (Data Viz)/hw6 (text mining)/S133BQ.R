#Sami Eljabali
#S133-BQ
#HW5
#19059321

text = readLines("stateoftheunion1790-2008.txt")
library(Rstem)

tableOfContents = text[11:228]
oldPresidents = strsplit(tableOfContents, ",")
Presidents = c()

for(i in 1:218){
	Presidents = c(Presidents, substring(oldPresidents[[i]][[1]], 3))
}

loc = regexpr("[[:alpha:]]+[ ][1-3]?[[:digit:]][,][[:blank:]][[:digit:]]{4}", text)
stringDates = substring(text, loc, loc + attr(loc, "match.length"))[11:228]
Dates = strptime(stringDates[1:218], format = "%b %d, %Y")

stringText = paste(text, collapse = " ")

#Cutting up into different speeches
speeches = strsplit(stringText, split = "\\*\\*\\*")[[1]]

#Remove table of contents and final junk
speeches = speeches[2:(length(speeches) - 1)]    

#Splitting sentences.
speeches = strsplit(speeches, split = "\\.")


#Function: Total Number of Words#
totalW = function(speeches){
	l = length(speeches)
	words = 0
	word = 0
	for (i in 1:l){
		word[i] = length (strsplit(speeches[[i]], split="[[:space:]]+")[[1]])-1
		words = words + word[i]
	}
	return (words)
}

#Getting the number of words in a sentence
numOfWordsInSent = c()
for (i in 1:length(speeches)){
	numOfWordsInSent = c(numOfWordsInSent, totalW(speeches[i]))
}


count = function (speeches){
	l = length(speeches)
	total = 0
	word = 0
	for (i in 1:l){
		word[i] =  length (strsplit(speeches[[i]], split="[[:space:]]+")[[1]])-1
		total = total + word[i]
		#totalNumOfWords = c(totalNumOfWords, total)
		#avg = c(avg, word[i])
	}
	#return (sapply(avg, function(x){x/total}))
	return(total/l)
}

#count the total avg for all the speeches
avgWordsInSent = c()
for (i in 1:length(speeches)){
	avgWordsInSent = c(avgWordsInSent, count(speeches[[i]]))
	#avgWordsInSent = rbind(avgWordsInSent,data.frame(count(speeches[[i]]), i))
}

avgWordsInSent
sortedAvgWords = sort(avgWordsInSent)

#Best 5 speech givers.
tail (sortedAvgWords)

frameAvgWords = data.frame("Words/Sentence" = avgWordsInSent,"Year" = 1790:2007)
AvgWords2 = data.frame("Words/Sentence" = frameAvgWords[2],"Year" = frameAvgWords[1])
jpeg("/Users/samieljabali/Desktop/Stat-proj3/Presidential State of the Union Addresses.jpg")
	plot(frameAvgWords2,xlab="Years: 1790 - 2008", ylab="Average Words/Sentence",main="Presidential State of the Union Addresses")
dev.off()


combineSpeechesAndStem = function (speeches,lst){
	stemmed = c()
	for (i in 1:length(lst)){
		for (j in 1:length(speeches[[i]])){
			sentence = strsplit(speeches[[i]][j], split="[[:space:]]+")
			for (k in 1:length(sentence[[1]])){
				stemmed = c(stemmed, wordStem(sentence[[1]][k]))
			}
		}
	}
	(stemmed)
}

TF = function(combinedSpeeches, allWords){
	T1 = table(combinedSpeeches)
	allWords = table(allWords)
	allWords = allWords * 0
	
	(T1 + allWords)
} 

#Works, but takes forever to compute!
#allWords = combineSpeechesAndStem(speeches,c(1:218))
#Washington = combineSpeechesAndStem(speeches,c(1:8))
#TF(Washington, allWords)
