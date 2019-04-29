## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source('global.R')


## Server processing
shinyServer(function(input, output, session) {
  
  output$dropdownOutput <- renderPrint({ input$dropdown })
  
  output$radioOutput <- renderPrint({ input$radio })
  
 
})