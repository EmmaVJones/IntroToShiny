## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")



# Read in shapefiles here, if you put shapefiles in global.R then they will be read in twice 
#  Unnecessary and can take a while depending on the size of the shapefile
ecoregions <- readOGR('C:/HardDriveBackup/R/Teaching/learningShiny/CacaponWorkshop2017/3_leafletMapApp/data',
                      'vaECOREGIONlevel3__proj84')
streams <- readOGR('C:/HardDriveBackup/R/Teaching/learningShiny/CacaponWorkshop2017/3_leafletMapApp/data',
                      'Streams_wgs84')

shinyServer(function(input, output, session) {
  
  output$myMap <- renderLeaflet({
    leaflet(probData) %>% addProviderTiles(basemapSelect())%>%
      fitBounds(~min(LongitudeDD),~min(LatitudeDD)
                ,~max(LongitudeDD),~max(LatitudeDD))
  })
  
  # Choose basemap
  basemapSelect <- reactive({switch(input$basemap,
                                    "Aerial"="Esri.WorldImagery"
                                    ,"Street"="OpenStreetMap.HOT"
                                    ,"Landscape"="Thunderforest.Outdoors")})
  
  # Color palette options
  colOptions <- data.frame(stressLevels=as.factor(c("No Probability of Stress to Aquatic Life",
                                                    "Low Probability of Stress to Aquatic Life",
                                                    "Medium Probability of Stress to Aquatic Life",
                                                    "High Probability of Stress to Aquatic Life")))
  pal <- colorFactor(c("blue","limegreen","yellow","red"),levels=colOptions$stressLevels, ordered=T)
  
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
  
  # Plot Probmon data
  observe({
    if(input$checkbox1==TRUE){
      leafletProxy('myMap') %>%
        addMarkers(data=probData,~LongitudeDD,~LatitudeDD,group = "probData_",
                   popup=paste(strong("StationID: "),probData$StationID))
      }else(leafletProxy('myMap')%>%clearGroup('probData_'))})
  
  # Plot Major Rivers shapefile
  observe({
    if(input$checkbox2==TRUE){
      leafletProxy('myMap') %>% 
        addPolylines(data=streams, color='blue', group="streams_",
                     popup=streams@data$NAME)
    }else(leafletProxy('myMap')%>%clearGroup('streams_'))})
    
  
  
  # Plot Ecoregion Shapefile
  observe({
    if(input$checkbox3==TRUE){
      leafletProxy('myMap') %>% 
        addPolygons(data=ecoregions, fill = 0.4, stroke = 0.2, color = 'orange',group = "ecoregions_"
                    ,popup=paste('Ecoregion: ',ecoregions@data$US_L3NAME))
    }else(leafletProxy('myMap')%>%clearGroup('ecoregions_'))})
    
  
  
  # Clear all layers from one button
  observeEvent(eventExpr = input$deselectAll,
               handlerExpr = {lapply(paste0("checkbox", 1:3),
                                              function(x){updateCheckboxInput(session = session,inputId = x,value = FALSE)})})
                 
  
  
  # Select point on map with mouse click
  observe({
    click <- input$myMap_marker_click
    if(is.null(click))
      return()
    text <-paste("You've selected point ", click$lat,"and",click$lng)
    output$Click_text<-renderText({
      text})
    
    # Select data from marker click
    selectedData <- subset(probData, LatitudeDD>=click$lat-0.0001 & LatitudeDD<=click$lat+0.0001 & 
                             LongitudeDD>=click$lng-0.0001 & LongitudeDD<=click$lng+0.0001)
    
  
  # Display selected data
  output$table <- DT::renderDataTable({
    if(is.null(selectedData))
      return(NULL)
    DT::datatable(selectedData,extensions = 'Buttons', escape=F, rownames = F,
                  options=list(
                    columnDefs=list(list(visible=FALSE,targets=4)),
                    pageLength=20,
                    buttons=list('copy',
                                 list(extend='csv',filename=selectedData$StationID),
                                 list(extend='excel',filename=selectedData$StationID))))%>% 
      formatStyle("VSCIVCPMI", backgroundColor = styleInterval(brksVSCI, clrsVSCI))%>%
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
  })
  
  

  # Display all probmon site data
  output$wholetable <- renderTable(probData)
  
  
})


### Tips and Tricks:


# You can choose from many free basemap options that work with leaflet by following this 
#  link: https://leaflet-extras.github.io/leaflet-providers/preview/

## To bring in any shapefiles preprocessed in ArcGIS
#polygons1 <- readOGR("C:/GIS/FolderName","polygonname") # note there are no file extensions 
#polygons2 <- readOGR("C:/GIS/FolderName","polygonname2") 
#polyline1 <-  readOGR("C:/GIS/FolderName","polylinename") 
# add more as needed

# ---------------------------------------------------------------------------------------------------
# If you plan on deploying your app to shinyserver.io (and you are currently working on a Windows
#  machine) you will need to build and test your app by reading in shapefiles locally (e.g. telling
#  R exact file locations readOGR("C:/GIS/FolderName","shapefilename") *BUT* because shiny server 
#  runs on Linux OS you need to comment out those lines (place # before them) and deploy the app 
#  following the protocol below. Remember to remove the comment before the next lines of code before
#  you try and deploy the app or shiny server will not know where to find your GIS files

# polygons1 <- readOGR("data/","polygonname")
# polygons2 <- readOGR("data/","polygonname2") 
# polyline1 <-  readOGR("data/","polylinename") 

# ----------------------------------------------------------------------------------------------------

## Bring in any POINT FILES as .RDS, see 'preprocessData.R' for more information on this process
#pointfile1 <- readRDS('data/pointfile1.RDS')

