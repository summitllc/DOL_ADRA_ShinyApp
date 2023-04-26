tab_map <- tabItem(tabName = "map",
                   
                   titlePanel(p(style="text-align: center;", ("Explore the data with our Interactive Map!"))),
                   
                   hr(),
                   
                   h4(p(style="text-align: center;", ("This tab helps you visualize the Black Lung Dataset to explore patterns and geospatial patterns."))),
                   
                   br(),
                   
                   box(title = strong(("Search Factors related to Black Lung")), status = "success", width = 12,
                       
                       
                       fluidRow(
                         
                         column(4,
                                selectInput(
                                  inputId = "factor",
                                  label = ("Choose a Factor"),
                                  choices = variables
                                  # choices = colnames(map_data)[map_data %>% colnames() %>% str_detect("per1000|pct|percent|tot")]
                                )),
                         
                         column(2,
                                br(),
                                actionButton(inputId = "search_map",
                                             label = strong(("Explore!")))
                         )
                       )
                       
                   ),
                   
                   fluidRow(
                     column(12,
                            leafletOutput(outputId = "map", height = 800)
                            )),
                   
                   br(),
                   
                   fluidRow(
                     column(12,
                            dataTableOutput(outputId = "region_data"))
                     # column(6,
                     #        dataTableOutput(outputId = "state_data"))
                   ),
                   
                   br(),
                   
                   fluidRow(
                     column(6,
                            plotOutput(outputId = "incid_plot")),
                     column(6,
                            plotOutput(outputId = "death_plot")))
                   
                  
        
)