
library(VennDiagram)

fill     = c("orange","red","green","blue")


FvsE_up <- read.table("FvsE_up_list",header=F)
GvsE_up <- read.table("GvsE_up_list",header=F)
HvsE_up <- read.table("HvsE_up_list",header=F)
IvsE_up <- read.table("IvsE_up_list",header=F)

FvsE_dn <- read.table("FvsE_dn_list",header=F)
GvsE_dn <- read.table("GvsE_dn_list",header=F)
HvsE_dn <- read.table("HvsE_dn_list",header=F)
IvsE_dn <- read.table("IvsE_dn_list",header=F)

category = c("FvsE","GvsE","HvsE","IvsE")



ovp_12 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"GvsE_up"=GvsE_up[,1]))
ovp_13 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"HvsE_up"=HvsE_up[,1]))
ovp_14 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_23 <- calculate.overlap(x=list("GvsE_up"=GvsE_up[,1],"HvsE_up"=HvsE_up[,1]))
ovp_24 <- calculate.overlap(x=list("GvsE_up"=GvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_34 <- calculate.overlap(x=list("HvsE_up"=HvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_123 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"GvsE_up"=GvsE_up[,1],"HvsE_up"=HvsE_up[,1]))
ovp_124 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"GvsE_up"=GvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_134 <- calculate.overlap(x=list("FvsE_up"=FvsE_up[,1],"HvsE_up"=HvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_234 <- calculate.overlap(x=list("GvsE_up"=GvsE_up[,1],"HvsE_up"=HvsE_up[,1],"IvsE_up"=IvsE_up[,1]))
ovp_1234 <- calculate.overlap(x = 
list("FvsE_up"=FvsE_up[,1] , 
"GvsE_up"=GvsE_up[,1],
"HvsE_up"=HvsE_up[,1], 
"IvsE_up"=IvsE_up[,1]))

ovp_12_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"GvsE_dn"=GvsE_dn[,1]))
ovp_13_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"HvsE_dn"=HvsE_dn[,1]))
ovp_14_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_23_dn <- calculate.overlap(x=list("GvsE_dn"=GvsE_dn[,1],"HvsE_dn"=HvsE_dn[,1]))
ovp_24_dn <- calculate.overlap(x=list("GvsE_dn"=GvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_34_dn <- calculate.overlap(x=list("HvsE_dn"=HvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_123_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"GvsE_dn"=GvsE_dn[,1],"HvsE_dn"=HvsE_dn[,1]))
ovp_124_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"GvsE_dn"=GvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_134_dn <- calculate.overlap(x=list("FvsE_dn"=FvsE_dn[,1],"HvsE_dn"=HvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_234_dn <- calculate.overlap(x=list("GvsE_dn"=GvsE_dn[,1],"HvsE_dn"=HvsE_dn[,1],"IvsE_dn"=IvsE_dn[,1]))
ovp_1234_dn <- calculate.overlap(x = 
list("FvsE_dn"=FvsE_dn[,1] , 
"GvsE_dn"=GvsE_dn[,1],
"HvsE_dn"=HvsE_dn[,1], 
"IvsE_dn"=IvsE_dn[,1]))



area1 = length(FvsE_up[,1]) + length(FvsE_dn[,1])
area2 = length(GvsE_up[,1]) + length(GvsE_dn[,1])
area3 = length(HvsE_up[,1]) + length(HvsE_dn[,1])
area4 = length(IvsE_up[,1]) + length(IvsE_dn[,1])
n12 = length(ovp_12$a3)+length(ovp_12_dn$a3)
n13 = length(ovp_13$a3)+length(ovp_13_dn$a3)
n14 = length(ovp_14$a3)+length(ovp_14_dn$a3)
n23 = length(ovp_23$a3)+length(ovp_23_dn$a3)
n24 = length(ovp_24$a3)+length(ovp_24_dn$a3)
n34 = length(ovp_34$a3)+length(ovp_34_dn$a3)
n123 = length(ovp_123$a5)+length(ovp_123_dn$a5)
n124 = length(ovp_124$a5)+length(ovp_124_dn$a5)
n134 = length(ovp_134$a5)+length(ovp_134_dn$a5)
n234 = length(ovp_234$a5)+length(ovp_234_dn$a5)
n1234 = length(ovp_1234$a6)+length(ovp_1234_dn$a6)





venn.plot <- draw.quad.venn(
area1 = area1,
area2 = area2,
area3 = area3,
area4 = area4,
n12 = n12,
n13 = n13,
n14 = n14,
n23 = n23,
n24 = n24,
n34 = n34,
n123 = n123,
n124 = n124,
n134 = n134,
n234 = n234,
n1234 = n1234,
category= category,
fill = fill,
lty="dashed",
cex=2,
cat.cex=2,
cat.col = fill
);

tiff(filename="Quad_Venn_diagram_updown_sepa.tiff");
grid.draw(venn.plot);
dev.off();



