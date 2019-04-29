## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")


## Build user interface (how your app looks)
shinyUI(
  fluidPage(
    titlePanel("My First App"),
    
    # Sidebar/Main Panel Layout
    sidebarLayout(
      sidebarPanel(
        selectInput('dropdown',label="Select Population to Plot",
                    choices=list("Virginia"="Virginia",
                                 "Blue Ridge Mountains"="BlueRidge",
                                 "Central Appalachian Ridges and Valleys"="CentralAppsRV",
                                 "Central Appalachians"="CentralApps",
                                 "Northern Piedmont"="NPiedmont",
                                 "Piedmont"="Piedmont",
                                 "Southeastern Plains"="SEPlains"),
                    selected="Virginia"),
        radioButtons('radio',label="Select Indicator to Plot",
                     choices=list("VSCI"=1,"Habitat"=2),     # radioButtons only take numeric 
                     selected=1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        verbatimTextOutput("dropdownOutput"),
        verbatimTextOutput("radioOutput")
      )
    )
  )
)
    
    