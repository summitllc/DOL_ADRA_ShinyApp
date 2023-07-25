library(tidyverse)
library(leaflet)
library(rgeos)
library(sf)
# tidy census

# data <- readxl::read_xlsx("black lung dataset for map.xlsx")
data <- readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 3)
# map_data <- read_rds("BlackLung_Dashboard/counties_lite.rds")
map_data <- read_rds("counties_lite.rds") 

map_data <- map_data %>% 
  mutate(binary_coal_county = ifelse(binary_coal_county == 1, "Yes", "No"),
         binary_coal_county = factor(binary_coal_county, levels = c("Yes", "No")),
         scalar_coal_county = factor(scalar_coal_county, levels = c("No Coal", "Very Low", "Low", "Medium", "High", "Very High")),
         scalar_coal_county = fct_rev(scalar_coal_county),
         coal_prod_anthracite = ifelse(coal_prod_anthracite == 1, "Yes", "No"),
         coal_prod_anthracite = factor(coal_prod_anthracite, levels = c("Yes", "No")),
         coal_prod_bituminous = ifelse(coal_prod_bituminous == 1, "Yes", "No"),
         coal_prod_bituminous = factor(coal_prod_bituminous, levels = c("Yes", "No")),
         coal_prod_lignite = ifelse(coal_prod_lignite == 1, "Yes", "No"),
         coal_prod_lignite = factor(coal_prod_lignite, levels = c("Yes", "No"))
         ) 
  
data_dict <- readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 4)

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


factor_names = readxl::read_xlsx("black lung analytic dataset FOR MAP.xlsx", sheet = 1) %>% 
  colnames()

variables <- data_dict[match(factor_names, data_dict$`Map Variable Name`),] %>% 
  pull(Variable)

variables <- setNames(variables, 
                      factor_names)

# metrics <- variables[str_detect(variables, "death|cwp|black")]
# factors <- variables[!(variables %in% metrics)]
# map_data$centers <- st_centroid(st_geometry(map_data))
# map_data <- map_data %>% 
#   mutate(long = unlist(map(map_data$centers,1)),
#          lat = unlist(map(map_data$centers,2)))

percent_cols <- colnames(map_data)[map_data %>% colnames() %>% str_detect("pct|percent")]


# Navajo Nation Boundary
# navajo <- sf::read_sf('cb_2018_us_aiannh_500k/cb_2018_us_aiannh_500k.shp') %>% filter(NAME == "Navajo Nation")
navajo <- read_rds("navajo.rds")

# Appalacia
# appalachia <- sf::read_sf('BlackLung_Dashboard/appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)
appalachia <- sf::read_sf('appalachia_bounds/appalachia_bounds.shp') %>% select(geometry)
