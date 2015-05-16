rm(list = ls())

library(rgdal);

ufs <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
codigos <- c(12, 16, 13, 21, 51, 15, 11, 14, 17)
estados <- data.frame(ufs,codigos,stringsAsFactors=FALSE)
names(estados) <- c('uf', 'codigo')

wd.base <- '/Users/rafaelreis/workspace/r/VegetacaoSecundaria/'
setwd(wd.base)
source('code/pre/terraclass/area_polygon.R')

wd <- paste0('data/input/ibge');
setwd(wd)

resultado <- data.frame(stringsAsFactors = FALSE)

for (i in 1:nrow(estados)) {
  arquivo <- paste0(estados$codigo[i], 'UFE250GC_SIR')
  
  shape <- readOGR(dsn = estados$uf[i], layer = arquivo )
  
  areas <- areaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
  area.sum <- sum(areas)/1000000
  
  nova.linha <- list(estados$uf[i], area.sum)
  
  write.table( x = nova.linha, file = paste0(wd.base, 'data/output/ibge/ibge.txt'), 
               row.names = FALSE, col.names = FALSE, append = TRUE)
  
  rm(shape)
  rm(areas)
  gc()
}