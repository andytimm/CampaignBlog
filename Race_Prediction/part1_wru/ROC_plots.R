library(tidyverse)
library(plotROC)

# One-hot encode the races for plotting
for(unique_value in unique(my_voters$race)){
  
  
  my_voters[paste("race", unique_value, sep = ".")] <- ifelse(my_voters$race == unique_value, 1, 0)
}

###########
# Build Plots. Rather than looping over the 4 models, we code each individually in case modification is needed.
###########

# White
white_ROC <- melt_roc(my_voters, "race.white", c("sur_pred.whi", "s_g_pred.whi", "kitchen_pred.whi")) %>% 
  mutate(name = fct_recode(name, "Surname only" = "sur_pred.whi",
         "Geo/Surname" = "s_g_pred.whi",
         "Kitchen Sink" = "kitchen_pred.whi"))
  

white_plot <- ggplot(white_ROC, aes(d = D.race.white, m = M, color = name)) + geom_roc(labels = FALSE) + ggtitle("White") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_discrete(name="Model Type",
                        labels=c("Kitchen Sink", "Geo/Surname", "Surname Only")) +
  theme(legend.position = c(0.75, 0.3))

# Black
black_ROC <- melt_roc(my_voters, "race.black", c("sur_pred.bla", "s_g_pred.bla", "kitchen_pred.bla")) %>% 
  mutate(name = fct_recode(name, "Surname only" = "sur_pred.bla",
                           "Geo/Surname" = "s_g_pred.bla",
                           "Kitchen Sink" = "kitchen_pred.bla"))


black_plot <- ggplot(black_ROC, aes(d = D.race.black, m = M, color = name)) + geom_roc(labels = FALSE) + ggtitle("Black") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_discrete(name="Model Type",
                      labels=c("Kitchen Sink", "Geo/Surname", "Surname Only")) +
  theme(legend.position = c(0.75, 0.3))

#Hispanic
hispanic_ROC <- melt_roc(my_voters, "race.hispanic", c("sur_pred.his", "s_g_pred.his", "kitchen_pred.his")) %>% 
  mutate(name = fct_recode(name, "Surname only" = "sur_pred.his",
                           "Geo/Surname" = "s_g_pred.his",
                           "Kitchen Sink" = "kitchen_pred.his"))


hispanic_plot <- ggplot(hispanic_ROC, aes(d = D.race.hispanic, m = M, color = name)) + geom_roc(labels = FALSE) + ggtitle("Hispanic") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_discrete(name="Model Type",
                      labels=c("Kitchen Sink", "Geo/Surname", "Surname Only")) +
  theme(legend.position = c(0.75, 0.3))

#Asian
asian_ROC <- melt_roc(my_voters, "race.asian", c("sur_pred.asi", "s_g_pred.asi", "kitchen_pred.asi")) %>% 
  mutate(name = fct_recode(name, "Surname only" = "sur_pred.asi",
                           "Geo/Surname" = "s_g_pred.asi",
                           "Kitchen Sink" = "kitchen_pred.asi"))


asian_plot <- ggplot(asian_ROC, aes(d = D.race.asian, m = M, color = name)) + geom_roc(labels = FALSE) + ggtitle("Asian") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_discrete(name="Model Type",
                      labels=c("Kitchen Sink", "Geo/Surname", "Surname Only")) +
  theme(legend.position = c(0.75, 0.3))

#Other
other_ROC <- melt_roc(my_voters, "race.other", c("sur_pred.oth", "s_g_pred.oth", "kitchen_pred.oth")) %>% 
  mutate(name = fct_recode(name, "Surname only" = "sur_pred.oth",
                           "Geo/Surname" = "s_g_pred.oth",
                           "Kitchen Sink" = "kitchen_pred.oth"))


other_plot <- ggplot(other_ROC, aes(d = D.race.other, m = M, color = name)) + geom_roc(labels = FALSE) + ggtitle("Other") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_discrete(name="Model Type",
                      labels=c("Kitchen Sink", "Geo/Surname", "Surname Only")) +
  theme(legend.position = c(0.75, 0.3))


calc_auc(white_plot)$AUC
calc_auc(black_plot)$AUC
calc_auc(hispanic_plot)$AUC
calc_auc(asian_plot)$AUC
calc_auc(other_plot)$AUC