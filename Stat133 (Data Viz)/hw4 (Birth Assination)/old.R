BAgen = function (lambda, kappa, maxGen){
	gen = vector ("list", length = maxGen)
	for (i in 1 : maxGen){
		gen[i] = data.frame(PID = "", CID = "", Birth = "", Death = "")
	}
		
	#head
	gen[[1]]$PID = 0
	gen[[1]]$CID = 1
	gen[[1]]$Birth = 0
	gen[[1]]$Death = rexp(1, rate = kappa)
		
	#for loop
	for (i in 2 : maxGen) { #Getting number of children per previous generation
		family = rpois (length gen[[i - 1]]$CID, kappa * ageOfParent(i -1))
		
		for (a in length (family)){
			for (b in a){													#another way to code    min = gen[i-1][3,a]
			 	rbind(gen[[i]]$PID = a, 
					  gen[[i]]$CID = length (gen[i] + 1), 
					  gen[i]$Birth = runif(a, min = gen [i-1]$Birth[a], max = gen[i-1]$Death[a]), 
					  gen[i]$Death = gen[i-1]$Death[a] + rexp(1, rate = kappa) )
			}
		}
	}
}
	
	#ageOfParent
	ageOfParent = function(genNum){
		ages = vector("numeric", length(gen[[genNum]]$CID))
		for (i in ages){
			ages[i] = gen[[genNum]][i,4] -gen[[genNum]][i,3]
		}
			return ages
	}
		
		

