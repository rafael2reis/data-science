statesMap.2012 <- list(AC = "ACRE", AM = "AM", RR = "RR", 
     RO = "RO", PA = "PA", AP = "AP",
     MT = "MT", TO = "TO", MA = "MA")

statesMap <- list(AC = "ACRE", AM = "AMAZONAS", RR = "RORAIMA", 
              RO = "RONDONIA", PA = "PARA", AP = "AMAPA",
              MT = "MATO_GROSSO", TO = "TOCANTINS", MA = "MARANHAO")

GetUrlTerraclass <- function(year, state, orbitPoint) {
  if (year == "2012") {
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", year, "/Dados_TC", year, "/", 
                          statesMap[[state]], "_2012/TC_", state,"_", year, "_", 
                          orbitPoint, ".zip")
  } else if (year == "2010") {
    nome.zip <- paste0("TC_", state, "_2010_", orbitPoint, ".zip");
    if (state == "MT" 
            && (orbitPoint == "22869" || orbitPoint == "22771" || orbitPoint == "22772")) {
      nome.zip <- paste0("TC_2010_MT_", orbitPoint, ".zip");
    }
    
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/", year, "/Dados_TC", year, "/", 
                          state, "/", nome.zip)
  } else if (year == "2008") {
    arquivo.url <- paste0("http://www.inpe.br/cra/projetos_pesquisas/2008/dados_terraclass/", 
                          statesMap[[state]], "/", orbitPoint, "/", orbitPoint, "_2008_shp.zip")
  }
  
  return(arquivo.url)
}

ReadShapefile <- function (year = NULL, state = NULL, orbitPoint = NULL) {
  
  #######-TESTE
  #year <- "2012"
  #orbitPoint <- "00665"
  #state <- "AC"
  ######
  
  arquivo.url <- GetUrlTerraclass(year = year, state = state, orbitPoint = orbitPoint)
  
  wdir <- getwd()
  setwd("data/input/temp")
  
  tryCatch({
    download.file(arquivo.url, 
                "dest.zip",
                  quiet = FALSE, mode = "w",
                  cacheOK = TRUE)
    
    unzip("dest.zip")
    
    if (year == "2008") {
      nome.arquivo <- paste0("terraclass_2008_", orbitPoint)
      nome.dir <- paste0(orbitPoint, "_2008_shp")
    } else if (year == "2012") {
      nome.dir <- paste0("TC_", state, "_", year, "_", orbitPoint)
      nome.arquivo <- paste0("TC_", statesMap.2012[[state]], "_", year, "_", orbitPoint)
    } else {
      nome.arquivo <- paste0("TC_", state, "_", year, "_", orbitPoint)
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