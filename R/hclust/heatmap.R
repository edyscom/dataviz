

## RNAseqの正規化後の発現データを読み込んでいます。
file <- "demo_data.txt"


matrix <- read.table(file,header=T,sep="\t",row.names=1)

#matrix <- na.omit(matrix)
### Remove all zero case !!! 
sub <- apply(matrix,1,function(row) any(row != 0))
matrix <- matrix[sub,]




##画像ファイルが以下のファイル名でカレントディレクトリに作成されます。
png(file="heatmap.png",1000,1000)

### ps で文字の大きさを指定します
### mar は下、左、上、右の余白のサイズを指定しています。
par(ps=14,mar=c(16,2,2,5) )


## 距離計算の方法と、クラスタリング手法を指定しています。必要に応じて変更してください。
d1<-dist(t(matrix),method="euclidian")
hcl1 <- hclust(d1, method="ward.D")
d2<-dist(matrix,method="euclidian")
hcl2 <- hclust(d2, method="ward.D")


hcl1
dendro <- as.dendrogram(hcl1)
dendro
str(hcl1)
str(dendro)

library(gplots)
library(RColorBrewer)
breaks = c(seq(-4.0,-1.01,length=100),seq(-1,1,length=101),seq(1.01,4,length=100))

my_palette <- colorRampPalette(c("blue","white","red"))(n=300)
heatmap.2( as.matrix(matrix) ,breaks=breaks, col=my_palette ,  Colv=as.dendrogram(hcl1) , Rowv=as.dendrogram(hcl2), trace="none", density.info='none' ,margins=c(18,8))


dev.off()

