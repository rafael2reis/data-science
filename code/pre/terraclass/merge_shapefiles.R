# Create TerraClass Shapefiles
# Default is Secondary Vegetation
CreateTerraClassShapes <- function (year = NULL, classe = 'VEGETACAO_SECUNDARIA', sufix = "SV") {
  source("code/pre/terraclass/read_shapefile.R")
  
  states <- read.table('data/input/terraclass/terraclass_arquivos.csv', colClasses = "character")
  poly.data <- NULL
  uid <- 1
  
  ExisteClasse <- function(shape, year, classe) {
    if (year == '2012') {
      existe <- shape$tc_2012 == classe
    } else if (year == '2010') {
      existe <- shape$tc_2010 == classe
    } else if (year == '2008') {
      existe <- shape$tcclasse == classe
    } else {
      print( paste('Não existem dados de', classe, 'disponíveis para o ano', year) )
    }
    
    return(existe)
  }
  
  for (i in 1:nrow(states)) {
    state <- states[i, 1]
    orbitas.ponto <- unlist(strsplit(states[i, 2], "[,]"))
    
    leu.primeiro <- FALSE
    for(j in 2:length(orbitas.ponto)) {
      if (!leu.primeiro) {
        
        poly.data <- ReadShapefile(year = year, state = state, orbitPoint = orbitas.ponto[j])
    
        if (length(poly.data) > 0) {
          existe <- ExisteClasse(shape = poly.data, year = year, classe = classe)
          
          if (any(existe)) {
            poly.data <- poly.data[existe, ]
            n <- length(slot(poly.data, "polygons"))
            poly.data <- spChFIDs(poly.data, as.character(uid:(uid+n-1)))
            uid <- uid + n
            leu.primeiro <- TRUE
          }
        }
      } else {
        temp.data <- ReadShapefile(year = year, state = state, orbitPoint = orbitas.ponto[j])
        
        if (length(temp.data) > 0) {
          existe <- ExisteClasse(shape = temp.data, year = year, classe = classe)
          
          if (any(existe)) {
            temp.data <- temp.data[existe, ]  
            n <- length(slot(temp.data, "polygons"))
            temp.data <- spChFIDs(temp.data, as.character(uid:(uid+n-1)))
            uid <- uid + n
            poly.data <- spRbind(poly.data,temp.data)
            
            # Grava o shapefile de 10 em 10 orbitas-ponto
            if (state == 'PA' && j %% 10 == 0) {
              wd <- getwd()
              setwd('data/output/terraclass')
              
              writeOGR(poly.data, dsn = year, layer = paste('TC_', year, '_', sufix,'_', state, '_', j, sep = ''), driver = 'ESRI Shapefile')
              
              setwd(wd)
              
              leu.primeiro <- FALSE
              rm(poly.data)
            }
          }
        }
        
        rm(temp.data)
        gc()
      }
    }
    
    wd <- getwd()
    setwd('data/output/terraclass')
    
    nome.arquivo <- paste0('TC_', year, '_', sufix,'_', state)
    if (state == 'PA') {
      nome.arquivo <- paste0('TC_', year, '_', sufix, '_', state, '_', j)
    }
    arquivo.shp <- paste0(year, '/', nome.arquivo, '.shp')
    if (file.exists( arquivo.shp )) {
      arquivos <- c( paste0(year, '/', nome.arquivo, '.dbf'),
                     paste0(year, '/', nome.arquivo, '.prj'),
                     paste0(year, '/', nome.arquivo, '.shp'),
                     paste0(year, '/', nome.arquivo, '.shx'))
      file.remove(arquivos)
    }
    writeOGR(poly.data, dsn = year, layer = nome.arquivo, driver = 'ESRI Shapefile')
    
    setwd(wd)
    
    rm(poly.data)
    rm(temp.data)
    gc()
  }
  gc()
}