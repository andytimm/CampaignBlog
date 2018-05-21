library(tidyverse)
library(plotROC)

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
  spread(key = X1, value = X2, sep = "a") %>%
  spread(key = X3, value = X4, sep = "b") %>%
  spread(key = X5, value = X6, sep = "c") %>%
  spread(key = X7, value = X8, sep = "d") %>%
  spread(key = X9, value = X10, sep = "e") %>% 
  
  unite("pred_white", c("X1a__label__white","X3b__label__white","X5c__label__white",
                             "X7d__label__white","X9e__label__white")) %>% 
  unite("pred_black", c("X1a__label__black","X3b__label__black","X5c__label__black",
                           "X7d__label__black","X9e__label__black")) %>% 
  unite("pred_hispanic", c("X1a__label__hispanic","X3b__label__hispanic","X5c__label__hispanic",
                           "X7d__label__hispanic","X9e__label__hispanic")) %>% 
  unite("pred_asian", c("X1a__label__asian","X3b__label__asian","X5c__label__asian",
                           "X7d__label__asian","X9e__label__asian")) %>% 
  unite("pred_other", c("X1a__label__other","X3b__label__other","X5c__label__other",
                           "X7d__label__other","X9e__label__other")) %>%
  select(-i) %>% 

transmute(pred_white = str_remove_all(pred_white,"[NA_]"),
           pred_black = str_remove_all(pred_black,"[NA_]"),
           pred_hispanic = str_remove_all(pred_hispanic,"[NA_]"),
           pred_asian = str_remove_all(pred_asian,"[NA_]"),
           pred_other = str_remove_all(pred_other,"[NA_]")) %>% 
  
  mutate_all(as.numeric)

# Now, bind the two dataframes together, and start plotting
fT_results <- bind_cols(true_labels,fT_baseline)






