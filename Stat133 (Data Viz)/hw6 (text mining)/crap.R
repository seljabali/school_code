wordCount = 0
numSentences = 0
MAX_SENTENCES = 500
numWordsInSentences = matrix(nrow = length(speeches), ncol = MAX_SENTENCES)
#wordsInSpeech = 0
#Calculate the number of words in each sentence and the number of words in each speech
for(i in 1:length(speeches)){ # i goes through speeches
	for(j in 1:length(speeches[[i]])){ # j goes through sentences		
		numWordsInSentences[i,j] = length(strsplit(speeches[[i]][[j]], split = "[[:space:]]+")[[1]]) - 1
		#wordCount = wordCount + numWordsInSentences[i][j]
	}
	#wordsInSpeech[i] = wordCount
	#wordCount = 0
}

numWordsInSentences = function(speech) {
	l = length(speech)
	total = 0
	numWords = 0
	for (x in 1:l) {
		numWords = c(length(strsplit(speech[[x]], split = "[[:space:]]+")[[1]]) - 1, numWords)
	}
	return numWords
}
numWords = 0
for(i in 1:length(speeches)){
	numWords[i] = numWordsInSentences(speeches[[i]])
}

#Calculate the average number of words in each sentence (a quality of every speech)
for (i in 1:length(speeches)){
	
	
	
	
	
	
newSentence
sentences
allWords	
for(i in 1:length(speeches)){ # i goes through speeches
	for(j in 1:length(speeches[[i]])){ # j goes through sentences
		newSentence
		#numWordsInSentences[[i]][j] = length(strsplit(speeches[[i]][[j]], split = "[[:space:]]+")[[1]]) - 1; #subtract 1 for extra space in beginning

	}
}