CalculateProdesAreas <- function(year = NULL, states = NULL) {
  if ( is.null(states) ) {
    states <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
  }
  
  source('code/pre/terraclass/area_polygon.R')
  
  wdir <- getwd()
  setwd( paste0('data/input/prodes') )
  
  for (i in 1:length(states)) {
    state <- states[[i]]
    if (year == '2008') {
      file <- paste0('Prodes2008_', state, '_pol')
    } else {
      file <- paste0('PDigital', year, '_', state, '__pol')
    }
    
    shape <- readOGR(dsn = year, layer = file )
    if (year == '2012') {
      shape <- shape[shape$mainclass == 'DESFLORESTAMENTO', ]
    } else if (year == '2010') {
      shape <- shape[shape$main_class == 'DESFLORESTAMENTO', ]
    } else if (year == '2008') {
      shape <- subset(shape, sprclasse == 'desmatamento' | sprclasse == 'desmatamento_total')
    }
    
    areas <- AreaPolygons(shape, CRS("+proj=poly +lat_0=0 +lon_0=-54 +x_0=5000000 +y_0=10000000 +ellps=aust_SA +units=m +no_defs"))
    area.sum <- sum(areas)/1000000
    
    new.line <- list(state, year, area.sum)
    
    write.table( x = new.line, file = paste0(wdir, '/data/output/prodes/prodes_', year, '.txt'), 
                 row.names = FALSE, col.names = FALSE, append = TRUE)
    
    rm(shape)
    rm(areas)
    gc()
  }
  
  setwd(wdir)
}