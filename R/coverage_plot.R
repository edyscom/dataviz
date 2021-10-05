
x <- read.table("depth.txt", header=T)
png("image.png", width = 500, height = 300, pointsize = 12, bg = "white")


plot(x$'depth', names.arg=x$'pos', ylim=c(0, 200)   )
box("plot",lty=1)
graphics.off()
