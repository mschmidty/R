wd <- "U:\\My Documents\\R\\Mancos_House"
setwd(wd)
getwd()

data <- read.csv('salesFinal.csv', header=T)

plotData <- data[c("Date", "Price")]

highValues <- subset(plotData, Price > 100000)

plotData$Date <- as.Date(plotData$Date, "%m/%d/%Y")

highValues$Date <- as.Date(highValues$Date, "%m/%d/%Y")

attach(plotData)

plot(Date, Price, main="Prices of Montezuma County Houses 2008-2016")

lines(lowess(Date,Price), col="blue")
abline(lm(Date~Price), col="red") # regression line (y~x) 

x <- highValues$Date
y <- highValues$Price 

marks <- c(0,100000,200000,300000,400000,500000,600000)
plot(x, y, yaxt="n", main="Prices of Montezuma County Houses 2008-2016")
axis(2,at=marks,labels=format(marks,scientific=FALSE))
lines(lowess(Date,Price), col="blue")

# basic straight line of fit
fit <- glm(y~x)
co <- coef(fit)
abline(fit, col="blue", lwd=2)