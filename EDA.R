data <- readxl::read_xlsx("black lung complete dataset.xlsx")

library(tidyverse)
library(leaflet)
library(tigris)
library(sf)

counties <- counties()#year = 2022)

counties %>% 
  anti_join(data, by = c(""))

# data <- data %>% 
#   mutate(countyfips = case_when(
#     nchar(countyfips) == 4 ~ paste0("0", countyfips),
#     TRUE ~ as.character(countyfips)
#   ))

geos <- counties %>% pull(GEOID) %>% as.integer()

# Find Missing counties 
missing_geo_id <- geos[!(geos %in% data$countyfips)]

counties <- counties %>% 
  rename(countyfips = GEOID) %>% 
  mutate(countyfips = as.double(countyfips))

bad_match <- anti_join(data, counties)
bad_match2 <- anti_join(counties, data) %>% 
  st_drop_geometry()

# Join data
map_data <- data %>% 
  left_join(counties) %>% 
  st_as_sf(crs = 4326)

# Creating a color palette based on the number range in the column of interest
pal <- colorNumeric("Blues", domain = map_data$pct_total_mining_employees_1986)

popup_sb <- paste0("Percent: ", as.character(map_data$pct_total_mining_employees_1986))

leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  setView(-98.35, 39.5, zoom = 4) %>% 
  addPolygons(data = map_data,
              fillColor = ~pal(pct_total_mining_employees_1986),
              color = "000000",
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2, 
              popup = ~popup_sb) %>% 
  addLegend(pal = pal, 
            values = map_data$pct_total_mining_employees_1986, 
            position = "bottomright", 
            title = "Percent Mining Employees 1986")
