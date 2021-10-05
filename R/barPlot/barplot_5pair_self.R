

file1 <- "../mRNA_linc_edgeR_DEG_v2_merge_normVal_meanCent.txt"
#file2 <- "../mRNA_linc_edgeR_DEG_v2_merge_normVal_3pairs_meanCent.txt"
#file2 <- "../miRNA_T_vs_N_pairedT_FDR1_v20_3pairs_meanCent.txt"

args1 = commandArgs(trailingOnly=TRUE)[1]
args2 = commandArgs(trailingOnly=TRUE)[2]


mat1 <- read.table(file=file1,header=T,sep="\t",row.names=1)
mat2 <- mat1

colnames <- as.character(colnames(mat1))

mat1 <- as.matrix(mat1)
mat2 <- as.matrix(mat2)

x <- as.vector(mat1[args1,])
y <- as.vector(mat2[args2,])

x_mean = mean(x)
y_mean = mean(y)

x <- x - x_mean
y <- y - y_mean


png(paste("barplot_",args1,"_vs_",args2,".png",sep=""), width = 1000, height = 1000, pointsize = 12, bg = "white")




par(mar=c(10,5,5,3),ps=12)

### remove __normalized char from colname
colnames <- sub("__normalized","",colnames)


#colnames


colnames2 <- colnames




matrix <- matrix(NA,2,10,dimnames=list(c("mRNA","lincRNA"),colnames2))

matrix[1,] <- x
matrix[2,] <- y


barplot(matrix,xlab="samples",ylab="normalized value(mean centered)",main=paste(args1," vs ",args2,sep=""),cex.lab=2,cex.axis=2,cex.main=2,beside=T,las=2)

legend("topright", c("mRNA", "lincRNA"), fill=grey.colors(2))


graphics.off()


