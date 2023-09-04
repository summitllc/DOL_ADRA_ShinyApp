#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Packages 
library(shiny)
library(shinydashboard)
library(shinycssloaders)

# Sourced Files 
source("ui/ui_home.R")
source("ui/ui_map.R")
source("ui/ui_bar_graphs.R")
source("ui/ui_data_dict.R")
source("ui/ui_data_disclosures.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "summit.css")
  # ),
  
  dashboardPage(skin = "black",
                dashboardHeader(disable = T), #title = " "),
                title="Black Lung Dashboard",
              
      
                dashboardSidebar(
                  sidebarMenu(
                    # style = "position: fixed; overflow: visible;",
                    
                    HTML(paste0(
                      "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='Seal_of_the_United_States_Department_of_Labor.png' width = '186'></a>",
                      "<br>",
                      "<p style = 'text-align: center;'><small>Brought to you by</small></p>",
                      "<p style = 'text-align: center;'><small>The U.S. Department of Labor</small></p>",
                      "<br>"
                    )),
                    
                    menuItem(HTML("&nbsp;Home"), tabName = "home", icon = icon("home")),
                    menuItem(HTML("&nbsp;Interactive Map"), tabName = "map", icon = icon("globe-americas")),
                    menuItem(HTML("&nbsp;Additional Graphs"), tabName = "bar_graphs", icon = icon("clock")),
                    menuItem(HTML("&nbsp;Data Dictionary"), tabName = "data_dict", icon = icon("book")),
                    menuItem(HTML("&nbsp;Data Disclosures"), tabName = "data_disclosures", icon = icon("table")),
                    
                    
                    
                    
                    tags$style("
                              .copyright {
                                font-size: 12px;
                                color: white;
                                padding: 10px;
                                position: absolute;
                                bottom: 0;
                                left: 50%;
                                transform: translateX(-50%);
                              }"
                    ),
                    
                    tags$style(HTML(
                      ".sidebar-open .main-footer {
                                      background-color: green;
                                      color: white;
                                    }
                                    .sidebar-open .main-footer a {
                                      color: white;
                                    }"
                    )),
                    
                    tags$style("
                               .main-sidebar {
                                position: fixed;
                                overflow: visible;
                              }"),
                    
                    # tags$style(".fa-map-location-dot {color: white}
                    #             .fa-map-pin {color: white}
                    #             .fa-lungs {color: white}
                    #             .fa-lungs-virus {color: white}
                    #             .fa-mountain-city {color: white}
                    #             .fa-helmet-safety {color: white}
                    #             .fa-flag-usa {color: white}
                    #             .fa-address-book {color: white}"),
                    
                    tags$style(
                     '.custom {
                        color: red;
                      }'
                    ),
                    
                    div(class = "copyright", HTML("&copy; 2023 Summit Consulting, LLC"))
                  )
                ),
                
                dashboardBody(
                  tags$style(".small-box.bg-black { background-color: #013783 !important; }"),
                  tags$style(".small-box.bg-navy { background-color: #fa234b !important; }"),
                  tags$style(".small-box.bg-yellow { background-color: #fda85e !important; }"),
                  tags$style(".small-box .icon-large { color: white !important; }"),#font-size: 55px; bottom: 15px; right: 6px;}"),
                  tags$style(".small-box p { font-size: 1.1vw; position: relative; bottom: 10px;}"),
                  tags$style(".small-box h3 { font-size: 2.3vw; }"),
                  # tags$style(".small { font-size: 100%; }"),
                  tags$style(".sidebar-menu { font-size: 18px; }"),
                  tags$style(".datatables caption { caption-side: bottom; }"),
                  tags$style(".shiny-text-output { font-size: 28px; }"),
                  tags$style(".leaflet-control-container { z-index: 5; }"),
                  tags$style(".leaflet-top { z-index: 5; }"),
                  tags$style(".selectize-control { z-index: 20; }"),
                  tags$style(".leaflet-popup-content { width: 325px; }"),
                  tags$style(".small-box {height: 120px; }"),
                  # tags$style(".map-title {font-size: 25px;}"),
                  tags$style(".left-side, .main-sidebar { width: 250px; padding-top: 20px;}"),
                  tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);"),
                  tabItems(tab_home, tab_map, tab_bar_graphs, tab_data_dict, tab_data_disclosures)
                )
                
                
                )
  
))
