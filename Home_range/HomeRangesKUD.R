#######################################################################
##################Determining KUDs of Seasonal Ranges##################
#######################################################################

#Require and load libraries
require(rgdal)
library(rgdal)
require(adehabitatHR)
library(adehabitatHR)

#Create a KUD list
kudlist<- list(50,55,60,65,70,75,80,85,90,95)

#Input shapefile ("working directory", "name of shapefile")
data<-readOGR("E:/Atlas_Migration/Elk_Migration/Absaroka_Elk/AbsarokaElk_ReadyforAlethea/ClarksForkElk/Migrants/Absaroka_Elk68_2009", "Absaroka_68_SummerRange_2009_Pts")

#You will want to change ElkID to the shapefile field representing Sagegrouse ID
data@data$ID<-as.character(data@data$ElkID)

#Build kernel
#You will want to change [3] to the shapefile field representing Sagegrouse ID 
#For example,in my code, [3] is the third field in the shapefile, which contains the Elk ID
kud <- kernelUD(data[3])

#Loop through and make homeranges at cutoffs in kudlist
for(k in 1:length(kudlist)){

#Extract home range contours, percent=x would be the x% home range
newhrW <- getverticeshr(kud, percent=kudlist[[k]])

#Transform shapefile into desired coordinate system
#Make sure to change'zone=12' to 'zone=13'
finalshape <- spTransform(newhrW, CRS("+proj=utm +zone=12 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"))

#Designate the name of the shapefile
outname<- paste("Absaroka_68_SummerRange_2009",kudlist[[k]],sep="_")

#write out the file, "E:/R" is the folder that you want, "test" is the output file name
writeOGR(finalshape, 'E:/Atlas_Migration/Elk_Migration/Absaroka_Elk/AbsarokaElk_ReadyforAlethea/ClarksForkElk/Migrants/Absaroka_Elk68_2009/KUDs_68_SummerRange', outname, driver="ESRI Shapefile",overwrite=TRUE)
  }
