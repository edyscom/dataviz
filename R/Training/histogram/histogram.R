
library(histogram)

mat <- read.table("input.tab",header=T,sep="\t")
mat

col1 <- "colA"
col2 <- "colB"


val <- mat[,col1]

png("histogram.png")
histogram(val,type="regular")
dev.off()

