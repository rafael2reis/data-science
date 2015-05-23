GetUrlTerraclass <- function(ano, estado, orbitaPonto) {
  if (ano == '2012') {
    estadoMap <- list(AC = 'ACRE', AM = 'AMAZONAS', RR = 'RORAIMA', 
                      RO = 'RONDONIA', PA = 'PARA', AP = 'AMAPA',
                      MT = 'MATO_GROSSO', TO = 'TOCANTINS', MA = 'MARANHAO')
    
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", ano, "/Dados_TC", ano, "/", 
                          estadoMap[[estado]],"_2012/TC_", estado,"_", ano,"_", 
                          orbitaPonto,".zip")
  } else if (ano == '2010') {
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", ano, "/Dados_TC", ano, "/", 
                          estado,"/TC_", estado,"_", ano,"_", 
                          orbitaPonto,".zip")
  }
  
  return(arquivo.url)
}

ReadShapefile <- function (ano = NULL, estado = NULL, orbitaPonto = NULL) {
  
  #######-TESTE
  #ano <- '2012'
  #orbitaPonto <- '00163'
  #estado <- 'AM'
  ######
  
  arquivo.url <- GetUrlTerraclass(ano = ano, estado = estado, orbitaPonto = orbitaPonto)
  
  wdir <- getwd()
  setwd('data/input/temp')
  
  tryCatch({
    download.file(arquivo.url, 
                "dest.zip",
                  quiet = FALSE, mode = "w",
                  cacheOK = TRUE)
    
    unzip("dest.zip")
    
    nome.arquivo <- paste("TC_", estado, "_", ano, "_", orbitaPonto, sep = "")
    print(nome.arquivo)
   
    #alguns arquivos são unzipados com diretório
    nome.dir <- nome.arquivo
    isDir <- file.info( nome.dir )$isdir
    if ( !is.na(isDir) && isDir ) {
      
      terra.class <- readOGR(dsn = nome.arquivo, layer = paste(nome.arquivo,"__pol", sep = "") )
      
    } else {
      # work-around por causa do bug do unzip()
      arquivos <- list.files(pattern = paste0(nome.arquivo, "__pol.+$"))
      novos.arquivos <- sub(".+\\\\", "", arquivos)
      file.rename(arquivos, novos.arquivos)
      
      terra.class <- readOGR(dsn = ".", layer = paste(nome.arquivo,"__pol", sep = "") )
    }
    
    return(terra.class)
  }, error = function(err) {
    print(err)
    return(NULL)
  }, finally = {
    setwd(wdir)
    file.remove(dir("data/input/temp", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)) 
  })
}