
library(vioplot)

exp <- read.table("meta_vsNeg_8samples_normRPKM.tab",sep="\t",header=T,row.names=1)

head(exp)

png("violin_plot.png",600,600)



cate_list <- names(exp)


plot(0,0,type = "n", xlab="",ylab="",axes = FALSE , xlim = c(0.5,length(cate_list) + 0.5) , ylim = range(exp) )
axis(side = 1 , at = 1:length(cate_list) , labels=cate_list)
axis(side=2)
col<-c(rep("red",8),"blue")

cate_list
index <- 1
for (i in cate_list){
        x <- exp[[i]]

        vioplot(x,at=index,col=col[index],add=TRUE)
        index <- index + 1
}




