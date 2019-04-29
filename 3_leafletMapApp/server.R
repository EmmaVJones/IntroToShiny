## Source global.R file
## This file must be in the same directory as your ui.R and server.R files
source("global.R")


shinyServer(function(input, output, session) {
  
  output$myMap <- renderLeaflet({
    leaflet() %>% addProviderTiles('Thunderforest.Outdoors')
  })
  
  
  
  
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

