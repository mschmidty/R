
##Set Working Directory
projectWD<-("U:\\My Documents\\R\\dima_analysis\\2016")
setwd(projectWD)
getwd()

##Load Libraries - May need to intall these with install.packages() before loading.
require(ggplot2)

##Read the Data
data <- read.csv('output/lpiFromScratch_byPLOT.csv')

##Subset the Data

#####For Specific Sites in the DIMA database
data2 <- subset(data, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR'))



#####Getting Rid of the Zeros
data3 <- data2[-which(data2$coverPercent2 == "0"), ]

##Subset Data with 
variables2 <- c("ACHY", "ARFR", "ARTR2","ARNO4","ATCA2", "BOGR2", "BRTE", "CHER2", "CHVI8", "ELEL5", "HECO26", "HL", "GUSA2", "KRLA", "PASM", "PHLO2", "PLJA", "SCLI", "SPCO", "WL", "None")
data444 <- subset(data3, symbol %in% variables2 )


##BoxPlot
p <- ggplot(data = data444, aes(x=symbol, y=coverPercent2)) + geom_boxplot(aes(fill=SiteID))
p <- p + geom_point(aes(y=coverPercent2, group=SiteID), position = position_dodge(width=0.75))
P <- p + facet_wrap( ~ symbol, scales="free")
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p
