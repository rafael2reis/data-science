rm(list = ls())

library(rgdal); library(maptools)

setwd('/Users/rafaelreis/workspace/r/VegetacaoSecundaria')

# Download and Process TerraClass shapefiles
source('code/pre/terraclass/merge_shapefiles.R')

CreateSvShapes(ano = '2008')
CreateSvShapes(ano = '2010')
CreateSvShapes(ano = '2012')

# Calculate Secondary Vegetation areas by States
source('code/pre/terraclass/area.R')

CalculateArea(ano = '2010')
