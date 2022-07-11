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
