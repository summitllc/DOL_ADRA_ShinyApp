tab_home <- tabItem(tabName = "home",
        
        titlePanel(p(style = "text-align: center;", ("Welcome to the Black Lung Dashboard"))),
        
        h4(p(style = "text-align: center;", ("This app is designed for you to interactively visualize black lung metrics throughout the United States."))),
        
        br(),
        
        # HTML(paste0(
        #   "<br>",
        #   "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='black_lung_cartoon.jpg' width = 300'></a>",
        #   "<br>"
        # )),
        
        fluidRow(
          valueBoxOutput("home1", width = 4),
          valueBoxOutput("home2", width = 4),
          valueBoxOutput("home3", width = 4)
        ),
        
        br(),
        br(),
        
        fluidRow(
          valueBoxOutput("home4", width = 4),
          valueBoxOutput("home5", width = 4),
          valueBoxOutput("home6", width = 4)
        ),
        
        br(),
        br(),
        
        fluidRow(
          valueBoxOutput("home7", width = 4),
          valueBoxOutput("home8", width = 4),
          valueBoxOutput("home9", width = 4)
        )
        
)
