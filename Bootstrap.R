setwd("~/CEAPwatersheds/")
dir.create("/dev/shm/rojakaveh")
setwd("/dev/shm/rojakaveh")
dir.create("Closest_USGS07325840")
file.copy(list.files("~/CEAPwatersheds/Closest-USGS07325840/",full.names = TRUE,recursive = TRUE),"/dev/shm/rojakaveh/Closest_USGS07325840/",recursive = TRUE)
setwd("/dev/shm/rojakaveh/Closest_USGS07325840/")

flowgage_id="07325840"
flowgage=get_usgs_gage(flowgage_id,begin_date = "2010-01-01",
                       end_date = "2022-01-01")


flowgage$flowdata$Qm3ps= flowgage$flowdata$flow/24/3600 #m3/s
#plot(flowgage$flowdata$mdate,flowgage$flowdata$Qm3ps,type="l")

library(SWATmodel)
#  Load updated functions
source("https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/SWATmodel/R/readSWAT.R?root=ecohydrology")
save(readSWAT,file="readSWAT.R")
source("https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/EcoHydRology/R/setup_swatcal.R?root=ecohydrology")
source("https://r-forge.r-project.org/scm/viewvc.php/*checkout*/pkg/EcoHydRology/R/swat_objective_function_rch.R?root=ecohydrology")

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

################################change sensitive params here
#params_select=c(3,6,7,8,9,10,11,13,14,16,17,18,19)
#calib_params=calib_params[params_select,]



calib_params[1:7]
setup_swatcal(calib_params)
rch=3

# DO NOT FORGET TO CHANGE PARAMS HERE
x=c(376, 0.56, 462, 0.088, 263.73, 0.24, 4.79, -1.83, 0.27, 0.72, 0.49, 0.87, 66, 0.95, 2.36, 0.83, 2.13, 0.86, 0.91)





# swat_objective_function_rch=function (x, calib_range, calib_params, flowgage, rch,save_results=F){
#   calib_params$current <- x
#   tmpdir=as.character(as.integer((runif(1)+1)*10000))
#   tmpdir=paste(c(format(Sys.time(), "%s"),tmpdir,Sys.getpid()),sep="",collapse="")
#   print(tmpdir)
#   dir.create(tmpdir)
#   file.copy(list.files(),tmpdir)
#   setwd(tmpdir)
#   file.remove(list.files(pattern="output."))
#   alter_files(calib_params)
#   libarch = if (nzchar(base::version$arch)) paste("libs", base::version$arch, sep = "/") else "libs"
#   swatbin <- "rswat2012.exe"
#   junkout=system(shQuote(paste(path.package("SWATmodel"), libarch, swatbin, sep = "/")),intern = TRUE)
#   start_year = read.fortran(textConnection(readLines("file.cio")[9]), "f20")
#   load("readSWAT.R")
#   outdata = readSWAT("rch",".")
#   #outdata_hru=readSWAT("hru",".")
#   test2 = subset(outdata, outdata$RCH == rch)
#   test3 = merge(flowgage$flowdata, test2, all = F)
#   NS = NSeff(test3$Qm3ps, test3$FLOW_OUTcms)
#   print(NS)
#   plot(test3$Qm3ps, test3$FLOW_OUTcms, col="red", xlab="Observation Flow (cms)", ylab = "Simulation Flow (cms)",cex.axis=1.25,cex.lab=1.25,ylim=c(0,100),xlim=c(0,100))
#   abline(lm(FLOW_OUTcms ~ Qm3ps, data = test3), col = "red",lwd=2)
#   abline(a=0,b=1,col="black",lwd=2,lty="dashed")
#   text(95,90,"x=y",col="black",cex=1.25)
#   #points(test3$Qmm, test3$FLOW_OUTmm, col="blue", xlab="Observation Flow (mm)", ylab = "Simulation Flow (mm)",cex.axis=1.25,cex.lab=1.25,ylim=c(0,35))
#   #abline(lm(FLOW_OUTmm ~ Qmm, data = test3), col = "blue",lwd=2)
#   #points(test3$Qm3ps, test3$FLOW_OUTcms, col="green")
#   #legend("topleft",legend = c("2010-2021 calibration, NSE=0.62","2015-2021 calibration, NSE=0.62"),col = c("red","blue"),lty = 1:2, cex = 1, pch=c(1,1))
#   #text(4, 60, expression(R^2 == 0.47),col="blue",cex=1.25)
#   #plot(test3$Qm3ps, test3$FLOW_OUTcms, col="black", xlab="Observation Flow", ylab = expression(paste("Simulation Flow Closest,", alpha, "=2")),cex.axis=1.25,cex.lab=1.25)
#   #text(4, 50, expression(R^2 == 0.61),col="blue",cex=1.25)
#   #lmodel=lm(FLOW_OUTcms~Qm3ps,data = test3)
#   #R2=summary(lmodel)$r.squared
#   #print(R2)
#   #par(mar = c(5, 4, 4, 8),                                  # Specify par parameters
#   #xpd = TRUE)
#   plot(test3$mdate,test3$Qm3ps , type = "l", col="black", cex.axis=1.25, lwd= 2,xlab="Date",ylab="Flow (cms)",cex.lab=1.25)
#   lines(test3$mdate,test3$FLOW_OUTcms,type="l",col="red",lwd= 2)
#   #legend("topleft",legend = c("Observation","Simulation using Weather Generator"),col = c("blue","red"),horiz=TRUE, lwd=1.25,cex=0.8,bty="n",inset=0)
#   legend("topleft",legend = c("Observation","Simulation (Closest, NSE=0.78)"),col = c("black","red"),lty = 1:2, cex = 1)
#   
#   #legend("topleft",legend = c("Observation",expression(paste("Simulation Flow Closest,", alpha, "=2, NSE=0.33"))),col = c("black","red"),lty = 1:2, cex = 1)
#   
#   if(save_results){file.copy(list.files(),"../")}
#   file.remove(list.files())
#   setwd("../")
#   file.remove(tmpdir)
#   return(abs(NS - 1))
# }
# 





# function (x, calib_range, calib_params, flowgage, rch,save_results=F)
# {
#   calib_params$current <- x
#   tmpdir=as.character(as.integer((runif(1)+1)*10000))
#   tmpdir=paste(c(format(Sys.time(), "%s"),tmpdir,Sys.getpid()),sep="",collapse="")
#   print(tmpdir)
#   dir.create(tmpdir)
#   file.copy(list.files(),tmpdir)
#   setwd(tmpdir)
#   file.remove(list.files(pattern="output."))
#   alter_files(calib_params)
#   libarch = if (nzchar(base::version$arch)) paste("libs", base::version$arch, sep = "/") else "libs"
#   swatbin <- "rswat2012.exe"
#   junkout=system(shQuote(paste(path.package("SWATmodel"), libarch, swatbin, sep = "/")),intern = TRUE)
#   start_year = read.fortran(textConnection(readLines("file.cio")[9]), "f20")
#   load("readSWAT.R")
#   outdata = readSWAT("rch",".")
#   test2 = subset(outdata, outdata$RCH == rch)
#   test3 = merge(flowgage$flowdata, test2, all = F)
#   NS = NSeff(test3$Qm3ps, test3$FLOW_OUTcms)
#   print(NS)
#   if(save_results){file.copy(list.files(),"../")}
#   file.remove(list.files())
#   setwd("../")
#   file.remove(tmpdir)
#   return(abs(NS - 1))
# }


swat_objective_function_rch(x,calib_range,calib_params,flowgage,rch,save_results=F)


#x=c(1.23, 0.68, 14.43, 0.29, 26.46, 0.14, -0.33, -0.65, 1.77, 0.27, 0.98, 1.48, 60, 2.90, 1.36, 2.54, 0.32, 0.19, 0.67)






calib_params$current <- x
tmpdir=as.character(as.integer((runif(1)+1)*10000))
tmpdir=paste(c(format(Sys.time(), "%s"),tmpdir,Sys.getpid()),sep="",collapse="")
print(tmpdir)
dir.create(tmpdir)
file.copy(list.files(),tmpdir)
setwd(tmpdir)
file.remove(list.files(pattern="output."))
alter_files(calib_params)
libarch = if (nzchar(base::version$arch)) paste("libs", base::version$arch, sep = "/") else "libs"
swatbin <- "rswat2012.exe"
junkout=system(shQuote(paste(path.package("SWATmodel"), libarch, swatbin, sep = "/")),intern = TRUE)
start_year = read.fortran(textConnection(readLines("file.cio")[9]), "f20")
load("readSWAT.R")
outdata = readSWAT("rch",".")
#outdata_hru=readSWAT("hru",".")
test2 = subset(outdata, outdata$RCH == rch)
test3 = merge(flowgage$flowdata, test2, all = F)
NS = topmodel::NSeff(test3$Qm3ps, test3$FLOW_OUTcms)
print(NS)
#plot(test3$Qm3ps, test3$FLOW_OUTcms, col="red", xlab="Time", ylab = "Discharge (cms)")
plot(test3$mdate,test3$Qm3ps , type = "l", col="blue", cex.axis=1.25, lwd= 2,xlab="Date",ylab="Flow (cms)")
lines(test3$mdate,test3$FLOW_OUTcms,type="l",col="red",lwd= 2)

##########bootstap between test3$Qm3ps (observed) and test3$FLOW_OUTcms (modeled)
pacman::p_load(boot)
myNSERun <- function(test3, i) topmodel::NSeff(test3[i,7],test3[i,14])
bootNSERun <- boot(test3, myNSERun,
                   R=10000)
bootNSERun
plot(bootNSERun)
boot.ci(bootNSERun, conf = 0.95, type = "norm", index = 1)
boot.ci(bootNSERun, conf = 0.95, type = "basic", index = 1)



####RSR

#pacman::p_load(boot)
myRSRRun <- function(test3, i) rsr(test3[i,7],test3[i,14])
bootRSRRun <- boot(test3, myRSRRun,
                   R=10000)
bootRSRRun
plot(bootRSRRun)
boot.ci(bootRSRRun, conf = 0.95, type = "norm", index = 1)
boot.ci(bootRSRRun, conf = 0.95, type = "basic", index = 1)


# #######################
# perc(as.numeric(bootNSERun$t),0.4,"leq")
# perc(as.numeric(bootNSERun$t),0.55,"leq")
# perc(as.numeric(bootNSERun$t),0.65,"leq")
# perc(as.numeric(bootNSERun$t),1,"leq")
