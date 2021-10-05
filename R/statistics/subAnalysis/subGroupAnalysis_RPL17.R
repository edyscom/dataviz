
library(forestplot)

### Program for 2 group t.test  Subgroup analysis 
# Input : 


mat <- read.table("data30s_exp_meta.180608.txt",sep="\t",header=T)


### Before Treatment vs Healthy Control
res <- t.test(mat$BT__RPL17,mat$HC__RPL17,paired=T)
total_n <- nrow(mat)
ratio <- total_n / total_n
ratio <- round(ratio,digits=2)
line <- c("Overall",total_n,ratio,res$p.value,as.numeric(res$estimate),res$conf.int[1],res$conf.int[2])
line

sub_group <- c('BTSampling','BloodVolume');

lines <- c("Group","N","Percent","","","","")
lines <- c(lines,line)


for (group in sub_group){
	for (lvs in levels(factor(mat[,group])) ){
		sub <- mat[ mat[,group] == lvs , ]
		res <- t.test(sub$BT__RPL17,sub$HC__RPL17,paired=T)
		ratio <- nrow(sub) / total_n
		ratio <- round(ratio,digits=2)
		n_sub <- nrow(sub) 
		line <- c(paste(group,lvs,sep="_"),n_sub,ratio,res$p.value,as.numeric(res$estimate),res$conf.int[1],res$conf.int[2])
		lines <- c(lines,line)
	}
}


results <- matrix(lines,ncol=7,byrow=T)
colnames(results) <- c("Group","N","percent","p-value","MeanDifference","lo","hi")
#results <- as.data.frame(results,stringsAsFactor=F)
#results$MeanDifference <- as.numeric(results$MeanDifference)

results

resTable <- structure( list(
							mean = as.numeric(results[,5]),
							lower = as.numeric(results[,6]),
							upper = as.numeric(results[,7])  ),
							.names = c("mean","lower","upper"),
							row.names= c(NA,-5L),
							class = "data.frame")

tableText <- cbind( as.vector(results[,1]),as.vector(results[,2]),as.vector(results[,3]) )

str(resTable)
check_array(resTable$mean)
tableText

pdf("forestPlot_RPL17.pdf")
forestplot(tableText,
		   #hrzl_lines = list("3" = gpar(lty=2), "11" = gpar(lwd=1,col="#444444")),
		   hrzl_lines = gpar(col="#444444"),
		   resTable,
		clip=c(-2.5,2.5),
		xlog=FALSE,
		new_page =FALSE,
		col=fpColors(box="royalblue",line="darkblue",summary="royalblue") )



