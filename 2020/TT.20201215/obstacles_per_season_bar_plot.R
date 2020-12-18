library(tidyverse)
#library(ggpubr)

ninja_warrior_df = read_csv("/Users/sarah/Documents/TidyTuesday/2020/TT.20201215/ninja_warrior.csv")
head(ninja_warrior_df)

# number of columns
ncol(ninja_warrior_df)

# number of rows
nrow(ninja_warrior_df)

# How many seasons?
num_seasons = nrow(ninja_warrior_df %>% 
  select(season) %>%
  distinct())

# Another way to find how many seasons
unique_seasons = ninja_warrior_df %>% 
  select(season) %>%
  distinct()
nrow(unique_seasons)

# How many obstacles in each season?
  num_obstacles_by_season = ninja_warrior_df %>%
    select(season, obstacle_name) %>%
    distinct() %>%
    group_by(season) %>%
    summarise(count = n())

# Set color palette
cols = c("#f6ac8d", "#eec354", "#e3e227", "#dcde51", "#d6dc89", "#b7e26b", "#83e843", "#7fe78f", 
         "#58e8cc", "#4ed9f6")

# Change season column to discrete factors of later reordering
num_obstacles_by_season$season = factor(num_obstacles_by_season$season)

# Plot the number of obstacles in each season
ggplot(data = num_obstacles_by_season) +
  geom_col(aes(x = fct_reorder(season, count), y = count, color = fct_reorder(season, count), 
               fill = fct_reorder(season, count)),
           alpha = 0.7, width = 0.7) +
  geom_text(aes(x = as.factor(season), y = 0, label = paste0("Season ", season)), size = 7, 
            fontface = 'bold', hjust = -0.1) +
  geom_text(aes(x = as.factor(season), y = count - 1, label = count), size = 5, hjust = 0.75) + 
  coord_flip() +
  scale_color_manual(values = cols) +
  scale_fill_manual(values = cols) +
  ggtitle("Number of obstacles per season of Ninja Warrior") +
  theme(legend.position = "none",
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.background = element_rect(fill = '#6f6f6f'),
        plot.title = element_text(color = "white", size = 27))

ggsave("/Users/sarah/Documents/TidyTuesday/2020/TT.20201215/obstacles_per_season_bar_plot.png")

