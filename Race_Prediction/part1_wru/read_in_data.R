library(tidyverse)
library(data.table)
library(lubridate)

folder <- "~/Datasets/Florida Voters/20180313_VoterDetail/"
file_list <- list.files(path=folder, pattern="*.txt")

my_voters <- 
  do.call("rbind", 
          lapply(file_list, 
                 function(x) 
                   fread(paste(folder, x, sep=''))))

# Drop uneeded columns, and add in correct names
# The full list of fields is here: http://flvoters.com/download/20180228/2018%20voter-extract-file-layout.pdf
my_voters <- my_voters %>%
  select(V1, V2, V3, V4, V5, V6, V7,V12,V20,V21,V22,V24) %>% 
  rename(county_code = V1,voter_id = V2, surname = V3, suffix_name = V4,
         first_name = V5, middle_name = V6, records_exemption = V7, zip = V12,
         gender = V20, race= V21, birth_date = V22, party = V24) %>%

# Remove voters who requested a public records exemption, as we don't get any info about them
filter(records_exemption == "N") %>%
  select( -(records_exemption))
  
# Turn the birth_date field into ages. The function for finding an age is faster than using lubridate,
# and is from: https://stackoverflow.com/questions/3611314/calculate-ages-in-r

age <- function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  
  age = to_lt$year - from_lt$year
  
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

my_voters <- mutate(my_voters,age = age(mdy(birth_date), today())) %>% 
  select( -(birth_date))

# Add concatenated name fields, which will be used later by NLP methods.
# last_first is for the ethnicolr LSTM, whereas f(irst)_m(middle)_l(ast)_s(uffix) is used by my models.
  
my_voters<- mutate(my_voters,last_first = paste(surname, first_name, sep = " "),
       f_m_l_s = paste(first_name, middle_name, surname, suffix_name, sep = " "))
  
  

# Use zip code to find census tract- this is a relatively coarse approximation, but is sufficient
# for the use here. Better geolocation would improve accuracy, but I don't have a fully geocded FL Voter File.
my_voters$zip <-  strtrim(my_voters$zip, 5)

zip_to_tract <- fread("C:/Users/Andy/Documents/Datasets/Florida Voters/zip_to_tracts.csv",
                      colClasses = c(tract = "character"))

#zip_to_tract$zip <- as.character(zip_to_tract$zip)

my_voters <- mutate(my_voters, county_tract_block =
                      zip_to_tract$tract[match(my_voters$zip, zip_to_tract$zip)]) %>% 
  select(-(zip))

# Tidy up after import
rm(age,zip_to_tract,file_list,folder)
