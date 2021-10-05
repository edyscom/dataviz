


data(iris)


for (i in 1:4){

	sd <- sd(iris[,i])

	cat ("SD of colum ", i , "=" , sd,"\n")
	

}
