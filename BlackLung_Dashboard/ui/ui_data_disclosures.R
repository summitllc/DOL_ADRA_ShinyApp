tab_data_disclosures <- tabItem(tabName = "data_disclosures",
                         
                         titlePanel(p(style="text-align: center;", ("Data Disclosures"))),
                         
                         h4(p(style="text-align: center;", ("This tab helps you understand the data sources, calculations, and modeling used to create this dashboard."))),
                         
                         br(),
                         
                         downloadButton(outputId = "data_download", label = "Data Download"),
                         
                         textOutput(outputId = "text")
                         
)