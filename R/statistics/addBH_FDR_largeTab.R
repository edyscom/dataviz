
library(gplots)


file <- "case_vs_control_DMR_WindowAnalysis.txt.tmp"

matrix <- read.table(file,header=T,sep="\t")

#matrix <- na.omit(matrix)



pval <- matrix$pValue
BH_FDR <- p.adjust(pval)


matrix <- cbind(matrix,BH_FDR)
matrix <- matrix[c(1:4,11,5:10)]


write.table(matrix,"case_vs_control_Rver.FDR.txt",sep="\t",quot=F,row.names=F);
