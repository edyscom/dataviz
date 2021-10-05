

## RNAseqの正規化後の発現データを読み込んでいます。
file <- "exp_SSc81s_meanCentering.tab"

matrix <- read.table(file,header=T,sep="\t",row.names=1)

matrix <- na.omit(matrix)



ColorFile <- "../data/sample_info_81s_col.txt"
ColorData <- read.table(ColorFile,row.names=1,header=TRUE,sep="\t")
label = as.character(ColorData$ExpDay)



#options(repos="http://cran.ism.ac.jp/")
#install.packages("dendextend")



order_check <- identical(colnames(matrix),rownames(ColorData))
order_check
if(!order_check) stop("order is different between data and color matrix")


library(dendextend)

##画像ファイルが以下のファイル名でカレントディレクトリに作成されます。
png(file="dendrogram_mRNAseq.png",800,400)

### ps で文字の大きさを指定します
### mar は下、左、上、右の余白のサイズを指定しています。
par(ps=10,mar=c(5,2,2,5) )


## 距離計算の方法と、クラスタリング手法を指定しています。必要に応じて変更してください。
d1<-dist(t(matrix),method="euclidian")
hcl <- hclust(d1, method="ward.D")
dend <- as.dendrogram(hcl)


labels_colors(dend) <- label[order.dendrogram(dend)]


plot(dend, horiz=FALSE, col=label)

dev.off()

