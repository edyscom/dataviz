library(plotly)


#p <- plot_ly(d, x = carat, y = price, text = paste("Clarity: ", clarity),
#			              mode = "markers", color = carat, size = carat)


file <- "Genes_TCC_normalized.txt"

matrix <- read.table(file,header=T,sep="\t",row.names=1)
matrix <- na.omit(matrix)
samplename <- colnames(matrix)
genename <- rownames(matrix)

normalized_col <- grep( "normalized" , colnames(matrix))
normalized_col
matrix <- matrix[,normalized_col]
rownames(matrix) <- genename
matrix<- t(matrix)
dim(matrix)

ColorFile <- "./groupInfo.color.txt"
ColorData <- read.table(ColorFile,row.names=1,header=TRUE,sep="\t")
label = as.character(ColorData$Color)
colorlabel = as.character(ColorData$Color)
group = as.character(ColorData$group)

name = rownames(ColorData)

order_check <- identical(name,rownames(ColorData))
order_check
if(!order_check) stop("order is different between data and color matrix")

#ordered_mat <- matrix[order(apply(matrix,1,var),decreasing=TRUE),]


pca <- prcomp(matrix)

summary(pca)
importance <- summary(pca)$importance
pc1<-round(100*importance[2,1],1)
pc2<-round(100*importance[2,2],1)
pc3<-round(100*importance[2,3],1)

#plot(pca$x[,1],pca$x[,2],xlab="PC1",ylab="PC2",col=label,pch=19,xlim=c(xmin,xmax))
#text(pca$x[,1],pca$x[,2],name,col=label,cex=0.4,adj=c(1,2))
#mtext(paste("PC1=",pc1,"% ","PC2=",pc2,"% ","PC3=",pc3,"% ",sep=""),cex=0.5,line=0.5,col=2,adj=0)
importanceinfo <- paste("PC1=",pc1,"% ","PC2=",pc2,"% ","PC3=",pc3,"% ",sep="")
layout <- list(
  scene = list(
    xaxis = list(
      title = "PC1", 
      showline = TRUE 
    ), 
    yaxis = list(
      title = "PC2", 
      showline = TRUE
    ), 
    zaxis = list(
      title = "PC3", 
      showline = TRUE
    )
  ), 
  title = paste("PCA plot (Contribution Ratio: ",importanceinfo,")",sep="")
)

getPalette = colorRampPalette(unique(colorlabel))
df <- data.frame(x=pca$x[,1],y=pca$x[,2],z=pca$x[,3])
p<-plot_ly(df, x=df$x,y=df$y,z=df$z,  text = name, type="scatter3d",mode = "markers", color = group, colors = getPalette(length(unique(colorlabel))))
		    #mode = "markers", color = label, size = carat)


#p <- plot_ly()
#p <- add_trace(p, mode="markers", name=name, type="scatter3d", x=pca$x[,1], y=pca$y[,1], z=pca$z[,1])
#p <- add_trace(p, mode=trace1$mode, name=trace1$name, type=trace1$type, x=trace1$x, y=trace1$y, z=trace1$z)
#p <- add_trace(p, mode=trace2$mode, name=trace2$name, type=trace2$type, x=trace2$x, y=trace2$y, z=trace2$z)
#p <- add_trace(p, mode=trace3$mode, name=trace3$name, type=trace3$type, x=trace3$x, y=trace3$y, z=trace3$z)
p <- layout(p, scene=layout$scene, title=layout$title)
p <- add_text(p,textposition='top left')
htmlwidgets::saveWidget(as_widget(p), "PCA_3D.html")



