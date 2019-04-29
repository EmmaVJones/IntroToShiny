# Call up the libraries you need to use to run the app
library(shiny) # Makes shiny apps
library(plyr) # Data manipulation
library(dplyr) # Data manipulation
library(ggplot2) # Elegant plots
library(DT) # Better table options
library(rmarkdown) # Reporting package

# Bring in your data for app
cdfdata <- read.csv('data/sampleCDFdata.csv')


# Also define any functions here

# CDF plot function
cdfplotFunction <- function(data,parameter,indicator,confIntervals){
  n <- max(data$NResp)
  
  if(confIntervals==FALSE){
    ggplot(data, aes(x=Value,y=Estimate.P)) + geom_point() + 
      labs(x=indicator,y="Percentile") +
      ggtitle(paste(parameter,"Percentile Graph ( n =",n,")",sep=" ")) +
      theme(plot.title = element_text(hjust=0.5,face='bold',size=15),
            axis.title = element_text(face='bold',size=12))
  }else{
    ggplot(data, aes(x=Value,y=Estimate.P)) + geom_point() + 
      labs(x=indicator,y="Percentile") +
      ggtitle(paste(parameter,"Percentile Graph ( n =",n,")",sep=" ")) +
      theme(plot.title = element_text(hjust=0.5,face='bold',size=15),
            axis.title = element_text(face='bold',size=12))+
      geom_line(aes(x=Value,y=LCB95Pct.P),color='orange')+
      geom_line(aes(x=Value,y=UCB95Pct.P),color='orange')
  }
}


