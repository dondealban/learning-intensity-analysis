# Learning the Intensity Analysis framework
This is a repository set up as my personal exercise for learning the Intensity Analysis framework [(Aldwaik & Pontius 2012)](#aldwaik_pontius_2012), an approach that unifies the measurements of size and stationarity of land changes at three levels: interval, category, and transition, using the `intensity.analysis` R package implementation [(Pontius & Khallaghi 2019)](https://cran.r-project.org/web/packages/intensity.analysis/index.html). It can also be used as a tutorial for someone interested in learning Intensity Analysis for their research projects.

Previously, I implemented the Intensity Analysis framework for my land change studies using the [Microsoft Excel Macro](https://sites.google.com/site/intensityanalysis/home) developed by Aldwaik & Pontius. The recent development of the `intensity.analysis` R package now allows for the implementation of the framework within the R environment, which makes the application and implementation of the framework more repeatable, transparent, and reproducible. (And in my opinion is truly *magnificent, magnificent, magnificent*! Hence thanks and kudos to Prof Pontius and his collaborators.) This repository is thus my first attempt to learn and my record of learning the Intensity Analysis framework implementation using R software using dataset from one of my land cover change studies (see [De Alban et al 2019](https://doi.org/10.3390/su11041139) published in Sustainability journal and its accompanying GitHub [repository](https://github.com/dondealban/ms-sustainability-2019)).

## Table of Contents
- [What is the Intensity Analysis framework?](#what_is_intensity_analysis)
- [Dataset](#dataset)
- [An Intensity Analysis Workflow Example](#workflow)
    + [Ingest](#ingest)
    + [Load Rasters](#load_rasters)
    + [Create Lists and Vectors](#create_lists_vectors)
    + [Implement Intensity Analysis](#intensity_analysis)
    + [View Outputs](#view_outputs)
    + [Save Outputs](#save_outputs)
- [References](#references)
- [Want to Contribute?](#contribute)

<a name="what_is_intensity_analysis"></a>

## What is the Intensity Analysis framework?
The **Intensity Analysis** framework is a quantitative method to analyse land cover change over time for an area of interest to summarise the change within time-intervals. Different types of information are extracted at three levels of analysis: interval, category, and transition, which progress from general to more detailed levels. At the ***interval level***, the total change in each time-interval is analysed to examine how the size and annual rate of change vary across time-intervals (i.e., to answer in which time-intervals are the overall annual rate of change relatively slow or fast). At the ***category level***, each land cover category is examined to measure how the size and intensity of both gross losses and gross gains vary across space (i.e., to answer which categories are relatively dormant versus active in a given time-interval, and to determine if the pattern is stable across time-intervals). Finally, at the ***transition level***, a particular transition is analysed to examine how the size and intensity of the transition vary among categories available for that transition (i.e., to answer which transitions are intensively targeted versus avoided by a given land category in a given time-interval, and to determine if the pattern is stable across time-intervals).

<a name="dataset"></a>

## Dataset
The dataset I used to illustrate the application of Intensity Analysis using the `intensity.analysis` package were extracted from the [global 24-year annual time-series global land cover maps](https://www.esa-landcover-cci.org) developed by the European Space Agency Climate Change Initiative (ESA CCI). The land cover data covers the Tanintharyi Region in southern Myanmar, a region experiencing profound land cover changes as a result of political and economic transitions. The land cover change analysis involves studying changes over three time-intervals (1992–1997, 1997–2004, 2004–2015) at four time-points only: 1992, 1997, 2004, 2015. (Note that in the land-cover regime shift [paper](https://doi.org/10.3390/su11041139), we analysed annual land cover change over 24 years from 1992–2015.) The land cover rasters are located in the [raster data folder](https://github.com/dondealban/learning-intensity-analysis/tree/master/raster%20data) of this repository.

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

<a name="load_rasters"></a>

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

To prevent the cross-tabulation process using the `multicrosstab` function later on from including the '0' or 'No Data' values, we need to set the '0' pixel values to NA. First, we copy the original raster files into new variable objects:
```R
lc1992 <- r1992
lc1997 <- r1997
lc2004 <- r2004
lc2015 <- r2015
```
Then, we assign 'NA' to the the '0' pixel values in the new raster variables to exclude these NA pixels from the calculations in Intensity Analysis.
```R
lc1992[lc1992 <= 0] <- NA
lc1997[lc1997 <= 0] <- NA
lc2004[lc2004 <= 0] <- NA
lc2015[lc2015 <= 0] <- NA
```

<a name="create_lists_vectors"></a>

### C. Create Lists and Vectors
We then create lists and vectors required by the `multicrosstab` function in `intensity.analysis` to calculate the cross-tabulation matrices for each time-interval. First, we create a list of the raster data from the previous step. Second, we create a character vector of time-points including all four years: 1992, 1997, 2004, and 2015. Finally, we create a character vector of land cover categories listed in the particular order shown in the table above.
```R
# Create a list of raster data
raster.layers <- list(lc1992, lc1997, lc2004, lc2015)

# Create character vector of time-points
time.points <- c("1992","1997","2004","2015")

# Create character vector of land cover categories
categories <- c("Forest","Mosaic Vegetation","Shrubland","Other Vegetation","Cropland","Non-Vegetation")
```

<a name="intensity_analysis"></a>

### D. Implement Intensity Analysis
We generate multiple cross-tabulation matrices (or transition matrices) for each time-interval, 1992–1997, 1997–2004, 2004–2015. We accomplish this by calling the `multicrosstab` function and using the `raster.layers`, `time.points`, and `categories` lists/vectors that we created previously as the function's parameters:
```R
crosstabulation <- multicrosstab(raster.layers, time.points, categories)
```
To calculate the three levels of Intensity Analysis, we can write the following:
```R
# Interval-level Intensity Analysis
IIA.output <- IIA(crosstabulation, time.points)

# Category-level Intensity Analysis
CIA.output <- CIA(crosstabulation, time.points, categories)

# Transition-level Intensity Analysis
TIA.output <- TIA(crosstabulation, time.points, categories)
```
where **IIA**, **CIA**, and **TIA** refer to interval-level, category-level, and transition-level of Intensity Analysis, respectively.

<a name="view_outputs"></a>

### E. View Outputs

#### Cross-tabulation matrices
The `crosstabulation` variable contains the cross-tabulation matrices for each of the three time-intervals, 1992–1997, 1997–2004, 2004–2015, which are stored inside three elements [[1]], [[2]], and [[3]] of the variable, respectively. To view the cross-tabulation matrices, we can write `crosstabulation` to print the multiple cross-tabulation matrices that were calculated for each time-interval. We can also display the cross-tabulation matrix of a specific time-interval 2004–2015 using the following:
```R
crosstabulation[[3]]
```
This will show the following cross-tabulation matrix:

2004–2015  | FOR    | MOS   | SHB    | OTH  | CRP   | NON
---------- | ------ | ----- | ------ | ---- | ----- | -----
FOR        | 283838 |  2816 |   4212 |   24 |   599 |    3
MOS        |    200 | 40181 |     59 |    0 |     0 |   14
SHB        |    783 |   335 | 104849 |    0 |   532 |    0
OTH        |      2 |     6 |      0 | 1088 |     0 |    7
CRP        |     65 |    12 |     27 |    0 | 23877 |   60
NON        |     66 |     1 |      2 |    1 |     5 | 9658

where **FOR** is Forest, **MOS** is Mosaic Vegetation, **SHB** is Shrubland, **OTH** is Other Vegetation, **CRP** is Cropland, and **NON** is Non-Vegetation.

#### Interval-level intensity analysis
The result of the interval-level intensity analysis shows the following two plots. On the left, the plot shows the amount of change elements/pixels (as a % of the domain or study area) for each of the three time-intervals; on the right, the plot shows the annual change intensity (as a % of the domain or study area) for each of the three time-intervals. Note that for the annual change intensity plot, the annual change intensity of the 1997–2004 interval is beyond the uniform intensity (depicted by the blue vertical dashed line), indicating that the annual change during this interval is faster compared to the two other time-intervals, 1992–1997 and 2004–2015, over the entire 24-year period.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/IIA1.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/IIA2.png" width="500" /> |
|:---:|:---:|

#### Category-level intensity analysis
The result of the category-level intensity analysis shows the following plots. The plots on the left shows the annual change size in terms of number of elements/pixels for each land cover category during a specific time-interval where the red bars indicate annual loss and the green bars indicate annual gain for a specific category. On the other hand, the plots on the right shows the annual change intensity by category (as a % of the category) during a specific time-interval where the light red bars indicate annual loss for the category while the light green bars indicate annual gain intensity for the category.

###### (a) Category-level intensity analysis for 1992–1997 time-interval

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA1.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA2.png" width="500" /> |
|:---:|:---:|

For the 1992–1997 interval, we see from the left plot that annual loss was high for Forest, and annual gains were high for Shrubland, Mosaic Vegetation, and Cropland. Then, for the plot on the right, we see that the annual loss change intensities were beyond the uniform intensity (blue vertical dashed line) for Other Vegetation and Forest, indicating that these were actively losing categories during the time-interval, whereas the annual gain change intensities of Shrubland, Non-Vegetation, Cropland, and Mosaic Vegetation were beyond the uniform intensity, indicating that these were actively gaining categories during the time-interval.

###### (b) Category-level intensity analysis for 1997–2004 time-interval

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA3.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA4.png" width="500" /> |
|:---:|:---:|

For the 1997–2004 interval, we see from the left plot that annual loss was high for Forest, and annual gains were high for Shrubland, Mosaic Vegetation, and Other Vegetation. Note that the annual loss in terms of pixels for Forest during this time-interval (close to 10000 pixels) is higher than the annual loss in terms of pixels for Forest during the 1992–1997 time-interval (close to 1000 pixels only). Then, for the plot on the right, we see that the annual loss change intensities were beyond the uniform intensity (blue vertical dashed line) for Forest only, indicating that it was an actively losing category during the time-interval, whereas the annual gain change intensities of Shrubland, Mosaic Vegetation, and Other Vegetation were beyond the uniform intensity, indicating that these were actively gaining categories during the time-interval.

###### (c) Category-level intensity analysis for 2004–2015 time-interval

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA5.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/CIA6.png" width="500" /> |
|:---:|:---:|

For the 2004–2015 interval, we see from the left plot that annual loss was high for Forest, and annual gains were high for Shrubland, Mosaic Vegetation, Cropland, and Forest. Note that the annual loss in terms of pixels for Forest during this time-interval was less than the annual loss in terms of pixels for Forest during the two prior time-intervals. Then, for the plot on the right, we see that the annual loss change intensities were beyond the uniform intensity (blue vertical dashed line) for Forest only, indicating that it was an actively losing category during the time-interval, whereas the annual gain change intensities of Mosaic Vegetation, Cropland, Shrubland, and Other Vegetation were beyond the uniform intensity, indicating that these were actively gaining categories during the time-interval.

#### Transition-level intensity analysis
The result of the transition-level intensity analysis shows the plots below, specifically for the transitions of Forest loss or deforestation (i.e., From Forest) for each time-interval. The output plots for the other land cover categories are found in the [outputs](https://github.com/dondealban/learning-intensity-analysis/tree/master/outputs) folder of this repository. The plots on the left shows the annual transition size (in terms of number of elements/pixels) for gains of the specific land cover category from Forest during a specific time-interval. On the other hand, the plots on the right shows the annual transition intensity (as % of the category at initial time) for gains of the specific land cover category from Forest during a specific time-interval.

###### (a) Transition-level intensity analysis for 1992–1997 time-interval

During the 1992–1997 interval, Forest lost to Shrubland, Mosaic Vegetation, and Cropland. The plots below show the gain of Shrubland from different land cover categories during the time-interval, of which we see the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Shrubland. The gain of Shrubland is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity (red vertical dashed line), whereas the gain of Cropland is avoided by the loss of Mosaic Vegetation and Other Vegetation as shown by the light blue bar not extending beyond the uniform intensity.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_5.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_6.png" width="500" /> |
|:---:|:---:|

Next, the plots below show the gain of Mosaic Vegetation most prominently from the loss of Forest during the time-interval. We see the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Mosaic Vegetation. The gain of Mosaic Vegetation is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity (red vertical dashed line).

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_3.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_4.png" width="500" /> |
|:---:|:---:|

Finally, the plots below show the gain of Cropland most prominently from the loss of Forest during the time-interval. We see the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Cropland. The gain of Cropland is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity (red vertical dashed line), whereas the gain of Cropland is avoided by the loss of Mosaic Vegetation and Other Vegetation.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_9.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_10.png" width="500" /> |
|:---:|:---:|

###### (b) Transition-level intensity analysis for 1997–2004 time-interval

During the 1997–2004 interval, Forest lost to Shrubland, Mosaic Vegetation, and Other Vegetation. The plots below show the gain of Shrubland most prominently from Forest during the time-interval. The transition size of Forest loss is shown as having the highest number of pixels/elements contributing to the gain of Shrubland. The gain of Shrubland is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_5.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_6.png" width="500" /> |
|:---:|:---:|

Next, the plots below show the gain of Mosaic Vegetation most prominently from the loss of Forest during the time-interval. We see the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Mosaic Vegetation. The gain of Mosaic Vegetation is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity, whereas the gain of Mosaic Vegetation is avoided by the loss of other land cover categories.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_3.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_4.png" width="500" /> |
|:---:|:---:|

Finally, the plots below show the gain of Other Vegetation comes mainly from the loss of Forest and followed by Shrubland during the time-interval. We see the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Other Vegetation. The gain of Other Vegetation is also targeted by both the loss of Forest and Shrubland as shown by the light blue bar beyond the uniform intensity, whereas the gain of Other Vegetation is avoided by the loss of Cropland.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_7.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA2_8.png" width="500" /> |
|:---:|:---:|

###### (c) Transition-level intensity analysis for 2004–2015 time-interval

During the 2004–2015 interval, Forest lost to Shrubland, Mosaic Vegetation, and Cropland. The plots below show the gain of Shrubland most prominently from Forest during the time-interval, with the transition size of Forest loss having the highest number of pixels/elements contributing to the gain of Shrubland. The gain of Shrubland is also targeted by the loss of Forest as shown by the light blue bar beyond the uniform intensity.

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA3_5.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA3_6.png" width="500" /> |
|:---:|:---:|

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_3.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_4.png" width="500" /> |
|:---:|:---:|

| <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_9.png" width="500" /> | <img src="https://github.com/dondealban/learning-intensity-analysis/blob/master/outputs/TIA1_10.png" width="500" /> |
|:---:|:---:|



<a name="save_outputs"></a>

### F. Save Outputs
We can save the outputs of the Intensity Analysis as CSV files as show in the `intensity.analysis` package [vignette](https://cran.r-project.org/web/packages/intensity.analysis/vignettes/README.html):
```R
# Interval-level Intensity Analysis
IIAname <- file.path(normalizePath(getwd()), "IIA.csv")
IIA2csv(IIA.output, time.points, IIAname)

# Category-level Intensity Analysis
CIAname <- file.path(normalizePath(getwd()), "CIA.csv")
CIA2csv(CIA.output, time.points, categories, CIAname)

# Transition-level Intensity Analysis
TIAname <- file.path(normalizePath(getwd()), "TIA.csv")
TIA2csv(TIA.output, time.points, categories, TIAname)
```


<a name="references"></a>

## References

<a name="aldwaik_pontius_2012"></a>
Aldwaik, S.Z., Pontius, R.G. (2012) Intensity analysis to unify measurements of size and stationarity of land changes by interval, category, and transition. *Landscape and Urban Planning*, 202, 18–27. [doi:10.1016/j.landurbplan.2012.02.010](https://doi.org/10.1016/j.landurbplan.2012.02.010)

<a name="dealban_etal_2019"></a>
De Alban, J.D.T., Prescott, G.W., Woods, K.M., Jamaludin, J., Latt, K.T., Lim, C.L., Maung, A.C., Webb, E.L. (2019) Integrating analytical frameworks to investigate land-cover regime shifts in dynamic landscapes. *Sustainability*, 11(4), 1139. [doi:10.3390/su11041139](https://doi.org/10.3390/su11041139)

<a name="pontius_khallaghi_2019"></a>
Pontius, R.G., Khallaghi, S. (2019) intensity.analysis: Intensity of Change for Comparing Categorical Maps from Sequential Intervals.

<a name="contribute"></a>

## Want to Contribute?
In case you wish to contribute or suggest changes, please feel free to fork this repository. Commit your changes and submit a pull request. Thanks.
