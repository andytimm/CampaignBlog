library(tidyverse)
library(data.table)
library(forcats)
library(lubridate)

# This function for finding an age is faster than using lubridate,
# and is from: https://stackoverflow.com/questions/3611314/calculate-ages-in-r

age <- function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  
  age = to_lt$year - from_lt$year
  
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

folder <- "~/Datasets/Florida Voters/20180313_VoterDetail/"
file_list <- list.files(path=folder, pattern="*.txt")

zip_to_tract <- fread("C:/Users/Andy/Documents/Datasets/Florida Voters/zip_to_tracts.csv",
                      colClasses = c(tract = "character"))

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
         sex = V20, race= V21, birth_date = V22, party = V24) %>%

# Remove voters who requested a public records exemption, as we don't get any info about them
filter(records_exemption == "N") %>%
  select( -(records_exemption)) %>%
  
# Change "gender" and "party" variables into format used by Imai/Khanna's wru: 0/1/2: male/female/unknown, and
# 0/1/2: Independent/Democrat/Republican. Note that we have to drop the unknown and blanks.
mutate(party = fct_lump(party, n = 2)) %>% 
  mutate(party = fct_recode(party,
                            "0" = "Other",
                            "1" = "DEM",
                            "2" = "REP")) %>% 
mutate(sex = fct_recode(sex,
                           "0" = "M",
                           "1" = "F",
                           "2" = "U")) %>%
  
  filter(sex %in% c("0","1")) %>% 
  mutate(sex = as.numeric(as.character(sex))) %>% 
  mutate(party = as.numeric(as.character(party))) %>% 
  
# Bin races into white, black, asian, hispanic, other. Again, this is a limitation of Imai/Khanna's framework.
mutate(race = as.character(race)) %>% 
  
  mutate(race = fct_recode(race,
  "other" = "1",
  "asian" = "2",
  "black" = "3",
  "hispanic" = "4",
  "white" = "5",
  "other" = "6",
  "other" = "7",
  "other" = "9"
)) %>% 

  
  
# Turn the birth_date field into ages. 
mutate(age = age(mdy(birth_date), today())) %>% 
  select( -(birth_date)) %>% 

# Add concatenated name fields, which will be used later by NLP methods.
# last_first is for the ethnicolr LSTM, whereas f(irst)_m(middle)_l(ast)_s(uffix) is used by my models.
  
mutate(last_first = paste(surname, first_name, sep = " "),
       f_m_l_s = paste(first_name, middle_name, surname, suffix_name, sep = " ")) %>% 
  
  

# Use zip code to find census tract- this is a relatively coarse approximation, but is sufficient
# for the use here. Better geolocation would improve accuracy, but I don't have a fully geocded FL Voter File.
# Zip codes used are 5 digit, and tracts are the last 6 characters of the FIPS codes in zip_to_tract.
# Files used and further documentation: https://www.huduser.gov/portal/datasets/usps_crosswalk.html#codebook
mutate(zip = strtrim(zip, 5)) %>% 

mutate(tract = zip_to_tract$tract[match(zip, zip_to_tract$zip)]) %>% 
  select(-(zip)) %>% 

# Split full FIPS code into state, county, and tract, then remove unsuccesful imputes
separate(tract, into = c("state", "county", "tract"), sep = c(2,5)) %>%
  mutate(state = "FL") %>% 
  drop_na(state,county,tract)

# Tidy up after import
rm(age,zip_to_tract,file_list,folder)
