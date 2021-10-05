
library(VennDiagram)


FvsE <- read.table("FvsE_list",header=F)
GvsE <- read.table("GvsE_list",header=F)
HvsE <- read.table("HvsE_list",header=F)
IvsE <- read.table("IvsE_list",header=F)

category = c("FvsE","GvsE","HvsE","IvsE")
fill     = c("orange","red","green","blue")


overlap <- calculate.overlap(x = 
list("FvsE"=FvsE[,1] , 
"GvsE"=GvsE[,1],
"HvsE"=HvsE[,1], 
"IvsE"=IvsE[,1]))

ovp_12 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"GvsE"=GvsE[,1]))
ovp_13 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"HvsE"=HvsE[,1]))
ovp_14 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"IvsE"=IvsE[,1]))
ovp_23 <- calculate.overlap(x=list("GvsE"=GvsE[,1],"HvsE"=HvsE[,1]))
ovp_24 <- calculate.overlap(x=list("GvsE"=GvsE[,1],"IvsE"=IvsE[,1]))
ovp_34 <- calculate.overlap(x=list("HvsE"=HvsE[,1],"IvsE"=IvsE[,1]))
ovp_123 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"GvsE"=GvsE[,1],"HvsE"=HvsE[,1]))
ovp_124 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"GvsE"=GvsE[,1],"IvsE"=IvsE[,1]))
ovp_134 <- calculate.overlap(x=list("FvsE"=FvsE[,1],"HvsE"=HvsE[,1],"IvsE"=IvsE[,1]))
ovp_234 <- calculate.overlap(x=list("GvsE"=GvsE[,1],"HvsE"=HvsE[,1],"IvsE"=IvsE[,1]))



overlap
area1 = length(IvsE[,1])
area2 = length(HvsE[,1])
area3 = length(GvsE[,1])
area4 = length(FvsE[,1])
n12 = length(ovp_12$a5)
n13 = length(ovp_13$a5)
n14 = length(ovp_14$a5)
n23 = length(ovp_23$a5)
n24 = length(ovp_24$a5)
n34 = length(ovp_34$a5)
n123 = length(ovp_123$a7)
n124 = length(ovp_124$a7)
n134 = length(ovp_134$a7)
n234 = length(ovp_234$a7)


ovp_123




venn.plot <- draw.quad.venn(
area1 = length(FvsE[,1]),
area2 = length(GvsE[,1]),
area3 = length(HvsE[,1]),
area4 = length(IvsE[,1]),
n12 = length(ovp_12$a3),
n13 = length(ovp_13$a3),
n14 = length(ovp_14$a3),
n23 = length(ovp_23$a3),
n24 = length(ovp_24$a3),
n34 = length(ovp_34$a3),
n123 = length(ovp_123$a5),
n124 = length(ovp_124$a5),
n134 = length(ovp_134$a5),
n234 = length(ovp_234$a5),
n1234 = length(overlap$a6),
category= category,
fill = fill,
lty="dashed",
cex=2,
cat.cex=2,
cat.col = fill
);

tiff(filename="Quad_Venn_diagram.tiff");
grid.draw(venn.plot);
dev.off();



