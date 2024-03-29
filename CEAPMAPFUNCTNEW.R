source("https://raw.githubusercontent.com/Rojakaveh/CEAP-ARS-watersheds/main/get_usgs_gage")
################################################HUCS IN WBHUC10
hucs=c("02050301",
       "02060005",
       "05060001",
       "04100003",
       "08030205",
       "08030203",
       "08030207",
       "08020204",
       "08020203",
       "07110006",
       "07110006",
       "07080207",
       "07080105",
       "12060202",
       "12070201",
       "11130302",
       "11130302",
       "17040212",
       "03110204",
       "04300108",
       "18030007"
)

#################################usgs gage ID
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
WBHUC10=list()
for(j in hucs){  
  #url=paste0("https://prd-tnm.s3.amazonaws.com/StagedProducts/Hydrography/NHD/HU8/HighResolution/Shape/NHD_H_",j,"_HU8_Shape.zip")
  #download.file(url,paste0("NHD_H_",j,"_HU8_Shape.zip"))
  #unzip(paste0("NHD_H_",j,"_HU8_Shape.zip"),exdir=j)
  # Take a quick look at what is included in the NHD dataset
  #list.files("j/Shape/",pattern = "dbf")
  WBHUC10[j]=readOGR(paste0(j,"/Shape/WBDHU10.shp"))
}
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
#colors <- c("Dfb"="dark blue", "Dfa"="light blue", "Cfa"="light green", "BSk"="Orange", "Csa"="yellow")
state <- map_data("state")
a=ggplot(data=state, aes(x=long, y=lat, fill=region, group=group)) + 
  geom_polygon(color = "white",fill="gray") + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(),legend.position = "bottom") +
  
  coord_fixed(1.3)
for(i in 1:19){
  b=a+geom_polygon(data=WBHUC10[[i]],fill="green")
  a=b
}
c=a+geom_point(data=cordinates,aes(x=declon,y=declat), color="red",inherit.aes = FALSE)



k=c(1,18)
for(i in k){
  # WBHUC10[[i]]$col="Dfb"
  b=a+geom_polygon(data=WBHUC10[[i]],aes(fill="dark blue"))+
    theme(legend.title = element_blank()) +
    scale_fill_identity("Climate Type", labels = c("Dfb"), breaks = c("dark blue"), guide = "legend") 
  
  
  a=b
  
}
a
l=c(2,3,4,10,11,12)
for(i in l){
  b=a+geom_polygon(data=WBHUC10[[i]],aes(fill="light blue"))+
    theme(legend.title = element_blank()) +
    scale_fill_identity("Climate Type", labels = c("Dfb","Dfa"), breaks = c("dark blue","light blue"), guide = "legend")    
  a=b
}
a
m=c(5,6,7,8,9,13,14,15,17)
for(i in m){
  b=a+geom_polygon(data=WBHUC10[[i]],aes(fill="light green"))+
    theme(legend.title = element_blank()) +
    scale_fill_identity("Climate Type", labels = c("Dfb","Dfa","Cfa"), breaks = c("dark blue","light blue","light green"), guide = "legend")        
  a=b
}
a
n=c(16)
for(i in n){
  b=a+geom_polygon(data=WBHUC10[[i]],aes(fill="orange"))+
    theme(legend.title = element_blank()) +
    scale_fill_identity("Climate Type", labels = c("Dfb","Dfa","Cfa","BSk"), breaks = c("dark blue","light blue","light green","orange"), guide = "legend")           
  a=b
}
a
s=c(19)
for(i in s){
  b=a+geom_polygon(data=WBHUC10[[i]],aes(fill="yellow"))+
    theme(legend.title = element_blank()) +
    scale_fill_identity("Climate Type", labels = c("Dfb","Dfa","Cfa","BSk","Csa"), breaks = c("dark blue","light blue","light green","orange","yellow"), guide = "legend")               
  a=b
}
a
plotclr <-  c("dark blue", "light blue", "light green","Orange","yellow")
a+ theme(legend.title = element_blank()) +
  scale_fill_identity("Title legend", labels = c("Dfb", "Dfa", "Cfa","BSk","Csa"), breaks = plotclr, guide = "legend") 
theme(legend.position = "bottom")
a+scale_color_identity(name = "Climate Type",
                       breaks = c("dark blue", "light blue", "light green","Orange","yellow"),
                       labels = c("Dfb", "Dfa", "Cfa","BSk","Csa"),
                       guide = "legend")+
  theme(legend.text = element_text(size = 20))+
  geom_point(data=cordinates,aes(x=declon,y=declat), color="red",inherit.aes = FALSE)
  

#roja=c(1,2,3)
#amir=c(4,5,6)
#plot(roja,amir)
