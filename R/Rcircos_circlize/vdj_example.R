library(circlize)


args1 = commandArgs(trailingOnly=T)[1]



#df <- read.table("SS3VHFamily.txt", sep="\t", header=TRUE, stringsAsFactors=FALSE)
df <- read.table(args1, sep="\t", header=TRUE, stringsAsFactors=FALSE)
rownames(df) <- df[,1]
colnames(df) <- sub("IGH","",colnames(df))
rownames(df) <- sub("IGH","",rownames(df))
df <- df[,2:ncol(df)]
df <- t(df)

df <- data.frame(from=rep(rownames(df), times=ncol(df)), to=rep(colnames(df), each=nrow(df)), value=as.vector(df), stringsAsFactors=FALSE)

df

names <- c(sort(unique(df[,1])), sort(unique(df[,2])))
names <- sub("IGH","",names)


colours <- c(VH1="darkgoldenrod1", VH3="chartreuse4", VH4="royalblue", VH5="darkred", VH6="darkorchid1", JH1="black", JH2="black", JH3="black", JH4="black", JH5="black", JH6="black")

pdf(paste(args1,".vdjlink.pdf",sep=""), width=10, height=10)
gap.degree=c(rep(2, length(unique(df[[1]]))-1))
unique(df[[1]])
length(unique(df[[1]]))
gap.degree

##start.degree : t he starting degree from which the circle begins to draw. Note this degree is measured in the standard polar coordinate which means it is always reverse-clockwise.
## Gap between two neighbour sectors. It can be a single value or a vector. If it is a vector, the first value corresponds to the gap after the first sector.

circos.par(start.degree=90,gap.degree=1)
#circos.par(gap.degree=c(rep(2, length(unique(df[[1]]))-1), 10, rep(2, length(unique(df[[2]]))-1), 10))

chordDiagram(df, grid.col=colours, transparency=0.55, directional=-1, diffHeight=0.04)
circos.clear()
dev.off()

