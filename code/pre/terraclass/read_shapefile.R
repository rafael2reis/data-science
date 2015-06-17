estadosMap.2012 <- list(AC = "ACRE", AM = "AM", RR = "RR", 
     RO = "RO", PA = "PA", AP = "AP",
     MT = "MT", TO = "TO", MA = "MA")

estadosMap <- list(AC = "ACRE", AM = "AMAZONAS", RR = "RORAIMA", 
              RO = "RONDONIA", PA = "PARA", AP = "AMAPA",
              MT = "MATO_GROSSO", TO = "TOCANTINS", MA = "MARANHAO")

GetUrlTerraclass <- function(ano, estado, orbitaPonto) {
  if (ano == "2012") {
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", ano, "/Dados_TC", ano, "/", 
                          estadosMap[[estado]], "_2012/TC_", estado,"_", ano, "_", 
                          orbitaPonto, ".zip")
  } else if (ano == "2010") {
    nome.zip <- paste0("TC_", estado, "_2010_", orbitaPonto, ".zip");
    if (estado == "MT" 
            && (orbitaPonto == "22869" || orbitaPonto == "22771" || orbitaPonto == "22772")) {
      nome.zip <- paste0("TC_2010_MT_", orbitaPonto, ".zip");
    }
    
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", ano, "/Dados_TC", ano, "/", 
                          estado, "/", nome.zip)
  } else if (ano == "2008") {
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/2008/dados_terraclass/", 
                          estadosMap[[estado]], "/", orbitaPonto, "/", orbitaPonto, "_2008_shp.zip")
  }
  
  return(arquivo.url)
}

ReadShapefile <- function (ano = NULL, estado = NULL, orbitaPonto = NULL) {
  
  #######-TESTE
  #ano <- "2012"
  #orbitaPonto <- "00665"
  #estado <- "AC"
  ######
  
  arquivo.url <- GetUrlTerraclass(ano = ano, estado = estado, orbitaPonto = orbitaPonto)
  
  wdir <- getwd()
  setwd("data/input/temp")
  
  tryCatch({
    download.file(arquivo.url, 
                "dest.zip",
                  quiet = FALSE, mode = "w",
                  cacheOK = TRUE)
    
    unzip("dest.zip")
    
    if (ano == "2008") {
      nome.arquivo <- paste0("terraclass_2008_", orbitaPonto)
      nome.dir <- paste0(orbitaPonto, "_2008_shp")
    } else if (ano == "2012") {
      nome.dir <- paste0("TC_", estado, "_", ano, "_", orbitaPonto)
      nome.arquivo <- paste0("TC_", estadosMap.2012[[estado]], "_", ano, "_", orbitaPonto)
    } else {
      nome.arquivo <- paste0("TC_", estado, "_", ano, "_", orbitaPonto)
      nome.dir <- nome.arquivo
    }
    print(nome.arquivo)
    
    #alguns arquivos são unzipados com diretório
    isDir <- file.info( nome.dir )$isdir
    if ( !is.na(isDir) && isDir ) {
      
      terra.class <- readOGR(dsn = nome.dir, layer = paste(nome.arquivo,"__pol", sep = "") )
      
    } else {
      # work-around por causa do bug do unzip()
      arquivos <- list.files(pattern = paste0(nome.arquivo, "__pol.+$"))
      novos.arquivos <- sub(".+\\\\", "", arquivos)
      file.rename(arquivos, novos.arquivos)
      
      terra.class <- readOGR(dsn = ".", layer = paste(nome.arquivo, "__pol", sep = "") )
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