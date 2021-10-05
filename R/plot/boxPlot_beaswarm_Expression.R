
library(beeswarm)

exp <- read.table("../expression_non0.tab",sep="\t",header=T,row.names=1)

head(exp)

boxplot(exp,col=c("red","red","red","blue","blue","blue"),ylim=c(0,3))
beeswarm(exp,add=TRUE)

