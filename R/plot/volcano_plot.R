

arg1 <- commandArgs(trailingOnly=T)[1]


mat <- read.table(arg1,sep=",",header=T)

df <- data.frame(x=mat$diff_value,y=mat$P_score)

png(paste("VolcanoPlot.png",sep=""),height=1000,width=1000  )
dm1<- mat$P_score >= 2

par(mar=c(5,5,5,2) , cex=2)
plot(df$x,df$y,xlab="Difference of %Diversity(group1-group2)",ylab="%Diversity Welch T.Test -log(P-value)",main="%diversity difference between immunized vs unimmunized \n for VDJ groups")
#smoothScatter(df$x,df$y,cex.lab=2,ylim=c(-8,8),xlim=c(0,10),xlab="Expression Average Value",ylab="Expression logFC")
df_signif <- df[dm1,]
points(df_signif$x,df_signif$y,col="red",pch=4)

