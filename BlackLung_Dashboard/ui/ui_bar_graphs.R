
tab_bar_graphs <- 
  tabItem(tabName = "bar_graphs",
          
          titlePanel(p(style="text-align: center;", ("Explore the MSHA mining Districts"))),
          
          br(),
          
          fluidPage(
            
            box(title = strong("Below we compare black lung prevalence and mining 
                               efficiency in MSHA districts. 
                               At the time of data collection, DOL 
                               MSHA's Mine Dataset utilizes C&M 
                               districting information."), 
                status = "success", width = 12,
                
                fluidRow(
                  column(12,
                         plotOutput(outputId = "surface_time")
                  )
                ),
                
                br(),
                
                fluidRow(
                  column(12,
                         plotOutput(outputId = "total_mine_time")
                  )
                ),
                
                fluidRow(
                  column(12, 
                         plotOutput(outputId = "total_employ_time"))
                )
            )
          ) 
  ) # End tab parenthesis 