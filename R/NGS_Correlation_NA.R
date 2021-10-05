



maxTPGR <- read.table("DrKoyama_PQslope_val.txt" , header = T)
data    <- read.table("RNA-Seq_AllGenes_TMMextSampleForPQ.txt",header=T , row.names="Gene_ID")


rowname_list <- rownames(data)


x <- c( maxTPGR[,2] )




for (i in 1:nrow(data)){

y<- as.numeric(data[i,])

rowname <- rowname_list[i]


cor.pval <- cor.test(x,y,method="pearson")

cori.pval <- as.numeric( cor.pval$p.value)
cori.estim <- as.numeric( cor.pval$estimate)


cori.pval  <- ifelse(is.na(cori.pval), 1, cori.pval)
cori.estim <- ifelse(is.na(cori.estim), 0, cori.estim)



if( i == 1)
	cors.pvals <- as.numeric(cori.pval)
else
	cors.pvals <- rbind(cors.pvals , as.numeric(cori.pval))


if( i == 1)
	cors.estims <- cori.estim
else
	cors.estims <- rbind(cors.estims , cori.estim)


#cat("DEBUG" , rowname , cor.pval$estimate , " " , cor.pval$p.value , "\n" , file="result_corr.txt" , append=T)


}

pval.fdr <- p.adjust(cors.pvals[,1], method= "BH" )

cors.pvals[,1]

#for (i in 1:nrow(data)){
#	cat (i, ",",cors.pvals[i,1],pval.fdr[i] ,"\n" , file="test.out" , append=T);
#}

for (i in 1:nrow(data)){

rowname <- rowname_list[i]
cat(rowname ,"\t" ,  cors.estims[i,1] , "\t" , cors.pvals[i,1] , "\t" , pval.fdr[i] , "\n" , file="result_corr.out" , append=T)

}
