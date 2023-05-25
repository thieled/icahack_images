#################
#
# ICA hackathon, Images & Disinfo group
# Author: Daniel Thiele
# Date: 2022-05-25
#
################


# Clean memory
rm(list = ls())

# Load packages
library(tidyverse)
library(magrittr)



# Get local paths to imges ---------------------------------------------------------------

# From local clone of Fabios repo:
# https://github.com/favstats/corona_conspiracyland/

paths <- dir("../conspiracyland/corona_conspiracyland/docs/data/originals/", pattern = ".jpg", full.names = T) 

# Sample ------------------------------------------------------------------

set.seed(20230525)
sampled_paths <- sample(paths, 1000L, replace = FALSE)



# Keep only filename ------------------------------------------------------

sampled_files <- stringr::str_remove_all(sampled_paths, "../conspiracyland/corona_conspiracyland/docs/data/originals/")

# Move sampled images into repo ---------------------------------------------

# Loop over all paths
for (i in seq_along(sampled_files)) {
  file.copy(from = paste0("../conspiracyland/corona_conspiracyland/docs/data/originals/", sampled_files[[i]]),
            to = paste0("./data/originals/", sampled_files[[i]])
  )
}




# Copy metadata folder ----------------------------------------------------

## Note: "Metadata" on Fabios website, not from Instagram directly
for (i in seq_along(sampled_files)) {
  file.copy(from = paste0("../conspiracyland/corona_conspiracyland/docs/data/metadata/file/", sampled_files[[i]], ".json"),
            to = paste0("./data/metadata/", sampled_files[[i]], ".json")
  )
}






