
mat1 <- read.table("Transgenic_vs_Control_FDR1_FC.txt", header=T, sep='\t' ,row.names=1,comment.char="#")
mat2 <- read.table("Transgenic_vs_Control_FDR1_10Mver_FC.txt", header=T, sep='\t' ,row.names=1,comment.char="#")
png("scatterPlot_FCvalues.png", width = 300, height = 300, pointsize = 12, bg = "white")

cor(mat1$'Log_FC', mat2$'Log_FC')

plot(mat1$'Log_FC', mat2$'Log_FC',xlab="original log(FC)",ylab="10M reads version log(FC)")

lm.obj<-lm(mat1$'Log_FC'~mat2$'Log_FC')
abline(lm.obj,col=2)
mtext(substitute(paste(R^2,"=",x),list(x=round(summary(lm.obj)$r.squared,digits=5))),line=-1,col=2,adj=0)

graphics.off()
