##################################################
#
# A script for MEDIPS
# Time-stamp: <16/03/24 12:23:18 sngjoken>
#
##################################################

# First, the MEDIPS package has to be loaded.
library(MEDIPS)
library(histogram)
library(data.table)

# This is example data for the MEDIPS workflow.
# library("MEDIPSData")

# The reference genome and load it.
library(BSgenome.Hsapiens.UCSC.hg19)
BSgenome = "BSgenome.Hsapiens.UCSC.hg19"
# library(BSgenome.Rnorvegicus.UCSC.rn5)
# BSgenome = "BSgenome.Rnorvegicus.UCSC.rn5"

# The smaller the p-value, the more reads at the same genomic position are potentially allowed.
# Alternatively, all reads mapping to exactly the same genomic position can be
# maintained (uniq = 0) or replaced by only one representative (uniq = 1).
uniq = 1

# All reads will be extended to a length of 300nt according to the given strand information:
extend = 300

# As an alternative to the extend parameter, the shift parameter can be used.
# Here, the reads are not extended but shifted by the speciﬁed number of nucleotides
# with respect to the given strand infomation.
# One of the two parameters extend or shift has to be 0.
shift = 0

# The genome will be divided into adjacent windows of length 100nt
# and all further calculations (short read coverage,
# diﬀerential coverage between conditions etc.) will be applied to these windows.
ws = 100

#here we use annotation tables as obtained from UCSC and other sources.
#for gtf files, only the first(chr), third(start) and 4th(end) column is of interest.
#for an example of biomart database excess, please see the vignette.
#read annotation tables
cc=c("character",  "numeric", "numeric", "character","NULL","NULL")
cc_cgi=c("NULL","character", "numeric", "numeric", "character", "NULL", "NULL", "NULL","NULL","NULL","NULL")
m_cgi=read.table("anno_dir/hg19_CpG_Islands.txt", header=T,sep="\t",colClasses=cc_cgi)
m_exon=read.table("anno_dir/hg19_ucsc_exons.bed", sep="\t", colClasses=cc)
m_exon$nr=1:dim(m_exon)[1]
m_intron=read.table("anno_dir/hg19_ucsc_introns.bed", sep="\t", colClasses=cc)
m_prom=read.table("anno_dir/hg19_ucsc_promoter1000bp.bed", sep="\t", colClasses=cc)
m_prom$nr=1:dim(m_prom)[1]
#reg=c("all regions", "Introns", "Exons","Promoter" , "CpG Islands" , "CpG Island\nPromoter")
reg=c("CpG Island\nPromoter")



chrom_select = c('chrX')



#File <- "All_samples_MQ20_edgeR_BH_minSum100_CF1.txt"
File <- "test.txt"

result <- fread(File,header=TRUE,sep="\t")

result <- as.data.frame(result)

minRowSum <- 100
result <- subset(result,CF > 0)
result <- subset(result,chr == 'chrX')
result <- subset(result,M1.counts + M2.counts + M4.counts + M5.counts + M6.counts >= minRowSum)

head(result)

results_CGI=MEDIPS.selectROIs(results=result, rois=m_cgi)
#results_exon=MEDIPS.selectROIs(results=mr.edgeR, rois=m_exon)
#results_intron=MEDIPS.selectROIs(results=mr.edgeR, rois=m_intron)
#results_prom=MEDIPS.selectROIs(results=mr.edgeR, rois=m_prom)
results_CGI_prom=MEDIPS.selectROIs(results=results_CGI, rois=m_prom)


dim(results_CGI)
dim(results_CGI_prom)



#results_CGI_s=MEDIPS.selectROIs(results=mr.edgeR.s, rois=m_cgi)
#results_exon_s=MEDIPS.selectROIs(results=mr.edgeR.s, rois=m_exon)
#results_intron_s=MEDIPS.selectROIs(results=mr.edgeR.s, rois=m_intron)
#results_prom_s=MEDIPS.selectROIs(results=mr.edgeR.s, rois=m_prom)
#results_CGI_prom_s=MEDIPS.selectROIs(results=results_CGI_s, rois=m_prom)
#DMR_rel=matrix(NA, 6,2, dimnames=list(reg, c("hypomethylated", "hypermethylated")))


colnames = colnames(result)
rms_scores_col <- grep( ".rms$" , colnames)
rms_scores_name <- colnames[ rms_scores_col ] 

rms_scores_CGIprom <- results_CGI_prom[ , rms_scores_col]

rms_scores_CGIprom <- as.matrix(rms_scores_CGIprom)
head(rms_scores_CGIprom)


library(gplots)


exp_mat <- rms_scores_CGIprom

pdf("PromCGI_dmr_chrX_heatmap_hm2.pdf")
#heatmap(rms_scores_CGIprom)

d1<-dist(exp_mat,method="euclidian")
d2<-dist(t(exp_mat),method="euclidian")
c1<-hclust(d1,method="ward.D")
c2<-hclust(d2,method="ward.D")

par(ps=10)

library(RColorBrewer)


breaks = c(seq(0,0.3,length=30),seq(0.31,0.5,length=20),seq(0.51,0.8,length=30))
#breaks = c(0,0.3,0.6,0.8)
my_palette <- colorRampPalette(c("blue","yellow","red"))(n=79)

heatmap.2( as.matrix(exp_mat) , col=my_palette , breaks=breaks, Colv=as.dendrogram(c2) , Rowv=as.dendrogram(c1), trace="none", density.info='none' ,margins=c(12,8))
dev.off()










