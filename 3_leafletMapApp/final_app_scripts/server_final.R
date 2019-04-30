

# you must change the file name to server.R in order for this to run




































## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")


ecoregions <- readOGR('data', 'vaECOREGIONlevel3__proj84')
streams <- readOGR('data', 'Streams_wgs84')

shinyServer(function(input, output, session) {
  
  # Choose basemap
  basemapSelect <- reactive({switch(input$basemap,
                                    "Aerial"="Esri.WorldImagery",
                                    "Street"="OpenStreetMap",
                                    "Topography" = "OpenTopoMap")})
  
  
  output$myMap <- renderLeaflet({
    leaflet(probData) %>% addProviderTiles(basemapSelect())%>%
      fitBounds(~min(LongitudeDD),~min(LatitudeDD),
                ~max(LongitudeDD),~max(LatitudeDD))
  })
  
  # toggle point data on and off on map
  observe({
    if(input$checkbox1==TRUE){
      leafletProxy('myMap') %>%
        addMarkers(data=probData,~LongitudeDD,~LatitudeDD,group = "probData_",
                   popup=paste(strong("StationID: "),probData$StationID))
    }else(leafletProxy('myMap')%>%clearGroup('probData_'))})
  
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
  
  
  observeEvent(eventExpr = input$deselectAll,
               handlerExpr = {lapply(paste0("checkbox", 1:3),
                                     function(x){updateCheckboxInput(session = session,inputId = x,value = FALSE)})})
  
  
  
  
  
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
    
    output$table <- DT::renderDataTable({
      if(is.null(selectedData))
        return(NULL)
      DT::datatable(selectedData,extensions = 'Buttons', escape=F, rownames = F,
                    options=list(dom='Bfrtip',#'Bt',
                                 #B=Buttons, f= filter, r=processing, t =table, i=table information, p= pagination
                                 scrollX = TRUE, # play with this to see how table rendering changes screen width
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
  })
  
  output$wholetable <- renderTable(probData)
  
  
  dataSelect <- reactive({switch(input$parameterToPlot,
                                 'VSCI'='VSCIfactor','Dissolved Oxygen'='DOfactor','pH'='pHfactor',
                                 'Specific Conductivity'='SpCondfactor','Total Phosphorus'='TPfactor',
                                 'Total Nitrogen'='TNfactor','Total Habitat'='TotHabfactor',
                                 'Total Dissolved Solids'='TDSfactor','Metals CCU'='MetalCCUfactor',
                                 'LRBS'='LRBSfactor','Dissolved Sodium'='Nafactor','Dissolved Potassium'='Kfactor',
                                 'Dissolved Chloride'='Clfactor','Dissolved Sulfate'='Sffactor')})
  
  filteredData <- reactive({
    df2 <- subset(probData_long,ParameterFactor==dataSelect())
  })
  
  
  observe({
    leafletProxy('myMap',data=filteredData()) %>% clearMarkers() %>%
      addCircleMarkers(color=~pal(ParameterFactorLevel),fillOpacity=1,stroke=FALSE
                       ,popup=paste(sep = "<br/>",paste(strong("StationID: "),filteredData()$sampleID,sep="")
                                    ,paste(strong("VSCI Score: "),prettyNum(filteredData()$VSCIAll,digits=3),sep="")
                                    ,paste(strong(filteredData()$Parameter[1]),": ",
                                           prettyNum(filteredData()$ParameterMeasure,digits=4)," ",
                                           filteredData()$units,sep="")))})
  
})


### Tips and Tricks:


# You can choose from many free basemap options that work with leaflet by following this 
#  link: https://leaflet-extras.github.io/leaflet-providers/preview/

## To bring in any shapefiles preprocessed in ArcGIS using sp library
#polygons1 <- rgdal::readOGR("FolderName","polygonname") # note there are no file extensions 
#polygons2 <- rgdal::readOGR("FolderName","polygonname2") 
#polyline1 <-  rgdal::readOGR("FolderName","polylinename") 
# add more as needed


## To bring in any shapefiles preprocessed in ArcGIS using sf library (preferred method as of ~2016)
#polygons1 <- sf::st_read("FolderName/polygonname.shp") # note there are no file extensions 
#polygons2 <- sf::st_read("FolderName/polygonname2.shp") 
#polyline1 <-  sf::st_read("FolderName/polylinename.shp") 
# add more as needed


## Always move GIS data into your working directory if you plan on deploying app on any server.
# If you do not, the server will look for the file in a location that it (likely) does not have 
# access to and will bomb out your app.


## Bring in any POINT FILES as .RDS, see 'preprocessData.R' for more information on this process
#pointfile1 <- readRDS('data/pointfile1.RDS')

