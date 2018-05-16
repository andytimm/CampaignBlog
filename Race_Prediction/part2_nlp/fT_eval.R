library(tidyverse)

true_labels <- read_delim("C:\\Users\\Andy\\Documents\\Datasets\\Florida Voters\\voters.pp.valid",delim =  " ",
                col_names = FALSE)

# Keep only the labels, and trim the fT label tags
true_labels <- true_labels %>%
  select(X1) %>% 
  rename(race = X1) %>% 
  mutate(race = fct_recode(race,
                           "other" = "__label__other",
                           "asian" = "__label__asian",
                           "black" = "__label__black",
                           "hispanic" = "__label__hispanic",
                           "white" = "__label__white"
  ))

# One-hot encode the races for plotting
for(unique_value in unique(true_labels$race)){
  
  
  true_labels[paste("race", unique_value, sep = ".")] <- ifelse(true_labels$race == unique_value, 1, 0)
}

#Import and clean 
fT_baseline <- read_delim("C:\\Users\\Andy\\Documents\\Datasets\\Florida Voters\\fT_baseline_preds.txt",
                          delim =  " ", col_names = FALSE) %>% 
  mutate(i = row_number()) %>% 
  spread(key = X1, value = X2) %>%
  spread(key = X3, value = X4) %>%
  spread(key = X5, value = X6) %>%
  spread(key = X7, value = X8) %>%
  spread(key = X9, value = X10)


