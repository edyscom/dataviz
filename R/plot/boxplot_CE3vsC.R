library(vioplot)






categoryFile <- "SSc_category_CE0toCE2_Cont_Only.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

pDataFile <- "exp_SSc_CEgroup_meanCentering.PH117.txt"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

pData <- t(pData)

cate_list <- levels(category$Category )

data_list <- colnames(pData)


#cate_list




index <- 1
for (i in data_list){
	if(i == "6772_STAT1"){

	cate1 <- "Group_1"
	cate2 <- "Group_7_2"
	x <- subset(pData[,i],subset=(category$Category == cate1))
	y <- subset(pData[,i],subset=(category$Category == cate2))
	x <- na.omit(x)
	y <- na.omit(y)
	if(length(x) < 3 ){
		next	
	}
	if(length(y) < 3 ){
		next	
	}

	x <- as.numeric(unlist(x))
	y <- as.numeric(unlist(y))
	
library(beeswarm)

	exp_list <- list("CE1"=x,"C"=y)

png("6772_STAT1_boxplot.png",600,600)
boxplot(exp_list,col=c("red","green"),ylim=c(-1.5,1.5))
beeswarm(exp_list,add=TRUE)






	

	}
	index <- index + 1
}

