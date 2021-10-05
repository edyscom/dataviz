
library(RCircos)
RCircos.Workflow()

#Load RCircos library:

library(RCircos)

#2. Load chromosome cytoband data:

data(UCSC.HG19.Human.CytoBandIdeogram);
cyto.info <- UCSC.HG19.Human.CytoBandIdeogram;

# Other chromosome ideogram data installed:
# UCSC.Mouse.GRCm38.CytoBandIdeogram
# UCSC.Baylor.3.4.Rat.cytoBandIdeogram

#3. Setup RCircos core components:

RCircos.Set.Core.Components(cyto.info, chr.exclude=NULL,
							tracks.inside=10, tracks.outside=0);

#4. Load input data:

heatmap.data <- read.table("/path/Heatmap.data.txt", 
						   sep="\t", quote="", head=T);
hist.data <- read.table("/path/histgram.data.txt", 
						sep="\t", quote="", head=T);
link.data <- read.table("/path/link.data.txt", 
						sep="\t", quote="", head=T);

#5. Modify plot parameters if necessary:

rcircos.params <- RCircos.Get.Plot.Parameters()
rcircos.params$radiu.len <- 1.5;
RCircos.Reset.Plot.Parameters(rcircos.params);

#6. Open graphic device:

RCircos.Set.Plot.Area();
#or submit your own code. For example: 

par(mai=c(0.25, 0.25, 0.25, 0.25));
plot.new();
plot.window(c(-2.5,2.5), c(-2.5, 2.5));

#7. Call plot function to plot each data track:

RCircos.Chromosome.Ideogram.Plot();
RCircos.Heatmap.Plot(heatmap.data, data.col=5, 
					 track.num=1, side="in");
RCircos.Histogram.Plot(hist.data, data.col=4, 
					   track.num=4, side="in");
RCircos.Link.Plot(link.data, track.num=5, 
				  by.chromosome=FALSE);

#8. Close the graphic device if you was plotting to file:

dev.off();



