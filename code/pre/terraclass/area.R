CalculateArea <- function (ano = ano) {
  estados <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
  #estados <- c('MT')
  
  wd.base <- getwd()
  source('code/pre/terraclass/area_polygon.R')
  
  setwd('data/output/terraclass');
  
  resultado <- data.frame(stringsAsFactors = FALSE)
  
  for (i in 1:length(estados)) {
    estado <- estados[[i]]
    arquivos <- list.files(path = ano, pattern = paste0('.+', estado, '.+shp$'))
    arquivos <- substr(arquivos, start = 1, stop = (nchar(arquivos) - 4))
    
    area.sum <- 0
    for (j in 1:length(arquivos)) {
      shape <- readOGR(dsn = ano, layer = arquivos[j] )
      
      areas <- AreaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
      
      area.sum <- sum(areas/1000000, area.sum)
      
      rm(shape)
      rm(areas)
      gc()
    }
    
    print( paste(estado, ano, area.sum) )
    nova.linha <- list(estado, ano, area.sum)
    
    write.table( x = nova.linha, file = paste0(wd.base, '/data/output/terraclass/terraclass_vs_', ano, '.txt'), 
                 row.names = FALSE, col.names = FALSE, append = TRUE)
  }
  
  setwd(wd.base)
  gc()
}