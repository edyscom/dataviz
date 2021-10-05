

file1 <- "mRNA_TMM_non0.txt"
file2 <- "miRNA_TMM_non0.txt"

args1 = commandArgs(trailingOnly=TRUE)[1]
args2 = commandArgs(trailingOnly=TRUE)[2]


mat1 <- read.table(file=file1,header=T,sep="\t",row.names=1)
mat2 <- read.table(file=file2,header=T,sep="\t",row.names=1)

colnames <- colnames(mat1)

mat1 <- as.matrix(mat1)
mat2 <- as.matrix(mat2)

x <- as.vector(mat1[args1,])
y <- as.vector(mat2[args2,])


png(paste("scatter_",args1,"_vs_",args2,".png",sep=""), width = 800, height = 800, pointsize = 12, bg = "white")


par(mar=c(6,5,5,3))

plot(x, y,xlab=args1,ylab=args2,main=paste(args1," vs ",args2,sep=""),cex.lab=2,cex.axis=2,cex.main=2)
text(x, y ,colnames,col=c("red","blue","red","blue","red","blue"))

par(ps=18)

lm.obj<-lm(y~x)
abline(lm.obj,col=2)

mtext(substitute(paste(R^2,"=",x),list(x=round(summary(lm.obj)$r.squared,digits=5))),line=0.5,col=2,adj=0)

graphics.off()


