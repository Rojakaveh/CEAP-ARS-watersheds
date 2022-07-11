
#### For NSE
NSE_ANOVA_data=read_excel("NSE_ANOVA.xlsx")
levels(NSE_ANOVA_data$Estimation_Method)
NSE_ANOVA_data$Estimation_Method=ordered(NSE_ANOVA_data$Estimation_Method,levels=c("Closest","IDW","IDEW"))
group_by(NSE_ANOVA_data, Estimation_Method) %>%
  summarise(
    count = n(),
    mean = mean(NSE, na.rm = TRUE),
    sd = sd(NSE, na.rm = TRUE)
  )

library("ggpubr")
ggboxplot(NSE_ANOVA_data, x = "Estimation_Method", y = "NSE", 
          color = "Estimation_Method", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("closest","IDW","IDEW"),
          ylab = "NSE", xlab = "Estimation method")

ggline(NSE_ANOVA_data, x = "Estimation_Method", y = "NSE", 
       add = c("mean_se", "jitter"), 
       order = c("closest","IDW","IDEW"),
       ylab = "NSE", xlab = "Estimation method")

# Compute the analysis of variance
res.aov.NSE_ANOVA <- aov(NSE ~ Estimation_Method, data = NSE_ANOVA_data)
# Summary of the analysis
summary(res.aov.NSE_ANOVA)

################## FOR RSR
RSR_ANOVA_data=read_excel("RSR_ANOVA.xlsx")
levels(RSR_ANOVA_data$Estimation_Method)
RSR_ANOVA_data$Estimation_Method=ordered(RSR_ANOVA_data$Estimation_Method,levels=c("Closest","IDW","IDEW"))
group_by(RSR_ANOVA_data, Estimation_Method) %>%
  summarise(
    count = n(),
    mean = mean(RSR, na.rm = TRUE),
    sd = sd(RSR, na.rm = TRUE)
  )

library("ggpubr")
ggboxplot(RSR_ANOVA_data, x = "Estimation_Method", y = "RSR", 
          color = "Estimation_Method", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("closest","IDW","IDEW"),
          ylab = "RSR", xlab = "Estimation method")

ggline(RSR_ANOVA_data, x = "Estimation_Method", y = "RSR", 
       add = c("mean_se", "jitter"), 
       order = c("closest","IDW","IDEW"),
       ylab = "RSR", xlab = "Estimation method")

# Compute the analysis of variance
res.aov.RSR_ANOVA <- aov(RSR ~ Estimation_Method, data = RSR_ANOVA_data)
# Summary of the analysis
summary(res.aov.RSR_ANOVA)
######################## FOR PABIAS
PABIAS_ANOVA_data=read_excel("PABIAS_ANOVA.xlsx")
levels(PABIAS_ANOVA_data$Estimation_Method)
PABIAS_ANOVA_data$Estimation_Method=ordered(PABIAS_ANOVA_data$Estimation_Method,levels=c("closest","IDW","IDEW"))
group_by(PABIAS_ANOVA_data, Estimation_Method) %>%
  summarise(
    count = n(),
    mean = mean(PABIAS, na.rm = TRUE),
    sd = sd(PABIAS, na.rm = TRUE)
  )

library("ggpubr")
ggboxplot(PABIAS_ANOVA_data, x = "Estimation_Method", y = "PABIAS", 
          color = "Estimation_Method", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("closest","IDW","IDEW"),
          ylab = "PABIAS", xlab = "Estimation method")

ggline(PABIAS_ANOVA_data, x = "Estimation_Method", y = "PABIAS", 
       add = c("mean_se", "jitter"), 
       order = c("closest","IDW","IDEW"),
       ylab = "PABIAS", xlab = "Estimation method")

# Compute the analysis of variance
res.aov.PABIAS_ANOVA <- aov(PABIAS ~ Estimation_Method, data = PABIAS_ANOVA_data)
# Summary of the analysis
summary(res.aov.PABIAS_ANOVA)
