
library(ggplot2)

#presidential <- subset(presidential, start > economics$date[1])
#write.table(presidential,"testdata.summary.txt",sep="\t");
#write.table(economics,"testdata.all.txt",sep="\t");

arg1 = commandArgs(trailingOnly=T)[1]
df <- read.table(arg1,sep="\t",header=T)

par(mfrow=c(2,1))
pdf("ggplot_backnoise.pdf")

ggplot(df) + 
geom_bar(aes(x=turnNo, y=Average,group=Category,fill=Category,beside=TRUE),stat="identity",position='dodge') + 
#geom_line(aes(date, unemploy)) + 
scale_fill_manual(values = c("blue", "red","yellow","grey")) +
xlab("TurnNo") + 
ylab("Average") +
theme(legend.position="top")



