library(gplots)


file <- "./averaged_beta_values_only.txt"

matrix <- read.table(file,header=T,sep="\t",row.names=1)

matrix <- na.omit(matrix)

matrix<- t(matrix)


ColorFile <- "../data/Phenodata.color.txt"
ColorData <- read.table(ColorFile,row.names=1,header=TRUE,sep="\t")
label = as.character(ColorData$Color)

name = rownames(ColorData)



#ordered_mat <- matrix[order(apply(matrix,1,var),decreasing=TRUE),]

pca <- prcomp(matrix)

summary(pca)

png("Methylome_PCA_analysis.png",600,600)
par(ps=20 ,mar=c(5,5,2,2))

plot(pca$x[,1],pca$x[,2],xlab="PC1",ylab="PC2",col=label,pch=19)
text(pca$x[,1],pca$x[,2],name,col=label)

dev.off()

