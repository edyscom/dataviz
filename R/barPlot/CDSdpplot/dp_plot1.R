

arg1 <- commandArgs(trailingOnly=T)[1]
arg2 <- commandArgs(trailingOnly=T)[2]


### CDS  exon position  table
arg3 <- commandArgs(trailingOnly=T)[3]
exonmat <- read.table(arg3,sep="\t",header=T)


mat <- read.table(arg1,sep="\t",header=T)

mat <- mat[mat$Sample == arg2,]


#mat <- mat[,c(2,6,7)]
#mat <- t(mat)
#mat <- t(mat)

pdf("cds_depthplot1.pdf",width=8,height=4)
x <- as.numeric(mat$CDS_pos)
y1 <- as.numeric(mat$dpF)
y2 <- as.numeric(mat$dpR)
#plot(x,y1,type="o",col="blue")
barplot(y1,names=x,col="#0000FF2F",border=F)
barplot(y2,names=x,col="#FF00002F",border=F,add=T)
#barplot(mat,beside=T,border=F)
#plot(x,y1,col="#0000FF7F",beside=T,border=F)
#plot(x,y2,col="#FF00007F",beside=T,border=F,add=T)
#barplot(df2,col="red")

library(ggplot2)
pdf("cds_depthplot2.pdf",width=8,height=4)

ggplot(mat) + 
	geom_rect(
			  aes(xmin = start, xmax = end, fill = exon), 
			  ymin = -Inf, ymax = Inf, alpha = 0.2, 
			  data = exonmat
			  ) + 
geom_bar(aes(CDS_pos, dpF),stat="identity",col="#0000FF2F") + 
geom_bar(aes(CDS_pos, dpR),stat="identity",col="#FF00002F") + 
xlab("CDS position") + 
ylab("Read Depth") +
theme(legend.position="top")



dev.off()




dev.off()

