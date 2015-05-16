rm(list = ls())

library(rgdal);

#estados <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
estados <- c('MT', 'PA', 'RO', 'RR', 'TO')
ano <- '2012'

wd.base <- '/Users/rafaelreis/workspace/r/VegetacaoSecundaria/'
setwd(wd.base)
source('code/pre/terraclass/area_polygon.R')

wd <- paste0('data/input/prodes');
setwd(wd)

resultado <- data.frame(stringsAsFactors = FALSE)

for (i in 1:length(estados)) {
  estado <- estados[[i]]
  arquivo <- paste0('PDigital', ano, '_', estado, '__pol')
  
  shape <- readOGR(dsn = ano, layer = arquivo )
  shape <- shape[shape$mainclass == 'DESFLORESTAMENTO', ]
  
  areas <- areaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
  area.sum <- sum(areas)/1000000
  
  nova.linha <- list(estado, ano, area.sum)
  
  write.table( x = nova.linha, file = paste0(wd.base, 'data/output/prodes/prodes_', ano, '.txt'), 
               row.names = FALSE, col.names = FALSE, append = TRUE)
  
  rm(shape)
  rm(areas)
  gc()
}
