library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(rmapshaper)


val <- eventReactive(input$search_map, {
  val <- input$factor
})

# met <- eventReactive(input$search_map, {
#   met <- input$metric
# })

map_data2 <- eventReactive(input$search_map, {
  # map_data %>%
  #   filter(get(val()) > 0 & get(met()) > 0)
  map_data 
})

# map_data3 <- eventReactive(input$search_map, {
#   map_data %>%
#     filter(get(met()) > 0)
# })

output$map <- renderLeaflet({
  # Creating a color palette based on the number range in the column of interest
  if (all(map_data2()[[val()]] == 0)) {
    pal <- colorNumeric(c("#FFFFFF"), domain = map_data2()[[val()]], na.color = "#bababa")
    
  } else if (val() == "scalar_coal_county") {#(is.character(map_data2()[[val()]])) {
    pal <- colorFactor(palette = "Blues", domain = map_data2()[[val()]], 
                       levels = c("No Coal", "Very Low", "Low", "Medium", "High", "Very High"), 
                       ordered = T,
                       na.color = "#bababa") 
  } else if (is.factor(map_data2()[[val()]]) & nlevels(map_data2()[[val()]])) {
    pal <- colorFactor(palette = "Blues", domain = map_data2()[[val()]], 
                       levels = c("Yes", "No"), 
                       ordered = T, reverse = T,
                       na.color = "#bababa") 
  } else {
    pal <- colorNumeric("Blues", domain = map_data2()[[val()]], na.color = "#bababa")
  }
  
  
  # IDEA FOR COLOR FIX 
  # all(data$undrgrnd_cwppmf_per1000 == 0)

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
                       "<span class='custom'>Predicted Total Black Lung Incidences: ", round(map_data2()$predict_any_cwp, 2), "</span>",
                       "<br>",
                       "Total Black Lung Deaths: ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Predicted Total Black Lung Deaths: ", round(map_data2()$predict_black_lung_deaths, 2), "</span>"
                       )
  } else if (is.character(map_data2()[[val()]]) | is.factor(map_data2()[[val()]])) {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>",
                       "<br>",
                       "Region: ", map_data2()$region_id,
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       names(variables)[variables==val()], ": ", as.character(map_data2()[[val()]]),
                       "<br>",
                       "Total Black Lung Incidences: ", map_data2()$any_cwp,
                       "<br>",
                       "<span class='custom'>Predicted Total Black Lung Incidences: ", round(map_data2()$predict_any_cwp, 2), "</span>",
                       "<br>",
                       "Total Black Lung Deaths: ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Predicted Total Black Lung Deaths: ", round(map_data2()$predict_black_lung_deaths, 2), "</span>"
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
                       "<span class='custom'>Predicted Total Black Lung Incidences: ", round(map_data2()$predict_any_cwp, 2),"</span>",
                       "<br>",
                       "Total Black Lung Deaths: ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Predicted Total Black Lung Deaths: ", round(map_data2()$predict_black_lung_deaths, 2), "</span>"
    )
  }

  map <- leaflet() %>%
    # always groups
    addProviderTiles("CartoDB.Positron", group = "Tiles") %>%
    setView(-98.35, 39.5, zoom = 5) %>%
    addPolygons(data = map_data2(),
                fillColor = ~pal(map_data2()[[val()]]),
                stroke = TRUE,
                color = "black",
                opacity = 1,
                fillOpacity = .9,
                weight = 0.2,
                smoothFactor = 0.2,
                popup = ~popup_sb, 
                group = "County-level Data") %>%
    # overlay groups
    addPolygons(data = navajo, color = "#FF0000", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fill = FALSE, group = "Navajo Nation") %>%
    addPolygons(data = appalachia, color = "#FF0000", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fill = FALSE, group = "Appalachia") %>%
    # addCircles(lng = map_data3()$long, lat = map_data3()$lat, weight = 1,
    #            radius = map_data3()[[met()]] * 100,
    #            color = "purple",
    #            opacity = .75, 
    #            fill = FALSE, 
    #            # data = map_data2,
    #            group = "Metric") %>% 
    # Overlay control
    addLayersControl(
      # baseGroups = c("Tiles"),
      overlayGroups = c("Navajo Nation", "Appalachia"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    # Legend for map
    addLegend(pal = pal,
              values = map_data2()[[val()]],
              position = "bottomleft",
              title = names(variables)[variables==val()])
    

  map %>% 
    hideGroup("Navajo Nation") %>% 
    hideGroup("Appalachia")
})

# output$incid_plot <- renderPlot({
#   map_data2() %>%
#     ggplot(aes_string(x = val(), y = 'any_cwp')) +
#     geom_point() +
#     geom_smooth(method = "lm",
#                 color = "#fa234b") +
#     theme_bw() +
#     labs(title = paste(names(variables)[variables==val()],
#                        " vs. \n",
#                        'Total Black Lung Incidences'),
#          x = names(variables)[variables==val()],
#          y = 'Total Black Lung Incidences')
# })
#
# output$death_plot <- renderPlot({
#   map_data2() %>%
#     ggplot(aes_string(x = val(), y = 'total_black_lung_deaths')) +
#     geom_point() +
#     geom_smooth(method = "lm",
#                 color = "#fa234b") +
#     theme_bw() +
#     labs(title = paste(names(variables)[variables==val()],
#                        " vs. \n",
#                        names(variables)[variables=='total_black_lung_deaths']),
#          x = names(variables)[variables==val()],
#          y = names(variables)[variables=='total_black_lung_deaths'])
# })

observeEvent(input$search_map, {
  output$region_data <- renderDataTable({
    if (is.numeric(map_data2()[[val()]])) {
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
    } else {
      df <- map_data %>%
        st_drop_geometry() %>%
        mutate(intermed = get(val())) %>%
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
    }
    
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
