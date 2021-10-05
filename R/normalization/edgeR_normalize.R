

library(edgeR)
library(GO.db)

### EdgeR statistical test for  Two groups unpaired RNA-Seq data

### Threshold for Differential Expression
FDR_cutoff <- 0.05
logFC_cutoff <- 1

### Input file  (raw count, and sample.info)
count <- read.table("Genes_raw_values.txt", header=T , sep="\t",row.names=1);
info  <- read.table("sample.info", header=T , sep="\t",row.names=1);



#Omit all zero lines from Expression raw count table
sub <- apply(count,1,function(row) any(row != 0))
count <- count[sub,]



### convert to MATRIX
count <- as.matrix(count)
dim(count)

### Specify Group
group <- factor(info$Group)


### Differentially expressed genes
d <- DGEList(counts = count , group = group)


d <- calcNormFactors(d,norm.method="TMM")


#d <- estimateCommonDisp(d)


#d <- estimateTagwiseDisp(d)
#d
#cpm(d)

norm.factors <- d$samples$norm.factors/mean(d$samples$norm.factors)
ef.libsizes <- colSums(count)*norm.factors
norm.count <- sweep(count,2,mean(ef.libsizes)/ef.libsizes,"*")
norm.count <- log(norm.count,2)

gene_names <- rownames(count)
new_colname <- c("Gene",colnames(count))
norm.count <- cbind(gene_names,norm.count)
colnames(norm.count) <- new_colname
write.table(norm.count, file="Genes_edgeR_normalized.txt",col.names=T , row.names=F , sep="\t",quote=F)


norm <- as.data.frame(cpm(d,log=FALSE))
write.table(norm, file="Genes_edgeR_normalized_CPM.txt",col.names=T , row.names=T , sep="\t")



