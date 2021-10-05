library(ggplot2)
library(data.table)

library(dplyr)

arg1 <- commandArgs(trailingOnly=T)[1]

matorg <- fread(arg1,sep='\t')
dim(matorg)
mat <- subset(matorg,REForVAR=="ref")
dim(mat)
mat$Length <- as.numeric(mat$Length)

mat2 <- mat %>% group_by(Sample,Region) %>% summarize(n=n(),mean = mean(Length),sd=sd(Length))
mat2
pdf("violinplot_fragsize.pdf")
#g1 <- ggplot(mat2,aes(x=Sample,y=Length,fill=Region))
g1 <- ggplot(mat,aes(x=Sample,y=Length,fill=Region))
g1 <- g1 + geom_violin()
g1 <- g1 + geom_boxplot(width=.1)
g1 <- g1 + facet_wrap(~Region,ncol=4)
g1 <- g1 + theme(axis.text.x = element_text(angle = 90))
plot(g1)


mat3 <- mat2 %>% group_by(Region) %>% summarize(n=n(),mean_mean = mean(mean),sd=sd(mean))
mat3$CUTOFF <- mat3$mean_mean - 3* mat3$sd
mat3

write.table(mat3,"Estimated_AnomaryDetection_Fragsize.csv",sep=",",quote=F,col.names=NA)





