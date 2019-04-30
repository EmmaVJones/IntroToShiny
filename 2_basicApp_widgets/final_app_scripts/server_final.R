
# you must change the file name to server.R in order for this to run






























## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source('global.R')


## Server processing
shinyServer(function(input, output, session) {
  
  output$dropdownwithallcsvoptions <- renderUI({
    selectInput("dropdownwithallcsvoptions","Select Population to Plot",
                unique(cdfdata$Subpopulation))})
  
  
  output$radioOutput <- renderPrint({ input$radio })
  
  indicator <- reactive({
    switch(input$radio,"1"="VSCIAll","2"="TotalHabitat")})
  
  cdfsubset <- reactive({
    req(input$dropdownwithallcsvoptions)
    cdf2 <- filter(cdfdata, Subpopulation == input$dropdownwithallcsvoptions, Indicator == indicator() )
    return(cdf2)
  })
  
  output$tablePreview <- renderTable({
    req(cdfsubset())
    head(cdfsubset(),15)
  })
  
  output$cdfplot <- renderPlot({
    req(cdfsubset())
    cdfplotFunction(cdfsubset(),input$dropdownwithallcsvoptions,indicator(),input$conf)
  })
  
  output$downloadCDFsubset <- downloadHandler(
    filename=function(){
      # filename, note we customized it based on the user subset data
      paste('cdfsubset', indicator(), input$radio, Sys.Date(),'.csv', sep='_')},
    content=function(file){
      write.csv(cdfsubset(),file)})
  
  
})