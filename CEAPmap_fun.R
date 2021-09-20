
#url="http://bit.ly/get_usgs_gageR"
#source(url)
library(ggplot2)
library(maps)
library(mapdata)
get_usgs_gage=function(flowgage_id,begin_date="1979-01-01",end_date="2013-01-01"){
  #
  # Grabs USGS stream flow data for 1979 to present... to align with CFSR datasets.
  #
  url = paste("https://waterdata.usgs.gov/nwis/inventory?search_site_no=", flowgage_id, "&search_site_no_match_type=exact&sort_key=site_no&group_key=NONE&format=sitefile_output&sitefile_output_format=rdb&column_name=station_nm&column_name=site_tp_cd&column_name=dec_lat_va&column_name=dec_long_va&column_name=alt_va&column_name=drain_area_va&column_name=contrib_drain_area_va&column_name=rt_bol&list_of_search_criteria=search_site_no",sep="")
  
  gage_tsv=readLines(url)
  gage_tsv=gage_tsv[grep("^#",gage_tsv,invert=T)][c(1,3)]
  tempdf=read.delim(text=gage_tsv,sep="\t",header=T,colClasses = c("character", "character", "numeric", "numeric", "character", "character", "numeric", "numeric", "character", "numeric"))
  area = tempdf$drain_area_va* 1.6^2
  if(is.na(area)) {area=0;print("warning, no area associated with gage, setting to 0\n")}
  declat = tempdf$dec_lat_va
  declon = tempdf$dec_long_va
  elev = tempdf$alt_va* 12/25.4
  if(is.na(elev)) {elev=0;print("warning, no elevation associated with gage, setting to 0\n")}
  
  gagename = tempdf$station_nm
  begin_date = as.character(begin_date)
  end_date = as.character(end_date)
  
  url = paste("https://nwis.waterdata.usgs.gov/nwis/dv?cb_00060=on&format=rdb&begin_date=",begin_date,"&end_date=",end_date,"&site_no=", flowgage_id, sep = "")
  flowdata_tsv=gage_tsv=readLines(url)
  flowdata_tsv=flowdata_tsv[grep("^#",flowdata_tsv,invert=T)][c(3:length(flowdata_tsv))]
  flowdata = read.delim(text=flowdata_tsv,header=F,sep="\t",col.names = c("agency", "site_no", "date", "flow", "quality","junk1","junk2","junk3","junk4"), colClasses = c("character", "numeric", "character", "character", "character","character","character","character","character"), fill = T)
  flowdata$mdate = as.Date(flowdata$date, format = "%Y-%m-%d")
  flowdata$flow = as.numeric(as.character(flowdata$flow)) * 12^3 * 2.54^3/100^3 * 24 * 3600
  flowdata = na.omit(flowdata)
  returnlist = list(declat = declat, declon = declon, flowdata = flowdata, area = area, elev = elev, gagename = gagename)
  return(returnlist)
  
}
################################################HUCS IN WBHUC10
hucs=c("02050301",
       "02060005",
       "05060001",
       "04100003",
       "08030205",
       "08030203",
       "08030207",
       "08020203",
       "07110006",
       "07080207",
       "07080105",
       "12070101",
       "12070201",
       "11130302",
       "11130302",
       "17040209",
       "03110204"
)
gids=c("01555500",
       "01491000",
       "03228500",
       "04179520",
       "04180000",
       "04101000",
       "04180500",
       "04178000",
       "07282075",
       "07275500",
       "0728862107",
       "05506100",
       "05451080",
       "05471000",
       "08098224",
       "08100500",
       "07327442",
       "07325840",
       "13087900",
       "02317797")

CEAPmap_fun=function(hucs,gids){

WBHUC10=list()
for(j in hucs){
  
  
  url=paste0("https://prd-tnm.s3.amazonaws.com/StagedProducts/Hydrography/NHD/HU8/HighResolution/Shape/NHD_H_",j,"_HU8_Shape.zip")
  download.file(url,paste0("NHD_H_",j,"_HU8_Shape.zip"))
  unzip(paste0("NHD_H_",j,"_HU8_Shape.zip"),exdir=j)
  # Take a quick look at what is included in the NHD dataset
  #list.files("j/Shape/",pattern = "dbf")
  WBHUC10[j]=readOGR(paste0(j,"/Shape/WBDHU10.shp"))
}
##################################################################################################
######USGS LAT/LON
##################################################################################################

flowgages=list()
for (flowgage_id in gids){
  print(flowgage_id)
  flowgage=get_usgs_gage(flowgage_id,begin_date = "2010-01-01",end_date
                         = "2022-01-01")
  flowgages=c(flowgages, list(flowgage))
  #flowgages[flowgage_id]=c(flowgages,flowgage)
}

CEAPflowgages=as.data.frame(do.call(rbind, flowgages))
ROJALAT=CEAPflowgages$declat
ROJALON=CEAPflowgages$declon
ROJADECLAT=as.data.frame(do.call(rbind, ROJALAT))
ROJADECLON=as.data.frame(do.call(rbind, ROJALON))
names(ROJADECLAT)="declat"
names(ROJADECLON)="declon"
cordinates=cbind(ROJADECLON,ROJADECLAT)
#####################################################MAPING
state <- map_data("state")
a=ggplot(data=state, aes(x=long, y=lat, fill=region, group=group)) + 
  geom_polygon(color = "white",fill="gray") + 
  guides(fill=FALSE) + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) + 
  ggtitle('U.S. Map with States') + 
  coord_fixed(1.3)
for(i in 1:16){
  b=a+geom_polygon(data=WBHUC10[[i]],color="black",fill="gray")
  a=b
}
c=a+geom_point(data=cordinates,aes(x=declon,y=declat), color="red",inherit.aes = FALSE)
return(c)
}
CEAPmap_fun(hucs,gids)
