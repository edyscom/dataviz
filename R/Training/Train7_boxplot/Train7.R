library(BrainStars)
ids <- c("1439627_at", "1439631_at", "1439633_at")
my.esets <- getBrainStars(query = ids, type = "expression")
exprs(my.esets)

exprs_gene <- t(exprs(my.esets))



#boxplot(exprs(my.esets))
boxplot(exprs_gene)

