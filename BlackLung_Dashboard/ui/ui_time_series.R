tab_time_series <- tabItem(tabName = "time_series",
                           
                           titlePanel(p(style="text-align: center;", ("Explore how Mining Factors have Changed over Time!"))),
                           
                           hr(),
                           
                           h4(p(style="text-align: center;", ("This tab helps you visualize the Black Lung Dataset to explore patterns across time."))),
                           
                           br(),
                           
                           fluidPage(
                           
                           box(title = strong(("How have things changed from 2001 to 2021?")), status = "success", width = 12,
                               
                             fluidRow(
                               
                               column(6,
                                      plotOutput(outputId = "surface_time", hover = hoverOpts("surface_time_hover")),
                                      uiOutput("hover_surface_time")
                               ),
                               
                               column(6,
                                      plotOutput(outputId = "under_time", hover = hoverOpts("under_time_hover")),
                                      uiOutput("hover_under_time")
                               )
                               
                             ),
                             
                             br(),
                             
                             fluidRow(
                               column(6,
                                      plotOutput(outputId = "total_mine_time", hover = hoverOpts("total_mine_time_hover")),
                                      uiOutput("hover_total_mine_time")
                               ),
                               
                               column(6,
                                      plotOutput(outputId = "total_prod_time", hover = hoverOpts("total_prod_time_hover")),
                                      uiOutput("hover_total_prod_time")
                               )
                             )
                           ),
                           
                           box(title = strong(("How have things changed from 1986 to 2020?")), status = "success", width = 12,
                               fluidRow(
                                 column(6,
                                        plotOutput(outputId = "total_employ_time", hover = hoverOpts("total_employ_time_hover")),
                                        uiOutput("hover_total_employ_time")
                                 ),
                                 
                                 column(6,
                                        plotOutput(outputId = "pct_employ_time", hover = hoverOpts("pct_employ_time_hover")),
                                        uiOutput("hover_pct_employ_time")
                                 )
                               )
                           )
                           ) # Fluid Page End
                           ) # End tab parenthesis 