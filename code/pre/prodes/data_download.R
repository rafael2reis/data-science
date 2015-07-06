DownloadProdesFiles <- function(year = NULL, states = NULL) {
  if ( is.null(states) ) {
    states <- c('AC', 'AP', 'AM', 'MA', 'MT', 'PA', 'RO', 'RR', 'TO')
  }
  
  wdir <- getwd()
  setwd( paste0('data/input/prodes/', year) )
  
  for (i in 1:length(states)) {
    state <- states[[i]]
    arquivo.url <- paste0('http://www.dpi.inpe.br/prodesdigital//dadosn/mosaicos/', year, 
                          '/PDigital2000_', year, '_', state, '_shp.zip')
    
    download.file(arquivo.url, 
                  "dest.zip",
                  quiet = FALSE, mode = "w",
                  cacheOK = TRUE)
    
    unzip("dest.zip")
  }
  
  setwd(wdir)
}

