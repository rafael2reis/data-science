AreaPolygons<- function(spPoly, proj4string = NULL) { 
  if(class(spPoly)[[1]] != "SpatialPolygonsDataFrame"& 
       class(spPoly)[[1]] != "SpatialPolygons") { 
    stop("spPoly must be a SpatialPolygonsDataFrame or a 
SpatialPolygons object.") 
  } 
  require(sp) 
  require(rgdal) 
  if(!is.null(proj4string)) { 
    if(class(proj4string)[[1]] != "CRS") { 
      stop("The proj4string must be of class CRS") 
    } 
    spP<- spTransform(spPoly, CRS = proj4string) 
  } 
  else { 
    spP<- spPoly 
  } 
  areas<- unlist(lapply(spP@polygons, function(x) a<- x@area)) 
  return(areas) 
}