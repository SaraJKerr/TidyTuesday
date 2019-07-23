options(scipen = 999)

library(tidyverse)
library(sf)
library(raster)
library(viridis)
library(cowplot)
library(usmap)

# Data Source https://wildlife.faa.gov/

bird_impacts <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-23/bird_impacts.csv")

# Focus on damage type by time of day excluding NA



bird_impacts %>% group_by(state) %>% summarise(Count = n())

imp_state <- bird_impacts %>% 
  group_by(state) %>% 
  summarise(Count = n())

b_damage$damage <- as_factor(b_damage$damage )
b_damage$damage <- fct_relevel(b_damage$damage, "N", "M?", "M", "S")
b_damage$operator <- as_factor(b_damage$operator)

plot_usmap(regions ="states")+ 
  labs(title = "US States", subtitle = "This is a blank map of the states of the United States.") + 
  theme(panel.background = element_rect(colour = "black", fill = "light blue"))
