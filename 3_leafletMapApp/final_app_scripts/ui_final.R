# you must change the file name to server.R in order for this to run








































## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")

## Build user interface (how your app looks), this one will be slightly more complex with 
#   navigation bar and bootstrap page
shinyUI(fluidPage(theme="yeti.css",
                  navbarPage("My Map App",theme='bootstrap.css',
                             tabPanel("About",
                                      h3("Instructions"),
                                      p("This is where you can write instructions."),
                                      h4("And give yourself credit for buiding an app")),
                             tabPanel("Map",
                                      bootstrapPage(div(class="outer",
                                                        tags$style(type ="text/css",".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                                        
                                                        leafletOutput("myMap", width="100%", height="100%"),
                                                        
                                                        absolutePanel(top=60, right=10,class="panel panel-default",fixed=T,style = "overflow-y:scroll; max-height: 400px",
                                                                      draggable = T, left = "auto",bottom="auto",height='auto',width=350,
                                                                      h4(strong("Legend")),
                                                                      selectInput("basemap",
                                                                                  label = 'Choose a basemap style',  
                                                                                  choices=c('Aerial','Street','Topography'),
                                                                                  selected='Aerial'),
                                                                      selectInput("parameterToPlot"
                                                                                  ,label = 'Choose a water quality parameter to display'
                                                                                  ,choices=c('','VSCI','pH','Dissolved Oxygen','Total Nitrogen','Total Phosphorus'
                                                                                             ,'Total Habitat','LRBS','Metals CCU','Specific Conductivity','Total Dissolved Solids'
                                                                                             ,'Dissolved Sulfate','Dissolved Chloride','Dissolved Potassium','Dissolved Sodium')
                                                                                  , selected=''),
                                                                      actionButton('deselectAll','Deselect All Layers'),
                                                                      br(),br(),
                                                                      wellPanel(h4("ProbMon Data"),
                                                                                checkboxInput('checkbox1','Plot Probmon data',value=F)),
                                                                      checkboxInput('checkbox2','Plot Major Rivers',value=F),
                                                                      checkboxInput('checkbox3','Plot Ecoregions',value=F)#,
                                                                      # great for testing what R is seeing
                                                                      #verbatimTextOutput('Click_text')
                                                        )))),
                             tabPanel("Table",
                                      tabsetPanel(
                                        tabPanel('Selected Data',
                                                 h2("Sellected Data"),
                                                 DT::dataTableOutput("table")),
                                        tabPanel('All Data',
                                                 h2("All Data"),
                                                 tableOutput("wholetable"))))
                             
                             
                  )
                  
)
)
