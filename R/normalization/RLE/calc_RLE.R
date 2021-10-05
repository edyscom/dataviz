#### Estimation of RLE normalization factor from read count matrix!!



library(psych)
library(edgeR)


### EdgeR statistical test for  Two groups unpaired RNA-Seq data

### Threshold for Differential Expression
FDR_cutoff <- 0.05
logFC_cutoff <- 1

### Input file  (raw count, and sample.info)
count <- read.table("tmp_values.txt", header=T , sep="\t",row.names=1);
info  <- read.table("tmp.info", header=T , sep="\t",row.names=1);



#Omit all zero lines from Expression raw count table
#sub <- apply(count,1,function(row) any(row != 0))
#count <- count[sub,]



### convert to MATRIX
count <- as.matrix(count)
dim(count)

### Specify Group
group <- factor(info$Group)




gm_mean <- geometric.mean(t(count))
gm_mean

## Different estimation without library
gm <- exp(rowMeans(log(count)))
gm


### Step wise calculation of median of relative ratio
vals <- sweep(count,1,gm_mean,FUN="/")
sf <- apply(vals,2,median)
sf

### median calculation code from  edgeR
RLE <- apply(count, 2, function(u) median((u/gm)[gm > 0]))
RLE

lib.size <- colSums(count)
RLE <- RLE / lib.size
RLE <- RLE/exp(mean(log(RLE)))
RLE


### Differentially expressed genes  
d <- DGEList(counts = count , group = group)

d <- calcNormFactors(d,method="RLE")

d

#d <- estimateCommonDisp(d)


#d <- estimateTagwiseDisp(d)
#d
#cpm(d)

