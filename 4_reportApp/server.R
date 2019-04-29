## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source('global.R')


## Server processing
shinyServer(function(input, output, session) {
  
  output$dropdownOutput <- renderPrint({ input$dropdownwithallcsvoptions })
  
  output$radioOutput <- renderPrint({ input$radio }) 
  
  output$dropdownwithallcsvoptions <- renderUI({
    selectInput("dropdownwithallcsvoptions","Select Population to Plot",
                unique(cdfdata$Subpopulation))})
  
  # Switch is critical for radio buttons and other user input widgets. It transforms the 
  #  user input into a format you can use for your own data manipulation or server calls
  
  indicator <- reactive({
    switch(input$radio,"1"="VSCIAll","2"="TotalHabitat")})
  
  cdfsubset <- reactive({
    if(is.null(input$dropdownwithallcsvoptions))
      return(NULL)
    cdf2 <- filter(cdfdata, Subpopulation == input$dropdownwithallcsvoptions, Indicator == indicator() )
    return(cdf2)
  })
  
  
  output$tablePreview <- renderTable({
    if(is.null(cdfsubset()))
      return(NULL)
    head(cdfsubset())
  })
  
  
  output$cdfplot <- renderPlot({
    if(is.null(cdfsubset()))
      return(NULL)
    cdfplotFunction(cdfsubset(),input$dropdown,indicator(),input$conf)
  })
  
  output$downloadCDFsubset <- downloadHandler(filename=function(){paste('cdfsubset_',Sys.Date(),'.csv',sep='')},
                                              content=function(file){
                                                write.csv(cdfsubset(),file)}
  )
  
  
  ####--------------------------------------- RMARKDOWN SECTION--------------------------------------------------
  
  # Make a reactive function to store the cdfplot
  cdfplotforMarkdown <- reactive({
    if(is.null(cdfsubset()))
    return(NULL)
    cdfplotFunction(cdfsubset(),input$dropdown,indicator(),input$conf)})
  
  
  output$report <- downloadHandler(
    "report.html",
    content= function(file){
      tempReport <- file.path(tempdir(),"reportHTML.Rmd")
      file.copy("reportHTML.Rmd",tempReport,overwrite = T)
      params <- list(table_usersubset=cdfsubset(), # don't need to make a new reactive object because it is already reactive
                     plot_cdfplot=cdfplotforMarkdown())
  
      rmarkdown::render(tempReport,output_file = file,
                        params=params,envir=new.env(parent = globalenv()))})
  
})