pacman::p_load(nlme,rio)
BBOXNEW1_1_ <- rio::import('https://github.com/Rojakaveh/CEAP-ARS-watersheds/raw/main/BBOXNEW1.xlsx')
#BBOXNEW1_1_ <- read_excel("~/RobinStat/BBOXNEW1 (1).xlsx")
###FOR NSE
NSEresponse=BBOXNEW1_1_[1:63,]
colnames(NSEresponse)=c("Estimation Method", "NSE", "parameter","Climate Classification")
NSEresponse$'Overal Mean'=mean(NSEresponse$NSE)
NSEresponse$`Estimation Method`=factor(NSEresponse$`Estimation Method`,levels = c("Closest","IDW","IDEW") )
NSEresponse$`Climate Classification`=factor(NSEresponse$`Climate Classification`,levels = c("Cfa","Dfa","Dfb","Csa","BSk"))
#plot(NSEresponse)
model1=lm(NSE~`Estimation Method`+`Climate Classification`-1+`Estimation Method`*`Climate Classification`+`Overal Mean`,data = NSEresponse)
summary(model1)
anova(model1)
#Anova(model1)
par(mfrow=c(2,2))
plot(model1)
###########################################
#for RSR

RSRresponse=BBOXNEW1_1_[64:126,]
colnames(RSRresponse)=c("Estimation Method", "RSR", "parameter","Climate Classification")
RSRresponse$'Overal Mean'=mean(RSRresponse$RSR)
RSRresponse$`Estimation Method`=factor(RSRresponse$`Estimation Method`,levels = c("Closest","IDW","IDEW") )
RSRresponse$`Climate Classification`=factor(RSRresponse$`Climate Classification`,levels = c("Cfa","Dfa","Dfb","Csa","BSk"))
#plot(RSRresponse)
model1=lm(RSR~`Estimation Method`+`Climate Classification`-1+`Estimation Method`*`Climate Classification`+`Overal Mean`,data = RSRresponse)
summary(model1)
anova(model1)
#Anova(model1)
par(mfrow=c(2,2))
plot(model1)

##########################################
#for PABIAS
PABIASresponse=BBOXNEW1_1_[127:189,]
colnames(PABIASresponse)=c("Estimation Method", "PABIAS", "parameter","Climate Classification")
PABIASresponse$'Overal Mean'=mean(PABIASresponse$PABIAS)
PABIASresponse$`Estimation Method`=factor(PABIASresponse$`Estimation Method`,levels = c("Closest","IDW","IDEW") )
PABIASresponse$`Climate Classification`=factor(PABIASresponse$`Climate Classification`,levels = c("Cfa","Dfa","Dfb","Csa","BSk"))
#plot(PABIASresponse)
model1=lm(PABIAS~`Estimation Method`+`Climate Classification`-1+`Estimation Method`*`Climate Classification`+`Overal Mean`,data = PABIASresponse)
summary(model1)
anova(model1)
#Anova(model1)
par(mfrow=c(2,2))
plot(model1)

