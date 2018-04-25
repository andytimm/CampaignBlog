# wru is available from CRAN, with further information at https://github.com/kosukeimai/wru
# it is an implementation of the prediction method of Imai and Khanna (2016):
# http://imai.princeton.edu/research/race.html
library(wru)
library(tidyverse)

# Note that 1,143,376 names weren't match to census surname list, and were imputed.
my_voters <- predict_race(voter.file = my_voters, surname.only = T) %>% 
  rename(sur_pred.whi = pred.whi, sur_pred.bla = pred.bla, sur_pred.his = pred.his, sur_pred.asi = pred.asi,
         sur_pred.oth = pred.oth)

my_voters <- predict_race()