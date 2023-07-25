library(billboarder)

output$surface_time <- renderBillboarder({#renderPlot({
  p1
})


output$under_time <- renderBillboarder({#renderPlot({
  p2
})

                                          

output$total_mine_time <- renderBillboarder({#renderPlot({
  p3
})


output$total_prod_time <- renderBillboarder({#renderPlot({
  p4
})

time_data <- data %>%
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "83|20")],
               names_to = c('.value', 'year'),
               names_pattern = '(.*)(..$)')


time_data2 <- data %>%
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "1986|2020")],
               names_to = c('.value', 'year'),
               names_pattern = '(.*)(....$)')

# Q_mines <- quantile(time_data$totalmines[time_data$totalmines > 0], probs=c(.25, .75), na.rm = FALSE)
# iqr_mines <- IQR(time_data$totalmines[time_data$totalmines > 0])
# up_mines <-  Q_mines[2] + 1.5 * iqr_mines

time_data_outlier_less<- time_data %>%
  filter(totalmines < 100, totalprodx1000st < 100000) %>%
  mutate(year = ifelse(year < 23, paste0(20, year), paste0(19, year)))

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


