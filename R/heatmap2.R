
library("gplots")


exprsFile <- "Correlation_ALLsamples.txt"
exprs_mat <- read.table (exprsFile, header=TRUE , sep="\t", row.names=1,as.is=TRUE)

exprs_t <- t(exprs_mat)
exprs_mat[lower.tri(exprs_mat)] <- exprs_t[lower.tri(exprs_t)]




d1<-dist(exprs_mat,method="euclidian")
d2<-dist(t(exprs_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")


#heatmap( as.matrix(exprs_mat) , Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1) )
#heatmap( as.matrix(exprs_mat) )



png("heatmap_correlation.png",600,600)
par(ps=10)
heatmap.2( as.matrix(exprs_mat) , col=greenred(75),Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1), trace="none", density.info='none' ,margins=c(12,12), key.xlab="correlation")
dev.off()



