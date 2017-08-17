#Working with AIM Data in R

##Set Working Directory
projectWD<-("U:\\My Documents\\R\\dima_analysis\\2016")
setwd(projectWD)
getwd()

##Load Libraries - May need to intall these with install.packages() before loading.
library(RODBC) ## - for reading Access Databases
library(reshape2) ## - for pivote table like functionality
library(psych) ## - This does a lot.  Here we are using it for the decribe() function which allows you to summarize data.
require(ggplot2)

###Read Plant List
plantList <- read.csv("PlantList.csv")

###Load the DIMA Database
channel1 <-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=database/DIMA.mdb")


###Get tagble with names "tblSites"
tblSites <- sqlFetch(channel1, "tblSites")
tblPlots <-sqlFetch(channel1, "tblPlots")

###Get Querry with plot level averages of LPI.
qryLpi <- sqlFetch(channel1, "qryBLMLPISpeciesSum")
qrySp <- sqlFetch(channel1, "qryBLMLPISpecies")

###Add SiteKey, PlotKey and Site ID to qry so you don't have to do this manually
####Adds Site Key to QryLpi
qryLpiM <- merge(qryLpi, tblPlots[, c("PlotKey", "SiteKey")], by = "PlotKey") 
####Adds SiteID to qryLPIM
qryLpiM1 <- merge(qryLpiM, tblSites[, c("SiteID", "SiteKey")], by = "SiteKey")
#### Clean up problematic SiteIDs
qryLpiM2 <- qryLpiM1[qryLpiM1$SiteID != "Community" & qryLpiM1$SiteID != "unknown",]
####Add Plant group type to qry LpiM2
qryLpiM3 <- merge(qryLpiM2, plantList[, c("symbol", "Growth_Habit")], by = "symbol")


###Averages plants by Site (SiteKey). 
cQryLpi <- dcast(qryLpiM3, SiteID ~ symbol, value.var="canopy_cvr_pcnt", mean)

###Doing Everything I did below, the easy way. 
variables <- c("ACHY", "ARFR", "ARTR2","ARNO4","ATCA2", "BOGR2", "BRTE", "CHER2", "CHVI8", "ELEL5", "HECO26", "GUSA2", "KRLA", "PASM", "PHLO2", "PLJA", "SCLI", "SPCO")

final3 <- subset(qryLpiM3, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR') & symbol %in% variables )
final2 <- subset(qryLpiM3, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR'))
p <- ggplot(data = final3, aes(x=symbol, y=canopy_cvr_pcnt)) + geom_boxplot(aes(fill=SiteID))
p <- p + geom_point(aes(y=canopy_cvr_pcnt, group=SiteID), position = position_dodge(width=0.75))
P <- p + facet_wrap( ~ symbol, scales="free")
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p


print(p)
###Separates the Sites by Site ID into the three areas. 
dense <- subset(cQryLpi, SiteID == 'GUSG_DENSE')
control <- subset(cQryLpi, SiteID == 'GUSG_CONTROL')
priority <- subset(cQryLpi, SiteID == 'GROUSE_PR')

###Box Plots for Dense, Control and Priority areas. 
####Separating the data
denseBox <- subset(qryLpiM3, SiteID == 'GUSG_DENSE')
controlBox <- subset(qryLpiM3, SiteID == 'GUSG_CONTROL')
priorityBox <- subset(qryLpiM3, SiteID == 'GROUSE_PR')


###Subsetting the Data###
####Setting Variables
variables <- c("ARTR2","ARNO4", "BOGR2", "BRTE", "ELEL5", "HECO26", "GUSA2", "KRLA", "PASM")

denseBoxSubset <- subset(denseBox, symbol %in% variables)
denseBoxSubset$symbol <- droplevels(denseBoxSubset$symbol) 
controlBoxSubset <- subset(controlBox, symbol %in% variables)
controlBoxSubset$symbol <- droplevels(controlBoxSubset$symbol)
priorityBoxSubset <- subset(priorityBox, symbol %in% variables)
priorityBoxSubset$symbol <- droplevels(priorityBoxSubset$symbol)

###3 rows of plots
par(mfrow=c(2,1))

####Plotting the data
boxplot(denseBoxSubset$canopy_cvr_pcnt~denseBoxSubset$symbol, data=denseBoxSubset, main='Dense Areas')
boxplot(controlBoxSubset$canopy_cvr_pcnt~controlBoxSubset$symbol, data=controlBoxSubset, main='Control')
boxplot(priorityBoxSubset$canopy_cvr_pcnt~priorityBoxSubset$symbol, data=priorityBoxSubset, main='Priority')


###Close the Connection to the database.  Run this before closing the R console. 
###You can also delete the .ldb file as well. 
odbcClose(channel1)