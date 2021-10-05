library(ggplot2)
library(data.table)

library(dplyr)

arg1 <- commandArgs(trailingOnly=T)[1]
PRINTNAME <- commandArgs(trailingOnly=T)[2]

mat <- fread(arg1,sep='\t')
#mat <- subset(matorg,REForVAR=="ref")


arg3 <- commandArgs(trailingOnly=T)[3]
df_cutoff <- read.table(arg3,header=T,sep=",",comment.char="#",row.names=1)

CUTOFF_GLOBAL   <- subset(df_cutoff,rownames(df_cutoff) == "res2")$EstimatedValue
CUTOFF_GLOBAL <- log2(CUTOFF_GLOBAL)


mat$Index <- as.factor(mat$Index)

mat <- subset(mat,Spike_VAF_percent==1)  ### check only positive distribution
write.table(mat,paste("TMScore_Values_",PRINTNAME,".csv",sep=""),sep=",",quote=F,col.names=NA);

#mat2 <- mat %>% group_by(Sample,Region) %>% summarize(n=n(),mean = mean(Length),sd=sd(Length))
pdf(paste("violinplot_cocktails.",PRINTNAME,".pdf",sep=""))
#g1 <- ggplot(mat2,aes(x=Sample,y=Length,fill=Region))
g1 <- ggplot(mat,aes(x=Index,y=log2TM))
#g1 <- g1 + geom_violin()
g1 <- g1 + geom_boxplot(width=.3)
g1 <- g1 + geom_point()
#g1 <- g1 + facet_wrap(~Spike_VAF_percent,ncol=2)
g1 <- g1 + theme(axis.text.x = element_text(angle = 90))
plot(g1)


mat3 <- mat %>% group_by(Index,Spike_VAF_percent) %>% summarize(n=n(),mean = mean(log2TM),sd=sd(log2TM))
mat3$CI95_LOW  <- mat3$mean - 2* mat3$sd
mat3$JUDGEMENT <- ifelse(mat3$CI95_LOW >= CUTOFF_GLOBAL,"SUCCESS","FAIL") 
#mat3


### remove Index 3 for ROS1 case
#mat <- subset(mat,Index!=3)  ### remove Index 3)


library(ggpubr)
pdf(paste("ggboxplot_anova.",PRINTNAME,".remove_i3.pdf",sep=""))
g2 <- ggboxplot(mat, x = "Index", y = "log2TM",color="Index",palette = "jco")+
ylab(paste("log2 TM-Score (1%-spike)",PRINTNAME))+
stat_compare_means(method = "anova")
plot(g2)

s<-summary(aov(log2TM ~ Index, data = mat))
anova_p <- unlist(s)['Pr(>F)1']
anova_p$Gene <- PRINTNAME
anova_p <- data.frame(anova_p)
colnames(anova_p) <- c("ANOVA_P_Value","Gene")
write.table(anova_p,paste("ANOVA_P_",PRINTNAME,".csv",sep=""),sep=",",quote=F,col.names=NA);


tablename <- paste("Estimated_Distri_9rep_",PRINTNAME,".csv",sep="");

write.table(mat3,tablename,sep=",",quote=F,col.names=NA)





