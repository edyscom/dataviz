### このスクリプトは、heatmap 作ります  GeneList そのまま version

#options(repos="http://cran.ism.ac.jp/")
#install.packages("gplots")
library("gplots")

library(data.table)

filename <- "TvsN_5pairs_ver2_FDR1.txt"

matrix <- fread(filename,header=T,sep="\t")

#matrix <- read.table(filename,header=T,sep="\t",row.names=1,comment.char="#")

#matrix <- na.omit(matrix)
matrix <- as.data.frame(matrix)
rownames(matrix) <- matrix$'Gene ID'
colnames(matrix)

matrix <- subset(matrix,p < 0.05 )
matrix <- subset(matrix, matrix$'FC (abs)' >= 1.5)

rownames(matrix) 
class(matrix)
dim(matrix)
#write.table(matrix,"matrix_out.txt",quote=F,sep='\t')
#grep(".normalized.$",colnames(matrix))


exp_matrix <- matrix[,grep(".normalized.",colnames(matrix))]

colnames(exp_matrix) <- sub(".normalized.$","",colnames(exp_matrix))

rownames(exp_matrix) <- row.names(matrix)
rownames(exp_matrix) 



### baseline = mean of expression among all samples  (subtracting by mean)
exp_matrix <- sweep(exp_matrix,1,apply(exp_matrix,1,mean))

### 色の指定ファイルを読み込みます
ColorFile <- "./color_5pairs.txt"
ColorData <- read.table(ColorFile,header=TRUE,sep="\t")
label = as.character(ColorData$Color)


colnames(exp_matrix)
as.vector(ColorData$Sample)

stopifnot(identical(colnames(exp_matrix),as.vector(ColorData$Sample)))



### Order Gene list according to specified file
#ordered_mat <- matrix[matrix_order,]

### Not sorting version
ordered_mat <- exp_matrix

### fold change 
#ordered_mat <- matrix[order(apply(matrix,1,var),decreasing=TRUE),]

###サンプル、領域それぞれ、euclidian , ward 法によりクラスタリング
d1<-dist(ordered_mat,method="euclidian")
d2<-dist(t(ordered_mat),method="euclidian")
c1<-hclust(d1,method="ward.D")
c2<-hclust(d2,method="ward.D")




par(ps=10, mar=c(30,30,50,50))

### PNG 形式の場合は、600,600のカ所で解像度を設定します。
pdf("heatmap_DEG_FC1.5p0.05_5PAIRS_ward.pdf")
#png("heatmap_DEG_FC1.5p0.05v1_ward_order.png",1000,1000)
#pdf("heatmap_mi_deg_ward_order.pdf")
###文字の大きさの設定     #### Color map range is defined by breaks option
#heatmap.2( as.matrix(ordered_mat) , col=greenred(256), breaks=seq(-6,6,length.out=257),Colv=as.dendrogram(c2) , Rowv=FALSE,ColSideColors=label, trace="none", density.info='none' ,margins=c(16,16),cexCol=2,cexRow=0.2)
heatmap.2( as.matrix(ordered_mat) , col=greenred(256), breaks=seq(-4,4,length.out=257),Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1),ColSideColors=label, trace="none", density.info='none' ,margins=c(18,14),cexCol=1.5,cexRow=1.0)
dev.off()

