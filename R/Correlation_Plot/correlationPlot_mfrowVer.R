

### R script to generate the scatter plot between INPUT DNA amount vs  estimated #tag

args <- commandArgs(TRUE)
matrixfile1 <- args[1]
matrixfile2 <- args[2]


df_new <- read.table(matrixfile1,sep='\t',header=T,stringsAsFactors=F,row.names=1)
df_old <- read.table(matrixfile2,sep='\t',header=T,stringsAsFactors=F,row.names=1)


pdf(paste("ReadCoverage_plot",".pdf",sep=""))
par(mfrow=c(2,4))


lst_new <- colnames(df_new)
lst_old <- colnames(df_old)




for (new in colnames(df_new) ){
	for (old in colnames(df_old)){

	y <- df_new[,new]   
	x <- df_old[,old]   

	cor(x,y)
	cat(cor(x,y))
	plot(x, y,xlab="Read Cov. Prev.",ylab="Read Cov. New",xlim=c(0,500000),ylim=c(0,500000))
	lm.obj<-lm(y~x)
	abline(lm.obj,col=2)
	mtext(substitute(paste(R^2,"=",x),list(x=round(summary(lm.obj)$r.squared,digits=5))),line=-2,col=2,adj=0)


	}

}

