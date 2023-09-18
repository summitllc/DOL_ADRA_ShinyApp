# Pre-processing for lite version of county data
library(tigris)
library(tidyverse)
library(leaflet)
library(sf)
library(rmapshaper)

# data <- readxl::read_xlsx("BlackLung_Dashboard/black lung dataset for map.xlsx")
data <- readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 1)

counties <- counties(year = 2020)

counties <- counties %>% 
  rename(countyfips = GEOID) %>% 
  mutate(countyfips = as.double(countyfips))

# Add missing counties
missing = data.frame(
  countyfips = c(20005, 10005, 10001, 10003, 20003, 20001, 20007, 20009, 08014),
  countyname = c("Atchison", "Sussex", "Kent", "New Castle", "Anderson", "Allen", "Barber", "Barton", "Broomfield"),
  state = c("Kansas", "Delaware", "Delaware", "Delaware", "Kansas", "Kansas", "Kansas", "Kansas", "Colorado"),
  region_id = c("-", "-", "-", "-", "-", "-", "-", "-", "-"),
  msha_district_county = c(NA, NA, NA, NA, NA, NA, NA, NA, NA)
)

# Replace NA to match rest of data
data <- data %>% 
  bind_rows(missing) %>% 
  mutate(across(is.numeric, ~replace_na(., 0))) %>% 
  mutate(across(is.character, ~replace_na(., "N/A")))

# Make new columns - from crosswalk
data <- data %>% 
  mutate(across(.cols = matches("total_j\\d*_deaths"), ~ ./acspopulation2021*1000, .names = "{.col}_per1000")) %>% 
  mutate(coal_prod_any = ifelse(rowSums(across(c(coal_prod_anthracite, coal_prod_bituminous, coal_prod_lignite))) > 0, 1, 0)) 

writexl::write_xlsx(data, 'BlackLung_Dashboard/updated_data.xlsx')

map_data <- data %>% 
  mutate(countyfips = case_when(
    countyfips == 12025 ~ 12086,
    countyfips == 46113 ~ 46102,
    TRUE ~ countyfips
  )) %>% 
  left_join(counties) %>% 
  st_as_sf(crs = 4326)
# geo join

percent_cols <- colnames(map_data)[map_data %>% colnames() %>% str_detect("pct|percent")]
map_data <- map_data %>% 
  mutate(across(percent_cols, ~ .x * 100))

# Would need to presave this and then read it in for it to be worth it
map_data2 <- ms_simplify(map_data, keep = 0.01, keep_shapes = TRUE)
write_rds(map_data2, "BlackLung_Dashboard/counties_lite.rds")

# Navajo 
navajo <- sf::read_sf('BlackLung_Dashboard/cb_2018_us_aiannh_500k/cb_2018_us_aiannh_500k.shp') %>% filter(NAME == "Navajo Nation")
navajo2 <- ms_simplify(navajo, keep = 0.01, keep_shapes = TRUE)
write_rds(navajo2, "BlackLung_Dashboard/navajo.rds")
