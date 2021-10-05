library(gplots)


file1 <- "input1.txt"
file2 <- "input2.txt"
file3 <- "input3.txt"
file4 <- "input4.txt"
file5 <- "input5.txt"
file6 <- "input6.txt"
file7 <- "input7.txt"
file8 <- "input8.txt"
file9 <- "input9.txt"

files <- list(file1,file2,file3,file4,file5,file6,file7,file8,file9)
#files <- list(file1,file2,file3)

results = as.list(NULL)


for (file in files){
res <- read.table(file,header=T,sep="\t")
rownames(res) = paste(res$chr,res$start,res$stop,sep="|")

results <- append(results,list(res))

}
matrix <- data.frame()

for (res in results){
	for (col_rpkm in colnames(res)[grep(".rpkm$",colnames(res))]){
		col_name <- sub(".rpkm","",col_rpkm)
		col_name <- sub("Input","IN",col_name)
		for (row in rownames(res)){
			matrix[row,col_name] = res[row,col_rpkm]
		}
	}
}
matrix <- na.omit(matrix)

matrix

ordered_mat <- matrix[order(apply(matrix,1,var),decreasing=TRUE),]




ordered_mat<- ordered_mat[1:500,]

d1<-dist(ordered_mat,method="euclidian")
d2<-dist(t(ordered_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")

png("heatmap_MEDIP_sort500.png",600,600)
par(ps=10)
heatmap.2( as.matrix(ordered_mat) , Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1), trace="none", density.info='none' ,margins=c(12,8))
dev.off()


write.table(ordered_mat,file="merge_matrix_sort500.tab",sep="\t",col.names=NA)







ordered_mat<- ordered_mat[1:100,]
d1<-dist(ordered_mat,method="euclidian")
d2<-dist(t(ordered_mat),method="euclidian")
c1<-hclust(d1,method="average")
c2<-hclust(d2,method="average")

png("heatmap_MEDIP.png",600,600)
par(ps=10)
heatmap.2( as.matrix(ordered_mat) , Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1), trace="none", density.info='none' ,margins=c(12,8))
dev.off()

write.table(ordered_mat,file="merge_matrix_sort100.tab",sep="\t",col.names=NA)





