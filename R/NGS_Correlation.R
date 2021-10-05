



mPAP <- read.table("DrKoyama_Ssc_mPAP_values.txt" , header = T)
data    <- read.table("RNA-Seq_AllGenes_TMMextSample.txt",header=T , row.names="Gene_ID")


rowname_list <- rownames(data)


x <- c( mPAP[,2] )

for (i in 1:nrow(data)){

y<- as.numeric(data[i,])

rowname <- rowname_list[i]


cor.pval <- cor.test(x,y,method="pearson")

cori.pval <- as.numeric( cor.pval$p.value)
cori.estim <- as.numeric( cor.pval$estimate)

if( i == 1)
	cors.pvals <- cori.pval 
else
	cors.pvals <- rbind(cors.pvals , cori.pval)


if( i == 1)
	cors.estims <- cori.estim
else
	cors.estims <- rbind(cors.estims , cori.estim)


#cat("DEBUG" , rowname , cor.pval$estimate , " " , cor.pval$p.value , "\n" , file="result_corr.txt" , append=T)


}

pval.fdr <- p.adjust(cors.pvals[,1], method= "BH" )

for (i in 1:nrow(data)){

rowname <- rowname_list[i]
cat(rowname ,"\t" ,  cors.estims[i,1] , "\t" , cors.pvals[i,1] , "\t" , pval.fdr[i] , "\n" , file="result_corr.txt" , append=T)

}
