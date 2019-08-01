# Video Games

options(scipen = 999)

library(tidyverse)
library(viridis)
library(readr)
library(anytime)
library(ggthemes)

# Data source: Steam Spy

# Clean dataset from lizawood's github
url <- "https://raw.githubusercontent.com/lizawood/apps-and-games/master/PC_Games/PCgames_2004_2018_raw.csv"


# Load and prepare data ---------------------------------------------------

# Read in raw data
raw_df <- url %>% 
        read_csv() %>% 
        janitor::clean_names() 

# Clean up some of the factors and playtime data
clean_df <- raw_df %>% 
        mutate(price = as.numeric(price),
               score_rank = word(score_rank_userscore_metascore, 1),
               average_playtime = word(playtime_median, 1),
               median_playtime = word(playtime_median, 2),
               median_playtime = str_remove(median_playtime, "\\("),
               median_playtime = str_remove(median_playtime, "\\)"),
               average_playtime = 60 * as.numeric(str_sub(average_playtime, 1, 2)) +
                       as.numeric(str_sub(average_playtime, 4, 5)),
               median_playtime = 60 * as.numeric(str_sub(median_playtime, 1, 2)) +
                       as.numeric(str_sub(median_playtime, 4, 5)),
               metascore = as.double(str_sub(score_rank_userscore_metascore, start = -4, end = -3))) %>% 
        select(-score_rank_userscore_metascore, -score_rank, -playtime_median) %>% 
        rename(publisher = publisher_s, developer = developer_s)

# Remove comma from date
clean_df <- clean_df %>% 
        mutate(release_date = gsub(",", "", release_date))

# Split date into Month, Day, Year
clean_df <- clean_df %>% 
        separate(release_date, into = c("Month", "Day", "Year"))

# Add 0 to numbers under 10
clean_df$Day <- case_when(clean_df$Day %in% c("1", "2", "3", "4", "5", "6", "7",
                                              "8", "9") 
                                                ~ str_pad(clean_df$Day, 2, "left", pad = "0"),
                          clean_df$Day >= 10 ~ clean_df$Day)

# Create date format variable
clean_df <- clean_df %>% 
        mutate(r_date = anydate(paste0(Year, "-", Month, "-", Day)))

# Remove 0 and NA from focus variables
clean <- clean_df %>% 
        filter(average_playtime > 0) %>% 
        filter(median_playtime > 0) %>% 
        filter(!is.na(r_date)) %>% 
        select(number, r_date, average_playtime, price, metascore,
                median_playtime,developer, Year)

clean$developer <- as_factor(clean$developer)
clean$Year <- as_factor(clean$Year)

clean <- clean %>% 
        filter(!is.na(price))

clean <- clean %>% 
        mutate(price_band = findInterval(price, c(10, 20, 30, 40, 50, 60, 70)))

clean$price_band <- as_factor(clean$price_band)

clean$price_band <- recode_factor(clean$price_band, `0` = "$0-$9.99", `1` = "$10-$19.99", 
              `2` = "$20-$29.99", `3` = "$30-$39.99", `4` ="$40-$49.99",
              `5` = "$50-$59.99", `7` = "$70-$79.99", .ordered = TRUE)

meta <- clean %>% 
        filter(!is.na(metascore)) %>% 
        filter(!is.na(developer))

play <- clean %>% 
        filter(!is.na(average_playtime)) %>% 
        filter(!is.na(developer))

# Create scatterplot using Economist theme --------------------------------

ggplot(clean, aes(x = r_date, y = average_playtime, colour = price_band)) +
        geom_point(shape = 16) +
        theme_economist() +
        scale_colour_economist() +
        theme(legend.title = element_text(size = 10), 
              legend.text = element_text(size = 8)) +
        ggtitle("Average Playtime by Release Date") +
        xlab("Release Data") +
        ylab("Average Playtime") +
        labs(colour = "Price Band",
             caption = "Data Source: Liza Wood via Steam Spy")


# Create circular bar plot ------------------------------------------------
# Plots adapted from https://www.r-graph-gallery.com/circular-barplot/

p <- ggplot(meta, aes(x = developer, y = metascore, fill = price_band)) +
        geom_bar(stat = "identity") +
        ylim(-15,120) +
        scale_fill_viridis_d(name = "Price") +
        theme_minimal() +
        theme(
                axis.text = element_blank(),
                axis.title = element_blank(),
                panel.grid = element_blank()
        ) +

        
        # This makes the coordinate polar instead of cartesian.
        coord_polar(start = 0) +
        labs(caption = "Data Source: Liza Wood via Steam Spy") +
        ggtitle("Metascore by Developer")

p <- p +  guides(color = guide_legend(override.aes = list(size = 0.5)))
p <- p +  theme(legend.title = element_text(size = 9), 
                legend.text = element_text(size = 7))
p


p2 <- ggplot(play, aes(x = developer, y = average_playtime, fill = price_band)) +
        geom_bar(stat = "identity") +
        ylim(-15,120) +
        scale_fill_viridis_d(name = "Price") +
        theme_minimal() +
        theme(
                axis.text = element_blank(),
                axis.title = element_blank(),
                panel.grid = element_blank()
        ) +
        
        
        # This makes the coordinate polar instead of cartesian.
        coord_polar(start = 0) +
        labs(caption = "Data Source: Liza Wood via Steam Spy") +
        ggtitle("Average Playtime by Developer")

p2 <- p2 +  guides(color = guide_legend(override.aes = list(size = 0.5)))
p2 <- p2 +  theme(legend.title = element_text(size = 9), 
                legend.text = element_text(size = 7))
p2 

