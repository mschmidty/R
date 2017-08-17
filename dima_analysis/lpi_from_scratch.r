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

##Open Database Connection
channel1 <-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=database/DIMA.mdb")

data <- sqlFetch(channel1, "tblLPIDetail")
lineKey <- sqlFetch(channel1, "tblLPIHeader")
plotKey<-	sqlFetch(channel1, "tblLines")
plotInfo <- sqlFetch(channel1, "tblPlots")

##Merge Tables
data1 <- merge(data, lineKey[, c("LineKey", "RecKey")], by = "RecKey")
data2 <- merge(data1, plotKey[, c("PlotKey", "LineID", "LineKey")], by = "LineKey")
data3 <- merge(data2, plotInfo[, c("PlotKey", "PlotID")], by = "PlotKey")

##Create copy
data4 <- data3



##cleaning the data
N <- 50
data4 <- tail(data4, -N) ####Remove unknowns (first 50 rows)

##Subset the data with only what we want. 
data5 <- data4[c("LineKey", "RecKey", "PlotKey", "LineID", "PlotID", "PointLoc", "TopCanopy", "Lower1", "Lower2", "Lower3", "Lower4")]

###Counting all of the Plant occurances
d <- table(data5$TopCanopy, data5$LineKey, data5$LineID)
d1 <- table(data5$Lower1, data5$LineKey, data5$LineID)
d2 <- table(data5$Lower2, data5$LineKey, data5$LineID)
d3 <- table(data5$Lower3, data5$LineKey, data5$LineID)
d4 <- table(data5$Lower4, data5$LineKey, data5$LineID)

###Merge 
h <- merge(d, d1, by=c("Var1", "Var2", "Var3"), all=TRUE)
h1 <- merge(h, d2, by=c("Var1", "Var2", "Var3"), all=TRUE)

h1$cover <- (h1$Freq.x+h1$Freq.y+h1$Freq)
h11<-h11
h11 <- h11[, c(1, 2, 3, 7)]
h2 <- merge(h11, d3, by=c("Var1", "Var2", "Var3"), all=TRUE)
h3 <- merge(h2, d4, by=c("Var1", "Var2", "Var3"), all=TRUE)

hFinal<- h3

hFinal$count <- (hFinal$Freq.x+hFinal$Freq.y+hFinal$cover)

