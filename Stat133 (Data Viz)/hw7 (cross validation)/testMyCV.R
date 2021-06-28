testcv = function(f) {
# The input to this function is your cv function
# The first two arguments of your function must be the size of the data (e.g. n)
# and the number of folds (e.g. v)
  n =  rep(c(100,200, 500, 750, 1000, 5000, 10000, 25000, 100000, 500000),100) 
  v = rep(c(2,3,4, 5,7,10,13,17,19,25,41), length = length(n))
  apply(cbind(n,v), 1, function(x) f(x[1], x[2]) )
  return(TRUE)
}