smooth = function (frame, n){
	 main = data.frame("")
	 if ((nrow(frame)) == 1)
	  return(frame)
	
	 for (i in 1: nrow(frame)){
	  if (i == nrow(frame))
	   return(main)
	  
	  if (i == 1)
	   main = slerp(c(frame[i,1],frame[i,2]), c(frame[i+1,1],frame[i+1,2]), n)
	  else
	   main = rbind(main, slerp(c(frame[i,1],frame[i,2]), c(frame[i+1,1],frame[i+1,2]), n))
	 }
	
	 for (i in nrow(main))
	  write (c(main[i,1],main[i,2]), file = "data", sep =",", append = TRUE)
	
	 #make output file
	 return (main)
}