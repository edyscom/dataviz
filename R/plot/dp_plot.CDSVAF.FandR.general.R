
library(ggplot2)
library(gridExtra)
library(cowplot)

### CDS table 1 (NGS)  table2 (NOIR)
arg1 <- commandArgs(trailingOnly=T)[1]
arg2 <- commandArgs(trailingOnly=T)[2]


### CDS  exon position  table
arg3 <- commandArgs(trailingOnly=T)[3]
exonmat <- read.table(arg3,sep="\t",header=T)

## Get X- min max range
xmin <- min(exonmat$start)
xmax <- max(exonmat$end)

### CDS COSMIC count   table
#arg4 <- commandArgs(trailingOnly=T)[4]
#cdscount <- read.table(arg4,sep="\t",header=T)

### CDS domain   table
#arg5 <- commandArgs(trailingOnly=T)[5]
#domain <- read.table(arg5,sep="\t",header=T)

arg6sample <- commandArgs(trailingOnly=T)[4]
outputbase <- commandArgs(trailingOnly=T)[4]


mat1 <- read.table(arg1,sep="\t",header=T)
mat1 <- mat1[mat1$Sample == arg6sample,]
mat2 <- read.table(arg2,sep="\t",header=T)
mat2 <- mat2[mat2$Sample == arg6sample,]

#pdf("cds_depthplot2.pdf",width=8,height=4)
#par(mfrow=c(2,1))
#pdf(paste("cds_vaf.ngs_noir.",outputbase,".pdf",sep=""))
#outpdf<-paste("cds_vaf.ngs_noir.",outputbase,".pdf",sep="")
outpng <-paste("cds_vaf.ngs_noir.",outputbase,".png",sep="")


#mat1$CDSMaxVafPerc <- ifelse(mat1$CDSMaxVafPerc < 0.01,0,log10(mat1$CDSMaxVafPerc)+2)
#mat2$CDSMaxVafPerc <- ifelse(mat2$CDSMaxVafPerc < 0.01,0,log10(mat2$CDSMaxVafPerc)+2)
mat1$CDSMaxVafPerc <- ifelse(mat1$CDSMaxVafPerc < 0.01,0,log10(mat1$CDSMaxVafPerc)+2)
mat2$CDSMaxVafPerc <- ifelse(mat2$CDSMaxVafPerc < 0.01,0,log10(mat2$CDSMaxVafPerc)+2)


gp1<- ggplot(mat1) + 
	geom_rect(
			  aes(xmin = start, xmax = end, fill = exon), 
			  ymin = -Inf, ymax = Inf, alpha = 0.2, 
			  data = exonmat
			  ) + 
geom_bar(aes(CDS_pos, CDSMaxVafPerc),stat="identity",col="#0000FF2F") + 
#geom_rug(aes(color=ifelse(CDS_pos<=100,'red','blue')),sides="b")+
xlab("") + 
ylab("%VAF NGS raw reads log10(%VAF) ")+
xlim(c(xmin,xmax)) + 
ylim(c(-2,2)) + 
scale_y_continuous(limits=c(0,4),breaks=seq(0,4,1), labels=seq(-2,2,1))+
#coord_cartesian(ylim=c(-2,2))+
theme(legend.position="top")


gp2<- ggplot(mat2) + 
	geom_rect(
			  aes(xmin = start, xmax = end, fill = exon), 
			  ymin = -Inf, ymax = Inf, alpha = 0.2, 
			  data = exonmat
			  ) + 
geom_bar(aes(CDS_pos, CDSMaxVafPerc),stat="identity",col="#FF00002F") + 
#geom_rug(aes(color=ifelse(CDS_pos<=100,'red','blue')),sides="b")+
xlab("CDS Position") + 
xlim(c(xmin,xmax)) + 
ylab("%VAF NOIR log10(%VAF)")+
#ylim(0,10)+
scale_y_continuous(limits=c(0,4),breaks=seq(0,4,1), labels=seq(-2,2,1))+
#ylim(c(-2,2)) + 
#coord_cartesian(ylim=c(-2,2))+
theme(legend.position="none")
#theme(legend.position="bottom")



#ggp1 <- ggplotGrob(gp1)
#ggpdom <- ggplotGrob(gpdom)
#ggp22 <- ggplotGrob(gp22)
#ggp2 <- ggplotGrob(gp2)


#gridExtra::grid.arrange(gp1,gp2)
#gridExtra::grid.arrange(gp1,gp2)
#g <- rbind(ggp1,ggp2, size="first")
#g$widths = grid::unit.pmax(ggp1$widths,ggp2$widths)
#plot(gp1)
#plot(gp2)


plot_grid( gp1,gp2, align = "v", ncol = 1, axis = "lr", rel_heights = c(40,40))
#plot <- plot_grid( gp1,gp2, align = "v", ncol = 1, axis = "lr", rel_heights = c(20,20))
#plot_grid(plot,  nrow = 1, rel_widths = c(15, 3.0))
#ggsave(file=outpdf,width=10,height=10,dpi=300)
ggsave(file=outpng,dpi=300,width=10,height=20,unit="cm")


#plot(g)

dev.off()




