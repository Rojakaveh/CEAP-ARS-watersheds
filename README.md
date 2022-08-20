Benefits of Using Higher Density Lower Reliability  Weather Data from the Global Historical Climatology Network (GHCN) Monitors for Watershed Modelling
=================

Evaluation of combined datasets of GHCN, including the addition of higher-density but perhaps lower-quality citizen science weather data, combined with previously published methods to estimate missing weather data from multiple weather stations on hydrological model performance.
## Links
See the following links for more information on  `R` and `RStudio` download and installation:

- An introduction to `R`: <https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf>
- `R` download: <https://www.r-project.org/>
- `RStudio` download: <https://www.rstudio.com/>

There is also a cloud-based `RStudio` sever at the following location:

- Cloud-based `RStudio` server: <https://rstudio.cloud/>

See the following links for more information on `GHCN` data:

- Global Historical Climatology Network daily (GHCNd): <https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily>
- Community Collaborative Rain, Hail, and Snow (CoCoRaHS): <https://www.cocorahs.org/>
- Cooperative Observer Program (COOP):<https://www.weather.gov/coop/Overview>
## Description
This repository contains R codes for a project called **Using Combined and Complete  Global Historical Climatology Network (GHCN) Data for Hydrological Models**. This study evaluates whether the combined datasets of GHCN, including the addition of higher-density but perhaps lower-quality citizen science weather data, combined with previously published methods to estimate missing weather data from multiple weather stations can increase model performance. To test this, we use the SWAT model for 21 United States Department of Agriculture (USDA)-Agricultural Research Service (ARS)-Conservation Effects Assessment Project (CEAP) watersheds across five climate regions in the United States and compare the model predicted streamflow to observed data. 

## Quick start

### R packages that need to be installed:
•   rnoaa
•   EcoHydRology
•   SWATmodel
•   nhdplusTools
•   sf
•   dplyr
•   ggplot2
•   moments
•   tidyverse
•   viridis
•   egg

        if (!require("pacman")) install.packages("pacman")
        pacman::p_load(rnoaa,EcoHydRology,SWATmodel,nhdplusTools,sf,dplyr,ggplot2,moments,tidyverse,viridis,egg)

##### CEAPMAPFUNCTNEW.R
This script automatically generates a map representing the location of CEAP watersheds and their climate classification.

        download.file("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/CEAPMAPFUNCTNEW.R","CEAPMAPFUNCTNEW.R")
        file.edit("CEAPMAPFUNCTNEW.R")

##### multipleSWAT_init_calib.R
This script automatically initializes three SWAT models for 21 CEAP watersheds with three missing weather estimation methods including closest, IDW, and IDEW, using the SWATmodel R package. Each initialization folder is named with the estimation method followed by the USGS gage ID. After model initialization in each of the 21 ARS-CEAP watersheds, 19 parameters, previously shown as important SWAT streamflow parameters, will be calibrated using the DEoptim algorithm. Finally, the data frame containing the calibrated parameters and the optimum Nash-Sutcliffe efficiency (NSE) will be generated for each SWAT model.  
In order to run this script in `RStudio`:

        download.file("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/multipleSWAT_init_calib.R","multipleSWAT_init_calib.R")
        file.edit("multipleSWAT_init_calib.R")

##### Barplot.R
This script genrates the stacked barplot of the number and type of GHCN stations used to obtain and fill in missing precipitation data of 21 USGS gages. Each bar represents the numbers and types of precipitation GHCN stations, including CoCoRaHS (purple), COOP (air force blue), SNOTEL (aquamarine), and WBAN (yellow) for a basin with the associated number from Table 1. The basins are grouped based on climate classification, including Dfa, Dfb, BSk, Cfa, Csa. The black lines that range from 0-110 show the y-axis scales (number of GHCN stations). For runing the code the excel file containing the data is provided in this repository as `data.xlsx`.

        download.file("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/Barplot.R","Barplot.R")
        file.edit("Barplot.R")
        
##### OnewayANOVA.R
This script contains R code for one-way ANOVA test. One-way analysis of variance (ANOVA) test was used individually for each of the statistical measures (NSE, RSR, PABIAS) obtained from three estimation methods for 21 watersheds to identify if there are any statistically significant differences between the means of estimation methods (three independent groups including closest, IDW, and IDEW with 21 samples (values of a statistical metric) per each group). Note that the significance level is α = 0.1 as recommended by (Kim & Choi, 2021) for small sample sizes. For runing the code the excel files containing the data are provided in this repository as `NSE_ANOVA.xlsx`, `RSR_ANOVA.xlsx`, and `PABIAS_ANOVA.xlsx`.

        download.file("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/OnewayANOVA.R","OnewayANOVA.R")
        file.edit("OnewayANOVA.R")
        
##### StatMeasureBoxplot.R
This script generates a boxplot. The boxplot of NSE (a), RSR (b), and PABIAS (c), values (dots) of ARS-CEAP watersheds obtained from closest, IDW, and IDEW were grouped based on climate classification. For runing the code the excel file containing the data is provided in this repository as `BBOXNEW1.xlsx`.

        download.file("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/StatMeasureBoxplot.R","StatMeasureBoxplot.R")
        file.edit("StatMeasureBoxplot.R")

# License
Please see the LICENSE.md file for license information.
