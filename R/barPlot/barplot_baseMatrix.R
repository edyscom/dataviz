
basematrix <- read.table("count_matrix.txt",header=T,row.names = 1)

basematrix <- as.matrix(basematrix)

colname <- colnames(basematrix)

color <- c("red","blue","green","black")
png(paste("baseMatrix.png",sep=""), 600, 600)
barplot(t(basematrix),  main="barPlot for base matrix", beside=T, col=color)
legend("topright", colname,fill=color)
dev.off()

