# Pre-processing for lite version of county data
library(tigris)
library(tidyverse)
library(leaflet)
library(sf)
library(rmapshaper)

counties <- counties(year = 2020)

counties <- counties %>% 
  rename(countyfips = GEOID) %>% 
  mutate(countyfips = as.double(countyfips))

map_data <- data %>% 
  left_join(counties) %>% 
  st_as_sf(crs = 4326)
# geo join

# Would need to presave this and then read it in for it to be worth it
map_data2 <- ms_simplify(map_data, keep = 0.01, keep_shapes = TRUE)
write_rds(map_data2, "BlackLung_Dashboard/counties_lite.rds")
