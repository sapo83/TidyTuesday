
library(tidyverse)

data <- read_csv("incarceration_trends.csv", na = c("", "NA"))

subset_pop_df <- data %>%
  filter(year >= 1983) %>%
  group_by(urbanicity, year) %>%
  summarise(subsetJailPop = sum(total_prison_pop, na.rm=TRUE))

total_pop_df <- data %>%
  filter(year >= 1983) %>%
  group_by(year) %>%
  summarise(totalJailPop = sum(total_prison_pop, na.rm=TRUE))

fin_df <- left_join(subset_pop_df, total_pop_df, by = "year") %>%
  mutate(pct = subsetJailPop/totalJailPop) %>%
  select(urbanicity, year, pct)

A <- ggplot(fin_df) +
  geom_point(aes(x = year, y = pct, color = urbanicity), size = 4, shape = 17) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(breaks = seq(1985, 2015, 5)) +
  theme(legend.position = "bottom",
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_text(size = 12),
    panel.background = element_blank(),
    panel.grid.major.x = element_line(linetype = "longdash", color = "azure4"),
    panel.grid.major.y = element_line(linetype = "dashed", color = "azure3"),
    plot.title = element_text(hjust = 0.5, size = 16),
    legend.text = element_text(size=10),
    legend.title = element_text(size = 12)) +
  scale_color_manual(name = "Urbanicity", values = c("#205e79", "#25963E", "#D19C4C", "#9D5F38")) +
  ggtitle("Population in Jail by Urbanicity in the United States")


png("dot.plot.US.png")
plot(A)
dev.off()
