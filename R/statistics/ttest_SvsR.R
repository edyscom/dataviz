library(vioplot)






categoryFile <- "SSc_Category_160621_SvsR.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

pDataFile <- "exp_SSc58s_meanCentering.mod.SvsR.PH.tab"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

pData <- t(pData)

cate_list <- levels(category$Category )

data_list <- colnames(pData)


cate_list




index <- 1
for (i in data_list){
	cate1 <- "Group_S"
	cate2 <- "Group_R"
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
	res <- t.test(x,y)

	sd_x <- sd(x)
	sd_y <- sd(y)
	mean_x <- mean(x)
	mean_y <- mean(y)

	diff <- mean_x - mean_y
	cat(i ,cate1 ,cate2,diff,res$p.value, res$estimate ,sd_x,sd_y, "\n")

	index <- index + 1
}

