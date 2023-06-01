tab_data_dict <- tabItem(tabName = "data_dict",
                         
                         titlePanel(p(style="text-align: center;", ("Welcome to our data dictionary!"))),
                         
                         hr(),
                         
                         h4(p(style="text-align: center;", ("This tab helps you understand the factors and matrics of the black lung dataset."))),
                         
                         br(),
                         
                         dataTableOutput("data_dict_table")
                         
                         )

