#Sami Eljabali
#S133-BQ
#HW 4
BAgen = function(lambda, kappa, maxGen)
{   
 	#helper functions
	numChildren = function(frame, row){
		kids = rpois(1, lambda*(frame[row, ]$Death - frame[row, ]$Birth))
		return (kids)
	}

	childBirth = function(frame, row){
		Birth = runif(1, min = frame[row, ]$Birth, max = frame[row, ]$Death)
		return (Birth)
	}
	childDeath = function(frame, row){
		Death = frame[row, ]$Death + rexp(1, rate = kappa)
		return (Death)
	}
    maxGen = maxGen - 1
    head = data.frame(PID=0, CID=1, Birth = 0, Death=rexp(1,rate=kappa))
    family = list(head)
    numGen = 1
    for(generations in 1:maxGen)
    {
        generation = family[[generations]]
        if(numGen < length(family))
            break
		childID = 1
        newGeneration = data.frame("PID" = NULL, "CID" = NULL, "Birth" = NULL, "Death" = NULL)
        for(parent in 1:nrow(generation))
        {
            for(i in 1:numChildren(generation,parent)){
                newGeneration = rbind(newGeneration, data.frame("PID"= generation[parent, ]$CID, 
														"CID" = childID, 
														"Birth" = childBirth(generation, parent), 
														"Death" = childDeath(generation, parent)))
                childID = childID + 1
            }
        }
    numGen = numGen + 1
    family = c(family, list(newGeneration))
    }
    return(family)
}