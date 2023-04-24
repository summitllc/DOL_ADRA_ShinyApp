output$home1 <- renderValueBox({
  valueBox(
    formatC('10+', format="d", big.mark=',')
    ,paste(("Map Visualizations"))
    ,icon = icon("map-marked-alt")
    ,color = "black"
    ,width = 8)
})

output$home2 <- renderValueBox({
  valueBox(
    formatC(nrow(data), format="d", big.mark=',')
    ,paste(("Counties Represented"))
    ,icon = icon('map-pin')
    ,color = "navy"
    ,width = 4)
})

output$home3 <- renderValueBox({
  valueBox(
    formatC(sum(data$total_black_lung_deaths), format="d", big.mark=',')
    ,paste(('Total Black Lung Deaths'))
    ,icon = icon('lungs')
    ,color = "yellow"
    ,width = 12)
})

output$home4 <- renderValueBox({
  valueBox(
    formatC(sum(data$any_cwp), format="d", big.mark=',')
    ,paste(("Total Black Lung Cases"))
    ,icon = icon("lungs-virus")
    ,color = "black")
})

output$home5 <- renderValueBox({
  valueBox(
    formatC(data %>% count(region_id) %>% count() %>% pull() -1, format="d", big.mark=',')
    ,paste(("Regions Represented"))
    ,icon = icon('mountain-city')
    ,color = "navy")
})

output$home6 <- renderValueBox({
  valueBox(
    formatC(data %>% count(msha_district_county) %>% count() %>% pull() - 1, format="d", big.mark=',')
    ,paste(('MSHA Districts Represented'))
    ,icon = icon('hard-hat')
    ,color = "yellow")
})

output$home7 <- renderValueBox({
  valueBox(
    formatC(data %>% filter(any_cwp != 0) %>% group_by(state) %>% count() %>% ungroup() %>% count() %>% ungroup(), format="d", big.mark=',')
    ,paste(("States with Black Lung Cases"))
    ,icon = icon("flag-usa")
    ,color = "black")
})

output$home8 <- renderValueBox({
  valueBox(
    formatC(sum(data$totalmines21), format="d", big.mark=',')
    ,paste(("Total Mines in 2021"))
    ,icon = icon('hard-hat')
    ,color = "navy")
})


output$home9 <- renderValueBox({
  valueBox(
    formatC(('Contact Us'), format="d", big.mark=','),
    paste(('For More Information')),
    icon = icon('address-book'),
    color = "yellow",
    href='https://www.dol.gov/general/contact')
})


