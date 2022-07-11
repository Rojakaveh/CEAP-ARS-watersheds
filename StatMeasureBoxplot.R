pacman::p_load("egg")
BxNSE <- read_excel("~/CEAPwatersheds/BBOXNEW1.xlsx")
colnames(BxNSE)[1]="EstimationMethod"
#colnames(BxNSE)[2]="NSE"
colnames(BxNSE)[4]="ClimateClassification"
#colnames(BxNSE)[4]="PBIAS"
#colnames(BxNSE)[5]="RSR"

BxNSE$EstimationMethod=factor(BxNSE$EstimationMethod, levels = c("Closest","IDW","IDEW"))
BxNSE$Parameter=factor(BxNSE$Parameter, levels = c("NSE","RSR","PABIAS"))
BxNSE$ClimateClassification=factor(BxNSE$ClimateClassification,levels = c("Cfa","Dfa","Dfb","Csa","BSk"))

plot4=ggplot(BxNSE,aes(x=ClimateClassification, y=Value, color=EstimationMethod))+ 
  geom_boxplot(outlier.shape=NA)+
  geom_point(position=position_dodge(width=0.75),aes(group=EstimationMethod))+
  
  labs(y="Value", x="Climate Classification", colour="Estimation Method")+
  scale_color_manual(values = c("red", "green","blue"))+
  theme(
    axis.title.x = element_text(size = 16,face="bold"),
    axis.text.x = element_text(size = 14,color = "black",face="bold"),
    axis.title.y = element_text(size = 16,face="bold"),
    axis.text.y = element_text(size = 14,color = "black",face="bold"),
    legend.title = element_text(size = 16,face="bold"),
    legend.text = element_text(size = 14))
plot4
plot4+facet_grid(Parameter ~ ., scales = "free_y")

plot5=plot4+facet_grid(Parameter ~ ., scales = "free_y",
           switch = "y", # flip the facet labels along the y axis from the right side to the left
  ) +
  ylab(NULL) + # remove the word "values"
  theme(strip.background = element_blank(), # remove the background
        strip.placement = "outside",
        strip.text.y = element_text(size = 16, face = "bold")) # put labels to the left of the axis text
  tag_facet(plot5)
 


