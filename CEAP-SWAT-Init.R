pacman::p_load(devtools,httr,EcoHydRology,curl,GSODR,rnoaa,data.table,DEoptim,tidyverse)
#install_github("{yourGitHubhere}/BSE4304/BSEHydroModels")
setwd("~/CEAPwatersheds/")
#EXAMPLE-USGS02317797-LITTLERIVERATUPPERTYTYROADNEAR TIFTON-GA
flowgage_id="02317797" 
flowgage=get_usgs_gage(flowgage_id,begin_date = "2010-01-01",
                       end_date = "2022-01-01")
source(
  paste0(
    "https://raw.githubusercontent.com/Rojakaveh/FillMissWX/main/FillMissWX.R"
  )
)
##################################weathe data
#FillMissWX=function(declat, declon,StnRadius,minstns,date_min,date_max,method,alfa=2)
###IDW, alpha=2
########################################################
hist_wx=FillMissWX(declat = flowgage$declat,declon = flowgage$declon,StnRadius =60,minstns = 10,date_min = "2010-01-01",
                   date_max="2021-01-01",method = "IDW",alfa = 2)
##############source SWAT_Init
source(
  paste0(
    "https://raw.githubusercontent.com/Rojakaveh/SWATinitialization/main/SWATInitializationFunc.R"
  )
)
######SwatInitialization=function (dirname="OWASCOIDWalpha", iyr="2010", nbyr=12,
#wsarea=flowgage$area, elev=flowgage$elev,
#declat=flowgage$declat, declon=flowgage$declon, hist_wx)
###########################################################################
dir.create("~/src")
setwd("~/src")
system("svn checkout svn://scm.r-forge.r-project.org/svnroot/ecohydrology/")
install.packages("~/src/ecohydrology/pkg/SWATmodel/",repos = NULL)
##############
library(SWATmodel)
setwd("~/CEAPPROJ/CEAP-ARS-watersheds/")
SwatInitialization(dirname = "IDW-USGS02317797-LITTLERIVERATUPPERTYTYROADNEAR TIFTON-GA",iyr = "2010",nbyr = 20,wsarea =flowgage$area,
                   elev=flowgage$elev,declat =flowgage$declat,declon=flowgage$declon, hist_wx )
file.remove("pcp1.pcp")
file.remove("tmp1.tmp")
setwd("..")
################################################################################################
####Closest
###############################################################################
hist_wx=FillMissWX(declat = flowgage$declat,declon = flowgage$declon,StnRadius = 60,minstns = 10,date_min = "2010-01-01",
                   date_max="2021-01-01",method = "closest",alfa = 2)

SwatInitialization(dirname = "Closest-USGS02317797-LITTLERIVERATUPPERTYTYROADNEAR TIFTON-GA",iyr = "2010",nbyr = 20,wsarea =flowgage$area,
                   elev=flowgage$elev,declat =flowgage$declat,declon=flowgage$declon, hist_wx )
file.remove("pcp1.pcp")
file.remove("tmp1.tmp")
