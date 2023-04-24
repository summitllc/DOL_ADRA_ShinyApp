library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(rmapshaper)

data <- readxl::read_xlsx("black lung complete dataset.xlsx")

counties <- counties(year = 2020)

counties <- counties %>% 
  rename(countyfips = GEOID) %>% 
  mutate(countyfips = as.double(countyfips))

map_data <- data %>% 
  left_join(counties) %>% 
  st_as_sf(crs = 4326)

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

percent_cols <- colnames(map_data)[map_data %>% colnames() %>% str_detect("pct|percent")]
map_data <- map_data %>% 
  mutate(across(percent_cols, ~ round(.x * 100, 2)))


# Would need to presave this and then read it in for it to be worth it
# map_data2 <- ms_simplify(map_data, keep = 0.01, keep_shapes = TRUE)
