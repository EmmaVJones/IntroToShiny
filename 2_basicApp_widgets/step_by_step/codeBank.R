# This script is meant to assist you both in and out of the workshop. Feel free to copy/paste
#  code from this script into the appropriate files to run your app in case you miss a step as 
#  we are walking through it together. You can also use this script as you build your own apps 
#  because it is organized in paired ui/server blocks of code that demonstrate complete reactive 
#  elements. 
 
# We will apply the following steps in order to transform our ui/server files (ui_start.R and 
#  server_start.R, respectively) into the final app (final_app_scripts/ui_final.R and 
#  final_app_scripts/ui_final.R).




# 1) Fix the radiobutton server output such that it actually subsets data

#### SERVER, anywhere but preferably after the first two output$ functions for flow/understanding

# Switch is critical for radio buttons and other user input widgets. It transforms the 
#  user input into a format you can use for your own data manipulation or server calls

indicator <- reactive({
  switch(input$radio,"1"="VSCIAll","2"="TotalHabitat")})

cdfsubset <- reactive({
  cdf2 <- filter(cdfdata, Subpopulation == input$dropdown, Indicator == indicator() )
  return(cdf2)
})








# 2) Add a table to user interface to preview the data

#### UI, in mainPanel() after radioOutput call; DON'T FORGET COMMA!

tableOutput("tablePreview")

#### SERVER

# Now display subsetted data to the user
output$tablePreview <- renderTable({
  head(cdfsubset(),15)
})







# 3) Plot the cdfdata subset, add an option for user to toggle the confidence intervals on and off

#### UI
# In the sidebarPanel after the radiobutton, DON'T FORGET COMMA!
hr(),
checkboxInput('conf',"Plot Confidence Intervals")

# In the mainPanel after the tableOutput, DON'T FORGET COMMA!
br(),
br(),
hr(),
plotOutput('cdfplot')


#### SERVER

output$cdfplot <- renderPlot({
  cdfplotFunction(cdfsubset(),input$dropdown,indicator(),input$conf)
})








# 4) Add a downloadButton to let users download a flat file of their data subset

#### UI, in sidebarPanel after checkboxInput, DON'T FORGET COMMA!
hr(),
br(),
downloadButton('downloadCDFsubset',"Download CDF data")


#### SERVER
output$downloadCDFsubset <- downloadHandler(filename=function(){paste('cdfsubset_',Sys.Date(),'.csv',sep='')},
                                            content=function(file){
                                              write.csv(cdfsubset(),file)})








# 5) Add all Subpopulation options to selectInput()

#### UI

# Delete selectInput() and put this instead (in sidebarPanel)
uiOutput('dropdownwithallcsvoptions'),


#### SERVER, anywhere but for flow make this the first function

# Delete output$dropdownOutput, replace with this:
output$dropdownwithallcsvoptions <- renderUI({
  selectInput("dropdownwithallcsvoptions","Select Population to Plot",
              unique(cdfdata$Subpopulation))})

# Update the cdfsubset() accordingly

# Because we added a reactive element to the server side, we need to give the server
#  a break and let it process. Basically, insert the next chunk into cdfsubset()
#  after the reactive({ call to prevent an error message from initially popping up 
#  when the app is first loaded. 

# cdfsubset <- reactive({
if(is.null(input$dropdownwithallcsvoptions))
  return(NULL)
# then the rest of that function

# Because we gave cdfsubset() a second to think, we need to do the same for all of the 
#  subsequent functions that use cdfsubset()

# output$tablePreview <- renderTable({
if(is.null(cdfsubset()))
  return(NULL)
# then the rest of that function


#output$cdfplot <- renderPlot({
if(is.null(cdfsubset()))
  return(NULL)
# then the rest of that function


# This will stop the server from initally freaking out that it doesn't have something to 
#  display/plot right when the app loads (because it is still processing the renderUI)
# This is a great trick for most reactive elements that give errors initially as the app is loading.

