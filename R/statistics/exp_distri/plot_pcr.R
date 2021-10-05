

matrix <- read.table("pcr_test.txt",sep="\t",header=F)

x <- matrix[,1]
#y <- matrix[,2]

ht_log <- hist(log10(x))
#ht <- hist(x)

#x2 <- x[ log10(x) > 3.2 & log10(x) < 4.2]
qqnorm(log10(x))
shapiro.test(log10(x))

#plot(ht_log$mids,ht_log$density)
plot(ht_log$mids,log10(ht_log$density))


#plot(log10(ht$mids),log10(ht$density))
