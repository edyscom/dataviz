
mat1 <- read.table("read_distri_chrom2.tsv", header=T, sep='\t' ,row.names=1,comment.char="#")
mat2 <- read.table("hg19_ChromInfo.txt", header=T, sep='\t' ,row.names=1,comment.char="#")
png("scatterPlot_J001.png", width = 600, height = 600, pointsize = 12, bg = "white")

as.numeric(mat1$'J001_R1')
mat2$'Size'

x <- as.numeric( mat1$'J001_R1')
y <- as.numeric( mat2$'Size')

cor(x,y)

plot(x, y,xlab="read # for J001_R1",ylab="Chrom Size")

lm.obj<-lm(y~x)
abline(lm.obj,col=2)
mtext(substitute(paste(R^2,"=",x),list(x=round(summary(lm.obj)$r.squared,digits=5))),line=-1,col=2,adj=0)

graphics.off()
