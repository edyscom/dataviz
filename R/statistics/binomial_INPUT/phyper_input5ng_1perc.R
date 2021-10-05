
library(ggplot2)


### This R script plots distribution of Binomial
x <-  c(0:10)

lambda = 10


cp_per_ng = 100
input = 200
input_cp = input * cp_per_ng;
RATIO = 0.01

drawn = 5
drawn_cp = drawn * cp_per_ng;

m = round(input_cp * RATIO ,0)
n = round(input_cp * (1-RATIO) ,0)
k = round(drawn_cp ,0)


input_pos = input_cp * RATIO


### Negative Binomial v2  (this case almost same mean vs V ,  mean  ~=  V )
p = RATIO
dhyper <- data.frame(x=x,y=dhyper(x=x,m=m,n=n,k=k),group=rep("5ng_1perc",11))


df <- rbind(dhyper)
#df <- rbind(poisson,nb1,nb2)
df

#ggplot(df) + geom_line(aes(x=x,y=poisson),color="red") + geom_line(aes(x=x,y=nb1),color="blue")
ggplot(df) + geom_line(aes(x=x,y=y,color=group)) 



phyper(q=3,m=m,n=n,k=k)



