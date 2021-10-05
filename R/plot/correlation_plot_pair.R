

### using psych library
library(psych)


pdf("correlation_pairs.pdf")

data <- read.table("read_distri_chrom2.tsv",sep="\t",head=T,row.names=1);
data2 <- read.table("hg19_ChromInfo.txt",sep="\t",head=T,row.names=1);

data <- data['J001_R1']

data <- cbind(data,data2)

pairs.panels(data)


dev.off()



