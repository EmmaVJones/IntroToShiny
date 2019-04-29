library(dplyr)
library(readxl)


# This is my preferred method for using point file data in shiny apps or leaflet maps.
#  By taking the raw data and saving it as a native R file format (.RDS) you can 
#  easily load the data into your app faster than a shapefile, it takes up much less
#  space, and because it requires less RAM your app runs faster!

probData <- read_excel('data/ProbMetrics_2001-2014_Final_Web_March_14_2017.xlsx',
                       sheet='Final_ProbMetrics')

# Slim down data for this exercise
probData <- select(probData,c(StationID,LongitudeDD,LatitudeDD,Year,Basin,VSCIVCPMI,DO,pH,SpCond,
                              TP,TN,TotHab,LRBS,MetalCCU,TDS,Na,K,Cl,Sf))

saveRDS(probData,'data/probData.RDS')



## Create factor levels for select variables
probData$DOfactor <- cut(probData$DO,c(0,7,8,10,20)
                                ,labels=c('High Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','No Probability of Stress to Aquatic Life')) 
# trick it into level order needed for pal
levels(probData$DOfactor) <- list('No Probability of Stress to Aquatic Life'='No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life'='Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life'='Medium Probability of Stress to Aquatic Life ','High Probability of Stress to Aquatic Life'='High Probability of Stress to Aquatic Life')
# trick it to have 4 levels for color pal purposes
probData$pHfactor <- cut(probData$pH,c(-1,0,6,9,15,16)
                                ,labels=rev(c('High Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life (-)','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life (+)'
                                              ,'No Probability of Stress to Aquatic Life'))) 
levels(probData$pHfactor) <- list('No Probability of Stress to Aquatic Life'='No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life'='Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life'=c('Medium Probability of Stress to Aquatic Life (-)','Medium Probability of Stress to Aquatic Life (+)'),'High Probability of Stress to Aquatic Life'='High Probability of Stress to Aquatic Life')
probData$SpCondfactor <- cut(probData$SpCond,c(0,250,350,500,4000)
                                    ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$TPfactor <- cut(probData$TP,c(0,0.02,0.05,0.1,5)
                                ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$TNfactor <- cut(probData$TN,c(0,0.5,1,2,100)
                                ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$TotHabfactor <- cut(probData$TotHab,c(0,100,130,150,200)
                                    ,labels=c('High Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','No Probability of Stress to Aquatic Life')) 
# trick it into level order needed for pal
levels(probData$TotHabfactor) <- list('No Probability of Stress to Aquatic Life'='No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life'='Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life'='Medium Probability of Stress to Aquatic Life ','High Probability of Stress to Aquatic Life'='High Probability of Stress to Aquatic Life')

probData$TDSfactor <- cut(probData$TDS,c(0,100,250,350,50000)
                                 ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$MetalCCUfactor <- cut(probData$MetalCCU,c(0,0.75,1.5,2.0,50)
                                      ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
# trick it to have 4 levels for color pal purposes
probData$LRBSfactor <- cut(probData$LRBS,c(-20,-1.5,-1.0,-0.5,0.5,15)
                                  ,labels=rev(c('High Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life (-)','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life (+)'
                                                ,'No Probability of Stress to Aquatic Life'))) 
levels(probData$LRBSfactor) <- list('No Probability of Stress to Aquatic Life'='No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life'='Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life'=c('Medium Probability of Stress to Aquatic Life (-)','Medium Probability of Stress to Aquatic Life (+)'),'High Probability of Stress to Aquatic Life'='High Probability of Stress to Aquatic Life')
probData$Nafactor <- cut(probData$Na,c(0,7,10,20,500)
                                ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$Kfactor <- cut(probData$K,c(0,1,2,10,500)
                               ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$Clfactor <- cut(probData$Cl,c(0,10,25,50,500)
                                ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$Sffactor <- cut(probData$Sf,c(0,10,25,75,500)
                                ,labels=c('No Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','High Probability of Stress to Aquatic Life')) 
probData$VSCIfactor <- cut(probData$VSCIVCPMI,c(0,42,60,72,115)
                                  ,labels=c('High Probability of Stress to Aquatic Life','Medium Probability of Stress to Aquatic Life','Low Probability of Stress to Aquatic Life','No Probability of Stress to Aquatic Life')) 


# double check all factors came in correctly
str(probData)


# Make long format of dataset for map circleMarkers
probData_ <- mutate(probData,VSCIAll=VSCIVCPMI,VSCI=VSCIVCPMI)%>%
  rename(Longitude=LongitudeDD,Latitude=LatitudeDD)%>%
  select(-c(Year,VSCIVCPMI,VSCI,DO,pH,SpCond,TP,TN,TotHab,TDS,MetalCCU,LRBS,Na,K,Cl,Sf))%>%
  reshape2::melt(id=c('StationID',"Longitude","Latitude","Basin","VSCIAll"))%>%
  filter(!is.na(value))%>%
  mutate(joincolumn=gsub("(.*)f.*","\\1",variable))

# do the same with regular data so it iwll be available for a popup in the final leaflet map
probData_1 <- mutate(probData,VSCI=VSCIVCPMI,VSCIAll=VSCIVCPMI)%>%
  rename(Longitude=LongitudeDD,Latitude=LatitudeDD)%>%select(-VSCIVCPMI)%>%
  select(c(StationID,Longitude,Latitude,Basin,VSCIAll,VSCI,DO,pH,SpCond,TP,TN,TotHab,TDS,
           MetalCCU,LRBS,Na,K,Cl,Sf))%>%
  reshape2::melt(id=c('StationID',"Longitude","Latitude","Basin" ,"VSCIAll"))%>%
  filter(!is.na(value))%>%mutate(joincolumn=variable)%>%
  merge(probData_,by=c('joincolumn','StationID',"Longitude","Latitude","Basin" ,"VSCIAll"))%>%
  rename(Parameter=variable.x,ParameterMeasure=value.x,ParameterFactor=variable.y,ParameterFactorLevel=value.y)%>%
  select(-joincolumn)%>%
  mutate(units=Parameter)# make column with units for popups
probData_1$units <- dplyr::recode(probData_1$units,"VSCI"="(unitless)","DO"="mg/L","pH"="(unitless)","SpCond"="uS/cm","TP"="mg/L","TN"="mg/L","TotHab"="(unitless)",
                                         "TDS"="mg/L","MetalCCU"="(unitless)","LRBS"="(unitless)","Na"="mg/L","K"="mg/L","Cl"="mg/L",
                                         "Sf"="mg/L")



saveRDS(probData_1,'data/probData_long.RDS')
