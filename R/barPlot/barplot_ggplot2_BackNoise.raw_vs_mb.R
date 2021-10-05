
library(ggplot2)
library(data.table)
#presidential <- subset(presidential, start > economics$date[1])
#write.table(presidential,"testdata.summary.txt",sep="\t");
#write.table(economics,"testdata.all.txt",sep="\t");

arg1 = commandArgs(trailingOnly=T)[1]
df <- fread(arg1,sep="\t",header=T)

arg2 = commandArgs(trailingOnly=T)[2]
df2 <- fread(arg2,sep="\t",header=T)

outpdf = commandArgs(trailingOnly=T)[3]
tocheck = commandArgs(trailingOnly=T)[4]

par(mfrow=c(2,1))
pdf(outpdf)

nelements <- nrow(df)
labelcolor <- rep("black",nelements)
labelcolor[tocheck] <- "red"

df$Category <- "NGS"
df2$Category <- "MB"
dfmerge <- rbind(df,df2)

dfmerge$gpos <- paste(dfmerge$chrom,dfmerge$pos,dfmerge$ref,dfmerge$alt)

ggplot(dfmerge) + 
geom_bar(aes(x=gpos, y=PMscore,group=Category,fill=Category),stat="identity",position='dodge') + 
#geom_line(aes(date, unemploy)) + 
scale_fill_manual(values = c("blue", "red")) +
xlab("Genome Position") + 
ylab("Mutation /100K molecules") +
theme(legend.position="top")+
theme(axis.text.x = element_text(angle = 90, hjust = 1))+
theme(axis.ticks=element_line(colour = "black"),
	             axis.text=element_text(colour = labelcolor))

