output$data_download <- downloadHandler(
  
  filename = function() {
    paste("blacklung_dataset", "xlsx", sep=".")
  },
  content = function(file) {
    
    file.copy('black lung analytic dataset FOR MAP.xlsx', file,overwrite = TRUE)
  },
  contentType = "text/xlsx"
)

# output$text_0 <- renderText({
#   paste0("<b>Download our data here:</b>")
# })

output$text_1 <- renderText({
  paste0("<b>Data Sources</b>", "<br>", "Data for this application is derived from a 
         series of publicly available sources including the U.S. Census, U.S. 
         Energy Information Administration (EIA), Department of Labor Mine 
         Safety & Health Administration (DOL MSHA), and Center for Disease 
         Control (CDC). The table below provides the title, description, 
         study period, relevant data point(s), and location of each data 
         source.")
})


output$sources <- renderDataTable({
 datatable(data_sources,
           caption = HTML(paste0("*Indicates the earliest available data.", "<br>", "^Indicates the most currently available data at the time of collection.")),
           escape = FALSE,
           options = list(dom = 't'),
           selection = 'none')
})

output$text_2 <- renderText({
  paste0("<b>Data Limitations</b>", "<br>", 
  "<ol>
  <li><em>Black lung diagnostic codes</em>: The term “black lung” is somewhat ambiguous as it is not explicitly tied to a medical diagnosis code. Therefore, black lung cases and deaths are measured using different diagnosis codes within the data collected by federal programs. Black lung cases are recorded according to the ICD-10 diagnosis code J60, coal workers’ pneumoconiosis (CWP). Black lung deaths, on the other hand, are measured according to a more expansive list of ICD-10 codes which includes CWP, silicosis, asbestosis, Berylliosis, and other unspecified pneumoconiosis (J60, J61, J62, J62.8, J63.2, J64). Because of these distinct definitions, metrics for black lung cases and deaths are reported separate from one another.</li>
  <li><em>Measuring black lung</em>: There are several federal programs that aim to measure black lung prevalence across the United States. Diagnosis of respiratory disease due to coal mine dust exposure requires respiratory symptoms, medical tests such as lung imaging and pulmonary function testing, and a detailed history of exposure. Because the symptoms and respiratory illnesses caused by exposure to coal dust can easily resemble other respiratory illnesses, the only way to conclusively pinpoint the cause to coal dust is through a well-documented history of exposure or through autopsies.</li>
  <li><em>Time frames</em>: Black lung case and death statistics were collected by different entities and across different time periods. This makes it difficult to compare the cases and deaths. Therefore, each metric is analyzed separately. Furthermore, when black lung cases and deaths are reported per 1000 residents, the result is based upon the population in the final year of the data collection period. Black lung cases per 1000 residents are reported according to 2014 population estimates; black lung deaths per 1000 residents are reported according to 2020 population.</li>
  <li><em>Black lung cases and death metrics “per 1000 residents”</em> are measured according to the final year of the data collection period:</li>
    <ol type='a'> 
      <li>Cumulative Black Lung Cases (1970-2014) compares the total number of black lung cases across the time period to the population in 2014.</li>
      <li>Cumulative Black Lung Deaths (1999-2020) compares the total number of black lung deaths across the time period to the population in 2020.</li>
    </ol>
    Meanwhile, data from Census, CDC, EIA, and MSHA are all collected over different periods with irregular periods of collection. The team could not construct a panel dataset for this analysis without exceeding the time and budget constraints of the project. Therefore, the team used discrete points in time (i.e., years) to approximate past/present time periods in the data. This is especially relevant in the classification of “current” and “former” coal counties, which are discussed below.
  </li>
  <li><em>Data Suppression</em>: Black lung case data are collected by CDC’s Enhanced Coal Workers’ Health Surveillance Program (ECWHSP). ECWHSP does not list data for districts, states, or counties with less than 10 examined miners to protect individual privacy. This means that counties with nine or fewer black lung cases show up in the data as zero cases, which is a form of data suppression. This practice makes it impossible to identify counties with less than 10 black lung cases, making the data more difficult to interpret. </li>
  <li><em>Data Underreporting</em>: In addition to data suppression, research suggests that counties defined as the Navajo Nation likely have a number of underreported black lung cases. Members of the Navajo Nation may have undiagnosed cases of black lung or choose not to participate in federally sponsored programs. While this underreporting is difficult to quantify, the researchers believe that there are more black lung cases and deaths than appear in the data. To help estimate this potential undercounting, the research team used a regression model to estimate the number of black lung cases and deaths in each county.</li>
</ol>")
})

output$text_3 <- renderText({
  paste0("<b>Outputs from research</b>", "<br>", 
         "<ol>
  <li><em>Coal counties</em>: Coal counties are defined according to the following four parameters: (1) the number of coal mines in the county, (2) the amount of coal produced measured in short tons, (3) the number of coal miners, and (4) the total weekly exposure hours for workers in coal mines.</li>
    <ol type='a'>
      <li>Indicator: A county is categorized as a coal county if any of the four criteria above are met across time. For example, a county with 1 or more active coal mines in 1983 is considered a coal county. This definition is designed to capture as many relevant counties as possible without being overly stringent.</li>
      <li>Scale: Coal counties are further classified beyond “Yes/No” indicators. Summit also classified each county’s coal level on a sliding scale according to percentiles within each parameter. The scale includes the titles “no coal” (0 mines, production, etc.), “very low” (1-24%), “low” (25-49%), “medium” (50-74%), “high” (75-89%), and “very high” (over 90%). </li>
      <li>Current/Former: Coal counties are defined as current or former according to the recency of each relevant data point. While the broader term leverages any point in time to define a coal county, this drilled-down identifier looks at each relevant data point’s time period to categorize counties on a historical coal basis. For example, counties producing coal in 2020 are considered “current” coal counties, while those with coal production in 1983 but not 2020 are considered “former” coal counties.</li>
    </ol>
  </li>
  <li><em>Regression-estimated results</em>:</li>
    <ol type='a'>
      <li>Methodology: The researchers designed a series of statistical models using this dataset to estimate the number of black lung cases/deaths within each county during the respective time period. The purpose of this exercise is to estimate how many cases/deaths occurred in each county using strictly empirical data. The models were also used to help the research team better understand the potential amount of underreporting that occurred within the Navajo Nation.</li>
      <li>Interpretations: These statistical models were designed for preliminary estimates only. Each model was constructed using the same publicly available data as was used for other quantitative analyses and therefore is subject to the same constraints and limitations outlined above.</li>
    </ol>
</ol>")
})
