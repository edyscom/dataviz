


args1 = commandArgs(trailingOnly=TRUE)[1]

library(data.table)

#geneInfo   <- read.table(file="geneInfo.txt",header=T,sep="\t",row.names=1,stringsAsFactors=F)
geneInfo   <- fread(file="geneInfo.txt",header=T,sep="\t",stringsAsFactors=F)
pathways   <- read.table(file=args1,header=T,sep="\t",stringsAsFactors=F)


module_list <- factor(geneInfo$moduleColor)


path_list <- factor(pathways$WP)
#levels(path_list)


levels(module_list)




df_col <- c("r_select","n_pathway","r_entire","n_entire","module_name","pathwayID","pathway_desc","pValue")

for (module in levels(module_list)){
	cat(module," Start\n")
	if(module != "blue"){
		#next
	}
	members <- geneInfo[ geneInfo$moduleColor == module,]
	n_select <- nrow(members)
	merge <- merge(members,pathways,by.x="Entrez_ID",by.y="Entrez.Gene.ID.L" )
	r_entire <- nrow(merge)
	n_entire  <- length(levels(factor( pathways$Entrez.Gene.ID.L )))

	c_df <- c()	
	for (pathway in levels(path_list)){

		this_pathway <- pathways[ pathways$WP == pathway,]
		this_pathway_desc <- this_pathway$Pathway.Name
		pathway_desc <- this_pathway_desc[1]

		n_pathway <- length(levels(factor( this_pathway$Entrez.Gene.ID.L )))
		
		sel_merge <- merge(members,this_pathway,by.x="Entrez_ID",by.y="Entrez.Gene.ID.L" )
		r_select <- nrow(sel_merge)

		res <- fisher.test( matrix(c(r_select,n_pathway,r_entire,n_entire),byrow=T,ncol=2),alternative='greater')
		cat(paste(r_select,n_pathway,r_entire,n_entire,module,pathway,pathway_desc,res$p.value,"\n",sep="\t"))


		line <- c(r_select,n_pathway,r_entire,n_entire,module,pathway,pathway_desc,res$p.value)
		c_df <- c(c_df,line)
		#cat(n_entire,r_entire,n_pathway,r_select,module,pathway,"\n")
		#cat(n_pathway,r_select,n_entire,r_entire,module,pathway,pathway_desc,"\n")
	}
	df <- data.frame(matrix(c_df,ncol=8,byrow=T))
	colnames(df) <- df_col
	df <- df[order(df$pValue,decreasing=F),]
	write.table(df,paste("pathwaystat_res_module_",module,".txt",sep=""),sep="\t",quote=F,row.names=F)
}



