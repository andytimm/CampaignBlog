library(ggplot2)
library(stringr)
library(data.table)
library(reshape2)
library(dbplyr)

folder <- "C:/Users/Andy/Documents/Datasets/Florida Voters/20180313_VoterDetail/"
file_list <- list.files(path=folder, pattern="*.txt")

voters <- 
  do.call("rbind", 
          lapply(file_list, 
                 function(x) 
                   fread(paste(folder, x, sep=''))))
