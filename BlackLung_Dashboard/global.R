library(tidyverse)
library(leaflet)
# tidy census

data <- readxl::read_xlsx("black lung complete dataset.xlsx")
# map_data <- read_rds("BlackLung_Dashboard/counties_lite.rds")
map_data <- read_rds("counties_lite.rds")

factors <- c('countyfips', 
             'countyname', 
             'state', 
             'msha_district_county', 
             'region_id', 
             'surfacemines01', 
             'undergrndmines01', 
             'totalmines01', 
             'surfacemines21', 
             'undergrndmines21', 
             'totalmines21', 
             'pct_total_mining_employees_1986', 
             'pct_total_mining_employees_2020', 
             'total_weekly_exposure_hours', 
             'totalprodx1000st01', 
             'totalprodx1000st21', 
             'scalar_coal_county', 
             'scalar_current_coal_county', 
             'scalar_former_coal_county')

variables <- colnames(map_data)[map_data %>% colnames() %>% str_detect("per1000|pct|percent|tot")]
variables <- setNames(variables, 
                      colnames(map_data)[map_data %>% colnames() %>%
                                           str_detect("per1000|pct|percent|tot")] %>%
                        str_replace_all("_", " ") %>%
                        str_replace("pct", "Percent") %>%
                        str_replace("acshouseheatingfueltotalocc", "acs house heating fuel total occ") %>%
                        str_replace("acshouseheatingfulepercentu", "acs house heating fuel percent") %>%
                        str_replace("totalmines", "total mines 20") %>%
                        str_replace("totalprodx1000st", "total production (x1000) 20") %>%
                        str_replace("per1000", "(per 1000)") %>%
                        str_replace("undrgrnd", "Underground") %>%
                        str_to_title() %>%
                        str_replace("Acs", "ACS") %>%
                        str_replace("Cwppmf", "CWP PMF") %>%
                        str_replace("Cwp", "CWP") %>%
                        str_replace("Occ", "OCC"))

time_vars <- map_data %>% 
  select(matches("86|01|21|20")) %>% 
  select(-matches("acs")) %>% 
  colnames()

