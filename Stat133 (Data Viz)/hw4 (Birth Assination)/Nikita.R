BAgen = function(lambda, k, maxGen)
{
    maxGen = maxGen - 1
    gen1 = data.frame(PID=0, CID=1, birth = 0, death=rexp(1,rate=k))
    main = list(gen1)
    currentGeneration = 1
    for(i in 1:maxGen)
    {
        i = main[[i]]
        if(currentGeneration < length(main)){
            break
        }
        curGenList = data.frame("PID"=NULL, "CID"=NULL, "birth"=NULL, "death"=NULL)
        kidCount = 1
        for(parent in 1:nrow(i))
        {
            numberOfKids = rpois(1, lambda*(i[parent, ]$death - i[parent, ]$birth))
            for(j in 1:numberOfKids){
                kidBirth = runif(1, min = i[parent, ]$birth, max = i[parent, ]$death)
                kidDeath = i[parent, ]$death + rexp(1, rate = k)
                curGenList = rbind(curGenList, data.frame("PID"= i[parent, ]$CID, "CID" = kidCount, "birth" = kidBirth, "death" = kidDeath))
                kidCount = kidCount + 1
            }
        }
    currentGeneration = currentGeneration + 1
    curGenList = list(curGenList)
    main = c(main, curGenList)
    }
    return(main)
}