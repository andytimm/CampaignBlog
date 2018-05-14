library(tidyverse)

# formats text for fastText's cmd line tools, ex: __label__white__ Andrew Garland Luboja Timm
# saves results into a textFile at path
fT_format <-  function(text,labels,path) {
  write.table(paste(paste("__label__", labels, sep = ""),text),path,
              row.names = FALSE, col.names = FALSE, quote = FALSE)
}

fT_format(my_voters$f_m_l_s,my_voters$race,"my_voters.txt")