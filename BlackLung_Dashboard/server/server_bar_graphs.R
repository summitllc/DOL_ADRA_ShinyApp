
output$surface_time <- renderPlot({
  p1
})

output$total_mine_time <- renderPlot({
  p3
})

output$total_employ_time <- renderPlot({
  p4
})

# NEW GRAPHS as of 7/27
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
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        legend.position="bottom",
        plot.title = element_text(size = 20),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(y = "Percent of Coal Miner's Pneumoconiosis",
       x = "MSHA District",
       title = "Percent of Coal Miner's Pneumoconiosis by MHSA District",
       fill = NULL) +
  scale_y_continuous(labels = scales::percent, limits =c(0,.008), expand = c(0,0)) +
  scale_fill_manual(values = c('#fda85e', '#fa234b'))

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
       title = 'Total Coal Production per Mine by MHSA District in 1983 and 2020',
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
  theme_bw() +
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        plot.title = element_text(size = 20),
        legend.position="none",
        plot.subtitle = element_text(size = 14),
        legend.text = element_text(size = 16),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 16)) +
  labs(y = "Percent Change in Mining Productivity Ratio",
       x = "MSHA District",
       title = 'Percent Change in Mining Productivity from 1983 to 2020 by MSHA District',
       subtitle = 'Mining Productivity Ratio: Total Coal Production (in thousands of short tons) / Number of Coal Mines',
       fill = NULL) +
  scale_y_continuous(labels = scales::percent, limits = c(-.5, 3), n.breaks = 8, expand = c(0,0)) +
  scale_fill_manual(values = c('#013783', "#c3c6c9"))

