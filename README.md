Using Combined and Complete  Global Historical Climatology Network (GHCN) Data for Hydrological Models
=================

Evaluation of combined datasets of GHCN, including the addition of higher-density but perhaps lower-quality citizen science weather data, combined with previously published methods to estimate missing weather data from multiple weather stations on hydrological model performance.
## Links
See the following links for more information on  `R` and `RStudio` download and installation:

- An introduction to `R`: <https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf>
- `R` download: <https://www.r-project.org/>
- `RStudio` download: <https://www.rstudio.com/>

There is also a cloud-based `RStudio` sever at the following location:

- Cloud-based `RStudio` server: <https://rstudio.cloud/>

See the following links for more information on 'GHCN' data:

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


