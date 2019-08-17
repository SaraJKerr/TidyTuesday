options(scipen = 999)

library(tidyverse)
library(readr)
library(lubridate)
library(ggthemes)
library(treemap)
library(d3treeR)

# Load data
emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")

# Make summary dataframe
emp_death <- emperors %>% 
        group_by(dynasty, cause, name) %>% 
        summarise(Count = n())

# Create treemap
emp_tree <-  treemap(emp_death,
        index=c("dynasty","cause", "name"),
        vSize="Count",
        type="index",
        border.col=c("black","white"),
        palette = "Set1",
        title="Roman Emperors: Cause of death by dynasty",                      
        fontsize.title=16
)

emp_int <- d3tree(emp_tree,  rootname = "Emperors")

library(htmlwidgets)
saveWidget(emp_int, file="EmperorTreemap.html", selfcontained = T)



