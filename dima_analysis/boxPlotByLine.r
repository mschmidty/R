
##Set Working Directory
projectWD<-("U:\\My Documents\\R\\dima_analysis\\2016")
setwd(projectWD)
getwd()

require(ggplot2)

data <- read.csv('output/lpiFromScratch_byLINE.csv')
data2 <- subset(data, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR'))

#####Getting Rid of the Zeros
data3 <- data2[-which(data2$coverPercent2 == "0"), ]

##Subset Data with 
variables <- c("ACHY", "ARFR", "ARTR2","ARNO4","ATCA2", "BOGR2", "BRTE", "CHER2", "CHVI8", "ELEL5", "HECO26", "GUSA2", "KRLA", "PASM", "PHLO2", "PLJA", "SCLI", "SPCO")
final1 <- subset(data3, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR') & Species %in% variables )

##BoxPlot
p <- ggplot(data = final1, aes(x=Species, y=coverPercent2)) + geom_boxplot(aes(fill=SiteID))
p <- p + geom_point(aes(y=coverPercent2, group=SiteID), position = position_dodge(width=0.75))
P <- p + facet_wrap( ~ Species, scales="free")
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p

