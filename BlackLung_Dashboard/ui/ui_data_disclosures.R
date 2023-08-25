tab_data_disclosures <- tabItem(tabName = "data_disclosures",
                         
                         titlePanel(p(style="text-align: center;", ("Data Disclosures"))),
                         
                         h4(p(style="text-align: center;", ("This tab helps you understand the data sources, calculations, and modeling used to create this dashboard."))),
                         
                         br(),
                         
                         fluidRow(
                           column(12, align = "right",
                                  # htmlOutput(outputId = 'text_0'),
                                  downloadButton(outputId = "data_download", label = "Data Download",
                                                 style="color: #fff; background-color: #337ab7; border-color: #2e6da4"))
                         ),
                         
                         htmlOutput(outputId = "text_1"),
                         
                         # br(),
                         
                         fluidRow(
                           column(12,
                                  dataTableOutput(outputId = "sources"))
                         ),
                         
                         br(),
                         
                         htmlOutput(outputId = "text_2"),
                         
                         br(),
                         
                         htmlOutput(outputId = "text_3")
                         
)