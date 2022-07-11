setwd("~")
dir.create("CEAP_Paper")
setwd("CEAP_Paper/")
rm(list=objects())
pacman::p_load(nhdplusTools,sf,dplyr,rnoaa,SWATmodel,ggplot2,moments)
source("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/get_nldi_basin_new.R")
source("https://raw.githubusercontent.com/Rojakaveh/Elab_SWATinitcalib/main/build_wgn_file.R") #loading the build_wgn_file func
source("https://raw.githubusercontent.com/Rojakaveh/FillMissWX/main/FillMissWX.R")#loading fillmisswx func
source("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/get_usgs_gage")
source("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/swat_objective_function_rch.R")
##-----getting usgs info--------------------------
#Here we 
gids=c("01555500",
       "01491000",
       "03228300",
       "04180000",
       "07283000",
       "07274000",
       "07288500",
       "07043500",
       "07047855",
       "05506800",
       "05506100",
       "05451210",
       "05471000",
       "08096500",
       "08100500",
       "07327442",
       "07325840",
       "13090000",
       "02317797",
       "04282650",
       "11208600"
       
)

for (i in gids){
  #i= "04282650"
  flowgage_id=i #Little Otter Creek at Ferrisburg, VT.
  flowgage=get_usgs_gage(flowgage_id,begin_date = "2010-01-01",end_date= "2021-12-31")
  flowgage$flowdata$Qm3ps= flowgage$flowdata$flow/24/3600 #m3/s# getting flow for calibration as observation
  #####getting the watershed centroid for making weather dataset for watershed centroid
  nldi_nwis <- list(featureSource = "nwissite", featureID = paste0("USGS-",i))
  basin <- get_nldi_basin_new(nldi_feature = nldi_nwis,
                              simplify = FALSE, split = TRUE)
  center=st_centroid(sf::st_geometry(basin))
  centerlong=center[[1]][1]
  centerlat=center[[1]][2]
  ##getting ghcn weather data
  INT_Meth=c("closest","IDW","IDEW")
  for (int_meth in INT_Meth){
    
    WXData=FillMissWX(declat = flowgage$declat,declon = flowgage$declon,StnRadius =30,date_min=min(flowgage$flowdata$mdate),date_max=max(flowgage$flowdata$mdate),method=int_meth,minstns = 3,alfa = 2)
    AllDays=data.frame(date=seq(min(flowgage$flowdata$mdate), by = "day", length.out = max(flowgage$flowdata$mdate)-min(flowgage$flowdata$mdate)))
    WXData=merge(AllDays,WXData,all=T)
    WXData$PRECIP=WXData$P
    WXData$PRECIP[is.na(WXData$PRECIP)]=-99
    WXData$TMX=WXData$MaxTemp
    WXData$TMX[is.na(WXData$TMX)]=-99
    WXData$TMN=WXData$MinTemp
    WXData$TMN[is.na(WXData$TMN)]=-99
    WXData$DATE=WXData$date
    #making swat init in the directory with the same name as usgs gagename
    build_swat_basic(dirname= paste0(int_meth,i), iyr=min(year(WXData$DATE),na.rm=T), nbyr=(max(year(WXData$DATE),na.rm=T)-min(year(WXData$DATE),na.rm=T) +1), wsarea=flowgage$area, elev=flowgage$elev, declat=flowgage$declat, declon=flowgage$declon, hist_wx=WXData)
    build_wgn_file() #wgn func
    runSWAT2012() #run swat 
    ###--------Calibration----------
    source("https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/SWATmodel/R/readSWAT.R?root=ecohydrology")
    save(readSWAT,file="readSWAT.R")
    source("https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/EcoHydRology/R/setup_swatcal.R?root=ecohydrology")
    change_params=""
    rm(change_params)
    load(paste(path.package("EcoHydRology"), "data/change_params.rda", sep = "/"))
    calib_range=c("1999-12-31","2021-12-31")
    params_select=c(1,2,3,4,5,6,7,8,9,10,11,14,19,21,22,23,24,32,33)
    calib_params=change_params[params_select,]
    #calib_params$current[2]=0.5
    calib_params$min[9]=0
    calib_params$min[10]=0
    calib_params$current[9]=2.5
    calib_params$current[10]=2.5
    calib_params$min[11]=0.01
    calib_params$max[11]=1
    calib_params$min[13]=40
    calib_params$max[13]=95
    calib_params$min[14]=0.3
    calib_params$max[14]=3
    calib_params$min[15]=0.3
    calib_params$max[15]=3
    calib_params$min[16]=0.3
    calib_params$max[16]=3
    calib_params$min[17]=0.3
    calib_params$max[17]=3
    calib_params$max[2]=2
    calib_params$max[3]=600
    calib_params$max[4]=0.3
    calib_params$min[2]=0
    calib_params$max[2]=1
    calib_params$current[2]=0.5
    calib_params[c(9,10),4]=0
    calib_params[c(9,10),6]=2.5
    calib_params[11,5]=1
    calib_params[11,6]=.5
    calib_params[1:7]
    setup_swatcal(calib_params)
    rch=3
    x=calib_params$current
    swat_objective_function_rch(x,calib_range,calib_params,flowgage,rch,save_results=F)
    cl <- parallel::makeCluster(16)
    nam=paste0("outDEoptim",int_meth,i)
    assign(nam,DEoptim(swat_objective_function_rch,calib_params$min,calib_params$max,
                       DEoptim.control(cluster=cl,strategy = 6,NP = 16,itermax=300,parallelType = 1,
                                       packages = c("SWATmodel","dplyr","EcoHydRology","base","topmodel","utils","cl"),parVar=c("%<%","NSeff","read.fortran","readSWAT","alter_files")),calib_range,calib_params,flowgage,rch))
    setwd("..")
  }
}
