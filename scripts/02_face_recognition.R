###########################
#
# ICA Hackathon, Images & Disinfo
# Author: Daniel Thiele
# Date: 2025-05-25
#
###########################

rm(list = ls())

# Load packages
library(tidyverse)
library(magrittr)

library(magick)
# install.packages("image.libfacedetection", repos = "https://bnosac.github.io/drat")
library(image.libfacedetection)


# Read data ---------------------------------------------------------------

img_paths <- dir("./data/originals/", pattern = ".jpg", full.names = T) 

set.seed(100)
sample100 <- img_paths %>% sample(100)

s <- sample100 %>% str_extract(pattern = "([^/]+\\.jpg)$")


## Store this sample
write.csv(data.frame(file_name = s), "./data/n100_sample/n100_sample.csv")

# Prototyping -------------------------------------------------------------

t1 <- img_paths[[1]]
ts <- img_paths[1:3]

image <- image_read()
faces <- image_detect_faces(image)
faces
plot(faces, image, border = "red", lwd = 7, col = "white")


i <- lapply(ts, image_read)
f <- lapply(i, image_detect_faces)

df <- as.data.frame(do.call(rbind, f))
df$file_name <- stringr::str_remove_all(ts, "./data/originals/")

df %<>% unnest(cols = c(detections))




# Function ----------------------------------------------------------------

load_images_detect_faces <- function(x){ # Input: character vector containing pathes to images
  
  i <- lapply(x, magick::image_read)
  
  f <- lapply(i, image.libfacedetection::image_detect_faces)
  
  df <- as.data.frame(do.call(rbind, f))
  
  df$file_name <- stringr::str_extract(x, pattern = "([^/]+\\.jpg)$")
  
  df <- df %>% unnest(cols = c(detections))
  
  return(df)
  
}



# Apply this to all images ------------------------------------------------

detected_images_df <- load_images_detect_faces(img_paths)
