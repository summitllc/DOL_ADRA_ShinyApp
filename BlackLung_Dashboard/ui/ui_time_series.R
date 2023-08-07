library(billboarder)

tab_time_series <- tabItem(tabName = "time_series",
                           
                           titlePanel(p(style="text-align: center;", ("Explore the MSHA mining Districts"))),
                           
                           hr(),
                           
                           # h4(p(style="text-align: center;", ("This tab helps you visualize how mining districts differ."))),
                           # 
                           br(),
                           
                           fluidPage(
                           
                           box(title = strong(("Below we compare black lung prevalence and mining efficiency in MSHA districts:")), status = "success", width = 12,
                               
                             fluidRow(
                               
                               column(12,
                                      # billboarderOutput(outputId = "surface_time")
                                      plotOutput(outputId = "surface_time")#, hover = hoverOpts("surface_time_hover")),
                                      #uiOutput("hover_surface_time")
                               )
                               
                               # column(6,
                               #        billboarderOutput(outputId = "under_time")#, hover = hoverOpts("under_time_hover")),
                               #        #uiOutput("hover_under_time")
                               # )
                               
                             ),
                             
                             br(),
                             
                             fluidRow(
                               column(12,
                                      # billboarderOutput(outputId = "total_mine_time")
                                      plotOutput(outputId = "total_mine_time")#, hover = hoverOpts("surface_time_hover")),
                                      #uiOutput("hover_total_mine_time")
                               )
                               
                               # column(6,
                               #        billboarderOutput(outputId = "total_prod_time")#, hover = hoverOpts("total_prod_time_hover")),
                               #        #uiOutput("hover_total_prod_time")
                               # )
                             ),
                             
                             fluidRow(
                               column(12, 
                                      plotOutput(outputId = "total_employ_time"))
                             )
                           )
                           
                           # box(title = strong(("How have the number and perentage of coal miners changed from 1986 to 2020?")), status = "success", width = 12,
                           #     fluidRow(
                           #       column(6,
                           #              plotOutput(outputId = "total_employ_time", hover = hoverOpts("total_employ_time_hover")),
                           #              uiOutput("hover_total_employ_time")
                           #       ),
                           #       
                           #       column(6,
                           #              plotOutput(outputId = "pct_employ_time", hover = hoverOpts("pct_employ_time_hover")),
                           #              uiOutput("hover_pct_employ_time")
                           #       )
                           #     )
                           # )
                           ) # Fluid Page End
                           ) # End tab parenthesis 