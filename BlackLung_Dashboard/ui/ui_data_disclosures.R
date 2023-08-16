tab_data_disclosures <- tabItem(tabName = "data_disclosures",
                         
                         titlePanel(p(style="text-align: center;", ("Data Disclosures"))),
                         
                         hr(),
                         
                         h4(p(style="text-align: center;", ("This tab helps you understand the data sources, calculations, and modeling used to create this dashboard."))),
                         
                         br(),
                         
                         textOutput(outputId = "text")
                         
)