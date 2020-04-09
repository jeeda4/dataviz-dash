library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(mapproj)
library(tidyverse)
library(maps)

dashboardPage(
    dashboardHeader(title = "COVID19 Outbreak"),
    dashboardSidebar(
        sliderInput("size", "Size of Points:", min=0.2, max=5, value=2)
    ),
    dashboardBody(
        # Boxes need to be put in a row (or column)
        fluidRow(
            box(width=6, 
                status="info", 
                title="Myplot",
                solidHeader = TRUE,
                plotOutput("myplot")
            ),
            box(width=6, 
                status="warning", 
                title = "Data Frame",
                solidHeader = TRUE, 
                collapsible = TRUE, 
                footer="Read Remotely from File",
                tableOutput("mydata")
            )
        ),
        ## Add some more info boxes
        fluidRow(
            valueBoxOutput(width=4, "nrows"),
            infoBoxOutput(width=6, "ncol")
        )
    )
)