options(scipen = 999)

library(tidyverse)
library(readr)
library(lubridate)
library(ggthemes)
library(treemap)
library(plotly)

# Load data
emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")

# Make summary dataframe
emp_death <- emperors %>% 
        group_by(dynasty, cause) %>% 
        summarise(Count = n())

# Create treemap
treemap(emp_death,
        index=c("dynasty","cause"),
        vSize="Count",
        type="index",
        border.col=c("black","white"),
        palette = "Set1",
        title="Roman Emperors: Cause of death by dynasty",                      
        fontsize.title=14
) 





