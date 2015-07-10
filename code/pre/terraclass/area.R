CalculateArea <- function (year = NULL, states = NULL, prefix = 'SV') {
  if ( is.null(states) ) {
    states <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
  }
  
  wd.base <- getwd()
  source('code/pre/terraclass/area_polygon.R')
  
  setwd('data/output/terraclass');
  
  resultado <- data.frame(stringsAsFactors = FALSE)
  
  for (i in 1:length(states)) {
    state <- states[[i]]
    arquivos <- list.files(path = year, pattern = paste0('.+', prefix, '_', state, '.+shp$'))
    arquivos <- substr(arquivos, start = 1, stop = (nchar(arquivos) - 4))
    
    area.sum <- 0
    for (j in 1:length(arquivos)) {
      shape <- readOGR(dsn = year, layer = arquivos[j] )
      
      areas <- AreaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
      
      area.sum <- sum(areas/1000000, area.sum)
      
      rm(shape)
      rm(areas)
      gc()
    }
    
    print( paste(state, year, area.sum) )
    nova.linha <- list(state, year, area.sum)
    
    write.table( x = nova.linha, file = paste0(wd.base, '/data/output/terraclass/terraclass_', prefix, '_', year, '.txt'), 
                 row.names = FALSE, col.names = FALSE, append = TRUE)
  }
  
  setwd(wd.base)
  gc()
}