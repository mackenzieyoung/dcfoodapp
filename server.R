library(leaflet)
library(RColorBrewer)
library(dplyr)
library(shiny)
library(geosphere)

pal <- colorFactor(c("navy", "gold", "darkgreen", "red"), 
                   domain = c("grocery", "farmersmarket", "corner", "groupmeal"))

function(input,output, session){
    
    data1 <- reactive({
        x <- dat
    })
    
    output$mymap1 <- renderLeaflet({
        dat <- data1()
        plotBy <- input$plot
        marketAccept <- input$accept
        m1 <- leaflet(data = dat) %>%
            addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                     attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>% 
            addCircleMarkers(lng = dat$X,
                             lat = dat$Y,
                             popup = dat$NAME, radius = 5, color = ~pal(dat$TYPE)) %>%
            addLegend("bottomleft", colors = c("darkgreen", "gold", "navy", "red"),
                      labels = c("Grocery store", "Farmers market", "Corner store", "Group meal"),
                      opacity = .7) %>%
            setView(lat = 38.892326, lng = -77.036141, zoom = 12)
        m1
    })
    
    observeEvent(input$plot, {
        plotBy <- input$plot
        marketAccept <- input$accept
        proxy <- leafletProxy("mymap1", data = dat)
        if (plotBy != 'all') {
            proxy %>% clearMarkers() %>% 
                addCircleMarkers(lng = subset(dat, TYPE==plotBy)$X,
                                 lat = subset(dat, TYPE==plotBy)$Y,
                                 popup = subset(dat, TYPE==plotBy)$NAME, radius = 5, color = ~pal(plotBy))
        }
    })
    
    output$histWard <- renderPlot({
        barplot(byward$count, main = "Count of grocery stores by ward", 
                col='palegreen4', names.arg=c("1", '2', '3', '4', '5', '6', '7', '8'), 
                xlab='Ward', ylab='Count')
    })
    
    output$histWard2 <- renderPlot({
        barplot(byward2$count, main = "Count of group meal centers by ward", 
                col='tomato2', names.arg=c("1", '2', '3', '4', '5', '6', '7', '8'), 
                xlab='Ward', ylab='Count')
    })
    
    observeEvent(input$mymap1_click, { # update the location selectInput on map clicks
        p <- input$mymap1_click
        rad <- input$radius
        plotBy <- input$plot
        proxy <- leafletProxy("mymap1", data = dat)
        for (i in 1:nrow(dat)) {
            dat$location[i] <- distGeo(c(p$lng,p$lat),c(dat[,1][[i]],dat[,2][[i]]))*0.000621371192
        }
        if (plotBy == 'all') {
            proxy %>% clearMarkers() %>% 
                addCircleMarkers(lng = subset(dat, location <= rad)$X,
                                 lat = subset(dat, location <= rad)$Y,
                                 popup = subset(dat, location <= rad)$NAME, radius = 5, color = ~pal(subset(dat, location <= rad)$TYPE))
        }
        else {
            proxy %>% clearMarkers() %>% 
                addCircleMarkers(lng = subset(dat, TYPE==plotBy & location <= rad)$X,
                                 lat = subset(dat, TYPE==plotBy & location <= rad)$Y,
                                 popup = subset(dat, TYPE==plotBy & location <= rad)$NAME, radius = 5, color = ~pal(plotBy))
        }
        
    })
    
    session$onSessionEnded(function() {
        stopApp()
    })
}

