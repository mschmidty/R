##Set Working Directory
projectWD<-("U:\\My Documents\\R\\dima_analysis\\2016")
setwd(projectWD)
getwd()

require(plyr)
library(ggplot2)

data <- read.csv('output/lpiFromScratch_byPLOT.csv')
data1 <- data

##Remove Zeros
#####Getting Rid of the Zeros
data2 <- data1[-which(data1$coverPercent2 == "0"), ]


##Calculates base on Site ID and symbol Standard Deviation 
## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    library(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}

data3 <- summarySE(data2, measurevar="coverPercent2", groupvars=c("SiteID", "symbol"))

##subsetData
variables <- c("ACHY", "ARFR", "ARTR2","ARNO4","ATCA2", "BOGR2", "BRTE", "CHER2", "CHVI8", "ELEL5", "HECO26", "GUSA2", "HL","KRLA", "PASM", "PHLO2", "PLJA", "SCLI", "SPCO", "WL")
final1 <- subset(data3, SiteID %in% c('GUSG_DENSE', 'GUSG_CONTROL', 'GROUSE_PR') & symbol %in% variables )

p <- ggplot(final1, aes(x=symbol, y=coverPercent2, fill=SiteID)) +
	geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=coverPercent2-se, ymax=coverPercent2+se),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))
p
write.csv(data2, file="output/summaryBySite.csv")