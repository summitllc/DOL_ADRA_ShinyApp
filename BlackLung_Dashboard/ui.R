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

# Sourced Files 
source("ui/home.R")
source("ui/map.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  dashboardPage(skin = "black",
                dashboardHeader(title = " "),
                
                dashboardSidebar(
                  sidebarMenu(
                    HTML(paste0(
                      "<br>",
                      "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='Seal_of_the_United_States_Department_of_Labor.png' width = '186'></a>",
                      "<br>",
                      "<p style = 'text-align: center;'><small>Brought to you by</small></p>",
                      "<p style = 'text-align: center;'><small>The United States Department of Labor</small></p>",
                      "<br>"
                    )),
                    
                    menuItem(("Home"), tabName = "home", icon = icon("home")),
                    menuItem("Interactive Map", tabName = "map", icon = icon("globe-americas")),
                    
                    tags$style("
                              .copyright {
                                font-size: 12px;
                                color: #878787;
                                padding: 10px;
                                position: absolute;
                                bottom: 0;
                                left: 50%;
                                transform: translateX(-50%);
                              }"
                    ),
                    
                    div(class = "copyright", HTML("&copy; 2023 Summit Consulting, LLC"))
                  )
                ),
                
                dashboardBody(
                  tags$style(".small-box.bg-black { background-color: #fa234b !important; }"),
                  tags$style(".small-box.bg-navy { background-color: #013783 !important; }"),
                  tags$style(".small-box.bg-yellow { background-color: #fda85e !important; }"),
                  tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);"),
                  tabItems(tab_home, tab_map)
                )
                
                
                )
  
))
