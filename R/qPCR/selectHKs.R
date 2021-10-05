
### This script is for selecting optimal reference House Keeping Genes from NGS expression data
### Estimation of Stability Measure
### made by ysato 2017.1.25


library('NormqPCR')

exp_tab <- read.table("gexp_mRNA_hkg.txt",sep="\t",header=T,row.names=1)
head(exp_tab)
symbols <- as.character(rownames(exp_tab))
exp_tab <- as.matrix(exp_tab)

exp_tab <- t(exp_tab)

stab <- stabMeasureM(exp_tab, log=TRUE)

res.HK <- selectHKs(exp_tab,method="geNorm", Symbols=symbols, minNrHK=1,log=TRUE)


res.HK


stab

