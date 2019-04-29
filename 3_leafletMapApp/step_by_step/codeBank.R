# This script is meant to assist you both in and out of the workshop. Feel free to copy/paste
#  code from this script into the appropriate files to run your app in case you miss a step as 
#  we are walking through it together. You can also use this script as you build your own apps 
#  because it is organized in paired ui/server blocks of code that demonstrate complete reactive 
#  elements. 

# We will apply the following steps in order to transform our ui/server files (ui_start.R and 
#  server_start.R, respectively) into the final app (final_app_scripts/ui_final.R and 
#  final_app_scripts/ui_final.R).






# 1) Hook up leaflet map to our data

#### SERVER, delete previous output$myMap <- renderLeaflet() statement and replace with:

output$myMap <- renderLeaflet({
  leaflet(probData) %>% addProviderTiles('Thunderforest.Outdoors')%>%
    fitBounds(~min(LongitudeDD),~min(LatitudeDD),
              ~max(LongitudeDD),~max(LatitudeDD))
})








# 2) Add an option to change the basemap in the absolute panel

#### UI
# Put in absolute panel; DON'T FORGET COMMA!

# first name it legend
h4(strong("Legend"))

selectInput("basemap",
            label = 'Choose a basemap style',  
            choices=c('Aerial','Street','Landscape'),
            selected='Aerial')


#### SERVER

# Choose basemap
basemapSelect <- reactive({switch(input$basemap,
                                  "Aerial"="Esri.WorldImagery"
                                  ,"Street"="OpenStreetMap.HOT"
                                  ,"Landscape"="Thunderforest.Outdoors")})
# Change Thunderforest.Outdoors above to addProviderTiles(basemapSelect()) to make 
#  server change the basemap













# 3) Plot Probmon data on Map

#### UI, put below selectInput; DON'T FORGET COMMA!
column(12,
       wellPanel(h4("ProbMon Data"),
                 checkboxInput('checkbox1','Plot Probmon data',value=F)))

#### SERVER
observe({
  if(input$checkbox1==TRUE){
    leafletProxy('myMap') %>%
      addMarkers(data=probData,~LongitudeDD,~LatitudeDD,group = "probData_",
                 popup=paste(strong("StationID: "),probData$StationID))
  }else(leafletProxy('myMap')%>%clearGroup('probData_'))})












# 4) Plot shapefiles on map
# Read in data in server.R (ABOVE shinyServer()); must be in WGS84 projection to work with leaflet
# You will need to change the exact file location to work with your computer
ecoregions <- readOGR('C:/HardDriveBackup/R/Teaching/learningShiny/CacaponWorkshop2017/3_leafletMapApp/data',
                      'vaECOREGIONlevel3__proj84')
streams <- readOGR('C:/HardDriveBackup/R/Teaching/learningShiny/CacaponWorkshop2017/3_leafletMapApp/data',
                   'Streams_wgs84')


#### UI; DON'T FORGET COMMA!

# put outside wellPanel but still in absolutePanel
checkboxInput('checkbox2','Plot Major Rivers',value=F),
checkboxInput('checkbox3','Plot Ecoregions',value=F)


#### SERVER
observe({
  if(input$checkbox2==TRUE){
    leafletProxy('myMap') %>% 
      addPolylines(data=streams, color='blue', group="streams_",
                   popup=streams@data$NAME)
  }else(leafletProxy('myMap')%>%clearGroup('streams_'))})


observe({
  if(input$checkbox3==TRUE){
    leafletProxy('myMap') %>% 
      addPolygons(data=ecoregions, fill = 0.4, stroke = 0.2, color = 'orange',group = "ecoregions_"
                  ,popup=paste('Ecoregion: ',ecoregions@data$US_L3NAME))
  }else(leafletProxy('myMap')%>%clearGroup('ecoregions_'))})














# 5) Make action button to remove all layers at once

#### UI, for flow I like to place right after selectInput()
actionButton('deselectAll','Deselect All Layers'),
br(),br(),

#### SERVER

#change ncheckboxes to total number of checkboxes you have in the app
observeEvent(eventExpr = input$deselectAll,
             handlerExpr = {lapply(paste0("checkbox", 1:NUMBER OF CHECKBOXES YOU HAVE IN APP),
                                   function(x){updateCheckboxInput(session = session,inputId = x,value = FALSE)})})











# 6) Click point on map and get lat/long

#### UI

# change absolutePanel height to 'auto'

# great for testing what R is seeing
verbatimTextOutput('Click_text')

#### SERVER

# Select point on map with mouse click
observe({
  click <- input$myMap_marker_click
  if(is.null(click))
    return()
  text <-paste("You've selected point ", click$lat,"and",click$lng)
  output$Click_text<-renderText({
    text})
}) 


# 7) Tell server to subset original dataset based on click results

#### SERVER, change observe call in step 6 to this
observe({
  click <- input$myMap_marker_click
  if(is.null(click))
    return()
  text <-paste("You've selected point ", click$lat,"and",click$lng)
  #output$Click_text<-renderText({
  #  text})
  
  
  
  # Select data from marker click
  selectedData <- subset(probData, LatitudeDD>=click$lat-0.0001 & LatitudeDD<=click$lat+0.0001 & 
                           LongitudeDD>=click$lng-0.0001 & LongitudeDD<=click$lng+0.0001)
  
  output$Click_text <- renderText({selectedData$StationID})
})









# 8) Display clicked data

#### UI, in Table tabPanel
DT::dataTableOutput("table")


#### SERVER, in previous observe statement

output$table <- DT::renderDataTable({
  if(is.null(selectedData))
    return(NULL)
  DT::datatable(selectedData)
})


# 9) DT package extensions: buttons 

#### SERVER, replace previous output$table <- with this
# MUST RUN EXTERNAL TO SEE ALL OPTIONS

output$table <- DT::renderDataTable({
  if(is.null(selectedData))
    return(NULL)
  DT::datatable(selectedData,extensions = 'Buttons', escape=F, rownames = F,
                options=list(dom='Bfrtip',#'Bt',
                             #B=Buttons, f= filter, r=processing, t =table, i=table information, p= pagination
                             buttons=list('copy',
                                          list(extend='csv',filename=selectedData$StationID),
                                          list(extend='excel',filename=selectedData$StationID))))%>%
    formatStyle("pH", backgroundColor = styleInterval(brkspH, clrspH))%>%
    formatStyle("DO", backgroundColor = styleInterval(brksDO, clrsDO)) %>%
    formatStyle("TN", backgroundColor = styleInterval(brksTN, clrsTN))%>%
    formatStyle("TP", backgroundColor = styleInterval(brksTP, clrsTP))%>%
    formatStyle("TotHab", backgroundColor = styleInterval(brksTotHab, clrsTotHab))%>%
    formatStyle("LRBS", backgroundColor = styleInterval(brksLRBS, clrsLRBS))%>%
    formatStyle("MetalCCU", backgroundColor = styleInterval(brksMCCU, clrsMCCU))%>%
    formatStyle("SpCond", backgroundColor = styleInterval(brksSpCond, clrsSpCond))%>%
    formatStyle("TDS", backgroundColor = styleInterval(brksTDS, clrsTDS))%>%
    formatStyle("Sf", backgroundColor = styleInterval(brksDS, clrsDS))%>%
    formatStyle("Cl", backgroundColor = styleInterval(brksDChl, clrsDChl))%>%
    formatStyle("K", backgroundColor = styleInterval(brksDK, clrsDK))%>%
    formatStyle("Na", backgroundColor = styleInterval(brksDNa, clrsDNa))})
              










# 10) Show difference between tableOutput and DT::dataTableOutput

#### UI, replace previous tabPanel('Table') with below
tabPanel("Table",
         tabsetPanel(
           tabPanel('Selected Data',
                    h2("Sellected Data"),
                    DT::dataTableOutput("table")),
           tabPanel('All Data',
                    h2("All Data"),
                    tableOutput("wholetable"))))
        

#### SERVER
output$wholetable <- renderTable(probData)













# 11) Change Markers plotted and color based on selectInput

# 11a. Recolor prob points based on stress level

#### UI
selectInput("parameterToPlot"
            ,label = 'Choose a water quality parameter to display'
            ,choices=c('','VSCI','pH','Dissolved Oxygen','Total Nitrogen','Total Phosphorus'
                       ,'Total Habitat','LRBS','Metals CCU','Specific Conductivity','Total Dissolved Solids'
                       ,'Dissolved Sulfate','Dissolved Chloride','Dissolved Potassium','Dissolved Sodium')
            , selected='')


#### SERVER, put above add prob data
colOptions <- data.frame(stressLevels=as.factor(c("No Probability of Stress to Aquatic Life",
                                                  "Low Probability of Stress to Aquatic Life",
                                                  "Medium Probability of Stress to Aquatic Life",
                                                  "High Probability of Stress to Aquatic Life")))

pal <- colorFactor(c("blue","limegreen","yellow","red"),levels=colOptions$stressLevels, ordered=T)


# 11b) Connect changes on server side

#### SERVER
# switch user input data to match what is in dataset behind the scenes
dataSelect <- reactive({switch(input$parameterToPlot,
                               'VSCI'='VSCIfactor','Dissolved Oxygen'='DOfactor','pH'='pHfactor',
                               'Specific Conductivity'='SpCondfactor','Total Phosphorus'='TPfactor',
                               'Total Nitrogen'='TNfactor','Total Habitat'='TotHabfactor',
                               'Total Dissolved Solids'='TDSfactor','Metals CCU'='MetalCCUfactor',
                               'LRBS'='LRBSfactor','Dissolved Sodium'='Nafactor','Dissolved Potassium'='Kfactor',
                               'Dissolved Chloride'='Clfactor','Dissolved Sulfate'='Sffactor')})


# Subset probData based on input parameter
filteredData <- reactive({
  df2 <- subset(probData_long,ParameterFactor==dataSelect())
})

# Update map markers when user changes parameter
observe({
  leafletProxy('myMap',data=filteredData()) %>% clearMarkers() %>%
    addCircleMarkers(color=~pal(ParameterFactorLevel),fillOpacity=1,stroke=FALSE
                     ,popup=paste(sep = "<br/>",paste(strong("StationID: "),filteredData()$sampleID,sep="")
                                  ,paste(strong("VSCI Score: "),prettyNum(filteredData()$VSCIAll,digits=3),sep="")
                                  ,paste(strong(filteredData()$Parameter[1]),": ",
                                         prettyNum(filteredData()$ParameterMeasure,digits=4)," ",
                                         filteredData()$units,sep="")))})
