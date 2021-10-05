
library(ggplot2)

presidential <- subset(presidential, start > economics$date[1])

write.table(presidential,"testdata.summary.txt",sep="\t");
write.table(economics,"testdata.all.txt",sep="\t");

par(mfrow=c(2,1))
pdf("ggplot_annotation.pdf")

ggplot(economics) + 
	geom_rect(
			  aes(xmin = start, xmax = end, fill = party), 
			  ymin = -Inf, ymax = Inf, alpha = 0.2, 
			  data = presidential
			  ) + 
geom_vline(
#geom_bar(
		   aes(xintercept = as.numeric(start)), 
	   data = presidential,
		   colour = "grey50", alpha = 0.5
		   ) + 
geom_text(
		  aes(x = start, y = 2500, label = name), 
		  data = presidential, 
		  size = 3, vjust = 0, hjust = 0, nudge_x = 50
		  ) + 
geom_bar(aes(date, unemploy),stat="identity") + 
#geom_line(aes(date, unemploy)) + 
scale_fill_manual(values = c("blue", "red")) +
xlab("date") + 
ylab("unemployment") +
theme(legend.position="top")

gp2 <- ggplot(economics) + 
geom_bar(aes(date, unemploy),stat="identity") + 
scale_fill_manual(values = c("blue", "red")) +
xlab("date") + 
ylab("unemployment")
gp2


