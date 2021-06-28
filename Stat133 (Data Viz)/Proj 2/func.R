d2r = function (x) {x = x*pi/180}
r2d = function (x) {x = x*180/pi}
neg = function (x) {x = x*-1}
#(34, 120, 46.7, 147.2)
ideal= function(lat1, long1, lat2, long2, n){
	slp = slerp (c(lat1,long1), c(lat2,long2), n)
	#neg = function(x) {x = x*-1}
	slp[,2] = sapply(slp[,2],neg)
	
	data = data.frame(slp[,2],slp[,1])
	return (data)
}


RandomWalk = function(longb, latb, longe, late, spe, sig){
	data1 = GCRandomWalk (d2r(longb), d2r(latb), d2r(longe), d2r(late), spe, sig)
	data1[,1] = sapply(data1[,1], neg)
	data1[,1] = sapply(data1[,1],r2d)
	data1[,2] = sapply(data1[,2],r2d)
	
	data2 = GCRandomWalk (d2r(longe), d2r(late), d2r(longb), d2r(latb), spe, sig)
	data2[,1] = sapply(data2[,1], neg)
	data2[,1] = sapply(data2[,1],r2d)
	data2[,2] = sapply(data2[,2],r2d)
	
	return(data.frame(c(data1[,1],data2[,1]), c(data1[,2],data2[,2])))
}