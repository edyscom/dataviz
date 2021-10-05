library(exactRankTests)


cate1 <- "KCNJ5"
cate2 <- "HET"




categoryFile <- "data/Phenodata.order.txt"
category <- read.table(categoryFile,row.names=1,header=TRUE,sep="\t")

pDataFile <- "tmp"
#pDataFile <- "averaged_beta_values.txt"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

data_list <- rownames(pData)
pData <- t(pData)

cate_list <- levels(category$GROUP)



header <- paste("GENE_GROUP" ,"Group1" ,"Group2","Difference","p-value", "AVERAGE1","SD1","AVERAGE2","SD2", "BH-FDR", "\n",sep="\t")
cat(header)


pvalues = c()
prints  = c()
index <- 1
for (i in data_list){
	x <- subset(pData[,i],subset=(category$GROUP == cate1))
	y <- subset(pData[,i],subset=(category$GROUP == cate2))
	x <- na.omit(x)
	y <- na.omit(y)
#	cat(i ,cate1 ,cate2,"x=",x,",y=",y, "\n")
	
	res <- wilcox.exact(x,y,paired=F)

	sd_x <- sd(x)
	sd_y <- sd(y)
	mean_x <- mean(x)
	mean_y <- mean(y)

	diff <- mean_x - mean_y
	pvalues <- c(pvalues , res$p.value)

	print <- paste(i ,cate1 ,cate2,diff,res$p.value, mean_x,sd_x,mean_y,sd_y, sep="\t")
	prints <- c(prints , print)


	index <- index + 1
}

fdr_values <- p.adjust(pvalues)

for ( i in 1:length(fdr_values)){
	cat( paste(prints[i],fdr_values[i],"\n",sep="\t"))

}


