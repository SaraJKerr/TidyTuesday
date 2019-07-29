options(scipen = 999)

library(tidyverse)
library(viridis)
library(ggmap)
library(readr)
library(maps)
library(mapproj)


# Data Source https://wildlife.faa.gov/

wildlife_impacts <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-23/wildlife_impacts.csv")


# Prepare Data ------------------------------------------------------------

# Remove results where state is NA
wildlife_impacts <- wildlife_impacts %>% 
        filter(state != "N/A")

# Select key information for plot and add full state name as regions
w_impacts <- wildlife_impacts %>% 
        group_by(state) %>% 
        summarise(Count = n()) %>% 
        mutate(region = tolower(state.name[match(state, state.abb)]))


# Create a Static Map -----------------------------------------------------

# Pull US state map
us_states <- map_data("state")

w_impact_map <- left_join(w_impacts, us_states, by = "region")

ggplot(w_impact_map, aes(long, lat, group = group)) +
        geom_polygon(aes(fill = COUNT), colour = "white") +
        scale_fill_viridis_c(option = "D", alpha = 0.8, name = "Number of Strikes") +
        coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
        ggtitle("Aircraft Wildlife Strikes by State") +
        labs(caption = "Data source: FAA")

