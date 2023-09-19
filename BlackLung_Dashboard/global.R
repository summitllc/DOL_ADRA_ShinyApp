library(tidyverse)
library(leaflet)
library(rgeos)
library(sf)
library(DT)
# library(tidycensus)

# data <- readxl::read_xlsx("black lung dataset for map.xlsx")
data <- readxl::read_xlsx("updated_data.xlsx")
# map_data <- read_rds("BlackLung_Dashboard/counties_lite.rds")
map_data <- read_rds("counties_lite.rds") 

map_data <- map_data %>% 
  # Do this during preprocessing if deploying to PROD environment. This is geo object.
  mutate(across(starts_with("binary_"), ~ ifelse(. == 1, "Yes", "No"))) %>% 
  mutate(across(starts_with("binary_"), ~ factor(., levels = c("Yes", "No")))) %>% 
  mutate(across(starts_with("scalar_"), ~ factor(scalar_coal_county, 
                                                 levels = c("No Coal", 
                                                            "Very Low", 
                                                            "Low", 
                                                            "Medium", 
                                                            "High", 
                                                            "Very High")))) %>%
  mutate(across(starts_with("coal_prod_"), ~ ifelse(. == 1, "Yes", "No"))) %>% 
  mutate(across(starts_with("coal_prod_"), ~ factor(., levels = c("Yes", "No"))))
  
data_dict <- readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 2)

crosswalk <- readxl::read_xlsx("blacklung_crosswalk-updated2.xlsx")

# Uncomment the following code to remove 'Household Residential Coal Use' from the map
# crosswalk <- crosswalk %>% filter(!str_detect(factor, '.*Residential Coal Use'))

data_sources <- readxl::read_xlsx("data_sources.xlsx") %>% 
  mutate(Location = paste0("<a href='", Location, "' target='_blank'>", Location, "</a>"))

# create a named vector for cleaning
replacements <- setNames(as.character(crosswalk$full_title), crosswalk$variable)

variables <- crosswalk %>% count(factor) %>% pull(factor)

dictionary_list <- crosswalk %>% 
  arrange(factor) %>% 
  pull(variable)

percent_cols <- colnames(data)[data %>% colnames() %>% str_detect("pct|percent|prop")]


# Navajo Nation Boundary
# navajo <- sf::read_sf('cb_2018_us_aiannh_500k/cb_2018_us_aiannh_500k.shp') %>% filter(NAME == "Navajo Nation")
navajo <- read_rds("navajo.rds")

# Appalacia
# appalachia <- sf::read_sf('BlackLung_Dashboard/appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)
appalachia <- sf::read_sf('appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)

# Custom function for help button code
addHelpButton <- function(elementId, x) {
  div(
    class = "pull-right",
    actionLink(elementId, label = NULL, icon = icon("info-circle")),
    x
  )
}
