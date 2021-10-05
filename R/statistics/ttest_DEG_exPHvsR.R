library(vioplot)




categoryFile <- "./SSc_category_exPH_exN_R.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

pDataFile <- "./exp_SSc_exPHgroup_meanCentering.txt"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

pData <- t(pData)

cate_list <- levels(category$Category )

data_list <- colnames(pData)


#cate_list
stat <- c()

index <- 1
for (i in data_list){
	#if(index > 2 ){
	#	next
	#}
	cate1 <- "Group_exPH"
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
    this_result <- c(i ,cate1 ,cate2,res$p.value,diff, mean_x , sd_x, mean_y, sd_y)
	stat <- c(stat,this_result)
	#stat <- rbind(stat,this_result)

	index <- index + 1
}

stat <- matrix(stat,ncol=9,byrow=TRUE)
colnames(stat) <- c('Gene','Category1','Category2','p_value','logFC','Mean_Category1','SD_Category1','Mean_Category2','SD_Category2')
stat <- as.data.frame(stat)

BH_FDR <- p.adjust(stat$p_value)
stat2 <- cbind(stat,BH_FDR)
stat3 <- stat2[,c(1:3,10,4:9)]
write.table(stat3,"TTest_Results_BH_FDR.txt",sep="\t",quot=F,row.names=F);





