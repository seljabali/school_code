#Sami Eljabali
#Stat133BQ
#HW8 Cross Validation

vFold = function (n, v, option = 1){
	#Input validation (to be removed after testing efficiency)
#	if (length(n) > 1 || length(v) > 1){
#		return (paste("Must enter single numeric values!"))}
#	if (v < 2){
#		return (paste("v values must be greater or equal to 2!"))}
#	if (v > n){
#		return (paste("Can't have",v,"folds with", n, "n values!"))}

#	#If entered invalid option, revert to the default option
#	if (option > 6 || option < 1){
#		warning(c("\tOption ",option," is not a valid option!","\n\tNow using option 1 instead."))
#		option = 1
#	}

	#Calculate the number of rows for all various cases.
	rows = ceiling (n / v)	
	vector  = sample(n)
		
    #Perfect Fold
	if (n %% v == 0){ 
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
	
	totalElements = rows * v #Used by the rest of the options.
	
	#Fill the short subgroup with NAs
	if (option == 1){
		for (i in n:(totalElements-1))
			vector = c(vector,NA)
		
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
	#Spread NAs as evenly as possible
	if (option == 2){
		for (i in n:(totalElements-1)){
			vector = c(vector,NA)
		}
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = TRUE, dimnames = NULL))
	}			
	#Recycle sorted 1:N values into the matrix
	if (option == 3){
		j = 1
		vector = c(1:n)
		for (i in n:(totalElements-1)){
			vector = append(vector,vector[j], i)
			j = j + 1
		}
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}
			
	#Recycle the sampled values
	if (option == 4){
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}	
	
	#Fill the short subgroup with NAs, and have that short group be in a random column
	if (option == 5){
		for (i in n:(totalElements-1)){
			vector = c(vector,NA)
		}
		neo = matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL)
		v1 = neo[,v]
		newCol = floor(runif(1,1,v+1))
		neo[,v] = neo[,newCol]
		neo[,newCol] = v1
		return(neo)
	}
	#Recycle random values into the matrix
	if (option == 6){
		j = 1
		for (i in n:(totalElements-1)){
			vector = append(vector,vector[j], i)
			j = j + 1
		}
		return(matrix(data = vector, nrow = rows, ncol = v, byrow = FALSE, dimnames = NULL))
	}	
}