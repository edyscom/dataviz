
library(histogram)

mat <- read.table("GeneList_miRNAprom_closest.log.txt",header=T,sep="\t" , stringsAsFactor=F)
#mat

col1 <- "Distance.bp."
col2 <- "colB"

val <- unlist(mat[,col1])

head(val)

val2 <- val[ val != "-" ]
val2 <- as.numeric(val2)
val3 <- val2[ val2 < 20000 ]


head(val3)

png("histogram.png") 
#histogram(val2,type="regular")
hist(val3,breaks=20)
dev.off()

