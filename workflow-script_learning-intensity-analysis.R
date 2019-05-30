# This script implements a land cover change analysis workflow using the Intensity 
# Analysis framework via the intensity.analysis R package (Pontius & Khallaghi 2019).
# The script uses land cover image datasets from one of my land cover change studies
# investigating land-cover regime shifts in Tanintharyi Region, Myanmar, published 
# in Sustainability journal (https://doi.org/10.3390/su11041139).
# 
# Script modified by: Jose Don T. De Alban
# Date created:       30 May 2019
# Date modified:      


# ----------------------------------------
# SET WORKING DIRECTORY
# ----------------------------------------
setwd("/Users/dondealban/Dropbox/Research/learning-intensity-analysis/")

# ----------------------------------------
# LOAD LIBRARIES
# ----------------------------------------
library(raster)
library(intensity.analysis)