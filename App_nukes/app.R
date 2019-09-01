# Shiny 
library(tidyverse)
library(lubridate)
library(leaflet)
library(readr)
library(htmltools)
library(htmlwidgets)
library(shiny)

# Load Data
nuclear_explosions <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-20/nuclear_explosions.csv")

# Clean data and select focus variables
# remove NA and 0 values in yield_upper
nukes <- nuclear_explosions 

nukes <- nukes %>% 
        filter(!is.na(yield_upper)) %>% 
        filter(yield_upper > 0) %>% 
        filter(country != "PAKIST") 

nukes$date <- ymd(nukes$date_long)

nukes <- nukes %>% 
        select(year, latitude, longitude, yield_upper, country, 
               purpose, date) 

country_choose <- "ALL"  %>% 
        append(unique(nukes$country))


# Create colours based on 1st quartile, mean, and above
getColor <- function(nukes) {
        sapply(nukes$yield_upper, function(yield_upper) {
                if(yield_upper <= 20) {
                        "green"
                } else if(yield_upper <= 330) {
                        "orange"
                } else {
                        "red"
                } })
}

icons <- awesomeIcons(
        icon = 'fa-radiation-alt',
        iconColor = 'black',
        library = 'fa',
        markerColor = getColor(nukes)
)

# User Interface
ui <- fluidPage(
        titlePanel("Nuclear Explosions Data #TidyTuesday"),
        
        sidebarPanel(
                tags$h5("Nuclear Explosions Dataset"),
                tags$p("This dataset explores nuclear explosions between 1945
                  and 1998. The records in this visualisation are from the
                  nuclear explosions dataset used for #TidyTuesday on
                  20th August 2019. Records for Pakistan, and those 
                  where yield_upper was NA or 0 have been excluded."),

                selectInput("country", "Choose country:", country_choose),
                tags$br(),
                tags$h6("Purpose of Detonation - definitions"),
                tags$ul(tags$li("COMBAT (WWII bombs dropped over Japan)"),
                        tags$li("FMS (Soviet test, study phenomenon of nuclear explosion)"),
                        tags$li("ME (Military Exercise)"),
                        tags$li("PNE (Peaceful nuclear explosion)"),
                        tags$li("SAM (Soviet test, accidental mode/emergency)"),
                        tags$li("SSE (French/US tests - testing safety of nuclear weapons in case of accident)"),
                        tags$li("TRANSP (Transportation-storage purposes)"),
                        tags$li("WE (British, French, US, evaluate effects of nuclear detonation on various targets)"),
                        tags$li("WR (Weapons development program)")
                    
                     )),
        
        mainPanel(
                tags$h4("Locations of Nuclear Explosions"),
                leafletOutput("mymap", height = 300),
                tags$br(),
                tags$h4("Number of Nuclear Explosions by Year"),
                plotOutput(outputId = "hist", height = 200)))
                
        

# Server
server <- function(input,output, session){
        
        selectedData <- reactive({
                if(input$country == "ALL"){
                        nukes2 <- nukes 
                        
                } else{
                nukes2 <- nukes %>% 
                        filter(country == input$country) 
                }
        })
        
        output$mymap <- renderLeaflet({
                df <- selectedData()
                
                m <- leaflet(data = df) %>%
                        addTiles() %>%
                        # setView(lng = 2.34, lat = 48.85, zoom = 1)
                        addProviderTiles(providers$OpenMapSurfer) %>% 
                        addAwesomeMarkers(~longitude, ~latitude, icon=icons,
                                          label= ~as.character(paste( "Date: ", date,
                                                                      "Country: ", country, 
                                                                      "Upper Yield: ", yield_upper, 
                                                                      "Purpose: ", purpose)), 
                                          clusterOptions = markerClusterOptions()) %>%
                        addMiniMap(toggleDisplay = TRUE,
                                   position = "topright") 
                
                m
        })
        
        output$hist <- renderPlot({
                df <- selectedData()
                
                ggplot(df, aes(year)) +
                geom_histogram(binwidth = 1, colour = "white", fill = "darkgreen") +
                labs(caption = "Data from Stockholm International Peace Research Institute") +
                xlab("Year") +
                ylab("Number of Explosions")})
        
        
}

# shinyApp
shinyApp(ui = ui, server = server)



