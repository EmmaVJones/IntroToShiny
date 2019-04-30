# Call up the libraries you need to use to run the app
library(shiny) # Makes shiny apps
library(leaflet) # Makes interactive maps
library(plyr) # Data manipulation
library(dplyr) # Data manipulation
library(ggplot2) # Elegant plots
library(DT) # Better table options
library(rgdal) # Read in spatial data


# Bring in your data for app
probData <- readRDS('data/probData.RDS')
probData_long <- readRDS('data/probData_long.RDS')


# Color breaks for table formatting
brksVSCI <- c(0,60,100)
clrsVSCI <- c("gray","red","limegreen","gray")
brkspH <- c(0,6,9)
clrspH <- c("gray","yellow","limegreen","yellow")
brksDO <- c(0,7,8,10)
clrsDO <- c("gray","red","yellow","limegreen","cornflowerblue")
brksTN <- c(0,0.5,1,2)
clrsTN <- c("gray","cornflowerblue","limegreen","yellow","red")
brksTP <- c(0,0.02,0.05,0.1)
clrsTP <- c("gray","cornflowerblue","limegreen","yellow","red")
brksTotHab <- c(0,100,130,150)
clrsTotHab <- c("gray","red","yellow","limegreen","cornflowerblue")
brksLRBS <- c(-3,-1.5,-1,-0.5,0.5)
clrsLRBS <- c("gray","red","yellow","limegreen","cornflowerblue","yellow")
brksMCCU <- c(0,0.75,1.5,2.0)
clrsMCCU <- c("gray","cornflowerblue","limegreen","yellow","red")
brksSpCond <- c(0,250,350,500)
clrsSpCond <- c("gray","cornflowerblue","limegreen","yellow","red")
brksTDS <- c(0,100,250,350)
clrsTDS <- c("gray","cornflowerblue","limegreen","yellow","red")
brksDS <- c(0,10,25,75)
clrsDS <- c("gray","cornflowerblue","limegreen","yellow","red")
brksDChl <- c(0,10,25,50)
clrsDChl <- c("gray","cornflowerblue","limegreen","yellow","red")
brksDK <- c(0,1,2,10)
clrsDK <- c("gray","cornflowerblue","limegreen","yellow","red")
brksDNa <- c(0,7,10,20)
clrsDNa <- c("gray","cornflowerblue","limegreen","yellow","red")

colOptions <- data.frame(stressLevels=as.factor(c("No Probability of Stress to Aquatic Life",
                                                  "Low Probability of Stress to Aquatic Life",
                                                  "Medium Probability of Stress to Aquatic Life",
                                                  "High Probability of Stress to Aquatic Life")))

pal <- colorFactor(c("blue","limegreen","yellow","red"),levels=colOptions$stressLevels, ordered=T)





