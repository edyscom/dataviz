### このスクリプトは、heatmap

#options(repos="http://cran.ism.ac.jp/")
#install.packages("gplots")
library("gplots")

file_all <- file("mRNA_all_list.txt")

file <- file("mRNA_deg_list.txt")

matrix <- read.table(file,header=T,sep="\t",row.names=1)
matrix_all <- read.table(file_all,header=T,sep="\t",row.names=1)

matrix <- na.omit(matrix)
matrix_all <- na.omit(matrix_all)


### baseline = mean of expression among all samples  (subtracting by mean)
matrix <- sweep(matrix,1,apply(matrix,1,mean))


### 色の指定ファイルを読み込みます
ColorFile <- "./mRNA_color.txt"
ColorData <- read.table(ColorFile,row.names=1,header=TRUE,sep="\t")
label = as.character(ColorData$Color)


ordered_mat <- matrix
### fold change 
#ordered_mat <- matrix[order(apply(matrix,1,var),decreasing=TRUE),]

###サンプル、領域それぞれ、euclidian , ward 法によりクラスタリング
d1<-dist(ordered_mat,method="euclidian")
d2<-dist(t(matrix_all),method="euclidian")
c1<-hclust(d1,method="ward.D")
c2<-hclust(d2,method="ward.D")

par(ps=24, mar=c(6,20,40,40))
### PNG 形式の場合は、600,600のカ所で解像度を設定します。
png("heatmap_mRNA_deg_ward.png",800,800)
###文字の大きさの設定     #### Color map range is defined by breaks option
heatmap.2( as.matrix(ordered_mat) , col=greenred(256), breaks=seq(-6,6,length.out=257),Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1),ColSideColors=label, trace="none", density.info='none' ,margins=c(16,16),cexCol=2.0)
dev.off()

