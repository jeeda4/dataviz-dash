library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(maps)
library(mapproj)
library(dplyr)
library(forcats)
library(tidyr)
library(shiny)
library(shinydashboard)
library(DT)


dashboardPage(
    dashboardHeader(title = "COVID'19 OUTBREAK"),
    dashboardSidebar(sidebarMenu(id = "sidebar",
                                 menuItem("Map", tabName = "map", icon = icon("map")), 
                                 menuItem("Plot", tabName = "plot", icon = icon("bar-chart-o")),
                                 conditionalPanel(condition="input.sidebar == 'map'", selectInput("dates", "Select a date:", choices=c(""))),
                                 conditionalPanel(condition="input.sidebar == 'map'", radioButtons("mapOptions", "Select an option:", c("Cases by county"= "cases", "Deaths by county"= "deaths"))),
                                 conditionalPanel(condition="input.sidebar == 'plot'", radioButtons("plotOptions", "Select an option:", c("All Florida cases"= "florida", "Cases by counties"= "county"))),
                                 conditionalPanel(condition = "input.plotOptions == 'county'", selectInput("counties", "Select counties:", choices=c(""), multiple = TRUE))
    )),
    dashboardBody(tabItems(
        tabItem(tabName = "map",
                fluidRow(box(width=8, status="warning", title= "Map of Counties", solidHeader = TRUE, plotOutput("mymap")),
                         box(width=4, status="warning", title = "Table of Counties", solidHeader = TRUE, collapsible = TRUE, DT::dataTableOutput("mytable")))),
        tabItem(tabName = "plot",
                fluidPage(box(width=10, status="warning", title= "Cases over Time", solidHeader = TRUE, plotOutput("mytimeseries")))),
        tabItem(tabName = "2", h2("Plot tab content"))
    ))
)






# sidebar <- dashboardSidebar(
#     sidebarMenu(id = "sidebar",
#         menuItem("Florida Map", tabName = "map", icon = icon("map")
#         ),
#         menuItem("Plot", tabName = "plot", icon = icon("bar-chart-o"))
#         
#     ),
#         conditionalPanel(condition="input.sidebar == 'map'", selectInput("dates", "Select a date:", choices = c("")))
#         
# )
# 
# body <- dashboardBody(
#     tabItems(
#         tabItem(tabName = "1",
#                 fluidRow(
#                     box(title = "COVID-19 Florida Map by County", plotOutput("mymap")),
#                     box(title = "Data Frame", status = "warning", solidHeader = TRUE,
#                         tableOutput("mydata")
#                         
#                     )
#                     
#                 )
#                 
#         ),
#         tabItem(tabName = "2", h2("Plot tab content"))
#     )
# )
# #     
# #      ##Boxes need to be put in a row (or column)
# #      fluidRow(
# #          
# #          box(width=6,
# #              status="warning",
# #              title = "Data Frame",
# #              solidHeader = TRUE,
# #              collapsible = TRUE,
# #              footer="Read Remotely from File",
# #              tableOutput("mydata")
# #              )
# #          ),
# #          ## Add some more info boxes
# #      fluidRow(
# #          valueBoxOutput(width=4, "nrows"),
# #          infoBoxOutput(width=6, "ncol")
# #          )
# # )
# # 
#  dashboardPage(
#      dashboardHeader(title = "COVID'19 OUTBREAK USA - FLORIDA"),
#      sidebar,
#      body
#  )