# Learning the Intensity Analysis framework
This is a repository set up as my personal exercise for learning the Intensity Analysis framework [(Aldwaik & Pontius 2012)](#aldwaik_pontius_2012), an approach that unifies the measurements of size and stationarity of land changes at three levels: interval, category, and transition, using the `intensity.analysis` R package implementation [(Pontius & Khallaghi 2019)](https://cran.r-project.org/web/packages/intensity.analysis/index.html). It can also be used as a tutorial for someone interested in learning Intensity Analysis for their research projects.

Previously, I implemented the Intensity Analysis framework for my land change studies using the [Microsoft Excel Macro](https://sites.google.com/site/intensityanalysis/home) developed by Aldwaik & Pontius. The recent development of the `intensity.analysis` R package now allows for the implementation of the framework within the R environment, which makes the application and implementation of the framework more repeatable, transparent, and reproducible. (And in my opinion is truly *magnificent, magnificent, magnificent*! Hence thanks and kudos to Prof Pontius and his collaborators.) This repository is thus my first attempt to learn and my record of learning the Intensity Analysis framework implementation using R software using dataset from one of my land cover change studies (see [De Alban et al 2019](https://doi.org/10.3390/su11041139) published in Sustainability journal and its accompanying GitHub [repository](https://github.com/dondealban/ms-sustainability-2019)).

<a name="intensity_analysis"></a>
## What is the Intensity Analysis framework?
The **Intensity Analysis** framework is a quantitative method to analyse land cover change over time for an area of interest to summarise the change within time-intervals. Different types of information are extracted at three levels of analysis: interval, category, and transition, which progress from general to more detailed levels. At the ***interval level***, the total change in each time-interval is analysed to examine how the size and annual rate of change vary across time-intervals (i.e., to answer in which time-intervals are the overall annual rate of change relatively slow or fast). At the ***category level***, each land cover category is examined to measure how the size and intensity of both gross losses and gross gains vary across space (i.e., to answer which categories are relatively dormant versus active in a given time-interval, and to determine if the pattern is stable across time-intervals). Finally, at the ***transition level***, a particular transition is analysed to examine how the size and intensity of the transition vary among categories available for that transition (i.e., to answer which transitions are intensively targeted versus avoided by a given land category in a given time-interval, and to determine if the pattern is stable across time-intervals).

<a name="dataset"></a>
## Dataset
The dataset I used to illustrate the application of Intensity Analysis using the `intensity.analysis` package were extracted from the [global 24-year annual time-series global land cover maps](https://www.esa-landcover-cci.org) developed by the European Space Agency Climate Change Initiative (ESA CCI). The land cover data covers the Tanintharyi Region in southern Myanmar, a region experiencing profound land cover changes as a result of political and economic transitions. The land cover change analysis involves studying changes over three time-intervals (1992–1997, 1997–2004, 2004–2015) at four time-points: 1992, 1997, 2004, 2015. (Note that in the land-cover regime shift [paper](https://doi.org/10.3390/su11041139), we analysed annual land cover change over 24 years from 1992–2015.) The land cover rasters are located in the [raster data folder](https://github.com/dondealban/learning-intensity-analysis/tree/master/raster%20data) of this repository.

<a name="workflow"></a>
## An `intensity.analysis` Workflow Example
I implemented the following workflow for land cover change analysis using the Intensity Analysis framework in R software. Users can modify this to suit their objectives.

<a name="ingest"></a>
### A. Ingest
Prior to loading packages, you can set your working directory using `setwd()` and indicate your working directory path. The following R packages or libraries were used for this exercise: `intensity.analysis` and `raster`. To load these packages we can write:
```R
library(raster)               # Package for geographic data analysis and modeling
library(intensity.analysis)   # Package for intensity of change for comparing categorical maps from sequential intervals
```
### B. Load Rasters
Next we load the raster datasets (our land cover maps) for each time-point and store them into variables using the `raster` function from the `raster` package.
```R
r1992 <- raster('Landscape_1992.tif')
r1997 <- raster('Landscape_1997.tif')
r2004 <- raster('Landscape_2004.tif')
r2015 <- raster('Landscape_2015.tif')
```
Note that these raw land cover maps have the following categories:

Pixel Value | Land Cover Categories
----------- | ----------------------
0           | No Data
1           | Forest
2           | Mosaic Vegetation
3           | Shrubland
4           | Other Vegetation
5           | Cropland
6           | Non-Vegetation

To prevent the subsequent cross-tabulation process using the `multicrosstab` function later on from including the '0' or 'No Data' values, we need to set the '0' pixel values to NA. First, we copy the original raster files into new variable objects:
```R
lc1992 <- r1992
lc1997 <- r1997
lc2004 <- r2004
lc2015 <- r2015
```
Subsequently, we assign 'NA' to the the '0' pixel values in the new raster variables to exclude these NA pixels from the calculations in Intensity Analysis.
```R
lc1992[lc1992 <= 0] <- NA
lc1997[lc1997 <= 0] <- NA
lc2004[lc2004 <= 0] <- NA
lc2015[lc2015 <= 0] <- NA
```


<a name="references"></a>
## References

<a name="aldwaik_pontius_2012"></a>
Aldwaik, S.Z., Pontius, R.G. (2012) Intensity analysis to unify measurements of size and stationarity of land changes by interval, category, and transition. *Landscape and Urban Planning*, 202, 18–27. [doi:10.1016/j.landurbplan.2012.02.010](https://doi.org/10.1016/j.landurbplan.2012.02.010)

<a name="dealban_etal_2019"></a>
De Alban, J.D.T., Prescott, G.W., Woods, K.M., Jamaludin, J., Latt, K.T., Lim, C.L., Maung, A.C., Webb, E.L. (2019) Integrating analytical frameworks to investigate land-cover regime shifts in dynamic landscapes. *Sustainability*, 11(4), 1139. [doi:10.3390/su11041139](https://doi.org/10.3390/su11041139)

<a name="pontius_khallaghi_2019"></a>
Pontius, R.G., Khallaghi, S. (2019) intensity.analysis: Intensity of Change for Comparing Categorical Maps from Sequential Intervals.
