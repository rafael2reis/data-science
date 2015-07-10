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

DownloadProdesFiles(year = '2008')
DownloadProdesFiles(year = '2010')
DownloadProdesFiles(year = '2012')

# Calculate Deforastation Areas By State in km^2
source('code/pre/prodes/area_by_state.R')

CalculateProdesAreas(year = '2008')
CalculateProdesAreas(year = '2010')
CalculateProdesAreas(year = '2012')

# Download and Process TerraClass shapefiles
source('code/pre/terraclass/merge_shapefiles.R')

# Create Secundary Vegetation Shapes
CreateTerraClassShapes(year = '2008')
CreateTerraClassShapes(year = '2010')
CreateTerraClassShapes(year = '2012')

# Create Non-observed areas Shapes
CreateTerraClassShapes(year = '2008', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')
CreateTerraClassShapes(year = '2010', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')
CreateTerraClassShapes(year = '2012', classe = 'AREA_NAO_OBSERVADA', sufix = 'NA')

# Calculate Secondary Vegetation areas by States
source('code/pre/terraclass/area.R')

CalculateArea(year = '2008')
CalculateArea(year = '2010')
CalculateArea(year = '2012')

# Calculate Not Observable Area
CalculateArea(year = '2010', prefix = 'NA')
CalculateArea(year = '2012', prefix = 'NA')

# List areas
source('code/pre/terraclass/list_area.R')

ListArea(year = '2008')
ListArea(year = '2010')
ListArea(year = '2012')
