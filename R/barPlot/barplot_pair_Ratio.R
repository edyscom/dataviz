

file1 <- "dedup_summary.txt"



mat1 <- read.table(file=file1,header=T,sep="\t",row.names=1)

names <- as.character(rownames(mat1))

#mat2 <- cbind(mat1$aligned_count,mat1$after_nuDup_count)
mat2 <- cbind(mat1$after_nuDup_count,mat1$aligned_count)
mat2 <- as.matrix(mat2)

mat2

mat=matrix(NA, nrow(mat2),2, dimnames=list(names, c("ALL", "af. remove dup.")))

mat <- mat2

png(paste("barplot_duplication.png",sep=""), width = 800, height = 800, pointsize = 12, bg = "white")




par(mar=c(10,10,10,10))





barplot(t(mat),names.arg=names,main="duplicate read count",cex.lab=2,cex.axis=2,cex.main=2,beside=F,las=2)

legend("topright", c("rem. PCR dup.", "ALL"), fill=grey.colors(2))


graphics.off()


