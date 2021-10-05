
### Ensembl biomart からヒトの SMN1 という splicing 異常によって疾患になる例が知られている遺伝子名(Gene symbol)の遺伝子構造を描きます。




library(GenomeGraphs)
library(biomaRt)

gene.symbol <- "SMN1"
png.file <- paste(gene.symbol, ".png", sep = "")

## construct an object of Human Ensembl Biomart
human <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", dataset = "hsapiens_gene_ensembl", host="www.ensembl.org")




gene <- getBM(
     attributes = c('hgnc_symbol', 'ensembl_gene_id', 'chromosome_name'),
     filters = 'hgnc_symbol',
     values  = gene.symbol,
     mart    = human
)

ensgene.id <- gene[,2]
chr.num    <- as.character(gene[,3])


## Get annotation of Ensembl Gene
gene <- makeGene(id = ensgene.id, type = "ensembl_gene_id", biomart = human)
transcript <- makeTranscript(
     id      = ensgene.id,
     type    = "ensembl_gene_id",
     biomart = human,
     dp      = DisplayPars(plotId = TRUE, cex = 0.5)
)


## Create an ideogram object for the entire chromosome
ideog <- new("Ideogram", chromosome = chr.num)

## Create a highlight of the gene position on the ideogram
## using "absolute coordinates"
highlight.posi.on.ideo <- makeRectangleOverlay(
     0.60, 0.65,
     region = c(0.75, 0.82),
     coords = "absolute",
     dp = DisplayPars(alpha = .2, fill = "red")
)


## Create the plot
png(png.file)
gdPlot(
     list(
       makeTitle(gene.symbol),
       "Chr"         = ideog,
       "Gene"        = gene,
       "Transcripts" = transcript
     ),
     overlays = list(highlight.posi.on.ideo)
)
dev.off()




