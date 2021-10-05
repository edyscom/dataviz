##################################################
#
# A script for MAPlot from RNAseq results (cuffdiff result version)
# Time-stamp: <17/02/9 10:52:18 ysato>
#
##################################################



### reading data matrix
#matrix <- read.table("Case_vs_Control_cuffdiff/gene_exp.diff" , header = T , sep="\t", row.names=1)
matrix <- read.table("/disk3/NGS/etc/RNAseq_healthy/cuffdiff_results_groups/gene_exp.diff" , header = T , sep="\t", row.names=1)


value_1 <- matrix$value_1
value_2 <- matrix$value_2

head(value_1)
head(value_2)

value_1[matrix$value_1 < 1] <- 1
value_2[matrix$value_2 < 1] <- 1

head(value_1)
head(value_2)


average <- (log2(value_1) +  log2(value_2) )/ 2
average <- as.vector(average)
class(average)
colnames(matrix)

head(average)

logFC <- matrix['log2.fold_change.']
logFC <- unlist(logFC)
class(logFC)


dim(average)
dim(logFC)

dm1<- matrix$q_value < 0.5 
dm2<- matrix$p_value < 0.5 
png(paste("MAplot_RNAseq.png",sep=""),height=1000,width=1000  )



par(mar=c(5,5,2,2) , cex=2)
smoothScatter(average,logFC,cex.lab=2,ylim=c(-8,8),xlim=c(0,10),xlab="Expression Average Value",ylab="Expression logFC")
#smoothScatter(average,logFC,cex.lab=2,xlab="Expression Average Value ",ylab="Expression logFC")


points(average[dm2],logFC[dm2],col="orange",pch=".")
points(average[dm1],logFC[dm1],col="red",pch=4)
