library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(rmapshaper)

# Creating a color palette based on the number range in the column of interest

observeEvent(input$search_map, {
  
  withProgress(message = "Searching Counties...", value = 0, {
    incProgress(amount = .9)
  
  map_data2 <- map_data %>% 
    filter(get(input$factor) > 0)
  
  output$map <- renderLeaflet({
    
    
    pal <- colorNumeric("Blues", domain = map_data2[[input$factor]])
    
    popup_sb <- paste0("Value: ", as.character(round(map_data2[[input$factor]], 2)))
    
    map <- leaflet() %>% 
      addProviderTiles("CartoDB.Positron") %>%
      setView(-98.35, 39.5, zoom = 4) %>% 
      addPolygons(data = map_data2,
                  fillColor = ~pal(map_data2[[input$factor]]),
                  stroke = TRUE,
                  color = "black",
                  opacity = 1,
                  fillOpacity = 1,
                  weight = 0.2,
                  smoothFactor = 0.2,
                  popup = ~popup_sb) %>%
      addLegend(pal = pal,
                values = map_data2[[input$factor]],
                position = "bottomleft",
                title = names(variables)[variables==input$factor])
    
    map
  })

  
  output$region_data <- renderDataTable({
    map_data2 %>% 
      st_drop_geometry() %>% 
      group_by(region_id) %>% 
      summarise(`Number of Mines (2001)` = sum(totalmines01),
                `Number of Mines (2021)` = sum(totalmines21),
                `Number of Black Lung Cases` = sum(any_cwp),
                `Number of Black Lung Deaths` = sum(total_black_lung_deaths)
                ) %>% 
      rename(Region = region_id)
  }, escape = F, options = list(lengthMenu = c(5, 15, 25), pageLength = 5))
  
  output$state_data <- renderDataTable({
    map_data2 %>% 
      st_drop_geometry() %>% 
      group_by(state) %>% 
      summarise(`Number of Mines (2001)` = sum(totalmines01),
                `Number of Mines (2021)` = sum(totalmines21),
                `Number of Black Lung Cases` = sum(any_cwp),
                `Number of Black Lung Deaths` = sum(total_black_lung_deaths)) %>% 
      rename(State = state)
  }, escape = F, options = list(lengthMenu = c(5, 15, 25), pageLength = 5))
  
  output$incid_plot <- renderPlot({
    map_data2 %>% 
      ggplot(aes_string(x = input$factor, y = 'any_cwp')) +
      geom_point() +
      geom_smooth(method = "lm",
                  color = "#fa234b") +
      theme_bw() +
      labs(title = paste(names(variables)[variables==input$factor], 
                         " vs. \n",
                         'Total Black Lung Incidences'),
           x = names(variables)[variables==input$factor],
           y = 'Total Black Lung Incidences')
  })
  
  output$death_plot <- renderPlot({
    map_data2 %>% 
      ggplot(aes_string(x = input$factor, y = 'total_black_lung_deaths')) +
      geom_point() +
      geom_smooth(method = "lm",
                  color = "#fa234b") +
      theme_bw() +
      labs(title = paste(names(variables)[variables==input$factor],
                         " vs. \n",
                         names(variables)[variables=='total_black_lung_deaths']),
           x = names(variables)[variables==input$factor],
           y = names(variables)[variables=='total_black_lung_deaths'])
  })
  
  }) 
})



# data %>% 
#   ggplot(aes(x = input$factor, y = total_black_lung_deaths)) +
#   geom_point() +
#   geom_smooth(method = "lm",
#               color = "#fa234b") +
#   theme_bw() +
#   labs(title = paste('Relationship between ', 
#                      names(variables)[variables==input$factor], 
#                      " and ", 
#                      names(variables)[variables==total_black_lung_deaths]),
#        x = names(variables)[variables==input$factor],
#        y = names(variables)[variables==total_black_lung_deaths])


