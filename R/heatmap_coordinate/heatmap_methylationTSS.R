
#load packages
library(ggplot2) #ggplot() for plotting
library(reshape2) #melt(), dcast() for data reformatting
library(plyr) #ddply() for data reformatting
library(Cairo) #better aliasing of output images

m <- read.csv("measles_lev1.csv",header = T,stringsAsFactors = F,skip = 2)
#convert data to long format
m2 <- melt(m,id.vars = c("YEAR", "WEEK"))
#rename column names
colnames(m2) <- c("Year", "Week", "State", "Value")

#custom function to convert to camel case
camelCase <- function(string=NULL,separator=".") {
	if(is.null(string)) stop("No input string.n")
	s <- strsplit(string, separator)
	s <- tolower(s[[1]])
	paste(toupper(substring(s, 1, 1)), substring(s, 2),sep = "", collapse = " ")
}

#change variable to character, convert to camel case, 
#remove dot and change variable back to factor 
m2$State <- factor(as.character(sapply(as.character(m2$State),camelCase)))

#change variable types
m2$Year <- factor(m2$Year)
m2$Week <- factor(m2$Week)
#also converts '-' to NA
m2$Value <- as.numeric(m2$Value)



#custom sum function returns NA when all values in set are NA, 
#in a set mixed with NAs, NAs are removed and remaining summed.
naSum <- function(x)
{
	if(all(is.na(x))) val <- sum(x,na.rm=F)
	if(!all(is.na(x))) val <- sum(x,na.rm=T)
	return(val)
}

#sums incidences for all weeks into one year
m3 <- ddply(m2,c("Year","State"),Incidence=round(naSum(Value),0),summarise)

#inspect data
head(m3)
str(m3)



#reverse level order of state
m3$State <- factor(as.character(m3$State),levels=rev(levels(m3$State)))

#create a new variable from incidence
m3$IncidenceFactor <- cut(m3$Incidence,
						  breaks = c(-1,0,1,10,100,500,1000,max(m3$Incidence,na.rm=T)),
						  labels=c("0","0-1","1-10","10-100","100-500","500-1000",">1000"))

#change level order
m3$IncidenceFactor <- factor(as.character(m3$IncidenceFactor),
							 levels=rev(levels(m3$IncidenceFactor)))





#define a colour for fonts
textcol <- "grey40"


#basic ggplot
#p <- ggplot(m3,aes(x=Year,y=State,fill=Incidence))+
#geom_tile()

#save plot to working directory


#modified ggplot
p <- ggplot(m3,aes(x=Year,y=State,fill=IncidenceFactor))+
geom_tile()+


#redrawing tiles to remove cross lines from legend
geom_tile(colour="white",size=0.25, show_guide=FALSE)+
#remove axis labels, add title
labs(x="",y="",title="Incidence of Measles in the US")+
#remove extra space
scale_y_discrete(expand=c(0,0))+
#custom breaks on x-axis
scale_x_discrete(expand=c(0,0),
				 breaks=c("1930","1940","1950","1960","1970","1980","1990","2000"))+
#custom colours for cut levels and na values
scale_fill_manual(values=c("#d53e4f","#f46d43","#fdae61",
						   "#fee08b","#e6f598","#abdda4","#ddf1da"),na.value="grey90")+
#mark year of vaccination
geom_vline(aes(xintercept = 36),size=3.4,alpha=0.24)+
#equal aspect ratio x and y axis
coord_fixed()+
#set base size for all font elements
theme_grey(base_size=10)+
#theme options
theme(
	  #remove legend title
	  legend.title=element_blank(),
	  #remove legend margin
	  legend.margin = grid::unit(0,"cm"),
	  #change legend text properties
	  legend.text=element_text(colour=textcol,size=7,face="bold"),
	  #change legend key height
	  legend.key.height=grid::unit(0.8,"cm"),
	  #set a slim legend
	  legend.key.width=grid::unit(0.2,"cm"),
	  #set x axis text size and colour
	  axis.text.x=element_text(size=10,colour=textcol),
	  #set y axis text colour and adjust vertical justification
	  axis.text.y=element_text(vjust = 0.2,colour=textcol),
	  #change axis ticks thickness
	  axis.ticks=element_line(size=0.4),
	  #change title font, size, colour and justification
	  plot.title=element_text(colour=textcol,hjust=0,size=14,face="bold"),
	  #remove plot background
	  plot.background=element_blank(),
	  #remove plot border
	  panel.border=element_blank())

ggsave(filename="measles-modified.png",plot = p)
