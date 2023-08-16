library(billboarder)

output$surface_time <- renderPlot({
  p1
})


# output$under_time <- renderBillboarder({#renderPlot({
#   p2
# })

                                          

output$total_mine_time <- renderPlot({
  p3
})

output$total_employ_time <- renderPlot({
  p4
})
# 
# 
# output$total_prod_time <- renderBillboarder({#renderPlot({
#   p4
# })

# time_data <- data %>%
#   pivot_longer(cols = colnames(data)[str_detect(colnames(data), "83|20")],
#                names_to = c('.value', 'year'),
#                names_pattern = '(.*)(..$)')
# 
# 
# time_data2 <- data %>%
#   pivot_longer(cols = colnames(data)[str_detect(colnames(data), "1986|2020")],
#                names_to = c('.value', 'year'),
#                names_pattern = '(.*)(....$)')

# Q_mines <- quantile(time_data$totalmines[time_data$totalmines > 0], probs=c(.25, .75), na.rm = FALSE)
# iqr_mines <- IQR(time_data$totalmines[time_data$totalmines > 0])
# up_mines <-  Q_mines[2] + 1.5 * iqr_mines

# time_data_outlier_less<- time_data %>%
#   filter(totalmines < 100, totalprodx1000st < 100000) %>%
#   mutate(year = ifelse(year < 23, paste0(20, year), paste0(19, year)))
# 
# p1 <- billboarder() %>%
#   bb_scatterplot(data = time_data_outlier_less, x = "totalmines", y = "totalprodx1000st", group = "year") %>%
#   bb_axis(x = list(tick = list(fit = FALSE))) %>%
#   bb_point(r = 8) %>%
#   bb_labs(title = "Total Mines and Coal Production") %>%
#   bb_y_axis(label = list(text = "Production (in thousands of short tons)", position = "outer-top")) %>%
#   bb_x_axis(label = list(text = "Total Mines", position = "outer-top"))
# 
# 
# p3 <- billboarder() %>%
#   bb_scatterplot(data = time_data2, x = "total_mining_employees_", y = "pct_total_mining_employees_", group = "year") %>%
#   bb_axis(x = list(tick = list(fit = FALSE))) %>%
#   bb_point(r = 8) %>%
#   bb_labs(title = "County-level Mining Employment",
#           caption = "Percentage of Miners := Number of mining employees relative to 2021 population") %>%
#   bb_y_axis(tick = list(format = suffix("%")),
#             label = list(text = "Percentage of Miners", position = "outer-top")) %>%
#   bb_x_axis(label = list(text = "Total Miners", position = "outer-top"))

# histograms
# p2 <- billboarder() %>%
#   bb_histogram(data = time_data_outlier_less %>%
#                  filter(totalmines > 0), x = "totalmines", group = "year") %>%
#   bb_x_axis(label = list(text = "Total Mines", position = "outer-top")) %>%
#   bb_y_axis(label = list(text = "Count", position = "outer-top")) %>%
#   bb_labs(title = "Time-dependent Distributions of total Mines")
# 
# 
# 
# p4 <- billboarder() %>%
#   bb_histogram(data = time_data2 %>%
#                  filter(total_mining_employees_ > 0), x = "total_mining_employees_", group = "year") %>%
#   bb_x_axis(label = list(text = "Total Miners", position = "outer-top")) %>%
#   bb_y_axis(label = list(text = "Count", position = "outer-top")) %>%
#   bb_labs(title = "Time-dependent Distributions of Miners")

# NEW GRAPHS 7/27
p1 <- data %>% 
  mutate(msha_district_county = ifelse(is.na(msha_district_county), "Other", msha_district_county)) %>% 
  pivot_longer(cols = c(any_cwp, total_cwp_deaths)) %>% 
  group_by(msha_district_county, name) %>% 
  filter(msha_district_county != 'N/A') %>% 
  summarise(pct = sum(value)/sum(acspopulation2021),
            n = sum(value)) %>% 
  mutate(name = case_when(
    name == 'any_cwp' ~ 'Cumulative Black Lung Cases (1970-2014)',
    name == 'total_cwp_deaths' ~ 'Cumulative Black Lung Deaths (1999-2020)',
    TRUE ~ 'NA'
  )) %>% 
  ggplot(aes(x = msha_district_county, y = pct, fill = name)) +
  geom_bar(color = "black", stat = 'identity', position = position_dodge(), width = .8) +
  # geom_text(aes(label = paste0(round(pct * 100, 3), "%")),
  #           position = position_dodge(width = 1),
  #           vjust = -.5,
  #           hjust = -.05,
  #           angle = 45,
  #           size = 3) +
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.position="bottom",
        plot.title = element_text(size = 20),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(y = "Rate of Coal Miner's Pneumoconiosis",
       x = "MSHA District",
       title = 'The highest rate of black lung cases and deaths occured in MSHA district C12',
       fill = NULL) +
  scale_y_continuous(labels = scales::percent, limits =c(0,.008), expand = c(0,0)) +
  scale_fill_manual(values = c('#fda85e', '#fa234b'))

# data %>% 
#   mutate(msha_district_county = ifelse(is.na(msha_district_county), "Other", msha_district_county)) %>% 
#   pivot_longer(cols = c(any_cwp, total_cwp_deaths)) %>% 
#   group_by(msha_district_county, name) %>% 
#   summarise(pct = sum(value)/sum(acspopulation2021),
#             n = sum(value)) %>% 
#   mutate(name = case_when(
#     name == 'any_cwp' ~ 'Cumulative Black Lung Cases (1970-2014)',
#     name == 'total_cwp_deaths' ~ 'Cumulative Black Lung Deaths (1999-2020)',
#     TRUE ~ 'NA'
#   )) %>% 
#   ggplot(aes(y = msha_district_county, x = pct, fill = name)) +
#   geom_bar(stat = 'identity', position = position_dodge(width = 1)) +
#   geom_text(aes(label = paste0(' n = ', n)),
#             position = position_dodge(width = 1),
#             hjust = -.1) +
#   theme_bw() +
#   theme(panel.border = element_blank(),
#         axis.line = element_line(colour = "black"),
#         legend.position="bottom") +
#   labs(x = "Rate of Coal Miner's Pneumoconiosis",
#        y = "MSHA District",
#        title = 'The highest rate of Black Lung Cases and Deaths occured in MSHA District C12',
#        fill = NULL) +
#   scale_x_continuous(labels = scales::percent, limits =c(0,.008), expand = c(0,0)) +
#   scale_fill_manual(values = c('#fa234b', '#013783'))

p3 <- data %>% 
  mutate(msha_district_county = ifelse(is.na(msha_district_county), "Other", msha_district_county)) %>% 
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "83$|20$")],
               names_to = c('.value', 'year'),
               names_pattern = '(.*)(..$)') %>%
  filter(msha_district_county != 'N/A') %>% 
  group_by(msha_district_county, year) %>% 
  summarise(ratio = sum(totalprodx1000st)/sum(totalmines)) %>% 
  mutate(year = ifelse(year < 23, paste0(20, year), paste0(19, year))) %>% 
  ggplot(aes(x = msha_district_county, y = ratio, fill = year)) +
  geom_bar(color = "black", stat = 'identity', position = position_dodge(), width = .8) +
  # geom_text(aes(label = paste0(round(pct * 100, 3), "%")),
  #           position = position_dodge(width = 1),
  #           vjust = -.5,
  #           hjust = -.05,
  #           angle = 45,
  #           size = 3) +
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.position="bottom",
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 14),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(y = "Total Coal Production per Mine",
       x = "MSHA District",
       title = 'MSHA district C09 had the largest productivity ratio in both 1983 and 2020',
       subtitle = 'Total Coal Production measured in thousands of short tons',
       fill = NULL) +
  scale_y_continuous(limits =c(0,6000), expand = c(0,0)) +
  scale_fill_manual(values = c("#c3c6c9", '#013783'))

p4 <- data %>% 
  mutate(msha_district_county = ifelse(is.na(msha_district_county), "Other", msha_district_county)) %>% 
  pivot_longer(cols = colnames(data)[str_detect(colnames(data), "83$|20$")],
               names_to = c('.value', 'year'),
               names_pattern = '(.*)(..$)') %>%
  filter(msha_district_county != 'N/A') %>% 
  group_by(msha_district_county, year) %>% 
  summarise(ratio = sum(totalprodx1000st)/sum(totalmines)) %>% 
  mutate(year = ifelse(year < 23, paste0(20, year), paste0(19, year))) %>%
  pivot_wider(names_from = year, values_from = ratio) %>% 
  mutate(pct_diff = (`2020` - `1983`)/`1983`,
         sign = ifelse(pct_diff < 0, "neg", "pos")) %>% 
  ggplot(aes(x = msha_district_county, y = pct_diff, fill = sign)) +
  geom_bar(color = "black", stat = 'identity', width = .4) +
  geom_hline(color = "black", yintercept = 0, linetype = "dashed", size = 1) +
  # geom_text(aes(label = paste0(round(pct * 100, 3), "%")),
  #           position = position_dodge(width = 1),
  #           vjust = -.5,
  #           hjust = -.05,
  #           angle = 45,
  #           size = 3) +
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        plot.title = element_text(size = 20),
        legend.position="none",
        plot.subtitle = element_text(size = 14),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14)) +
  labs(y = "Change in Mining Productivity Ratio (1983 -2020)(%)",
       x = "MSHA District",
       title = 'On average, coal production per mine has increased from 1983 to 2020 in MSHA districts',
       subtitle = 'Mining Productivity Ratio: Total Coal Production (in short mines)/ Number of Coal Mines',
       fill = NULL) +
  scale_y_continuous(labels = scales::percent, limits = c(-.5, 3), n.breaks = 8, expand = c(0,0)) +
  scale_fill_manual(values = c('#013783', "#c3c6c9"))

