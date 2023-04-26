#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define server logic 
shinyServer(function(input, output) {
  
    source("server/server_home.R", local = TRUE)
    source("server/server_map.R", local = TRUE)

})
