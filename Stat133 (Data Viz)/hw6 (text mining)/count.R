# total number of words in a speech
totalW = function(sp){
	l = length(sp)
	total = 0
	word = 0
	for (i in 1:l){
		word[i] = length (strsplit(sp[[i]], split="[[:space:]]+")[[1]])-1
		total = total + word[i]
	}
	return (total)
}

#
numOfWordsInSent = c()
for (i in 1:length(speeches)){
numOfWordsInSent = c(numOfWordsInSent, totalW(speeches[i]))
}




# pass in speech as argument
#totalNumOfWords = c()
count = function (sp){
	# count how many sentences in sp
	l = length(sp)
	total = 0
	word = 0
	for (i in 1:l){
		word[i] =  length (strsplit(sp[[i]], split="[[:space:]]+")[[1]])-1
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

