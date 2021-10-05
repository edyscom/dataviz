# このRスクリプトは、RNAseqの発現データを入力として、主成分分析(PCA)を行います。



### TMM正規化後のRNA-Seq 全遺伝子データを読み込んでいます
file <- "./RNAseq_TMM.txt"
matrix <- read.table(file,header=T,sep="\t",row.names=1)


###発現が全て0の遺伝子を除外しています。
### Omit all zero lines
matrix <- na.omit(matrix)
sub <- apply(matrix,1,function(row) any(row != 0))
matrix <- matrix[sub,]


matrix<- t(matrix)


### 色を指定しているファイルを読み込んでおります
ColorFile <- "./color.txt"
ColorData <- read.table(ColorFile,row.names=1,header=TRUE,sep="\t")
label = as.character(ColorData$Color)

name = rownames(ColorData)





### PCA解析の実行
pca <- prcomp(matrix,scale=TRUE)

###コンソールに累積寄与率が出力されます
summary <- summary(pca)
print(summary)

###以下の名前で画像PDFファイルが保存されます
pdf("RNA-Seq_PCA_analysis.pdf")

###文字の大きさは以下 psで指定します。
par(ps=16 ,mar=c(5,5,2,2))


### X軸、Y軸のラベルはxlab , ylabで指定します。
plot(pca$x[,1],pca$x[,2],xlab="PC1",ylab="PC2",col=label,pch=19)
### ラベルを出力させない場合は、以下のtextをコメントアウトします。
text(pca$x[,1],pca$x[,2],name,col=label)

dev.off()

