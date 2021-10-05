
library(ggplot2)


### This R script plots distribution of Poisson & Negative Binomial
x <-  c(0:30)

lambda = 10

poisson <- data.frame(x=x,y=dpois(x,10),group=rep("poisson",31))
poisson


### Negative Binomial  (this case 2 x mean  =  V )
mu = 10
v  = 20
### k= the number of success (estimated from observed mean & variance (V,sigma^2))
### p= the rate of success (estimated from observed mean & variance (V,sigma^2))
k = (mu*mu) / (v - mu)
p = k / (k + mu)
nb1 <- data.frame(x=x,y=dnbinom(x=x,size=k,prob=p),group=rep("nb_u10_v20",31))

### Negative Binomial v2  (this case almost same mean vs V ,  mean  ~=  V )
mu = 10
v  = 10.5
k = (mu*mu) / (v - mu)
p = k / (k + mu)
nb2 <- data.frame(x=x,y=dnbinom(x=x,size=k,prob=p),group=rep("nb_u10_v10.5",31))

df <- rbind(poisson,nb1,nb2)
df

#ggplot(df) + geom_line(aes(x=x,y=poisson),color="red") + geom_line(aes(x=x,y=nb1),color="blue")
ggplot(df) + geom_line(aes(x=x,y=y,color=group)) 



