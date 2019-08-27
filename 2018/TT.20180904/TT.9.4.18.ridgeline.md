
### \#TidyTuesday 9-4-18 Week 23

This week’s data is fast food nutritional data. The data can be found
[here](https://github.com/rfordatascience/tidytuesday/blob/master/data/2018-09-04/fastfood_calories.csv).

First, let’s load the tidyverse library & read in our data.

``` r
library(tidyverse)
library(ggridges)

data <- read_csv("fastfood_calories.csv")
```

    ## Warning: Missing column names filled in: 'X1' [1]

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_integer(),
    ##   restaurant = col_character(),
    ##   item = col_character(),
    ##   calories = col_integer(),
    ##   cal_fat = col_integer(),
    ##   total_fat = col_integer(),
    ##   sat_fat = col_double(),
    ##   trans_fat = col_double(),
    ##   cholesterol = col_integer(),
    ##   sodium = col_integer(),
    ##   total_carb = col_integer(),
    ##   fiber = col_integer(),
    ##   sugar = col_integer(),
    ##   protein = col_integer(),
    ##   vit_a = col_integer(),
    ##   vit_c = col_integer(),
    ##   calcium = col_integer(),
    ##   salad = col_character()
    ## )

For this tutorial, we’re going to do ridgeline plots using the ggridges
package. I want to visualize cholesterol per item for each restaurant.
Let’s start by using select() to get the columns we need.

``` r
data1 <- data %>%
  select(restaurant, cholesterol)

head(data1)
```

    ## # A tibble: 6 x 2
    ##   restaurant cholesterol
    ##   <chr>            <int>
    ## 1 Mcdonalds           95
    ## 2 Mcdonalds          130
    ## 3 Mcdonalds          220
    ## 4 Mcdonalds          155
    ## 5 Mcdonalds          120
    ## 6 Mcdonalds           80

Next, let’s do a basic ridgeline plot to see if we’re heading in the
right direction.

``` r
ggplot(data1, aes(cholesterol, restaurant)) +
  geom_density_ridges2()
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Looks good\! To start with, let’s add some color. First, we need to add
color & fill to the aes call. Color controls the outline of the plot.
Fill controls the color inside the plot. If you want to leave the
outline black, you can simply leave out the color call. Then we add
scale\_color\_brewer() & scale\_fill\_brewer(). I picked the “Dark2”
palette.

``` r
ggplot(data1, aes(cholesterol, restaurant, color = restaurant, fill = restaurant)) +
  geom_density_ridges2() +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2")
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Looks better now\! Next thing I would like to do is remove the
background panel. This will help me figure out other aesthetic choices
later. We can remove the background panel using
theme().

``` r
ggplot(data1, aes(cholesterol, restaurant, color = restaurant, fill = restaurant)) +
  geom_density_ridges2() +
  theme(panel.background = element_blank()) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2")
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Much better\! Now let’s clean it up a bit. I’d like to remove the legend
& the axis titles. Also I’d like to bump up the font on the tick mark
labels. We can do all of these by adding to the theme()
call.

``` r
ggplot(data1, aes(cholesterol, restaurant, color = restaurant, fill = restaurant)) +
  geom_density_ridges2() +
  theme(legend.position = "none",
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 14)) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2")
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

It’s looking better\! Now let’s remove the tick marks from the y-axis &
add x-axis grid lines for clarification. Both of these things can be
done in theme.

I also want to reverse the order of the y-axis. We can do this using
fct\_rev() from the forcats package. The forcats package is included in
the
tidyverse.

``` r
ggplot(data1, aes(cholesterol, fct_rev(restaurant), color = restaurant, fill = restaurant)) +
  geom_density_ridges2() +
  theme(legend.position = "none",
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 14),
    axis.ticks.y = element_blank(),
    panel.grid.major.x = element_line(color = 'gray', linetype= 'dashed')) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2")
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Another way to go is to remove the “tails” from the plot. If you want to
remove the “tails”, you can add rel\_min\_height to the
geom\_density\_ridges2() call. Removing the “tails” can help visualize
some of the outliers that don’t fall into the main curve of the density
plot.

``` r
ggplot(data1, aes(cholesterol, fct_rev(restaurant), color = restaurant, fill = restaurant)) +
  geom_density_ridges2(rel_min_height = 0.01) +
  theme(legend.position = "none",
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 14),
    axis.ticks.y = element_blank(),
    panel.grid.major.x = element_line(color = 'gray', linetype= 'dashed')) +
  scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2")
```

    ## Picking joint bandwidth of 15.2

![](TT.9.4.18.ridgeline_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Any questions or comment, feel free to reach out to me on
[Twitter](https://twitter.com/sapo83).
