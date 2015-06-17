rm(list = ls())

library(rgdal); library(maptools)

setwd('/Users/rafaelreis/workspace/r/VegetacaoSecundaria')

# Create file system structure
dir.create('data')
dir.create(file.path('data', 'input'))
dir.create(file.path('data/input', 'prodes'))
dir.create(file.path('data/input', 'terraclass'))
dir.create(file.path('data/input', 'temp'))
dir.create(file.path('data', 'output'))
dir.create(file.path('data/output', 'prodes'))
dir.create(file.path('data/output', 'terraclass'))

# Download Prodes Files
source('code/pre/prodes/data_download.R')

DownloadProdesFiles(ano = '2008')
DownloadProdesFiles(ano = '2010')
DownloadProdesFiles(ano = '2012')

# Calculate Deforastation Areas By State in km^2
source('code/pre/prodes/area_por_estado.R')

CalculateProdesAreas(ano = '2008')
CalculateProdesAreas(ano = '2010')
CalculateProdesAreas(ano = '2012')

# Download and Process TerraClass shapefiles
source('code/pre/terraclass/merge_shapefiles.R')

# Create Secundary Vegetation Shapes
CreateTerraClassShapes(ano = '2008')
CreateTerraClassShapes(ano = '2010')
CreateTerraClassShapes(ano = '2012')

# Create Non-observed areas Shapes
CreateTerraClassShapes(ano = '2008', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')
CreateTerraClassShapes(ano = '2010', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')
CreateTerraClassShapes(ano = '2012', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')

# Calculate Secondary Vegetation areas by States
source('code/pre/terraclass/area.R')

CalculateArea(ano = '2010')
CalculateArea(ano = '2012')

# Calculate Not Observable Area
CalculateArea(ano = '2010', prefix = 'NA')
CalculateArea(ano = '2012', prefix = 'NA')
