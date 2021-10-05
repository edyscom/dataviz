
library(VennDiagram)


FvsE <- read.table("FvsE_list",header=F)
FvsE_old <- read.table("FvsE_list_old",header=F)

data <- list(NEW=FvsE[,1] , OLD= FvsE_old[,1])



png(filename="FvsE_Venn_diagram.png");
venn.diagram(
data,
fill = c(3,2),
title="FvsE",
filename="FvsE_Venn_diagram.png",
)

dev.off()

