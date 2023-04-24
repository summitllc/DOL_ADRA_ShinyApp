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
    popup_sb <- paste0("Percent: ", as.character(map_data2()[[val()]]), "%")
  } else {
    popup_sb <- paste0("Value: ", as.character(round(map_data2()[[val()]], 2)))
  }
  
  print(paste0("Percent: ", as.character(map_data2()[[val()]]), "%"))
  print(popup_sb)
  
  map <- leaflet() %>% 
    addProviderTiles("CartoDB.Positron") %>%
    setView(-98.35, 39.5, zoom = 4) %>% 
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
      select(countyname, state, region_id, val(), any_cwp, total_black_lung_deaths) %>%
      arrange(desc(get(val()))) %>% 
      rename(County = countyname,
             State = state,
             Region = region_id,
             `Number of Black Lung Cases` = any_cwp,
             `Number of Black Lung Deaths` = total_black_lung_deaths
      )
    
    colnames(df)[4] <- names(variables)[variables==val()] 
    print(colnames(df)[4])
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
