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
  
  i <- pbapply::pblapply(x, magick::image_read)
  
  f <- pbapply::pblapply(i, image.libfacedetection::image_detect_faces)
  
  df <- as.data.frame(do.call(rbind, f))
  
  df$file_name <- stringr::str_extract(x, pattern = "([^/]+\\.jpg)$")
  
  df <- df %>% tidyr::unnest(cols = c(detections))
  
  return(df)
  
}


i <- pbapply::pblapply(img_paths, magick::image_read)


## use subset
i50 <- i[1:50]


# Apply this to all 1000 images ------------------------------------------------

detected_faces_df <- load_images_detect_faces(img_paths)


f50 <- pbapply::pblapply(i50, image.libfacedetection::image_detect_faces)



# Save --------------------------------------------------------------------

write_csv(detected_faces_df, "output/detected_faces_df.csv")


# Crop images to faces only -----------------------------------------------


df %<>% mutate(crop_pos = paste0(width, "x", height, "+", x, "+", y),
               path = paste0("./data/originals/", file_name)) 


cropped_faces <- map2(.x = ti, .y = tdf$crop_pos, .f = image_crop)



t_df  <- df[1:10,]


crop_faces <- function(df){ # Input: df containing 
  
  i <- pbapply::pblapply(df$path, magick::image_read)
  
  cropped_faces <- map2(.x = i, .y = df$crop_pos, .f = magick::image_crop)
  
  return(cropped_faces)
  
}

c_faces <- crop_faces(df)


c_faces[1:30]


# Plot some examples ------------------------------------------------------


plot(f50[[40]], i50[[40]], border = "red", lwd = 7, col = "white")

plot(f50[[21]], i50[[21]], border = "red", lwd = 7, col = "white")


