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
  
   nytimes <- 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'
   coronaupdate <- reactiveFileReader(1000, session, nytimes, read_csv)
   observe({updateSelectInput(session, "dates", label = "Select Date:", choices = unique(coronaupdate()[coronaupdate()$state=="Florida",]$date))})
   observe({updateSelectInput(session, "counties", label = "Select counties::", choices = unique(coronaupdate()[coronaupdate()$state=="Florida",]$county))})
    
     corona <-  reactiveFileReader(
         intervalMillis = 10000,
         session = session,
         filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv',
         readFunc = read_csv)
     
     #corona <- corona %>% filter(state=="florida")

    # datalabels <- as.character(unique(corona$date))
    # updateSelectInput(session, "dates", choices = datalabels)
    
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
    #   coronaupdate<- coronaupdate()
    #   coronaupdate<- coronaupdate %>% filter(state == "Florida")
    #   colnames(coronaupdate)<- c("Date", "County", "State", "Fips", "Cases", "Deaths")
    #   for (i in 1:nrow(coronaupdate)){
    #     coronaupdate[i,2]<- tolower(coronaupdate[i,2])
    #   }
    #   if (input$mapOptions == "deaths"){
    #     coronaupdate<- coronaupdate %>% filter(is.na(County) == FALSE & Date == input$dates)
    #     counties<- coronaupdate
    #     counties<- counties %>% filter(County != "unknown")
    #     counties[counties$County == "dade",][2]<- "miami-dade"
    #     counties[counties$County == "st. johns",][2]<- "st johns"
    #     counties[counties$County == "st. lucie",][2]<- "st lucie"
    #     counties[counties$County == "desoto",][2]<- "de soto"
    #     florida_data <- map_data("county") %>% filter(region == "florida")
    #     map_data<- florida_data %>% left_join(counties, by = c("subregion" = "County"))
    #     map_data$Cases[is.na(map_data$Cases)]<- 0
    #     map_data$Deaths[is.na(map_data$Deaths)]<- 0
    #     
    #     p<- ggplot(map_data, aes(x = long, y = lat, group = group, fill = Cases)) + 
    #       geom_polygon(color = "black", size = 0.5) + scale_fill_viridis_c() + 
    #       labs(fill = "Cases", x = "Longitude", y = "Latitude") + 
    #       coord_map(projection = "albers", lat0 = 25, lat1 = 31) + theme_minimal()
    #   }
    #   
    #   if (input$mapOptions == "cases"){
    #     coronaupdate<- coronaupdate %>% filter(is.na(County) == FALSE & Date == input$dates)
    #     counties<- coronaupdate
    #     counties<- counties %>% filter(County != "unknown")
    #     counties[counties$County == "dade",][2]<- "miami-dade"
    #     counties[counties$County == "st. johns",][2]<- "st johns"
    #     counties[counties$County == "st. lucie",][2]<- "st lucie"
    #     counties[counties$County == "desoto",][2]<- "de soto"
    #     florida_data <- map_data("county") %>% filter(region == "florida")
    #     map_data<- florida_data %>% left_join(counties, by = c("subregion" = "County"))
    #     map_data$Cases[is.na(map_data$Cases)]<- 0
    #     map_data$Deaths[is.na(map_data$Deaths)]<- 0
    #     
    #     p<- ggplot(map_data, aes(x = long, y = lat, group = group, fill = Cases)) + 
    #       geom_polygon(color = "black", size = 0.5) + scale_fill_viridis_c() + 
    #       labs(fill = "Cases", x = "Longitude", y = "Latitude") + 
    #       coord_map(projection = "albers", lat0 = 25, lat1 = 31) + theme_minimal()
    #   }
    #   return(p)
    # })
    
       #corona() <- corona() %>% filter((Date == input$dates))
      
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
     
     output$timeplot<- renderPlot({
       #corona<- corona()
       corona<- corona %>% filter(state == "Florida")
       #colnames(df)<- c("Date", "County", "State", "Fips", "Cases", "Deaths")
       if (input$plotOptions == "florida"){
         florida_df<- corona %>% group_by(Date) %>% summarise(Cases = sum(Cases))
         p<- florida_df %>% ggplot(aes(x = Date, y = Cases)) + geom_line(aes(colour = "red")) + geom_point(aes(colour = "red")) +
           theme_classic() + theme(legend.position = "none") +  scale_x_date(labels = date_format("%b-%d"), breaks='6 days') +
           labs(title = "COVID-19 Cases in Florida Since March")
       }
       if (input$plotOptions == "county") {
         x<- input$counties
         county_df<- corona %>% filter(County %in% x) %>% group_by(County, Date) %>% summarise(Cases = sum(Cases))
         p<- county_df %>% ggplot(aes(x = Date, y = Cases)) + geom_line(aes(colour = County)) + geom_point(aes(colour = County)) + 
           theme_classic() +  scale_x_date(labels = date_format("%b-%d"), breaks='6 days') + labs(title = "COVID-19 Cases by County Since March")
       }
       return(p)
     })
})

       
    # })
 #})
    
      # df <- reactiveFileReader(intervalMillis = 10000, session = session, filePath = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv', readFunc = read_csv)
      #        df <- df()
      #        df$counties <- df$counties %>% tolower()
      #        counties<- df
      #        counties[counties$county == 'dade',][1]<- 'miami-dade'
      #        counties[counties$county == 'st. johns',][1]<- 'st johns'
      #        county_cases <- counties %>% select(county,cases) %>% group_by(county) %>% count()
      #        florida_data <- map_data('county') %>% filter(region == 'florida')
      #        map_data<- left_join(florida_data, county_cases, by = c(subregion = 'county'))
      #        
      #        p<- ggplot(map_data, aes(x = long, y = lat, group = group, fill = n)) +
      #            geom_polygon(color = 'black', size = 0.5) +
      #            #scale_fill_gradient(low = 'blue', high = 'red')
      #            labs(fill = 'Number of Cases', x = 'Longitude', y = 'Latitude') +
      #            coord_map(projection = 'albers', lat0 = 25, lat1 = 31) + theme_minimal()
      #        return(p)
      #    })
      # 
 # output$nrows <- renderValueBox({
 #         nr <- nrow(df())
 #         valueBox(
 #             value = nr,
 #             subtitle = "Number of Rows",
 #             icon = icon("table"),
 #             color = if (nr <=6) "yellow" else "aqua"
 #         )
 #     })
 #     
 #     output$ncol <- renderInfoBox({
 #         nc <- ncol(df())
 #         infoBox(
 #             value = nc,
 #             title = "Colums",
 #             icon = icon("list"),             color = "purple",             fill=TRUE)
 #      })
     
##})



