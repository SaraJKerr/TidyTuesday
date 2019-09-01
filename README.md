# TidyTuesday

This repo contains my code for the __Tidy Tuesday__ project from __R4DS__, with the aim of experimenting with different types of visualisation.

## Week 1 - 23 July 2019
My first week of TidyTuesday uses the __Wildlife Strikes__ dataset from the _FAA_ (available from https://wildlife.faa.gov/).

For this visualisation I created a chloropleth map. This indicates that the southern coastal states of California, Texas, and Florida have the highest number of bird strikes.

![Wildlife Strikes](https://github.com/SaraJKerr/TidyTuesday/blob/master/Images/Wildlife%20Strikes.jpeg)

## Week 2 - 30 July 2019
The dataset for this week of TidyTuesday is the __Video Games__ dataset from Liza Wood via _Steam Spy_ (blog available from https://cruiseofdimensionality.home.blog/2019/07/24/pc-video-games-we-still-play/).

This week I wanted to create two different types of visualisation. Firsly I wanted to try out the Economist theme from ggthemes. For the next visualisation I chose to experiment with a circular bar plot.

![Average Playtime](https://github.com/SaraJKerr/TidyTuesday/blob/master/Images/Playtime%20by%20Release.jpeg)

![Metascore](https://github.com/SaraJKerr/TidyTuesday/blob/master/Images/Metascore.jpeg)

![Playtime](https://github.com/SaraJKerr/TidyTuesday/blob/master/Images/Average%20Playtime.jpeg)

## Week 3 - 13 August 2019
This week's dataset is a throwback to my undergraduate degree in Ancient History - __Roman Emperors__. The dataset is from _Wikipedia_ and _Zonination_. I chose to explore creating an interactive treemap, using the _treemap_, _d3treeR_, and _htmlwidgets_ packages. 

The interactive plot can be found here: http://sarajkerr.com/Dataviz/TidyTuesday/EmperorTreemap.html

## Week 4 - 20 August 2019
This week's dataset is all about nuclear explosions from the _Stockholm International Peace Research Institute_. I wanted to take the interactive side a little further so decided to create a shiny app with an interactive map showing locations, and a histogram showing the number of explosions per year. A drop down was included to allow users to drill down into the individual countries, and markers were coloured using the upper yield in kilotons, split at 20 kt (1st quartile), 330 kt (mean), and above 330 kt.

![Image of Nukes App](https://github.com/SaraJKerr/TidyTuesday/blob/master/Images/Images%20of%20Nukes%20app.jpeg)

The shiny app can be found here: http://sarajkerr7.shinyapps.io/app_nukes
