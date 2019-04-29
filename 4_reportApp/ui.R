## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")



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
        plotOutput('cdfplot'),
        fluidPage(
          column(12,
                 wellPanel(h4('Report Output:'),
                           helpText('Click below to save a .HTML version of all the tables and graphics associated with 
                                                                           the input station. You can save this to a .pdf after initial HTML conversion 
                                                                           (File -> Print -> Save as PDF).'),
                           downloadButton('report','Generate Report'))))
        
      )
    )
  )
)
