
library(WGCNA)



lambda <- 10


#dist_exp <- rexp(10000,rate=lambda)
dist_exp <- rweibull(10000,shape=0.5)


hi <- hist(dist_exp)

cdf <- cumsum(hi$density)

#plot(log(hi$mids),cdf)
plot(log10(hi$mids),log10(hi$density))

#df <- data.frame(cbind(hi$mids,hi$density))

scaleFreePlot(dist_exp)

hi




