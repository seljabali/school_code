people = function (family){
	maxGen = length(family)
	numPpl = 0
    for(generations in 1:maxGen)
    {
        generation = family[[generations]]
        for(parent in 1:nrow(generation))
			numPpl = numPpl + 1
	}
	return (numPpl)
}


death = function (family){
	maxGen = length(family)
	life = 0
	numPpl = 0
    for(generations in 1:maxGen)
    {
        generation = family[[generations]]
        for(parent in 1:nrow(generation)){
				life = life + generation[parent,]$Death - generation[parent,]$Birth
				numPpl = numPpl + 1
		}
	}
	return (life/numPpl)
}


AvgPpl = function (tries, lambda, kappa, maxGen){
		avg = 0
		for (i in 1:tries)
			avg = avg + people(BAgen(lambda, kappa, maxGen))
		return (avg/tries)
}

AvgLifeSpan = function (tries, lambda, kappa, maxGen){
		avg = 0
		for (i in 1:tries)
			avg = avg + death(BAgen(lambda, kappa, maxGen))
		return (avg/tries)
}

#AvgLifeSpan(5, 0.2, 0.2, 4)