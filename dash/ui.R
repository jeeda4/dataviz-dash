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
                         box(width=4, status="warning", title = "Table of Counties", solidHeader = TRUE, collapsible = TRUE, tableOutput("mydata")))),
        tabItem(tabName = "plot",
                fluidPage(box(width=10, status="warning", title= "Cases over Time", solidHeader = TRUE, plotOutput("mytimeplot"))))
    ))
)




