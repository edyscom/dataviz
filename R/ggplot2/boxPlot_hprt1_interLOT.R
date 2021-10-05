
arg1 <- commandArgs(trailingOnly=T)[1]
arg2 <- commandArgs(trailingOnly=T)[2]

target_vari <- as.character(arg2)

df <- read.table(arg1,sep="\t",header=T)


df_sub_vec <- df$sample %in% grep(target_vari,df$sample,value=TRUE)

df_sub <- df[df_sub_vec,]

library(ggplot2)

gp <- ggplot(df_sub,aes(x=LOT,y=HKscore))
gp <- gp+	geom_boxplot(outlier.shape=NA)
gp <- gp+	geom_jitter(size=2.0)
gp <- gp+	ylab(paste(target_vari,"_HPRT1 M-Score pos/100K",sep=""))

ggsave(filename=paste(target_vari,"hprt1_boxplot.pdf",sep=""),plot = gp)


