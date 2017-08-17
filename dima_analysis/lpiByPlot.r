##options
options('scipen' = 10)
options()$scipen
##Set Working Directory
projectWD<-("U:\\My Documents\\R\\dima_analysis\\2016")
setwd(projectWD)
getwd

##Load Libraries - May need to intall these with install.packages() before loading.
library(RODBC) ## - for reading Access Databases

##Open Database Connection
channel1 <-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=database/DIMA.mdb")

data <- sqlFetch(channel1, "tblLPIDetail")
lineKey <- sqlFetch(channel1, "tblLPIHeader")
plotKey<-	sqlFetch(channel1, "tblLines")
plotInfo <- sqlFetch(channel1, "tblPlots")
tblSites <- sqlFetch(channel1, "tblSites")

##Add LineKey to dataset
data1 <- merge(data, lineKey[, c("LineKey", "RecKey")], by = "RecKey")
data2 <- merge(data1, plotKey[, c("PlotKey", "LineID", "LineKey")], by = "LineKey")

##Count all Plants by species and PlotKey
d <- table(data2$TopCanopy, data2$PlotKey)
d1 <- table(data2$Lower1, data2$PlotKey)
d2 <- table(data2$Lower2, data2$PlotKey)
d3 <- table(data2$Lower3, data2$PlotKey)
d4 <- table(data2$Lower4, data2$PlotKey)

###Merge in two steps and merge the two steps
h <- merge(d, d1, by=c("Var1", "Var2"), all=TRUE)
h1 <- merge(h, d2, by=c("Var1", "Var2"), all=TRUE)
h11<-h1
h11[is.na(h11)]=0
h11$cover <- (h11$Freq.x+h11$Freq.y+h11$Freq)
h11F <- h11[, c(1, 2, 6)]
h2 <- merge(d3, d4, by=c("Var1", "Var2"), all=TRUE)
h22<-h2
h22[is.na(h22)]=0
h22$cover2 <- (h22$Freq.x+h22$Freq.y)
h22F <- h22[, c(1, 2, 5)]

lpiMerge <- merge(h11F, h22F, by=c("Var1", "Var2"), all=TRUE)
lpiMerge[is.na(lpiMerge)]=0

##Clear columns with no vegetation species
lpiMerge <- lpiMerge[-which(lpiMerge$Var1 == ""), ]

##Do math to get cover. 
lpiMerge$coverCount <- (lpiMerge$cover+lpiMerge$cover2)
lpiMerge$coverPercent <- (lpiMerge$coverCount/150)
lpiMerge$coverPercent2 <- (lpiMerge$coverPercent*100)

##Rename Var1 and Var2 to Species and Linekey for Future Merge
names(lpiMerge)[1] <- "symbol"
names(lpiMerge)[2] <- "PlotKey"

##Merge with Original Values
data3 <- merge(lpiMerge, plotInfo[, c("PlotKey", "PlotID", "SiteKey")], by = "PlotKey")
data4 <- merge(data3, tblSites[, c("SiteID", "SiteKey")], by = "SiteKey")

##clean
finalData <- data4[-which(data4$PlotID == "unknown"), ]

##Write to a file
write.csv(finalData, file="output/lpiFromScratch_byPLOT.csv")

###Close the Connection to the database.  Run this before closing the R console. 
###You can also delete the .ldb file as well. 
odbcClose(channel1)