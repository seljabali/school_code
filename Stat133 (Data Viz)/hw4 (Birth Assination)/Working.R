BAgen = function(lambda, kappa, maxGen)
{
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
    currentGeneration = 1
    for(i in 1:maxGen)
    {
        i = family[[i]]
        if(currentGeneration < length(family)){
            break
        }
        curGenList = data.frame("PID"=NULL, "CID"=NULL, "Birth"=NULL, "Death"=NULL)
        kidCount = 1
        for(parent in 1:nrow(i))
        {
            for(j in 1:numChildren(i,parent)){
                curGenList = rbind(curGenList, data.frame("PID"= i[parent, ]$CID, 
														"CID" = kidCount, 
														"Birth" = childBirth(i, parent), 
														"Death" = childDeath(i, parent)))
                kidCount = kidCount + 1
            }
        }
    currentGeneration = currentGeneration + 1
    curGenList = list(curGenList)
    family = c(family, curGenList)
    }
    return(family)
}
		
		

