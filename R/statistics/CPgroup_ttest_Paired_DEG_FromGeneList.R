library(vioplot)


library(data.table)

categoryFile <- "./CP_Category.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

expFile <- "RNA-Seq_reAnalysis_responder_PairedTxls.unix.txt"
exptab <- fread(expFile,header=TRUE,sep="\t")

#rownames(exptab) <- exptab$Gene.ID

### grep only normalized expression values

exptab <- as.data.frame(exptab)
rownames(exptab) <- exptab$"Gene ID"

normalized_col <- grep( "normalized" , colnames(exptab))

normalized_col
exptab <- exptab[,normalized_col]
normalized_col <- grep( "^CP" , colnames(exptab))
exptab <- exptab[,normalized_col]
head(exptab)

exp <- t(exptab)


data_list <- colnames(exp)


#cate_list
stat <- c()

index <- 1
for (i in data_list){
	#if(index > 2 ){
	#	next
	#}
	cate1 <- "After"
	cate2 <- "Before"
	x <- subset(exp[,i],subset=(category$Category == cate1))
	y <- subset(exp[,i],subset=(category$Category == cate2))
	x <- na.omit(x)
	y <- na.omit(y)
	if(length(x) < 3 ){
		next	
	}
	if(length(y) < 3 ){
		next	
	}

	sd_x <- sd(x)
	sd_y <- sd(y)
    mean_x <- mean(x)
    mean_y <- mean(y)
	if(sd_x == 0 && sd_y == 0 ){
		next	
	}
	
	res <- t.test(x,y,paired=T)

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
write.table(stat3,"CP_PairedTTest_Results_BH_FDR.txt",sep="\t",quot=F,row.names=F);





