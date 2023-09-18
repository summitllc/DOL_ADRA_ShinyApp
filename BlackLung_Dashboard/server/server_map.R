library(tidyverse)
library(leaflet)
library(tigris)
library(sf)
library(rmapshaper)

val2 <- eventReactive(input$search_map, {
  val2 <- input$factor
})

output$radio_opts <- renderUI({
  radioButtons(
    inputId = "option",
    label = HTML(paste0(strong(("More Specific Please")))), 
    choices = crosswalk %>% filter(factor == input$factor) %>% count(radio) %>% pull(radio)
  )
})

output$radio_opts2 <- renderUI({
  opt = ifelse(is.null(input$option), "Indicator", input$option)
  radioButtons(
    inputId = "option2",
    label = HTML(paste0(strong(("Even More...")), "&nbsp;&nbsp;", addHelpButton("help", ""))), 
    choiceNames = crosswalk %>% filter(factor == input$factor) %>% filter(radio == opt) %>% pull(radio2),
    choiceValues = crosswalk %>% filter(factor == input$factor) %>% filter(radio == opt) %>% pull(variable)
  )
})

val <- eventReactive(input$search_map, {
  val <- input$option2
})

map_data2 <- eventReactive(input$search_map, {
  
  if (is.numeric(map_data[[val()]])) {
    map_data <- map_data %>% 
      filter(get(val()) > 0)
  } else {
    map_data <- map_data %>% 
      filter(get(val()) != "No Coal" & get(val()) != "No")
  }

  map_data
    
})

output$map <- renderLeaflet({
  # Creating a color palette based on the number range in the column of interest
  if (all(map_data2()[[val()]] == 0)) {
    pal <- colorNumeric(c("#FFFFFF"), domain = map_data2()[[val()]], na.color = "#bababa")
    
  } else if (str_detect(val(), "^scalar_")) {
    pal <- colorFactor(palette = "YlOrRd", domain = map_data2()[[val()]], 
                       levels = c("No Coal", "Very Low", "Low", "Medium", "High", "Very High"), 
                       ordered = T,
                       na.color = "#bababa") 
  } else if (is.factor(map_data2()[[val()]]) & nlevels(map_data2()[[val()]])) {
    pal <- colorFactor(palette = "YlOrRd", domain = map_data2()[[val()]], 
                       levels = c("Yes", "No"), 
                       ordered = T, reverse = T,
                       na.color = "#bababa") 
  } else {
    pal <- colorNumeric("YlOrRd", domain = map_data2()[[val()]], na.color = "#bababa")
  }
  print(pal)
  
  
  # IDEA FOR COLOR FIX 
  # all(data$undrgrnd_cwppmf_per1000 == 0)

  if (val() %in% percent_cols) {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>",
                       "<br>",
                       "Region: ", map_data2()$region_id,
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       val2(), ": ", as.character(round(map_data2()[[val()]], 2)), "%",
                       "<br>",
                       "Cumulative Black Lung Cases (1970-2014): ", map_data2()$any_cwp,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Cases (1970-2014): ", 
                       round(map_data2()$predict_any_cwp, 2), "</span>",
                       "<br>",
                       "Cumulative Black Lung Deaths (1999-2020): ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Deaths (1999-2020): ", 
                       round(map_data2()$predict_black_lung_deaths, 2), "</span>"
                       )
  } else if (is.character(map_data2()[[val()]]) | is.factor(map_data2()[[val()]])) {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>",
                       "<br>",
                       "Region: ", map_data2()$region_id,
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       val2(), ": ", as.character(map_data2()[[val()]]),
                       "<br>",
                       "Cumulative Black Lung Cases (1970-2014): ", map_data2()$any_cwp,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Cases (1970-2014): ", 
                       round(map_data2()$predict_any_cwp, 2), "</span>",
                       "<br>",
                       "Cumulative Black Lung Deaths (1999-2020): ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Deaths (1999-2020): ", 
                       round(map_data2()$predict_black_lung_deaths, 2), "</span>"
    )
  } else {
    popup_sb <- paste0("<B><u>", map_data2()$countyname, " County, ", map_data2()$state, "</B></u>",
                       "<br>",
                       "Region: ", map_data2()$region_id,
                       "<br>",
                       "MSHA District: ", map_data2()$msha_district_county,
                       "<br>",
                       val2(), ": ", as.character(round(map_data2()[[val()]], 2)),
                       "<br>",
                       "Cumulative Black Lung Cases (1970-2014): ", map_data2()$any_cwp,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Cases (1970-2014): ", 
                       round(map_data2()$predict_any_cwp, 2),"</span>",
                       "<br>",
                       "Cumulative Black Lung Deaths (1999-2020): ", map_data2()$total_black_lung_deaths,
                       "<br>",
                       "<span class='custom'>Regression-estimated Cumulative Black Lung Deaths (1999-2020): ", 
                       round(map_data2()$predict_black_lung_deaths, 2), "</span>"
    )
  }
  

  map <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
    htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomright' }).addTo(this)
    }") %>%
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
    addPolygons(data = navajo, color = "#0189DC", weight = 2, smoothFactor = 0.5,
                opacity = 1.0, fill = FALSE, group = "Navajo Nation") %>%
    addPolygons(data = appalachia, color = "#0189DC", weight = 2, smoothFactor = 0.5,
                opacity = 1.0, fill = FALSE, group = "Appalachia") %>%
    addLayersControl(
      overlayGroups = c("Navajo Nation", "Appalachia"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    htmlwidgets::onRender("
        function() {
            $('.leaflet-control-layers-overlays').prepend('<label style=\"text-align:center\">Add or remove regional borders</label>');
        }
    ") %>% 
    # add title
    addControl(html =  strong(paste0("US Map of ", crosswalk$full_title[crosswalk$variable==val()])),
               position = "topleft", 
               className="info legend") %>%
    # Legend for map
    addLegend(pal = pal,
              values = map_data2()[[val()]],
              position = "bottomleft",
              opacity = 1,
              title = paste0(val2(), '\n', input$radio))
    

  map %>% 
    hideGroup("Navajo Nation") %>% 
    hideGroup("Appalachia")
})

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
               `Cumulative Black Lung Cases (1970-2014)` = any_cwp,
               `Cumulative Black Lung Deaths (1999-2020)` = total_black_lung_deaths
        )
      
      colnames(df)[5] <- crosswalk$factor[crosswalk$variable==val()]
      # df
      datatable(df, filter = "none")
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
               `Cumulative Black Lung Cases (1970-2014)` = any_cwp,
               `Cumulative Black Lung Deaths (1999-2020)` = total_black_lung_deaths
        )
      
      colnames(df)[5] <- crosswalk$factor[crosswalk$variable==val()]
      # df
      datatable(df, filter = "none")
    }
    
  }, escape = F, options = list(lengthMenu = c(10, 25, 50), pageLength = 10))

})

observeEvent(input$help, {
  if (str_detect(input$option2, "^predict")) {
    showModal(
      modalDialog(
        p("Choose a factor, more specifics, and then click explore."),
        strong("Your Current Option:"),
        p(data_dict$Description[data_dict$Variable==input$option2]),
        p("**Note: Regression-estimated values (in red) estimate black lung prevalence 
          based on a statistical model that includes independent factors presenting 
          risk to contracting coal-related respiratory illnesses. For additional details, see the report."),
        easyClose = TRUE
      )
    )
  } else {
    showModal(
      modalDialog(
        p("Choose a factor, more specifics, and then click explore."),
        strong("Your Current Option:"),
        p(data_dict$Description[data_dict$Variable==input$option2]),
        easyClose = TRUE
      )
    )
  }
})

