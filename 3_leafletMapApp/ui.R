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
                                                                      draggable = T, left = "auto",bottom="auto",height=350,width=350)))),
                             tabPanel("Table")
                  )
                  
)
)
