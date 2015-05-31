# Create Secundary Vegetation Shapefiles
CreateSvShapes <- function (ano = ano) {
  source("code/pre/terraclass/read_shapefile.R")
  
  estados <- read.table('data/input/terraclass/terraclass_arquivos.csv', colClasses = "character")
  poly.data <- NULL
  uid <- 1
  
  ExisteVegetacaoSecundaria <- function(shape, ano) {
    if (ano == '2012') {
      existe <- shape$tc_2012 == 'VEGETACAO_SECUNDARIA'
    } else if (ano == '2010') {
      existe <- shape$tc_2010 == 'VEGETACAO_SECUNDARIA'
    } else if (ano == '2008') {
      existe <- shape$tcclasse == 'VEGETACAO_SECUNDARIA'
    } else {
      print( paste('Não existem dados disponíveis para o ano', ano) )
    }
    
    return(existe)
  }
  
  for (i in 1:nrow(estados)) {
    estado <- estados[i, 1]
    orbitas.ponto <- unlist(strsplit(estados[i, 2], "[,]"))
    
    leu.primeiro <- FALSE
    for(j in 1:length(orbitas.ponto)) {
      if (!leu.primeiro) {
        
        poly.data <- ReadShapefile(ano = ano, estado = estado, orbitaPonto = orbitas.ponto[j])
    
        if (length(poly.data) > 0) {
          existe <- ExisteVegetacaoSecundaria(shape = poly.data, ano = ano)
          
          if (any(existe)) {
            poly.data <- poly.data[existe, ]
            n <- length(slot(poly.data, "polygons"))
            poly.data <- spChFIDs(poly.data, as.character(uid:(uid+n-1)))
            uid <- uid + n
            leu.primeiro <- TRUE
          }
        }
      } else {
        temp.data <- ReadShapefile(ano = ano, estado = estado, orbitaPonto = orbitas.ponto[j])
        
        if (length(temp.data) > 0) {
          existe <- ExisteVegetacaoSecundaria(shape = temp.data, ano = ano)
          
          if (any(existe)) {
            temp.data <- temp.data[existe, ]  
            n <- length(slot(temp.data, "polygons"))
            temp.data <- spChFIDs(temp.data, as.character(uid:(uid+n-1)))
            uid <- uid + n
            poly.data <- spRbind(poly.data,temp.data)
            
            # Grava o shapefile de 10 em 10 orbitas-ponto
            if (estado == 'PA' && j %% 10 == 0) {
              wd <- getwd()
              setwd('data/output/terraclass')
              
              writeOGR(poly.data, dsn = ano, layer = paste('TC_', ano, '_VS_', estado, '_merge_', j, sep = ''), driver = 'ESRI Shapefile')
              
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
    
    nome.arquivo <- paste0('TC_', ano, '_VS_', estado)
    if (estado == 'PA') {
      nome.arquivo <- paste0('TC_', ano, '_VS_', estado, '_merge_', j)
    }
    writeOGR(poly.data, dsn = ano, layer = nome.arquivo, driver = 'ESRI Shapefile')
    
    setwd(wd)
    
    rm(poly.data)
    rm(temp.data)
    gc()
  }
  gc()
}