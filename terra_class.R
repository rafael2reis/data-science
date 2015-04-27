install.packages("RCurl")
require(RCurl)
library(ggplot2)
library(ggmap)
library(rgdal)

# Carrega o mapa P&B do Brazil
mapa.amazonia <- ggmap(
                  get_googlemap(center = c(-58.376641, -5.051945), 
                                zoom = 4, 
                                maptype = "roadmap", 
                                color = "bw",
                                size = c(640,640), 
                                scale = 2,
                                style = c(feature = "all", element = "labels", visibility = "off")
                  ))
# Imprime o mapa
mapa.amazonia

estados.2008 <- read.table('terraclass_arquivos_2008.csv', colClasses = "character")
estados.2010 <- c("AC", "AM", "RR", "PA", "AP", "MA", "TO", "RO", "MT")

# Dowload de shapefile diretamente do TerraClass
# MUDAR O INÍCIO DE i para 1 !!!
for(i in 2:dim(estados.2008)[1]) {
  
  estado <- estados.2008[i, 1]
  orbitas.ponto <- unlist(strsplit(estados.2008[i, 2], "[,]"))
 
  for(j in 2:length(orbitas.ponto)) {
    arquivo.url <- paste("http://www.inpe.br/cra/projetos_pesquisas/2008/dados_terraclass/", estado, "/",orbitas.ponto[j],"/",orbitas.ponto[j],"_2008_shp.zip", sep = "")
    
    tryCatch({
      download.file(arquivo.url, 
                    "dest.zip",
                    quiet = FALSE, mode = "w",
                    cacheOK = TRUE)
      
      unzip("dest.zip", exdir = "data")
      terra.class <- readOGR(dsn = "data", layer = paste("terraclass_2008_", orbitas.ponto[j],"__pol", sep = "") )
      
      sel <- terra.class$tcclasse == 'VEGETACAO_SECUNDARIA'
      terra.f <- fortify(terra.class[sel, ])
      mapa.amazonia <- mapa.amazonia + geom_polygon(data = terra.f,
                                                    aes(x = long, y = lat, group = group),
                                                    alpha = 0.8, fill = "green")
    }, error = function(err) {
      print(err)
    })
  }

  file.remove(dir("data", full.names=TRUE)) 
  Sys.sleep(2)
}
mapa.amazonia
ggsave("vs_terraclass_2008.png",  width=22.5, height=18.25, dpi=600)

