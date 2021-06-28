#Sami Eljabali
#Stat133BQ
#HW8 Cross Validation

vFold = function (n, v, option = 1){
	#Input validation
	if (length(n) > 1 || length(v) > 1){
		return (paste("Must enter single numeric values!"))}
	if (v < 2){
		return (paste("v values must be greater or equal to 2!"))}
	if (v > n){
		return (paste("Can't have",v,"folds with", n, "n values!"))}
	
	#If entered invalid option, revert to the default option
	if (option > 6 || option < 1){
		warning(c("\tOption ",option," is not a valid option!","\n\tNow using option 1 instead."))
		option = 1
	}
		
    #Perfect Fold
	if (n %% v == 0){ 
		rows = n / v
		vector  = sample(n,n,FALSE)
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
	#Fill the short subgroup with NAs
	if (option == 1){
		rows = floor(n / v) + 1
		totalElements = rows * v
		finalVector = sample(n,n,FALSE)
		for (i in n:totalElements){
			finalVector = append(finalVector,NA, n)
		}
		return(matrix(data = finalVector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
	#Spread NAs as evenly as possible
	if (option == 2){
		rows = floor(n / v) + 1
		totalElements = rows * v
		finalVector = sample(n,n,FALSE)
		for (i in n:totalElements){
			finalVector = append(finalVector,NA, n)
		}
		return(matrix(data = finalVector, nrow = rows, ncol = v, byrow = TRUE, dimnames = NULL))
	}			
	#Recycle 1:N values into the matrix
	if (option == 3){
		rows = floor(n / v) + 1
		totalElements = rows * v
		vector = c(1:n)
		finalVector = sample(n,n,FALSE)
		j = 1
		vector = c(1:n)
		for (i in n:totalElements){
			finalVector = append(finalVector,vector[j], i)
			j = j + 1
		}
		return(matrix(data = finalVector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}		
	#Randomly insert the rest of the values
	if (option == 4){
		rows = floor(n / v) + 1
		vector  = c(1:n)
		finalVector = sample(n,n,FALSE)
		return(matrix(data = finalVector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
	#Fill the short subgroup with NAs, and have that short group be in a random column
	if (option == 5){
		rows = floor(n / v) + 1
		totalElements = rows * v
		vector  = c(1:n)
		finalVector = sample(n,n,FALSE)
		for (i in n:totalElements){
			finalVector = append(finalVector,NA, n)
		}
		neo = matrix(data = finalVector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL)
		v1 = neo[,v]
		newCol = floor(runif(1,1,v+1))
		neo[,v] = neo[,newCol]
		neo[,newCol] = v1
		return(neo)
	}
	#Recycle random values into the matrix
	if (option == 6){
		rows = floor(n / v) + 1
		totalElements = rows * v
		vector = c(1:n)
		finalVector = sample(n,n,FALSE)
		j = 1
		for (i in n:totalElements){
			finalVector = append(finalVector,finalVector[j], i)
			j = j + 1
		}
		return(matrix(data = finalVector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}	
}