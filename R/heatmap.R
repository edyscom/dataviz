
library("Biobase")


exprsFile <- "exp_SSc60s_meanCentering_PH.tab"
exprs_mat <- as.matrix(read.table (exprsFile, header=TRUE , sep="\t", row.names=1,as.is=TRUE))
eset<-ExpressionSet(assayData=exprs_mat)


eset

colnames(exprs_mat)


pDataFile <- "./ExpDay.sort.txt"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")



batch = pData$ExpDay

label <- ifelse(pData$ExpDay == "red","red","blue")

batch

d1<-dist(exprs_mat,method="euclidian")
d2<-dist(t(exprs_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")


heatmap( as.matrix(exprs_mat) , Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1) ,ColSideColors=label)


