fit=rpart(formula(paste("Primary.Winner.2008~",paste(sapply(3:(ncol(master)-2), FUN=function(col) {
	colnames(master)[col]
}),collapse="+"),collapse="")), data=master[!is.na(master$Primary.Winner.2008),])

