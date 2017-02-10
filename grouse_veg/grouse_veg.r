
setwd("~/misc/git/R/grouse_veg")

##Load Data
sagebrush <- read.csv("sb_cover_2007_present.csv")

##attach table to make headers variables
attach(sagebrush)

##get headers
names(sagebrush)

##Creates Summary of Sage1Cover
summary(Sage1Cover.)

##Histogram
hist(Sage1Cover.)

 

