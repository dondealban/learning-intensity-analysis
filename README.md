# Learning the Intensity Analysis framework
This is a repository set up as my personal exercise for learning the Intensity Analysis framework [(Aldwaik & Pontius 2012)](#aldwaik_pontius_2012), an approach that unifies the measurements of size and stationarity of land changes at three levels: interval, category, and transition, using the `intensity.analysis` R package implementation [(Pontius & Khallaghi 2019)](https://cran.r-project.org/web/packages/intensity.analysis/index.html). It can also be used as a tutorial for someone interested in learning Intensity Analysis for their research projects.

Previously, I implemented the Intensity Analysis framework for my land change studies using the [Microsoft Excel Macro](https://sites.google.com/site/intensityanalysis/home) developed by Aldwaik & Pontius. The recent development of the `intensity.analysis` R package now allows for the implementation of the framework within the R environment, which makes the application and implementation of the framework more repeatable, transparent, and reproducible. (And in my opinion is truly *magnificent, magnificent, magnificent*! Hence thanks and kudos to Prof Pontius and his collaborators.) This repository is thus my first attempt to learn and my record of learning the Intensity Analysis framework implementation using R software using dataset from one of my land cover change studies (see [paper](https://doi.org/10.3390/su11041139) published in Sustainability journal and its accompanying GitHub [repository](https://github.com/dondealban/ms-sustainability-2019)).

<a name="intensity_analysis"></a>
## What is the Intensity Analysis framework?
The **Intensity Analysis** framework is a quantitative method to analyse land cover change over time for an area of interest to summarise the change within time-intervals. Different types of information are extracted at three levels of analysis: interval, category, and transition, which progress from general to more detailed levels. At the ***interval level***, the total change in each time-interval is analysed to examine how the size and annual rate of change vary across time-intervals (i.e., to answer in which time-intervals are the overall annual rate of change relatively slow or fast). At the ***category level***, each land cover category is examined to measure how the size and intensity of both gross losses and gross gains vary across space (i.e., to answer which categories are relatively dormant versus active in a given time-interval, and to determine if the pattern is stable across time-intervals). Finally, at the ***transition level***, a particular transition is analysed to examine how the size and intensity of the transition vary among categories available for that transition (i.e., to answer which transitions are intensively targeted versus avoided by a given land category in a given time-interval, and to determine if the pattern is stable across time-intervals).

<a name="references"></a>
## References

<a name="aldwaik_pontius_2012"></a>
Aldwaik, S.Z., Pontius, R.G. (2012) Intensity analysis to unify measurements of size and stationarity of land changes by interval, category, and transition. *Landscape and Urban Planning*, 202, 18–27. [doi:10.1016/j.landurbplan.2012.02.010](https://doi.org/10.1016/j.landurbplan.2012.02.010)

<a name="pontius_khallaghi_2019"></a>
Pontius, R.G., Khallaghi, S. (2019) intensity.analysis: Intensity of Change for Comparing Categorical Maps from Sequential Intervals.
