library(gplots)

file <- "example_data.txt"
res <- read.table(file,header=T,sep="\t",row.names=1)


ordered_mat <- res



d1<-dist(ordered_mat,method="euclidian")
d2<-dist(t(ordered_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")

png("heatmap.png",600,600)
par(ps=10)
heatmap.2( as.matrix(ordered_mat) , col=greenred(100),Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1), trace="none", density.info='none' ,margins=c(12,8))
#heatmap.2( as.matrix(ordered_mat) , col=greenred(100),Colv=colnames(res) , Rowv=rownames(res), trace="none", density.info='none' ,margins=c(12,8))
dev.off()


