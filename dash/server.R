library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(mapproj)
library(tidyverse)
library(maps)

shinyServer(function(input, output, session) {
    
    df <- reactiveFileReader(
        intervalMillis = 10000, 
        session = session,
        filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv',
        readFunc = read_csv)
    
    output$mydata <-renderTable({df()})
    
    output$myplot <- renderPlot({
        df <- df()
        df$County <- df$County %>% tolower()
        county<- df
        county[county$County == 'dade',][1]<- 'miami-dade'
        county[county$County == 'st. johns',][1]<- 'st johns'
        county_cases <- county %>% select(County,Case) %>% group_by(County) %>% count()
        florida_data <- map_data('county') %>% filter(region == 'florida')
        map_data<- left_join(florida_data, county_cases, by = c(subregion = 'County'))
        
        p<- ggplot(map_data, aes(x = long, y = lat, group = group, fill = n)) +
            geom_polygon(color = 'black', size = 0.5) + #scale_fill_gradient(low = 'blue', high = 'red') +
            labs(fill = 'Number of Cases', x = 'Longitude', y = 'Latitude') +
            coord_map(projection = 'albers', lat0 = 25, lat1 = 31) + theme_minimal()
        return(p)
    })
    output$nrows <- renderValueBox({
        nr <- nrow(df())
        valueBox(
            value = nr,
            subtitle = "Number of Rows",
            icon = icon("table"),
            color = if (nr <=6) "yellow" else "aqua"
        )
    })
    
    output$ncol <- renderInfoBox({
        nc <- ncol(df())
        infoBox(
            value = nc,
            title = "Colums",
            icon = icon("list"),
            color = "purple",
            fill=TRUE)
    })
    
})