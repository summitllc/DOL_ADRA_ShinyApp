output$home4 <- renderValueBox({
  valueBox(
    formatC('30+', format="d", big.mark=','),
    HTML(paste('Possible Mapping Metrics', br(), ' ')),
    icon = icon("map-marked-alt"),
    color = "black",
    width = 8)
})

output$home5 <- renderValueBox({
  valueBox(
    formatC(paste0(data %>% filter(any_cwp != 0) %>% count(), "/3145"), 
            format="d", big.mark=','),
    HTML(paste0("Counties with Black Lung Cases","<br>","from 1970 to 2014")),
    icon = icon('map-pin'),
    color = "black",
    width = 4)
})

output$home6 <- renderValueBox({
  valueBox(
    formatC(data %>% 
              filter(any_cwp != 0) %>% 
              group_by(state) %>% 
              count() %>% 
              ungroup() %>% 
              count() %>% 
              ungroup(), 
            format="d", big.mark=','),
    HTML(paste0("States with Black Lung Cases","<br>"," from 1970 to 2014")),
    icon = icon("flag-usa"),
    color = "black")
})

output$home1 <- renderValueBox({
  valueBox(
    formatC(sum(data$any_cwp), format="d", big.mark=','),
    HTML(paste0("Cummulative Black Lung Cases","<br>"," from 1970 to 2014")),
    icon = icon("lungs-virus"),
    color = "yellow")
})

output$home2 <- renderValueBox({
  valueBox(
    formatC(sum(data$total_black_lung_deaths), format="d", big.mark=','),
    HTML(paste0("Cummulative Black Lung Deaths", "<br>", "from 1999 to 2020")),
    icon = icon('lungs'),
    color = "yellow",
    width = 12)
})

output$home3 <- renderValueBox({
  valueBox(
    # Change
    formatC("-1576 (-75.7%)", format="s", big.mark=','),
    HTML(paste0("Change in number of coal-producing","<br>","mines from 1983 to 2020")),
    icon = icon('hard-hat'),
    color = "yellow")
})

output$home7 <- renderValueBox({
  valueBox(
    formatC(data %>% count(region_id) %>% count() %>% pull() -1, format="d", big.mark=','),
    paste(("Regions Represented")),
    icon = icon('mountain-city'),
    color = "navy")
})

output$home8 <- renderValueBox({
  valueBox(
    formatC(data %>% count(msha_district_county) %>% count() %>% pull() - 1, 
            format="d", big.mark=','),
    paste(('MSHA Districts Represented')),
    icon = icon('hard-hat'),
    color = "navy")
})


output$home9 <- renderValueBox({
  valueBox(
    formatC(('Link to Report'), format="d", big.mark=','),
    paste(('Coming soon...')),
    icon = icon('file-circle-check'),
    color = "navy",
    href='https://www.dol.gov/agencies/oasp/evaluation/about#:~:text=For%20questions%20about%20CEO%2C%20please,at%20ChiefEvaluationOffice%40dol.gov.')
})


