
library("Biobase")


exprsFile <- "gene_exp_table.txt"
exprs_mat <- as.matrix(read.table (exprsFile, header=TRUE , sep="\t", row.names=1,as.is=TRUE))
eset<-ExpressionSet(assayData=exprs_mat)


eset

colnames(exprs_mat)


pDataFile <- "sample_color.txt"
pData <- read.table(pDataFile,row.names=1,header=TRUE,sep="\t")

geneColorFile <- "gene_color.txt"
geneColorData <- read.table(geneColorFile,row.names=1,header=TRUE,sep="\t")


label = as.character(pData$Color)
geneColor = as.character(geneColorData$Color)

geneColor


d1<-dist(exprs_mat,method="euclidian")
d2<-dist(t(exprs_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")


heatmap( as.matrix(exprs_mat) , Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1) ,ColSideColors=label,RowSideColors=geneColor)

#tiff(filename="heatmap_sidecol.tiff");
