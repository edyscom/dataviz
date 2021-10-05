
library(data.table)


args1 = commandArgs(trailingOnly=TRUE)[1]
args2 = commandArgs(trailingOnly=TRUE)[2]
args3 = commandArgs(trailingOnly=TRUE)[3]


#geneInfo   <- read.table(file="geneInfo.txt",header=T,sep="\t",row.names=1)
geneInfo   <- fread(file="geneInfo.txt",header=T,sep="\t",stringsAsFactors=F)
#pathways   <- read.table(file=args1,header=T,sep="\t",stringsAsFactors=F)
pathways   <- fread(file=args1,header=T,sep="\t",stringsAsFactors=F)



#### Addition of logFC values from Statistics Results
stat_res   <- fread(file=args3,header=T,sep="\t",stringsAsFactors=F)
gene_stat <- stat_res$Gene
gene_info <- geneInfo$GeneID
stat2info <- match(gene_info,gene_stat)
logFC <- stat_res$logFC[stat2info]
geneInfo <- cbind(geneInfo,logFC)



### Conversion to character
pathways$Entrez.Gene.ID.L <- as.character(pathways$Entrez.Gene.ID.L)
geneInfo$Entrez_ID <- as.character(geneInfo$Entrez_ID)
str(pathways)
str(geneInfo)

#n_entire <- 21587 ### all genes analyzed!!
gexp   <- fread(file=args2,header=T,sep="\t",stringsAsFactors=F)
n_entire <- nrow(gexp)


geneInfo$Entrez_ID <- factor(geneInfo$Entrez_ID)

module_list <- factor(geneInfo$moduleColor)
levels(module_list)


path_list <- factor(pathways$WP)
#levels(path_list)


df_all <- data.frame()
df_col <- c("r_select","n_select","r_entire","n_entire","module_name","pathwayID","pathway_desc","pValue","Symbols","logFC_mean")

for (module in levels(module_list)){
	if(module != "blue"){
		#next
	}
	members <- geneInfo[ geneInfo$moduleColor == module,]
	n_select <- nrow(members)

	#cat(members$GeneID,"\n")
	#cat ("DEB", n_select , module ,"\n");

	merge <- merge(members,pathways,by.x="Entrez_ID",by.y="Entrez.Gene.ID.L" )
	r_entire <- nrow(merge)
	#n_entire  <- length(levels(factor( pathways$Entrez.Gene.ID.L )))

	c_df <- c()	
	for (pathway in levels(path_list)){

		this_pathway <- pathways[ pathways$WP == pathway,]
		this_pathway_desc <- this_pathway$Pathway.Name
		pathway_desc <- this_pathway_desc[1]
		#str(pathway_desc,"\n")
		n_pathway <- length(levels(factor( this_pathway$Entrez.Gene.ID.L )))
		
		sel_merge <- merge(members,this_pathway,by.x="Entrez_ID",by.y="Entrez.Gene.ID.L" )
		r_select <- nrow(sel_merge)


		symbols <- sel_merge$Gene_Symbol
		logFC_mean <- mean(sel_merge$logFC)
		if(length(symbols) == 0){
			symbols <- "-"
			logFC_mean <- "-"
		}
		else{
			symbols <- paste(symbols,collapse=';')
		}
		if(length(symbols) == 2){
			#cat(symbols,"\n");
		}
		#res <- fisher.test( matrix(c(r_select,n_pathway,r_entire,n_entire),byrow=T,ncol=2),alternative='greater')
		res <- fisher.test( matrix(c(r_select,n_select - r_select ,n_pathway,n_entire - n_pathway),byrow=T,ncol=2),alternative='greater')
		#cat(paste(r_select,n_pathway,r_entire,n_entire,module,pathway,pathway_desc,res$p.value,"\n",sep="\t"))
	#	cat(paste(r_select,n_select,n_pathway,n_entire,module,pathway,pathway_desc,res$p.value,"\n",sep="\t"))


		#line <- c(r_select,n_pathway,r_entire,n_entire,module,pathway,pathway_desc,res$p.value)
		line <- c(r_select,n_select,n_pathway,n_entire,module,pathway,pathway_desc,res$p.value,symbols,logFC_mean)
		c_df <- c(c_df,line)
		#cat(n_entire,r_entire,n_pathway,r_select,module,pathway,"\n")
		#cat(n_pathway,r_select,n_entire,r_entire,module,pathway,pathway_desc,"\n")
	}
	df <- data.frame(matrix(c_df,ncol=10,byrow=T))
	colnames(df) <- df_col
	df <- df[order(df$pValue,decreasing=F),]

	df_all <- rbind(df_all,df)
	write.table(df,paste("pathwaystat_res_module_",module,".txt",sep=""),sep="\t",quote=F,row.names=F)
}


dim(df_all)
write.table(df_all,paste("pathwaystat_res_AllModule",".txt",sep=""),sep="\t",quote=F,row.names=F)


