


mat <- read.table("input.tab",header=T,sep="\t")
mat

col1 <- "colA"
col2 <- "colB"

sub <-  subset(mat,subset=(mat[col1] == mat[col2]))
sub
