
library(survival)
library(data.table)

arg1 <- commandArgs(trailingOnly=T)[1]
outpdf <- commandArgs(trailingOnly=T)[2]



matorg <- read.table(arg1,sep='\t',header=T,stringsAsFactor=F)
mat <- read.table(arg1,sep='\t',header=T,stringsAsFactor=F)

mat

#group = mat[,1]
#value = mat[,2]

#g0 <- mat[group==0 & value !='-',2]
#g1 <- mat[group==1 & value !='-',2]
#g0 <- as.numeric(g0)
#g1 <- as.numeric(g1)
#summary(g0)
#summary(g1)
#t.test(g0,g1)

head(mat)
mat <- mat[mat$PFS_day !="-",]


mat <- mat[mat$pID !="pO-09",]  ### Remove PointA-null case
#mat <- mat[mat$Tissue !="NA",]
#mat <- mat[mat$Comutation !="NA",]


pdf(outpdf)
mat$status = 1

### bottom , left , upper , right
par(mar=c(6,6,9,3))

mat$PFS_day <- as.numeric(mat$PFS_day)
#mat$T790Msize <- ifelse( (mat$T790M_A_ctDNA_size < 75 & !is.na(mat$T790M_A_ctDNA_size)) | (mat$T790M_B_ctDNA_size < 75 & !is.na(mat$T790M_B_ctDNA_size)) , 1, 0)
#mat$T790Msize <- ifelse( (mat$T790M_A_ctDNA_size < 75 & !is.na(mat$T790M_A_ctDNA_size) & !is.na(mat$T790M_B_ctDNA_size))  , 1, 0)
mat$T790Msize <- ifelse( (mat$T790M_A_ctDNA_size < 75 & !is.na(mat$T790M_A_ctDNA_size))  , 1, 0)

#with(data=mat, Surv(PFS_day, status))[1:20]
survfit1 <- survfit(Surv(PFS_day, status)~T790Msize, data=mat)

survdiff(Surv(PFS_day)~T790Msize,data=mat,rho=0) 
res <- survdiff(Surv(PFS_day)~T790Msize,data=mat,rho=0) 
str(res)
n0 <- res$obs[1]
n1 <- res$obs[2]
pvalue <- pchisq(res$chisq, 1, lower.tail=FALSE)

title <- paste("EGFR_T790M pointA \n group1 : size<75 ctDNA n1=",n1,  "\n", "group0 : size>=75 or not detected","n0=",n0, "\n","log-rank P=",pvalue)
colors<-c("red","blue")
plot(survfit1,xlab="day after pointA" , ylab="PFS" ,col=colors,main=title)
legend("topright", paste("T790Msize=",0:1, sep=""), lty=1, col=colors)



