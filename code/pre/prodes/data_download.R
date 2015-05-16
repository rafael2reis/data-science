ano <- '2012'
#estados <- c('AM', 'AP', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
estados <- c('MT', 'PA', 'RO', 'RR', 'TO')

wdir <- getwd()
setwd( paste0('data/input/prodes/', ano) )

for (i in 1:length(estados)) {
  estado <- estados[[i]]
  arquivo.url <- paste0('http://www.dpi.inpe.br/prodesdigital//dadosn/mosaicos/', ano, 
                        '/PDigital2000_', ano, '_', estado, '_shp.zip')
  
  download.file(arquivo.url, 
                "dest.zip",
                quiet = FALSE, mode = "w",
                cacheOK = TRUE)
  
  unzip("dest.zip")
}