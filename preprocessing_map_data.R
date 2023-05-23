# Pre-processing for lite version of county data
library(tigris)
library(tidyverse)
library(leaflet)
library(sf)
library(rmapshaper)

data <- readxl::read_xlsx("BlackLung_Dashboard/black lung dataset for map.xlsx")

counties <- counties(year = 2020)

counties <- counties %>% 
  rename(countyfips = GEOID) %>% 
  mutate(countyfips = as.double(countyfips))

map_data <- data %>% 
  left_join(counties) %>% 
  st_as_sf(crs = 4326)
# geo join

percent_cols <- colnames(map_data)[map_data %>% colnames() %>% str_detect("pct|percent")]
map_data <- map_data %>% 
  mutate(across(percent_cols, ~ .x * 100))

# Would need to presave this and then read it in for it to be worth it
map_data2 <- ms_simplify(map_data, keep = 0.01, keep_shapes = TRUE)
write_rds(map_data2, "BlackLung_Dashboard/counties_lite.rds")
