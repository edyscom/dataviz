
library(histogram)

mat <- read.table("../KnownGenes.bed",header=F,sep="\t")
head(mat)

category <- mat[,4]
category <- levels(category)

length_list <- mat[,3] - mat[,2]


pdf("histogram_mm10_smallRNA.pdf")

vector <- as.character(mat[,4])


par(mfrow=c(2,2))
for (cate in category){
do_list <- vector == cate

length_subset <- length_list[do_list]



hist(length_subset,type="regular",main=cate)

}


dev.off()

