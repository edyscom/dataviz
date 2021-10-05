
# Pie Chart with Percentages

x <- read.table("4485.ISanal.txt", header=T)
png("image.png", width = 500, height = 300, pointsize = 12, bg = "white")


count <- sort(x[,4],decreasing=TRUE)
count

pie(count,labels=NA, main="Pie Chart of Clonality", init.angle=90 ,clockwise=TRUE  )



graphics.off()


