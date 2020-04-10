library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(maps)
library(mapproj)
library(dplyr)
library(forcats)
library(tidyr)
library(DT)



shinyServer(function(input, output, session) {
  
   # nytimes <- 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
   # coronaupdate <- reactiveFileReader(1000, session, nytimes, read_csv)
   # observe({updateSelectInput(session, "dates", label = "Select Date:", choices = unique(coronaupdate()[coronaupdate()$state=="Florida",]$date))})
   # observe({updateSelectInput(session, "counties", label = "Select counties::", choices = unique(coronaupdate()[coronaupdate()$state=="Florida",]$county))})
    
     corona <-  reactiveFileReader(
         intervalMillis = 10000,
         session = session,
         filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv',
         readFunc = read_csv)
     
     output$mydata <-renderTable({
       
       corona3 <- corona() %>% filter(state == "Florida") %>% group_by(county) %>% summarise(Cases=as.integer(sum(cases)), Deaths=as.integer(sum(deaths)))
       return(corona3)
     })
       
    #   coronaupdate<- coronaupdate()
    #   coronaupdate<- coronaupdate %>% filter(state == "Florida")
    #   if (input$mapOptions == "cases"){
    #     coronaupdate<- coronaupdate %>% filter(Date == input$dates) %>% select(County, Date, Cases) %>% arrange(desc(Cases)) %>% datatable(options = list(pageLength = 20)) %>% formatRound(columns = 'Cases', digits = 0)
    #   }
    #   return(coronaupdate)
    #   if (input$mapOptions == "deaths"){
    #     coronaupdate<- coronaupdate %>% filter(Date == input$dates) %>% select(County, Date, Deaths) %>% arrange(desc(Deaths)) %>% datatable(options = list(pageLength = 20)) %>% formatRound(columns = 'Deaths', digits = 0)
    #   }
    # })
       #corona3 <- corona() %>% filter(state == "Florida") %>% group_by(county) %>% summarise(Cases=as.integer(sum(cases)), Deaths=as.integer(sum(deaths)))
       #if (input$mapOptions == "deaths")
       #corona <- corona() %>% filter(date == input$dates & state == "florida") %>% select(county,date,cases) %>% arrange(desc(deaths))
       
       #if (input$mapOptions == "Cases")
       #corona <- corona %>% filter(Date == input$dates) %>% select(County,Date,Cases) %>% arrange(desc(Cases))
        #return(corona3)
     
    
     output$mymap <- renderPlot({
      
       counties <- map_data('county') %>% filter(region == 'florida')
       
       corona1 <- corona() %>% group_by(county) %>% summarise(Cases=sum(cases)) %>% mutate(County=tolower(county)) %>% mutate(County = fct_recode(County, `miami-dade` = "dade", `st johns` = "st. johns", `st lucie` = "st. lucie"))
       
       map <- left_join(corona1, counties, by=c("County"="subregion"))
       
       p<- ggplot(map, aes(x=long, y=lat, group=group, fill= Cases))+
         geom_polygon(color = 'black', size = 0.5) + theme_minimal() +
         scale_fill_viridis_c() +
         labs(fill="Number of Cases", x= 'Longitude', y='Latitude') +
         coord_map(projection = 'albers', lat0 = 25, lat1 = 31) + theme_minimal()
       return(p)
       })
     
     output$mytimeplot<- renderPlot({
       corona2 <- corona() %>% group_by(date) %>% summarize(sumcases=sum(cases)) %>% select(date,sumcases) 
         p <- ggplot(data = corona2, aes(x = date, y = sumcases)) + geom_line(aes(colour = "blue")) + geom_point(aes(colour = "black")) +
           theme_classic() + theme(legend.position = "none") +  scale_x_date(labels = date_format("%b-%d"), breaks='6 days') +
           labs(title = "COVID-19 Cases in Florida")
       return(p)
     })
})

