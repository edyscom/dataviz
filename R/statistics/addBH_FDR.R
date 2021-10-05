library(gplots)


file <- "make_Ven_DEG.txt"

matrix <- read.table(file,header=T,sep="\t")

matrix <- na.omit(matrix)



pval <- matrix$pvalue
FDR <- p.adjust(pval)


matrix <- cbind(matrix,FDR)

write.table(matrix,"make_Ven_DEG.FDR.txt",sep="\t",quot=F);
