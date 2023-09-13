options(repos ="http://cran.us.r-project.org")  # required to get latest libs
# Installing the packages 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(elevatr,soilDB,rgdal,raster,EcoHydRology,rnoaa,curl,httr,ggplot2,data.table)
dir.create("/dev/shm/rojakaveh")
setwd("/dev/shm/rojakaveh")
rm(list=objects())

###Source TMWB model
source("https://raw.githubusercontent.com/vtdrfuka/BSE5304_2022/main/functions/TMWBmodel.R")
source("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/get_usgs_gage")
myflowgage_id="11208600"
myflowgage=get_usgs_gage(myflowgage_id,begin_date = "2010-01-01",end_date = "2022-01-01")
# Note that flow returned is in m3/day, but we want mm/day for the basin
myflowgage$flowdata$Qmm = myflowgage$flowdata$flow/myflowgage$area/10^3
###############################################################
source("https://raw.githubusercontent.com/Rojakaveh/FillMissWX/main/FillMissWX.R")
flow_mindate=min(myflowgage$flowdata$mdate)
flow_maxdate=max(myflowgage$flowdata$mdate)

####################################################
#Do not forget to test for each closest, idw, and idew
#"closest", "IDW", "IDEW"
#######################################################IDW initialization
WXData=FillMissWX(declat = myflowgage$declat,declon = myflowgage$declon,StnRadius = 60,date_min=flow_mindate,date_max=flow_maxdate,method = "IDEW",minstns =10)
AllDays=data.frame(date=seq(flow_mindate, by = "day", length.out = flow_maxdate-flow_mindate))
WXData=merge(AllDays,WXData,all=T)
#WXData$DATE=WXData$date

# Create an aligned modeldata data frame to build our model in
modeldata=merge(WXData,myflowgage$flowdata,by.x="date",by.y="mdate")
#modeldata$MaxTemp=modeldata$tmax # Converting to C
#modeldata$MinTemp=modeldata$tmin # Converting to C
#modeldata$P=modeldata$prcp # Converting to mm
# View(modeldata)  
# Comparing precipitation to the flow out of basin
modeldata$P[is.na(modeldata$P)]=0
modeldata$MinTemp[is.na(modeldata$MinTemp)]=0
modeldata$MaxTemp[is.na(modeldata$MaxTemp)]=modeldata$MinTemp[is.na(modeldata$MaxTemp)] +1
modeldata$MaxTemp[modeldata$MaxTemp<=modeldata$MinTemp]=modeldata$MinTemp[modeldata$MaxTemp<=modeldata$MinTemp]+1
modeldata$AvgTemp=(modeldata$MaxTemp+modeldata$MinTemp)/2.0
modeldata[is.na(modeldata)]=0 # A Quick removal of NAs
TMWB=modeldata

#optimize TMWB
f <- function (x) {
  fcresopt=x[1]
  SFTmpopt=x[2]
  Tlagopt=x[3]
  AWCopt=x[4]
  TMWBnew=TMWBmodel(TMWB=TMWB,fcres=fcresopt,SFTmp = SFTmpopt,Tlag =Tlagopt,AWCval = AWCopt)
  1-NSE(TMWBnew$Qmm,TMWBnew$Qpred)  
}
lower <- c(0.1,-5,0,50)
upper <- c(0.5,20,1,350)

## run DEoptim and set a seed first for replicability
set.seed(1234)
A=DEoptim(f, lower, upper,control = DEoptim.control(itermax=30))
##############################
##HERE YOU HAVE TO CHANGE THE VALS

TMWBnew=TMWBmodel(TMWB=TMWB,fcres=0.1010282,SFTmp =19.8237382,Tlag =0.6437485 ,AWCval =68.9464496)
NSE(TMWBnew$Qmm,TMWBnew$Qpred)
#0.3627943
