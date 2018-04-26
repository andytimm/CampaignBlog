# wru is available from CRAN, with further information at https://github.com/kosukeimai/wru
# it is an implementation of the prediction method of Imai and Khanna (2016):
# http://imai.princeton.edu/research/race.html
library(wru)
library(tidyverse)

# Note that 1,142,993 (~17%) names weren't matched to census surname list, and were imputed.
my_voters <- predict_race(voter.file = my_voters, surname.only = T) %>% 
  rename(sur_pred.whi = pred.whi, sur_pred.bla = pred.bla, sur_pred.his = pred.his, sur_pred.asi = pred.asi,
         sur_pred.oth = pred.oth)

# Second model: includes block level geo data
# Data is downloaded in separate step in case download fails
census_data_g <- get_census_data(key = CENSUS_API_KEY, state = "FL", census.geo = "tract")

my_voters <- predict_race(voter.file = my_voters, census.geo = "tract",
                          census.key = CENSUS_API_KEY, census.data = census_data_g) %>% 
  rename(s_g_pred.whi = pred.whi, s_g_pred.bla = pred.bla, s_g_pred.his = pred.his, s_g_pred.asi = pred.asi,
         s_g_pred.oth = pred.oth)

# Full model: includes block level geo data, party registration, sex, and age
census_data_all <- get_census_data(key = CENSUS_API_KEY, state = "FL", census.geo = "tract",age = TRUE,
                               sex = TRUE)

my_voters <- predict_race(voter.file = my_voters, census.geo = "tract", party = "party", sex = TRUE,
                          age = TRUE, census.key = CENSUS_API_KEY, census.data = census_data_all) %>% 
  rename(kitchen_pred.whi = pred.whi, kitchen_pred.bla = pred.bla, kitchen_pred.his = pred.his,
         kitchen_pred.asi = pred.asi, kitchen_pred.oth = pred.oth)
