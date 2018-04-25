# wru is available from CRAN, with further information at https://github.com/kosukeimai/wru
# it is an implementation of the prediction method of Imai and Khanna (2016):
# http://imai.princeton.edu/research/race.html
library(wru)
library(tidyverse)

# Note that 1,143,376 names weren't match to census surname list, and were imputed.
my_voters <- predict_race(voter.file = my_voters, surname.only = T) %>% 
  rename(sur_pred.whi = pred.whi, sur_pred.bla = pred.bla, sur_pred.his = pred.his, sur_pred.asi = pred.asi,
         sur_pred.oth = pred.oth)

# Second model: includes block level geo data
my_voters <- predict_race(voter.file = my_voters, census.geo = "tract",
                          census.key = CENSUS_API_KEY) %>% 
  rename(s_g_pred.whi = pred.whi, s_g_pred.bla = pred.bla, s_g_pred.his = pred.his, s_g_pred.asi = pred.asi,
         s_g_pred.oth = pred.oth)

# Full model: includes block level geo data, party registration, sex, and age
my_voters <- predict_race(voter.file = my_voters, census.geo = "tract", party = "party", sex = "gender",
                          age = "age" ,census.key = CENSUS_API_KEY) %>% 
  rename(kitchen_pred.whi = pred.whi, kitchen_pred.bla = pred.bla, kitchen_pred.his = pred.his,
         kitchen_pred.asi = pred.asi, kitchen_pred.oth = pred.oth)
