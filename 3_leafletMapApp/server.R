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

