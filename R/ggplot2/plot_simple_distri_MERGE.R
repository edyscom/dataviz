
library(ggplot2)




mat <- read.table("merge_frequency_data.txt",header=T);
#x <-  c(0:30)


head(mat)


#mat1[,1] <- log10(mat1[,1]);
#mat1[,2] <- log10(mat1[,2]);

#df1 <- data.frame(x=mat1[,1],y1=mat1[,2],y2=mat1[,3])
df <- data.frame(x=log10(mat$ReadsPerTag),y=log10(mat$Freq),type=mat$Type)

pdf("reads_per_tag_distri_MERGE.pdf")

color = c("red","blue","green","black")
#ggplot(df) + geom_line(aes(x=x,y=y1),color="red") + geom_line(aes(x=x,y=y2),color="blue") + geom_line(aes(x=x,y=y3),color="green") + geom_line(aes(x=x,y=y4),color="black") + xlim(0,3) 

ggplot(df) + geom_line(aes(x=x,y=y,group=type,colour=type)) + xlim(0,3) + theme_bw(base_size=16) + xlab("log10 Reads Per Tag") + ylab("log10 Frequency")




