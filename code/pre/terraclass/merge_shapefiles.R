rm(list = ls())

library(rgdal); library(maptools); library(parallel)

source("read_shapefile.R")

estados.2012 <- read.table('terraclass_arquivos_2012_teste.csv', colClasses = "character")
poly.data <- NULL
uid <- 1

for (i in 1:nrow(estados.2012)) {
  estado <- estados.2012[i, 1]
  orbitas.ponto <- unlist(strsplit(estados.2012[i, 2], "[,]"))
  
  leu.primeiro <- FALSE
  for(j in 1:length(orbitas.ponto)) {
    if (!leu.primeiro) {
      poly.data <- ReadShapefile(ano = '2012', estado = estado, orbitaPonto = orbitas.ponto[j])
  
      if (length(poly.data) > 0) {
        existe <- poly.data$tc_2012 == 'VEGETACAO_SECUNDARIA'
        
        if (any(existe)) {
          poly.data <- poly.data[poly.data$tc_2012 == 'VEGETACAO_SECUNDARIA', ]
          n <- length(slot(poly.data, "polygons"))
          poly.data <- spChFIDs(poly.data, as.character(uid:(uid+n-1)))
          uid <- uid + n
          leu.primeiro <- TRUE
        }
      }
    } else {
      temp.data <- ReadShapefile(ano = '2012', estado = estado, orbitaPonto = orbitas.ponto[j])
      
      if (length(temp.data) > 0) {
        existe <- temp.data$tc_2012 == 'VEGETACAO_SECUNDARIA'
        
        if (any(existe)) {
          temp.data <- temp.data[temp.data$tc_2012 == 'VEGETACAO_SECUNDARIA', ]  
          n <- length(slot(temp.data, "polygons"))
          temp.data <- spChFIDs(temp.data, as.character(uid:(uid+n-1)))
          uid <- uid + n
          poly.data <- spRbind(poly.data,temp.data)
          
          # Grava o shapefile de 10 em 10 orbitas-ponto
          #if (j %% 10 == 0) {
          #  writeOGR(poly.data, dsn = 'new', layer = paste('TC_2012_VS_', estado, '_merge_', j, sep = ''), driver = 'ESRI Shapefile')
          #  leu.primeiro <- FALSE
          #  rm(poly.data)
          #}
        }
      }
      
      rm(temp.data)
      gc()
    }
  }
  
  writeOGR(poly.data, dsn = 'new', layer = paste('TC_2012_VS_', estado, '_merge', sep = ''), driver = 'ESRI Shapefile')
  rm(poly.data)
  rm(temp.data)
}