library(tidyverse)
library(leaflet)
library(rgeos)
library(sf)
library(DT)
# tidy census

# data <- readxl::read_xlsx("black lung dataset for map.xlsx")
data <- readxl::read_xlsx("updated_data.xlsx")
# map_data <- read_rds("BlackLung_Dashboard/counties_lite.rds")
map_data <- read_rds("counties_lite.rds") 

map_data <- map_data %>% 
  # IDEA: Do this during preprocessing if possible. This is geo object
  mutate(across(starts_with("binary_"), ~ ifelse(. == 1, "Yes", "No"))) %>% 
  mutate(across(starts_with("binary_"), ~ factor(., levels = c("Yes", "No")))) %>% 
  mutate(across(starts_with("scalar_"), ~ factor(scalar_coal_county, levels = c("No Coal", "Very Low", "Low", "Medium", "High", "Very High")))) %>%
  mutate(across(starts_with("coal_prod_"), ~ ifelse(. == 1, "Yes", "No"))) %>% 
  mutate(across(starts_with("coal_prod_"), ~ factor(., levels = c("Yes", "No"))))
  
data_dict <- readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 4)

crosswalk <- readxl::read_xlsx("blacklung_crosswalk-updated2.xlsx")

# factors <- c('countyfips', 
#              'countyname', 
#              'state', 
#              'msha_district_county', 
#              'region_id', 
#              'surfacemines01', 
#              'undergrndmines01', 
#              'totalmines01', 
#              'surfacemines21', 
#              'undergrndmines21', 
#              'totalmines21', 
#              'pct_total_mining_employees_1986', 
#              'pct_total_mining_employees_2020', 
#              'total_weekly_exposure_hours', 
#              'totalprodx1000st01', 
#              'totalprodx1000st21', 
#              'scalar_coal_county', 
#              'scalar_current_coal_county', 
#              'scalar_former_coal_county')

# variables <- colnames(map_data)[map_data %>% colnames() %>% str_detect("per1000|pct|percent|tot|pred")]
# variables <- setNames(variables, 
#                       colnames(map_data)[map_data %>% colnames() %>%
#                                            str_detect("per1000|pct|percent|tot|pred")] %>%
#                         str_replace_all("_", " ") %>%
#                         str_replace("pct", "Percent") %>%
#                         str_replace("acshouseheatingfueltotalocc", "acs house heating fuel total occ") %>%
#                         str_replace("acshouseheatingfulepercentu", "acs house heating fuel percent") %>%
#                         str_replace("totalmines", "total mines 20") %>%
#                         str_replace("totalprodx1000st", "total production (x1000) 20") %>%
#                         str_replace("per1000", "(per 1000)") %>%
#                         str_replace("undrgrnd", "Underground") %>%
#                         str_to_title() %>%
#                         str_replace("Acs", "ACS") %>%
#                         str_replace("Cwppmf", "CWP PMF") %>%
#                         str_replace("Cwp", "CWP") %>%
#                         str_replace("Occ", "OCC"))


# factor_names = readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 1) %>% 
#   colnames()
# 
# variables <- data_dict[match(factor_names, data_dict$`Map Variable Name`),] %>% 
#   pull(Variable)
# 
# variables <- setNames(variables, 
#                       factor_names)
variables <- crosswalk %>% count(factor) %>% pull(factor)

dictionary_list <- crosswalk %>% 
  arrange(factor) %>% 
  pull(variable)

# metrics <- variables[str_detect(variables, "death|cwp|black")]
# factors <- variables[!(variables %in% metrics)]
# map_data$centers <- st_centroid(st_geometry(map_data))
# map_data <- map_data %>% 
#   mutate(long = unlist(map(map_data$centers,1)),
#          lat = unlist(map(map_data$centers,2)))

percent_cols <- colnames(data)[data %>% colnames() %>% str_detect("pct|percent|prop")]


# Navajo Nation Boundary
# navajo <- sf::read_sf('cb_2018_us_aiannh_500k/cb_2018_us_aiannh_500k.shp') %>% filter(NAME == "Navajo Nation")
navajo <- read_rds("navajo.rds")

# Appalacia
# appalachia <- sf::read_sf('BlackLung_Dashboard/appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)
appalachia <- sf::read_sf('appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)

# Help Code (from CAT)
addHelpButton <- function(elementId, x) {
  div(
    # div(
      class = "pull-right",
      actionLink(elementId, label = NULL, icon = icon("info-circle")),
    # ),
    x
  )
}
