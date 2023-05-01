library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(rmapshaper)


val <- eventReactive(input$search_map, {
  val <- input$factor
}) 

map_data2 <- eventReactive(input$search_map, {
  map_data %>% 
    filter(get(val()) > 0)
}) 

output$map <- renderLeaflet({
  # Creating a color palette based on the number range in the column of interest
  pal <- colorNumeric("Blues", domain = map_data2()[[val()]])
  
  if (val() %in% percent_cols) {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>", 
                       "<br>",
                       "Region: ", map_data2()$region_id, 
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       names(variables)[variables==val()], ": ", as.character(round(map_data2()[[val()]], 2)), "%",
                       "<br>",
                       "Total Black Lung Incidences: ", map_data2()$any_cwp,
                       "<br>",
                       "Total Black Lung Deaths: ", map_data2()$total_black_lung_deaths
                       )
  } else {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>",
                       "<br>",
                       "Region: ", map_data2()$region_id, 
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       names(variables)[variables==val()], ": ", as.character(round(map_data2()[[val()]], 2)),
                       "<br>",
                       "Total Black Lung Incidences: ", map_data2()$any_cwp,
                       "<br>",
                       "Total Black Lung Deaths: ", map_data2()$total_black_lung_deaths
    )
  }
  
  map <- leaflet() %>% 
    addProviderTiles("CartoDB.Positron") %>%
    setView(-98.35, 39.5, zoom = 5) %>% 
    addPolygons(data = map_data2(),
                fillColor = ~pal(map_data2()[[val()]]),
                stroke = TRUE,
                color = "black",
                opacity = 1,
                fillOpacity = .9,
                weight = 0.2,
                smoothFactor = 0.2,
                popup = ~popup_sb) %>%
    addLegend(pal = pal,
              values = map_data2()[[val()]],
              position = "bottomleft",
              title = names(variables)[variables==val()])
  
  map
})

output$incid_plot <- renderPlot({
  map_data2() %>% 
    ggplot(aes_string(x = val(), y = 'any_cwp')) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = paste(names(variables)[variables==val()], 
                       " vs. \n",
                       'Total Black Lung Incidences'),
         x = names(variables)[variables==val()],
         y = 'Total Black Lung Incidences')
})

output$death_plot <- renderPlot({
  map_data2() %>% 
    ggplot(aes_string(x = val(), y = 'total_black_lung_deaths')) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = paste(names(variables)[variables==val()],
                       " vs. \n",
                       names(variables)[variables=='total_black_lung_deaths']),
         x = names(variables)[variables==val()],
         y = names(variables)[variables=='total_black_lung_deaths'])
})

observeEvent(input$search_map, {
  output$region_data <- renderDataTable({
    df <- map_data %>% 
      st_drop_geometry() %>% 
      mutate(intermed = round(get(val()), 2)) %>% 
      select(countyname, state, region_id, msha_district_county, intermed, any_cwp, total_black_lung_deaths) %>%
      arrange(desc(intermed)) %>% 
      rename(County = countyname,
             State = state,
             Region = region_id,
             `MSHA District` = msha_district_county,
             `Number of Black Lung Cases` = any_cwp,
             `Number of Black Lung Deaths` = total_black_lung_deaths
      ) 
    
    colnames(df)[5] <- names(variables)[variables==val()]
    df
    
  }, escape = F, options = list(lengthMenu = c(10, 25, 50), pageLength = 10))
  
})

# output$state_data <- renderDataTable({
#   map_data %>% 
#     st_drop_geometry() %>% 
#     group_by(state) %>% 
#     summarise(`Number of Mines (2001)` = sum(totalmines01),
#               `Number of Mines (2021)` = sum(totalmines21),
#               `Number of Black Lung Cases` = sum(any_cwp),
#               `Number of Black Lung Deaths` = sum(total_black_lung_deaths)) %>% 
#     rename(State = state)
# }, escape = F, options = list(lengthMenu = c(5, 15, 25), pageLength = 5))

# output$region_data <- renderDataTable({
#   map_data %>% 
#     st_drop_geometry() %>% 
#     group_by(region_id) %>% 
#     summarise(`Number of Mines (2001)` = sum(totalmines01),
#               `Number of Mines (2021)` = sum(totalmines21),
#               `Number of Black Lung Cases` = sum(any_cwp),
#               `Number of Black Lung Deaths` = sum(total_black_lung_deaths)
#     ) %>% 
#     rename(Region = region_id)
# }, escape = F, options = list(lengthMenu = c(5, 15, 25), pageLength = 5))
# 
# output$state_data <- renderDataTable({
#   map_data %>% 
#     st_drop_geometry() %>% 
#     group_by(state) %>% 
#     summarise(`Number of Mines (2001)` = sum(totalmines01),
#               `Number of Mines (2021)` = sum(totalmines21),
#               `Number of Black Lung Cases` = sum(any_cwp),
#               `Number of Black Lung Deaths` = sum(total_black_lung_deaths)) %>% 
#     rename(State = state)
# }, escape = F, options = list(lengthMenu = c(5, 15, 25), pageLength = 5))
