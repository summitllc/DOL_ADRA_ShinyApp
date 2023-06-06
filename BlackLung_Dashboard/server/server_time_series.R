# output$surface_time <- renderPlot({
#   map_data %>% 
#     ggplot(aes(x = surfacemines01, y = surfacemines21)) +
#     geom_point() +
#     geom_smooth(method = "lm",
#                 color = "#fa234b") +
#     theme_bw() +
#     labs(title = "Surface Mines 2001 vs. 2021",
#          x = "Surface Mines 2001",
#          y = "Surface Mines 2021")
# })

library(billboarder)

output$surface_time <- renderBillboarder({#renderPlot({
  billboarder() %>% 
    bb_scatterplot(data = time_data_outlier_less, x = "totalmines", y = "totalprodx1000st", group = "year") %>% 
    bb_axis(x = list(tick = list(fit = FALSE))) %>% 
    bb_point(r = 8) %>% 
    bb_labs(title = "Total Mines and Coal Production") %>% 
    bb_y_axis(label = list(text = "Production (in thousands of short tons)", position = "outer-top")) %>% 
    bb_x_axis(label = list(text = "Total Mines", position = "outer-top")) 
  #map_output("surfacemines01", "surfacemines21", "Surface Mines 2001 vs. 2021", "Surface Mines 2001", "Surface Mines 2021")
})

# output$hover_surface_time <- renderUI({hover_output("surface_time_hover",
#                                                        "Surface Mines 2001: ",
#                                                        "Surface Mines 2021: ",
#                                                        "surfacemines01",
#                                                        "surfacemines21")})

output$under_time <- renderBillboarder({#renderPlot({
  p2
  #map_output("undergrndmines01", "undergrndmines21", "Underground Mines 2001 vs. 2021", "Underground Mines 2001", "Underground Mines 2021")
})

# output$hover_under_time <- renderUI({hover_output("under_time_hover",
#                                                        "Underground Mines 2001: ",
#                                                        "Underground Mines 2021: ",
#                                                        "undergrndmines01",
#                                                        "undergrndmines21")})

output$total_mine_time <- renderBillboarder({#renderPlot({
  p3
  #map_output("totalmines01", "totalmines21", "Total Mines 2001 vs. 2021", "Total Mines 2001", "Total Mines 2021")
})

# output$hover_total_mine_time <- renderUI({hover_output("total_mine_time_hover",
#                                                        "Total Mines 2001: ",
#                                                        "Total Mines 2021: ",
#                                                        "totalmines01",
#                                                        "totalmines21")})

output$total_prod_time <- renderBillboarder({#renderPlot({
  p4
  #map_output("totalprodx1000st01", "totalprodx1000st21", "Total Coal Production 2001 vs. 2021", "Total Production (x1000) 2001", "Total Production (x1000) 2021")
})

# output$hover_total_prod_time <- renderUI({hover_output("total_prod_time_hover",
#                                                        "Total Production (x1000) 2001: ",
#                                                        "Total Production (x1000) 2021: ",
#                                                        "totalprodx1000st01",
#                                                        "totalprodx1000st21")})

# output$total_employ_time <- renderPlot({
#   map_output("total_mining_employees_1986", "total_mining_employees_2020", "Mining Employees 1986 vs. 2020", "Mining Employees 1986", "Mining Employees 2020")
# })
# 
# output$hover_total_employ_time <- renderUI({hover_output("total_employ_time_hover",
#                                                        "Total Number of Mining Employees 1986: ",
#                                                        "Total Number of Mining Employees 2020: ",
#                                                        "total_mining_employees_1986",
#                                                        "total_mining_employees_2020")})
# 
# output$pct_employ_time <- renderPlot({
#   map_output("pct_total_mining_employees_1986", "pct_total_mining_employees_2020", "Percent of Miners 1986 vs. 2020", "Percent of Miners 1986", "Percent of Miners 2020")
# })
# 
# output$hover_pct_employ_time <- renderUI({hover_output("pct_employ_time_hover",
#                                                        "Percent of Miners 1986: ",
#                                                        "Percent of Miners 2020: ",
#                                                        "pct_total_mining_employees_1986",
#                                                        "pct_total_mining_employees_2020")})
# 
# hover_output <- function(hover_input_id, x_lab, y_lab, x_col, y_col) {
#   hover <- input[[hover_input_id]]
#   if(is.null(hover)) return(NULL)
#   
#   point <- nearPoints(map_data, hover, threshold = 5, maxpoints = 1)
#   if(nrow(point) == 0) return(NULL)
#   
#   left_px <- hover$coords_css$x
#   top_px  <- hover$coords_css$y
#   
#   style <- paste0(
#     "position:absolute; z-index:100; pointer-events:none; ", 
#     "background-color: rgba(245, 245, 245, 0.85); ",
#     "left:", left_px, 
#     "px; top:", top_px, "px;"
#   )
#   
#   # tooltip created as wellPanel
#   tooltip <- paste0(
#     "<b>", point[["countyname"]], " County, ", point[["state"]], "</b>",  "<br/>", 
#     "<b> ", x_lab, " </b>",   round(point[[x_col]], 2),     "<br/>",
#     "<b> ", y_lab, " </b>",   round(point[[y_col]], 2),     "<br/>"
#   )
#   wellPanel(
#     style = style, p(HTML(tooltip))
#   )
# }
# 
# map_output <- function(x, y, title, x_axis, y_axis) {
#   min = min(data[[x]], data[[y]]) 
#   max = max(data[[x]], data[[y]]) * 1.05
#   
#   map_data %>% 
#     ggplot(aes_string(x = x, y = y)) +
#     geom_point(size = 4) +
#     geom_smooth(method = "lm",
#                 color = "#fa234b") +
#     theme_bw() +
#     labs(title = title,
#          x = x_axis,
#          y = y_axis) +
#     coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
#     theme(title = element_text(size = 18),
#           axis.title = element_text(size = 16),
#           axis.text = element_text(size = 14))
# }

map_output2 <- function(x, y, title, x_axis, y_axis) {
  # min_x = min(data[[x]]) 
  # max_y = max(data[[y]]) * 1.05
  # min_y = min(data[[y]]) 
  # max_x = max(data[[x]]) * 1.05
  
  time_data %>% 
    ggplot(aes_string(x = x, y = y, color = "year")) +
    geom_point(size = 4, alpha = .5) +
    geom_smooth(method = "lm",
                aes(color = year)) +
    theme_bw() +
    labs(title = title,
         x = x_axis,
         y = y_axis) +
    # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
    theme(title = element_text(size = 18),
          axis.title = element_text(size = 16),
          axis.text = element_text(size = 14))
}

map_output3 <- function(x, y, title, x_axis, y_axis) {
  # min_x = min(data[[x]]) 
  # max_y = max(data[[y]]) * 1.05
  # min_y = min(data[[y]]) 
  # max_x = max(data[[x]]) * 1.05
  
  time_data2 %>% 
    ggplot(aes_string(x = x, y = y, color = "year")) +
    geom_point(size = 4, alpha = .5) +
    geom_smooth(method = "lm",
                aes(color = year)) +
    theme_bw() +
    labs(title = title,
         x = x_axis,
         y = y_axis) +
    # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
    theme(title = element_text(size = 18),
          axis.title = element_text(size = 16),
          axis.text = element_text(size = 14))
}

map_output4 <- function(x, title, x_axis) {
  # min_x = min(data[[x]]) 
  # max_y = max(data[[y]]) * 1.05
  # min_y = min(data[[y]]) 
  # max_x = max(data[[x]]) * 1.05
  
  time_data %>% 
    ggplot(aes_string(x = x, color = "year")) +
    geom_boxplot() +
    theme_bw() +
    labs(title = title,
         x = x_axis)
    # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
    theme(title = element_text(size = 18),
          axis.title = element_text(size = 16),
          axis.text = element_text(size = 14))
}

time_data <- data %>% 
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "01|21")], 
               names_to = c('.value', 'year'), 
               names_pattern = '(.*)(..$)') 


time_data2 <- data %>% 
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "1986|2020")], 
               names_to = c('.value', 'year'), 
               names_pattern = '(.*)(....$)') 


# map_output2("totalmines", "totalprodx1000st", "Total Mines vs. Production", "Total Mines", "Total Coal Production (x1000)")
# # map_output2("undergrndmines", "undergrndmprodx1000st", "Underground Mines vs. Production", "Underground Mines", "Total Coal Production (x1000)")
# # map_output2("surfacemines", "surfaceprodx1000st", " Surface Mines vs. Production", "Surface Mines", "Total Coal Production (x1000)")
# map_output3("total_mining_employees_", "pct_total_mining_employees_", "Total Mining Employees vs. Percentage", "Total Miners", "Percentage Miners")
# map_output4("totalmines", "Total Mines", "Total Mines")

# time_data %>% 
#   filter(totalmines > 0) %>% 
#   ggplot(aes_string(y = "totalmines", color = "year")) +
#   geom_boxplot() +
#   theme_bw() +
#   labs(title = "Total Mines 2001 vs. 2021",
#        y = "Total Mines") +
# # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
# theme(title = element_text(size = 18),
#       axis.title = element_text(size = 16),
#       axis.text = element_text(size = 14),
#       axis.text.x = element_blank(),
#       axis.ticks.x = element_blank())

# time_data %>% 
#   filter(surfacemines > 0) %>% 
#   ggplot(aes_string(x = "surfacemines", fill = "year")) +
#   geom_density(alpha = 0.5) +
#   theme_bw() +
#   labs(title = "Surface Mines 2001 vs. 2021",
#        x = "Surface Mines") +
#   # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
#   theme(title = element_text(size = 18),
#         axis.title = element_text(size = 16),
#         axis.text = element_text(size = 14))

# time_data %>% 
#   filter(undergrndmines > 0) %>%
#   ggplot(aes_string(x = "undergrndmines", fill = "year")) +
#   geom_density(alpha = 0.5) +
#   theme_bw() +
#   labs(title = "Underground Mines 2001 vs. 2021",
#        x = "Underground Mines") +
#   # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
#   theme(title = element_text(size = 18),
#         axis.title = element_text(size = 16),
#         axis.text = element_text(size = 14))

# change <- data %>% 
#   mutate(tot_mine_change = (totalmines21 - totalmines01),
#          tot_mine_pct_change = (totalmines21 - totalmines01)/totalmines01) %>% 
#   select(totalmines01, totalmines21, tot_mine_change, tot_mine_pct_change) 

# change %>% 
#   ggplot(aes_string(x = "tot_mine_pct_change")) +
#   geom_histogram()+
#   theme_bw() +
#   scale_x_continuous(labels = scales::percent) +
#   geom_vline(xintercept = 0, linetype="dotted", 
#              color = "red", size=1.5) +
#   labs(title = "Total Mines 2001 vs. 2021",
#        x = "Percent Change (2001 to 2021)") +
#   # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
#   theme(title = element_text(size = 18),
#         axis.title = element_text(size = 16),
#         axis.text = element_text(size = 14))

# change %>% 
#   filter(tot_mine_change != 0) %>% 
#   ggplot(aes_string(x = "tot_mine_change")) +
#   geom_histogram()+
#   theme_bw() +
#   geom_vline(xintercept = 0, linetype="dotted", 
#              color = "red", size=1.5) +
#   labs(title = "Total Mines 2001 vs. 2021",
#        x = "# Mines Change (2001 to 2021)") +
#   # coord_fixed(xlim = c(min, max), ylim = c(min, max)) +
#   theme(title = element_text(size = 18),
#         axis.title = element_text(size = 16),
#         axis.text = element_text(size = 14))

# Try Billboarder
library(billboarder)

# Q_mines <- quantile(time_data$totalmines[time_data$totalmines > 0], probs=c(.25, .75), na.rm = FALSE)
# iqr_mines <- IQR(time_data$totalmines[time_data$totalmines > 0])
# up_mines <-  Q_mines[2] + 1.5 * iqr_mines

time_data_outlier_less<- time_data %>% 
  filter(totalmines < 100, totalprodx1000st < 100000) %>% 
  mutate(year = paste0(20, year))

p1 <- billboarder() %>% 
  bb_scatterplot(data = time_data_outlier_less, x = "totalmines", y = "totalprodx1000st", group = "year") %>% 
  bb_axis(x = list(tick = list(fit = FALSE))) %>% 
  bb_point(r = 8) %>% 
  bb_labs(title = "Total Mines and Coal Production") %>% 
  bb_y_axis(label = list(text = "Production (in thousands of short tons)", position = "outer-top")) %>% 
  bb_x_axis(label = list(text = "Total Mines", position = "outer-top")) 

p3 <- billboarder() %>% 
  bb_scatterplot(data = time_data2, x = "total_mining_employees_", y = "pct_total_mining_employees_", group = "year") %>% 
  bb_axis(x = list(tick = list(fit = FALSE))) %>% 
  bb_point(r = 8) %>% 
  bb_labs(title = "County-level Mining Employment",
          caption = "Percentage of Miners := Number of mining employees relative to 2021 population") %>% 
  bb_y_axis(tick = list(format = suffix("%")),
            label = list(text = "Percentage of Miners", position = "outer-top")) %>% 
  bb_x_axis(label = list(text = "Total Miners", position = "outer-top")) 


# Stacked Bar Plot
# time_data3 <- data %>% 
#   pivot_longer(cols = c("totalmines01", "totalmines21", "totalprodx1000st01", "totalprodx1000st21"), 
#   names_to = c('.value', 'year'), 
#   names_pattern = '(.*)(..$)') 
  # mutate(year = str_extract(name, "..$")) %>% 
  # mutate(name = str_remove(name, "\\d*$")) %>% 
  # mutate(name = case_when(
  #   name == "totalmines" ~ "Total Mines",
  #   name == "totalprodx1000st" ~ "Production",
  #   TRUE ~ name
  # )) 

# time_data4 <- time_data3 %>% 
#   group_by(year) %>% 
#   summarise(totalmines = mean(totalmines),
#             totalprodx1000st = mean(totalprodx1000st))
# 
# billboarder() %>%
#   bb_barchart(
#     data = time_data4[, c("year", "totalmines", "totalprodx1000st")]
#   ) %>%
#   bb_data(
#     names = list(totalmines = "Total Mines", totalprodx1000st = "Total Production")
#   ) %>% 
#   bb_y_grid(show = TRUE) %>%
#   bb_y_axis(tick = list(format = suffix("TWh")),
#             label = list(text = "production (in terawatt-hours)", position = "outer-top")) %>% 
#   bb_legend(position = "inset", inset = list(anchor = "top-right")) %>% 
#   bb_labs(title = "Renewable energy production",
#           caption = "Data source: RTE (https://opendata.rte-france.com)")


# histograms
p2 <- billboarder() %>%
  bb_histogram(data = time_data_outlier_less %>% 
                 filter(totalmines > 0), x = "totalmines", group = "year") %>% 
  bb_x_axis(label = list(text = "Total Mines", position = "outer-top")) %>% 
  bb_y_axis(label = list(text = "Count", position = "outer-top")) %>% 
  bb_labs(title = "Time-dependent Distributions of total Mines")



p4 <- billboarder() %>%
  bb_histogram(data = time_data2 %>% 
                 filter(total_mining_employees_ > 0), x = "total_mining_employees_", group = "year") %>% 
  bb_x_axis(label = list(text = "Total Miners", position = "outer-top")) %>% 
  bb_y_axis(label = list(text = "Count", position = "outer-top")) %>% 
  bb_labs(title = "Time-dependent Distributions of Miners") 

