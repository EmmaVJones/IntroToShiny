

# you must change the file name to ui.R in order for this to run

























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
        uiOutput('dropdownwithallcsvoptions'),
        radioButtons('radio',label="Select Indicator to Plot",
                     choices=list("VSCI"=1,"Habitat"=2),     # radioButtons only take numeric 
                     selected=1),
        hr(),
        checkboxInput('conf',"Plot Confidence Intervals"),
        hr(),
        br(),
        downloadButton('downloadCDFsubset',"Download CDF data")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        verbatimTextOutput("dropdownOutput"),
        verbatimTextOutput("radioOutput"),
        tableOutput("tablePreview"),
        br(),
        br(),
        hr(),
        plotOutput('cdfplot')
      )
    )
  )
)
    
    