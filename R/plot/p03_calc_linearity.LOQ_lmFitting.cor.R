
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggbeeswarm)

library(tidyr)
library(purrr)

## for paired-correlation plot
library("tidyverse")  #ggplot2収録
library("GGally")  #ggpairsはここに収録
library("ggthemes")


arg1 = commandArgs(trailingOnly=T)[1] ### %VAF summary result
arg2 = commandArgs(trailingOnly=T)[2] ### CUTOFF file
arg3 = commandArgs(trailingOnly=T)[3] ### Mutation - Template correspondence table file
specified_max = commandArgs(trailingOnly=T)[4] ### specified max INPUT %VAF
specified_max = as.numeric(specified_max)


df <- read.table(arg1,header=T,sep="\t",comment.char="#")
df_cutoff <- read.table(arg2,header=T,sep="\t",comment.char="#")
df_corres <- read.table(arg3,header=T,sep="\t",comment.char="#")

df_corres <- subset(df_corres,Template !="-") 
#df_corres
#df_neg <- subset(df,input_VAF==0)

### merge cutoff & template INFO.
df_cutoff <- merge(df_cutoff, df_corres, by="mutation", all=T)
#df_cutoff


df_long = melt(df,
			   id.vars=c("SampleID","template", "input_VAF", "replicates_no","Index","input_ng","LotType"),
			   variable.name="Mutation", value.name="estimated_VAF",na.rm=TRUE)
#head(df_long)
df_long <- merge(df_long, df_cutoff, by.x="Mutation",by.y="mutation", all=T)
df_long$CALL <- ifelse(df_long$estimated_VAF >= df_long$CUTOFF_VAF_percent,"Positive","Negative")

df_long <- subset(df_long,!is.na(Template))  ### added 2021.10.01
df_long$template <- as.character(df_long$template) ## added
df_long$Template <- as.character(df_long$Template) ## added
write.table(df_long,"merged_results.annot.txt",sep="\t",quote=F,col.names=NA)



library(ggpubr)


pdf("scatter_plot_inputVAF_vs_estimatedVAF.EGFR3mix.pdf")
#df_EGFR3mix <- subset(df_long,template==Template & template == "EGFR 3sites mix")
#df_EGFR3mix <- subset(df_long,(template==Template & template == "EGFR3mix") | template == "wildtype")
df_EGFR3mix <- df_long ### revised
df_EGFR3mix <- subset(df_EGFR3mix,Mutation=="EGFR_L858R" | Mutation=="EGFR_T790M" | Mutation=="EGFR_e19del")

write.table(df_EGFR3mix,"inputVAF_vs_estimatedVAF_EGFR3mix.txt",sep="\t",quote=F,col.names=NA)
EGFR3mix_cv <- df_EGFR3mix %>% group_by(Mutation,input_VAF) %>% summarize(CoefficientOfVariance=sd(estimated_VAF)/mean(estimated_VAF),mean_estimated_VAF=mean(estimated_VAF),sd_estimated_VAF=sd(estimated_VAF))
write.table(EGFR3mix_cv,"EGFR3mix_CoefficientOfVariance.csv",sep=",",quote=F,col.names=NA)

### ggpair 
EGFR3mix_VAF <-  select(.data = df_EGFR3mix,Mutation,replicates_no,Index,input_VAF,estimated_VAF,LotType)
EGFR3mix_VAF
write.table(EGFR3mix_VAF,"EGFR3mix_VAF.txt",sep="\t",quote=F,col.names=NA)
### INPUT VAF 相対定量相関性
input_cor2 <- EGFR3mix_VAF %>% group_by(Mutation,Index) %>% summarize(PearsonR=cor(input_VAF,estimated_VAF))
input_cor2
#input_cor <- rbind(input_cor1,input_cor2)
input_cor <- input_cor2 ### revised
write.table(input_cor,"InputVAF_vs_EstimatedVAF_PearsonCor.csv",sep=",",quote=F,col.names=NA)
input_cor_gmean <- input_cor %>% group_by(Mutation) %>% summarize(geomeanR=exp(mean(log(PearsonR))))
write.table(input_cor_gmean,"InputVAF_vs_EstimatedVAF_PearsonCor.GEOMEAN.csv",sep=",",quote=F,col.names=NA)

REPRO_R_VALS =c()
for (lot in c("A","B")){
	for (mut in c("EGFR_L858R","EGFR_T790M","EGFR_e19del")){
		outpdf <- paste("ggpair_",mut,"_",lot,".pdf",sep="")
		vaf_table <- paste("vaftable_index_",mut,"_",lot,".csv",sep="")
		mut_VAF <- subset(EGFR3mix_VAF,Mutation==mut & LotType==lot)
		#mut_VAF <- subset(EGFR3mix_VAF,Mutation==mut)
		#write.table(mut_VAF,vaf_table,sep=",",quote=F,col.names=NA)
		mut_VAF <- select(.data=mut_VAF,Mutation,Index,input_VAF,estimated_VAF)
		#write.table(mut_VAF,vaf_table,sep=",",quote=F,col.names=NA)
		mut_VAF <- mut_VAF %>% tidyr::spread(key = Index, value = estimated_VAF)
		write.table(mut_VAF,vaf_table,sep=",",quote=F,col.names=NA)
		mut_VAF <- select(.data=mut_VAF,3:10)
	
		### smooth_loess = 回帰　平滑化	
		### smooth = 回帰　
		#p0 <- mut_VAF %>% ggpairs(lower=list(continuous="smooth_loess", combo="facethist"))
		p0 <- mut_VAF %>% ggpairs(lower=list(continuous="smooth", combo="facethist"),upper=list(continuous="cor",combo="box"))
		ggsave(plot=p0,file=outpdf,width=20)

		R_table <- paste("reproducibility_PearsonR_",mut,"_",lot,".csv",sep="")
		pearson <- cor(mut_VAF)
		write.table(pearson,R_table,sep=",",quote=F,col.names=NA)
		REPRO_R_VALS <- c(REPRO_R_VALS,mut,exp(mean(log(pearson[lower.tri(pearson)]))))
	}
}

REPRO_R_MAT <- matrix(REPRO_R_VALS,ncol=2,byrow=T)
REPRO_JUDGE <- ifelse(min(REPRO_R_MAT[,2]) >= 0.95,"SUCCESS","FAIL")
REPRO_R_VALS <- c(REPRO_R_VALS,"REPRODUCIBILITY_JUDGE",REPRO_JUDGE)
REPRO_R_MAT <- matrix(REPRO_R_VALS,ncol=2,byrow=T)
colnames(REPRO_R_MAT) <- c("Mutation","Geometric_Mean_Pearson_R")
write.table(REPRO_R_MAT,"Reproducibiilty_Pearson_GEOMEAN.csv",sep=",",quote=F,col.names=NA)

my.formula <- y ~ x
g1 <- ggplot(df_EGFR3mix,aes(x=input_VAF,y=estimated_VAF))
#g1 <- g1 + geom_point()
g1 <- g1 + 
	#stat_smooth_func(geom="text",method="lm",hjust=0,parse=TRUE) +
	geom_smooth(method = "lm", se=FALSE, color="black", formula = my.formula) +
	stat_regline_equation(label.y = specified_max -1, aes(label = ..eq.label..)) +
	stat_regline_equation(label.y = specified_max -2, aes(label = ..rr.label..))+
	ylim(c(-2,specified_max))+
	xlim(c(0,specified_max))+
	geom_point() + facet_wrap(~Mutation,ncol=1)
g1 <- g1 + theme(panel.spacing = grid::unit(1, "lines"))
plot(g1)

q()

pdf("plot_estimatedVAF_vs_CV.EGFR3mix.pdf",width=10)

#EGFR3mix_cv <- df_EGFR3mix %>% group_by(Mutation,input_VAF) %>% summarize(CoefficientOfVariance=sd(estimated_VAF)/mean(estimated_VAF),mean_estimated_VAF=mean(estimated_VAF),sd_estimated_VAF=sd(estimated_VAF),Mutation=Mutation)

#cv_matrix_all <- rbind(EGFR3mix_cv,BRAFKRAS_cv)
cv_matrix_all <- EGFR3mix_cv

#cv_matrix <- cv_matrix_all
#cv_matrix <- subset(cv_matrix_all,CoefficientOfVariance < 0.5 & input_VAF > 0 )  ### NOTE : estimate LOQ by only CV< 0.5 data
cv_matrix <- subset(cv_matrix_all,input_VAF > 0 )  ### NOTE : estimate LOQ by only CV< 0.5 data
#cv_matrix <- subset(cv_matrix,!(Mutation == "EGFR_L858R" & mean_estimated_VAF < -1) )  ### NOTE : Remove L858R outlier
#cv_matrix <- subset(cv_matrix_all,input_VAF > 0)  ### NOTE : estimate LOQ by only CV< 0.5 data
cv_matrix$mean_estimated_VAF <- log2(cv_matrix$mean_estimated_VAF)
cv_matrix$CoefficientOfVariance <- log2(cv_matrix$CoefficientOfVariance)

my.formula <- y ~ x
g3 <- ggplot(cv_matrix,aes(x=mean_estimated_VAF,y=CoefficientOfVariance))
#g1 <- g1 + geom_point()

#library(dplyr)
#lm_fit_all <- cv_matrix %>% group_by(Mutation) %>% do(lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .) %>% coef %>% as_tibble )
lm_fit_all <- cv_matrix %>% group_by(Mutation) %>% do(model=lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .)) %>%  dplyr::summarise(Mutation=Mutation,rsq = summary(model)$r.squared,coef = summary(model)$coefficient[1],slope = summary(model)$coefficient[2])
#lm_fit_all <- cv_matrix %>% group_by(Mutation) %>% do(model=lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .)) %>%  dplyr::summarise(Mutation=Mutation,rsq = summary(model)$r.squared,var=names(coef(.$model)),coef = coef(.$model))
#do(data.frame(cyl = .$cyl, var = names(coef(.$mod)), coef = coef(.$mod)))
#fitted_models <- cv_matrix %>% group_by(Mutation) %>% do(model=lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .)  )
lm_fit_all$LOQ_VAFp_at30pCV_log2 <- (log2(0.3) + -1*lm_fit_all$coef) / lm_fit_all$slope  ### estimation of VAF for 30% CV
lm_fit_all$LOQ_VAFp_at30pCV <- round(2^lm_fit_all$LOQ_VAFp_at30pCV_log2,2)
lm_fit_all
write.table(lm_fit_all,"estimated_LOQ.csv",sep=",",quote=F,col.names=NA)


#library(data.table)
#lm_fit_all <- lm_fit_all[, est := rep( c("intercept", "coef"), .N/(ncoefs + 1)) ]
#lm_fit_all <- cv_matrix %>% group_by(Mutation) %>% do(lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .) )
#lm_fit_all <- cv_matrix %>% group_by(Mutation) %>% do(lm(CoefficientOfVariance ~ mean_estimated_VAF, data = .) %>% as_tibble(Mutation   = .$Mutation,intercept = coef(.$lm.res)[1],slope     = coef(.$lm.res)[2]) )

g3 <- g3 + 
	#stat_smooth_func(geom="text",method="lm",hjust=0,parse=TRUE) +
	geom_smooth(method = "lm", se=FALSE, color="black", formula = my.formula) +
	stat_regline_equation(label.y = 1.0, aes(label = ..eq.label..)) +
	stat_regline_equation(label.y = 0.8, aes(label = ..rr.label..))+
	#ylim(c(-2,specified_max))+
	#xlim(c(0,specified_max))+
	geom_point() + facet_wrap(~Mutation,ncol=5)
g3 <- g3 + theme(panel.spacing = grid::unit(1, "lines"))
g3 <- g3 + xlab("mean estimated %VAF log2 scale")
g3 <- g3 + ylab("estimated CV log2 scale")
plot(g3)



q()




q()


