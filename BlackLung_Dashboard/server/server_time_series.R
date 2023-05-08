output$surface_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = surfacemines01, y = surfacemines21)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Surface Mines 2001 vs. 2021",
         x = "Surface Mines 2001",
         y = "Surface Mines 2021")
})

output$hover_surface_time <- renderUI({hover_output("surface_time_hover",
                                                       "Surface Mines 2001: ",
                                                       "Surface Mines 2021: ",
                                                       "surfacemines01",
                                                       "surfacemines21")})

output$under_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = undergrndmines01, y = undergrndmines21)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Underground Mines 2001 vs. 2021",
         x = "Underground Mines 2001",
         y = "Underground Mines 2021")
})

output$hover_under_time <- renderUI({hover_output("under_time_hover",
                                                       "Underground Mines 2001: ",
                                                       "Underground Mines 2021: ",
                                                       "undergrndmines01",
                                                       "undergrndmines21")})

output$total_mine_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = totalmines01, y = totalmines21)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Total Mines 2001 vs. 2021",
         x = "Total Mines 2001",
         y = "Total Mines 2021")
})

output$hover_total_mine_time <- renderUI({hover_output("total_mine_time_hover",
                                                       "Total Mines 2001: ",
                                                       "Total Mines 2021: ",
                                                       "totalmines01",
                                                       "totalmines21")})

output$total_prod_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = totalprodx1000st01, y = totalprodx1000st21)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Total Production (x1000) 2001 vs. 2021",
         x = "Total Production (x1000) 2001",
         y = "Total Production (x1000) 2021")
})

output$hover_total_prod_time <- renderUI({hover_output("total_prod_time_hover",
                                                       "Total Production (x1000) 2001: ",
                                                       "Total Production (x1000) 2021: ",
                                                       "totalprodx1000st01",
                                                       "totalprodx1000st21")})

output$total_employ_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = total_mining_employees_1986, y = total_mining_employees_2020)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Total Number of Mining Employees 1986 vs. 2020",
         x = "Total Number of Mining Employees 1986",
         y = "Total Number of Mining Employees 2020")
})

output$hover_total_employ_time <- renderUI({hover_output("total_employ_time_hover",
                                                       "Total Number of Mining Employees 1986: ",
                                                       "Total Number of Mining Employees 2020: ",
                                                       "total_mining_employees_1986",
                                                       "total_mining_employees_2020")})

output$pct_employ_time <- renderPlot({
  map_data %>% 
    ggplot(aes(x = pct_total_mining_employees_1986, y = pct_total_mining_employees_2020)) +
    geom_point() +
    geom_smooth(method = "lm",
                color = "#fa234b") +
    theme_bw() +
    labs(title = "Percentage of County residents that are Mining Employees 1986 vs. 2020",
         x = "Percent of Miners 1986",
         y = "Percent of Miners 2020")
})

output$hover_pct_employ_time <- renderUI({hover_output("pct_employ_time_hover",
                                                       "Percent of Miners 1986: ",
                                                       "Percent of Miners 2020: ",
                                                       "pct_total_mining_employees_1986",
                                                       "pct_total_mining_employees_2020")})

hover_output <- function(hover_input_id, x_lab, y_lab, x_col, y_col) {
  hover <- input[[hover_input_id]]
  if(is.null(hover)) return(NULL)
  
  point <- nearPoints(map_data, hover, threshold = 5, maxpoints = 1)
  if(nrow(point) == 0) return(NULL)
  
  left_px <- hover$coords_css$x
  top_px  <- hover$coords_css$y
  
  style <- paste0(
    "position:absolute; z-index:100; pointer-events:none; ", 
    "background-color: rgba(245, 245, 245, 0.85); ",
    "left:", left_px, 
    "px; top:", top_px, "px;"
  )
  
  # tooltip created as wellPanel
  tooltip <- paste0(
    "<b>", point[["countyname"]], " County, ", point[["state"]], "</b>",  "<br/>", 
    "<b> ", x_lab, " </b>",     point[[x_col]],     "<br/>",
    "<b> ", y_lab, " </b>",     point[[y_col]],     "<br/>"
  )
  wellPanel(
    style = style, p(HTML(tooltip))
  )
}

