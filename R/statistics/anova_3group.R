library(vioplot)






categoryFile <- "SSc_Category_160621_3group.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

pDataFile <- "exp_SSc58s_meanCentering.mod.3group.tab"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

pData <- t(pData)

cate_list <- levels(category$Category )

data_list <- colnames(pData)


cate_list



list <- list()

index <- 1
for (i in data_list){
	score <- pData[,i]
	cate  <- category$Category

	res <- anova(aov(score ~ cate))
	cat(i ,res$Pr,"\n")
	index <- index + 1
}



