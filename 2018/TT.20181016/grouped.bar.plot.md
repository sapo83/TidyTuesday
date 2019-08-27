
### \#TidyTuesday 10-16-18 Week 29

This week’s data explores different types of college major data,
including number of students in majors, salary & type of work. The data
can be found
[here](https://github.com/rfordatascience/tidytuesday/blob/master/data/2018-10-16/recent-grads.csv).

Today, I’m going to do a grouped bar plot showing the type of work (full
time or part time) for each major category.

Let’s start by loading the tidyverse library & reading in our data using
`read_csv`. We can use `head()` to take a quick peek at our
    data.

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## Warning: package 'dplyr' was built under R version 3.5.1

    ## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
data <- read_csv("college_major.csv", col_names = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_integer(),
    ##   Major = col_character(),
    ##   Major_category = col_character(),
    ##   ShareWomen = col_double(),
    ##   Unemployment_rate = col_double()
    ## )

    ## See spec(...) for full column specifications.

``` r
head(data)
```

    ## # A tibble: 6 x 21
    ##    Rank Major_code Major Total   Men Women Major_category ShareWomen
    ##   <int>      <int> <chr> <int> <int> <int> <chr>               <dbl>
    ## 1     1       2419 PETR…  2339  2057   282 Engineering         0.121
    ## 2     2       2416 MINI…   756   679    77 Engineering         0.102
    ## 3     3       2415 META…   856   725   131 Engineering         0.153
    ## 4     4       2417 NAVA…  1258  1123   135 Engineering         0.107
    ## 5     5       2405 CHEM… 32260 21239 11021 Engineering         0.342
    ## 6     6       2418 NUCL…  2573  2200   373 Engineering         0.145
    ## # ... with 13 more variables: Sample_size <int>, Employed <int>,
    ## #   Full_time <int>, Part_time <int>, Full_time_year_round <int>,
    ## #   Unemployed <int>, Unemployment_rate <dbl>, Median <int>, P25th <int>,
    ## #   P75th <int>, College_jobs <int>, Non_college_jobs <int>,
    ## #   Low_wage_jobs <int>

First, I’m going to use `select()` to get the columns we need for this
analysis. Further work shows that there are some NAs in this data that
prevent further mutation of variables. I’m going to use `na.omit()` to
remove those NAs.

Then we need to `group_by()` the major category so we can calculate the
totals for each column. Next, we’ll use `summarise()` to get our totals.
We can use `sum()` to calculate a total for each column by each group
(Major\_category). We’ll use `mutate()` to find the precentages of
people working full time & people working part time.

Then we use `select()` to drop the columns we no longer need. Finally,
we use `gather()` to get key value pairs for easier plotting. We also
use `head()` to see the new structure of our data frame.

``` r
type <- data %>%
select(Major_category, Total, Full_time, Part_time) %>%
na.omit() %>%
group_by(Major_category) %>%
summarise(total = sum(Total), FT = sum(Full_time), PT = sum(Part_time)) %>%
mutate(FTpct = FT/total, PTpct = PT/total) %>%
select(-total, -FT, -PT) %>%
gather(variable, value, FTpct:PTpct)

head(type)
```

    ## # A tibble: 6 x 3
    ##   Major_category                  variable value
    ##   <chr>                           <chr>    <dbl>
    ## 1 Agriculture & Natural Resources FTpct    0.735
    ## 2 Arts                            FTpct    0.582
    ## 3 Biology & Life Science          FTpct    0.530
    ## 4 Business                        FTpct    0.759
    ## 5 Communications & Journalism     FTpct    0.696
    ## 6 Computers & Mathematics         FTpct    0.694

Next, I want to set factor levels for our new “variable” column. The
labels in this factor are the labels seen in the legend. We want
meaningful labels in the legend so let’s take care of that
here.

``` r
type$variable <- factor(type$variable, levels = c("FTpct", "PTpct"), labels = c("Full Time", "Part Time"))

head(type)
```

    ## # A tibble: 6 x 3
    ##   Major_category                  variable  value
    ##   <chr>                           <fct>     <dbl>
    ## 1 Agriculture & Natural Resources Full Time 0.735
    ## 2 Arts                            Full Time 0.582
    ## 3 Biology & Life Science          Full Time 0.530
    ## 4 Business                        Full Time 0.759
    ## 5 Communications & Journalism     Full Time 0.696
    ## 6 Computers & Mathematics         Full Time 0.694

Now when we look at our data, we see that variable has more meaningful
labels.

Let’s get to plotting\! First, let’s do a basic grouped bar plot. We use
`geom_bar()` to get our bar plot. Since we want the bars to be next to
each other, we specify `position = "dodge"`. We use `fill` in the
`aes()` call to specify how we want our data grouped.

``` r
ggplot(type) +
  geom_bar(aes(x = Major_category, y = value, fill = variable), stat = "identity", position = "dodge")
```

![](grouped.bar.plot_files/figure-gfm/first%20plot-1.png)<!-- -->

Looks good so far\! First thing I would like to do is flip this on it’s
side. It will make the major categories easier to read. To do that, we
use `coord_flip()`.

``` r
ggplot(type) +
  geom_bar(aes(x = Major_category, y = value, fill = variable), stat = "identity", position = "dodge") +
  coord_flip()
```

![](grouped.bar.plot_files/figure-gfm/second%20plot-1.png)<!-- -->

That makes the major categories much easier to read. Next, let’s change
the colors & move the legend. We can change the colors by using
`scale_fill_manual()`. The colors we want to use go in a character
vector. To move the legend to the bottom of the plot, we use
`legend.position = "bottom"` inside `theme()`. Other options for legend
position are left, top, & right.

``` r
ggplot(type) +
  geom_bar(aes(x = Major_category, y = value, fill = variable), stat = "identity", position = "dodge") +
  coord_flip() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = c("#ff943d", "#2ec0f9"))
```

![](grouped.bar.plot_files/figure-gfm/third%20plot-1.png)<!-- -->

Looking even better\! Now I want to remove the titles from the axes &
the legend. To remove the axes titles, we can use `axis.title =
element_blank()` in `theme()`. To remove the legend title, we can use
`legend.title = element_blank()` in `theme()`.

``` r
ggplot(type) +
  geom_bar(aes(x = Major_category, y = value, fill = variable), stat = "identity", position = "dodge") +
  coord_flip() +
  theme(legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank()) +
  scale_fill_manual(values = c("#ff943d", "#2ec0f9"))
```

![](grouped.bar.plot_files/figure-gfm/fourth%20plot-1.png)<!-- -->

I’d like to bump up the font size on my axis labels, remove the panel
background & remove the tick marks on the axis labels. We can change the
font size of the labels by adding `axis.text = element_text(size = 12)`
to `theme()`. We can remove the panel background by adding
`panel.background = element_blank()` to `theme()`. To remove the axis
tick marks, we add `axis.ticks = element_blank()` to `theme()`.

``` r
ggplot(type) +
  geom_bar(aes(x = Major_category, y = value, fill = variable), stat = "identity", position = "dodge") +
  coord_flip() +
  theme(legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 12),
    panel.background = element_blank(),
    axis.ticks = element_blank()) +
  scale_fill_manual(values = c("#ff943d", "#2ec0f9"))
```

![](grouped.bar.plot_files/figure-gfm/fifth%20plot-1.png)<!-- -->

I’d like to reorder the original x axis so that it reads alphabetically.
I would also like to add a label at the end of each bar with the value
of that bar as a percent.

To reverse the x axis, we use `fct_rev()`. Inside the parentheses goes
the column name you would like to reverse. In this case, it is
“Major\_category”. This goes inside the `aes()` call in `geom_bar()`.

To add labels to the plot, we use `geom_text()`. Make sure to set the
`aes()` to match `geom_bar()`. Add `label` to the `aes()` to specify
what you want the labels to be. I also added `scales::percent()` so the
labels would be in percent form. Since we have a grouped plot, we need
to specify the `group` inside `aes()` as well. The key to getting the
labels to work with a dodged bar plot is using `position =
position_dodge(width = 1)` inside `geom_text()` but outside the `aes()`
call. Last of all, you can use `hjust` & `vjust` to change the location
& alignment of labels. Play around with it till you find something you
like\!

``` r
ggplot(type) +
  geom_bar(aes(x = fct_rev(Major_category), y = value, fill = variable), stat = "identity", position = "dodge") +
  geom_text(aes(x = fct_rev(Major_category), y = value, label = scales::percent(value), group = variable), position = position_dodge(width = 1), hjust = -0.1) +
  coord_flip() +
  theme(legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 12),
    panel.background = element_blank(),
    axis.ticks = element_blank()) +
  scale_fill_manual(values = c("#ff943d", "#2ec0f9"))
```

![](grouped.bar.plot_files/figure-gfm/sixth%20plot-1.png)<!-- -->

Looks good, but some of our labels are hanging off the end of the plot.
We can fix this by adjusting the limits on the “original” y axis. We can
use `scale_y_continuous()` to set new limits. This is another option you
can play around with until you get what you like.

I want to remove the y axis labels now. We have the bars labeled now so
we don’t need the axis labels anymore. To do this, I’ve added
`axis.text.x = element_blank()` to `theme()`.

Last of all, I would like to reorder the legend so it matches the order
of the bars. We can do that by adding `guide = guide_legend(reverse =
TRUE)` into `scale_fill_manual()`.

``` r
ggplot(type) +
  geom_bar(aes(x = fct_rev(Major_category), y = value, fill = variable), stat = "identity", position = "dodge") +
  geom_text(aes(x = fct_rev(Major_category), y = value, label = scales::percent(value), group = variable), position = position_dodge(width = 1), hjust = -0.1) +
  coord_flip() +
  theme(legend.position = "bottom",
    legend.title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_text(size = 12),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_blank()) +
  scale_y_continuous(limits = c(0,.85)) +
  scale_fill_manual(values = c("#ff943d", "#2ec0f9"), guide = guide_legend(reverse = TRUE))
```

![](grouped.bar.plot_files/figure-gfm/final%20plot-1.png)<!-- -->

That’s a great looking plot\!\!\! If you have an feedback or questions,
you create an issue/pull request or you can always connect with me on
[Twitter](https://twitter.com/sapo83).
