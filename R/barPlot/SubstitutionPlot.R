
library(ggplot2)
library(gridExtra)
library(cowplot)
library(scales)

### CDS table 1 (NGS)  table2 (NOIR)
arg1 <- commandArgs(trailingOnly=T)[1]
outpdf <- commandArgs(trailingOnly=T)[2]


outpdf <-paste(outpdf)
pdf(outpdf)

mat1 <- read.table(arg1,sep="\t",header=T)

gp1<- ggplot(mat1) + 
geom_bar(aes(Substitution,Count,fill=Sample ),stat="identity",position="dodge",col="#0000FF2F") + 
scale_y_continuous(labels = percent)+
#geom_rug(aes(color=ifelse(CDS_pos<=100,'red','blue')),sides="b")+
xlab("") + 
ylab("Frequency of Substitution ")+
#xlim(c(xmin,xmax)) + 
#ylim(c(-2,2)) + 
#scale_y_continuous(limits=c(0,4),breaks=seq(0,4,1), labels=seq(-2,2,1))+
#coord_cartesian(ylim=c(-2,2))+
theme(legend.position="top")


plot(gp1)

dev.off()




