library(ggplot2)
library(stringr)
library(data.table)
library(reshape2)
library(dbplyr)
library(dplyr)

folder <- "C:/Users/Andy/Documents/Datasets/Florida Voters/20180313_VoterDetail/"
file_list <- list.files(path=folder, pattern="*.txt")

voters <- 
  do.call("rbind", 
          lapply(file_list, 
                 function(x) 
                   fread(paste(folder, x, sep=''))))

# Drop uneeded columns, and add in correct names
# The full list is here: http://flvoters.com/download/20180228/2018%20voter-extract-file-layout.pdf
voters <- voters %>%
  select(V1, V2, V3, V4, V5, V6, V7,V12,V20,V21,V22,V24) %>% 
  rename(county_code = V1,voter_id = V2, surname = V3, name_suffix = V4,
         first_name = V5, middle_name = V6, records_exemption = V7, zip = V12,
         gender = V20, race= V21, birth_date = V22, party = V24) %>%

# Remove voters who requested a public records exemption, as we don't get any info about them
filter(records_exemption == "N") %>%
  select( -(records_exemption))
  
# Use zip code to find census tract- this is a relatively course approximation, but is sufficient
# for the use here.
voters$zip <-  strtrim(voters$zip, 5)

zip_to_tract <- fread("C:/Users/Andy/Documents/Datasets/Florida Voters/zip_to_tracts.csv",
                      colClasses = c(tract = "character"))




