ReadShapefile <- function (ano = NULL, orbitaPonto = NULL, estado = NULL) {
  estadoMap <- list(AC = 'ACRE', AM = 'AMAZONAS', RR = 'RORAIMA', 
                    RO = 'RONDONIA', PA = 'PARA', AP = 'AMAPA',
                    MT = 'MATO_GROSSO', TO = 'TOCANTINS', MA = 'MARANHAO')
  
  arquivo.url <- NULL
  if (ano == '2012') {
    arquivo.url <- paste("http://www.inpe.br/cra/projetos_pesquisas/", ano, "/Dados_TC", ano, "/", 
                         estadoMap[[estado]],"_2012/TC_", estado,"_", ano,"_", 
                         orbitaPonto,".zip", sep = "")
  }
  
  tryCatch({
    download.file(arquivo.url, 
                "dest.zip",
                  quiet = FALSE, mode = "w",
                  cacheOK = TRUE)
    
    unzip("dest.zip", exdir = "data")
    
    #######-TESTE
    #ano <- '2012'
    #orbitaPonto <- '22261'
    #estado <= 'MA'
    ######
    
    nome.arquivo <- paste("TC_", estado, "_", ano, "_", orbitaPonto, sep = "")
    print(nome.arquivo)
   
    #alguns arquivos são unzipados com diretório
    nome.dir <- paste('data/', nome.arquivo, sep = '')
    isDir <- file.info( nome.dir )$isdir
    if ( !is.na(isDir) && isDir ) {
      wd <- getwd()
      setwd( paste(wd, '/data', sep = '') )
      
      terra.class <- readOGR(dsn = nome.arquivo, layer = paste(nome.arquivo,"__pol", sep = "") )
      
      setwd(wd)
    } else {
      # work-around por causa do bug do unzip()
      arquivos <- list.files(path = "data",  pattern = paste(nome.arquivo, "__pol.+$", sep = ""))
      novos.arquivos <- sub(".+\\\\", "", arquivos)
      arquivos <- paste("data/", arquivos, sep = "")
      novos.arquivos <- paste("data/", novos.arquivos, sep = "") 
      file.rename(arquivos, novos.arquivos)
      
      terra.class <- readOGR(dsn = "data", layer = paste(nome.arquivo,"__pol", sep = "") )
    }
    
    return(terra.class)
  }, error = function(err) {
    print(err)
    return(NULL)
  }, finally = {
    file.remove(dir("data", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)) 
  })
}