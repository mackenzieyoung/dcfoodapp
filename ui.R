library(leaflet)
library(shiny)

vars <- c(
    "All" = 'all',
    "Grocery stores" = "grocery",
    "Farmers markets" = 'farmersmarket',
    "Healthy corner stores" = "corner",
    "Group meal centers" = 'groupmeal'
)

fluidPage(
    titlePanel("Map of food options for DC residents"),

    mainPanel(

                    leafletOutput("mymap1",height = 725),
                    absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                  draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                                  width = 300, height = "auto",
                                  h2("Map explorer"),
                                  selectInput("plot", "Show:", vars),
                                  radioButtons("radius", "Show locations within ____ miles:", c(.25,.5,1)),
                                  plotOutput("histWard", height = 200),
                                  plotOutput("histWard2", height = 200),
                                  tags$div(id="cite",
                                           'Data downloaded from DC.gov:'
                                  ),
                                  tags$a(href = 'http://opendata.dc.gov/datasets/', 'http://opendata.dc.gov/datasets/')
            ))

)

