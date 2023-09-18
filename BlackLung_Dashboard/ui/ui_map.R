tab_map <- 
  tabItem(tabName = "map",
          
          titlePanel(p(style="text-align: center;", ("Explore the data with our interactive map"))),
          
          h4(p(style="text-align: center;", ("This tab helps you visualize the geographic aspects of the black lung dataset."))),
          
          br(),
          
          box(title = strong(("Search factors related to black lung")), status = "success", width = 12,
              
              
              fluidRow(
                
                column(4,
                       selectInput(
                         inputId = "factor",
                         label = strong(("Choose a Factor")),
                         choices = variables
                       )
                ),
                
                column(3,
                       uiOutput("radio_opts")
                ),
                
                column(3,
                       uiOutput("radio_opts2")
                ),
                
                column(2,
                       p(" ", style = "margin-bottom: 25px;"),
                       actionButton(inputId = "search_map",
                                    label = strong(("Explore")))
                )
              )
          ),
          
          fluidRow(
            column(12,
                   withSpinner(
                     leafletOutput(outputId = "map", height = 800), 
                     type = 4, color = "black"
                   )
            )),
          
          br(),
          
          fluidRow(
            column(12,
                   dataTableOutput(outputId = "region_data"))
          )
  )

