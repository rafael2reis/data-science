rm(list = ls())

library(rgdal);

estados <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
#estados <- c('PA')
ano <- '2010'

wd.base <- '/Users/rafaelreis/workspace/r/VegetacaoSecundaria/'
setwd(wd.base)
source('code/pre/terraclass/area_polygon.R')

wd <- paste0(wd.base, 'data/output/terraclass');
setwd(wd)

resultado <- data.frame(stringsAsFactors = FALSE)

for (i in 1:length(estados)) {
  estado <- estados[[i]]
  arquivos <- list.files(path = ano, pattern = paste0('.+', estado, '.+shp$'))
  arquivos <- substr(arquivos, start = 1, stop = (nchar(arquivos) - 4))
  
  area.sum <- 0
  for (j in 1:length(arquivos)) {
    shape <- readOGR(dsn = ano, layer = arquivos[j] )
    
    areas <- AreaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
    
    area.sum <- sum(areas, area.sum)
    rm(shape)
    rm(area.list)
    rm(areas)
    gc()
  }
  
  nova.linha <- list(estado, ano, area.sum)
  resultado <- rbind(resultado, nova.linha)
}

names(resultado) <- c('estado', 'ano', 'area')
setwd( paste0(wd.base, 'data/output/terraclass')  )
write.table(resultado, paste0('terraclass_vs_', ano, '.txt'), row.names = FALSE, col.names = FALSE)
