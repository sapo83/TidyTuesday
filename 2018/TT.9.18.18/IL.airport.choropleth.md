
### \#TidyTuesday 9-18-18 Week 25

This week’s data is US airport
[data](https://github.com/rfordatascience/tidytuesday/blob/master/data/2018-09-18/us-airports.csv).

Since I live in Illinois, I’ve decided to make a state map showing all
the airports in Illinois & their yearly rank.

First, let’s start by loading the libraries we need & the data file.
Then, let’s use head to take a quick peek at our data.

``` r
library(tidyverse)
library(ggmap)
library(maps)

data <- read_csv("us-airports.csv", col_names = TRUE)
```

    ## Warning: Missing column names filled in: 'X1' [1]

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_integer(),
    ##   yearly_rank = col_integer(),
    ##   region = col_character(),
    ##   state = col_character(),
    ##   loc_id = col_character(),
    ##   city = col_character(),
    ##   airport_name = col_character(),
    ##   airport_classification = col_character(),
    ##   hub_type = col_character(),
    ##   year = col_integer(),
    ##   passengers = col_integer()
    ## )

``` r
head(data)
```

    ## # A tibble: 6 x 11
    ##      X1 yearly_rank region state loc_id city  airport_name airport_classif…
    ##   <int>       <int> <chr>  <chr> <chr>  <chr> <chr>        <chr>           
    ## 1     1          58 AL     AK    ANC    Anch… Ted Stevens… Primary         
    ## 2     2         121 AL     AK    FAI    Fair… Fairbanks I… Primary         
    ## 3     3         138 AL     AK    JNU    June… Juneau Inte… Primary         
    ## 4     4         199 AL     AK    BET    Beth… Bethel       Primary         
    ## 5     5         222 AL     AK    KTN    Ketc… Ketchikan I… Primary         
    ## 6     6         226 AL     AK    ENA    Kenai Kenai Munic… Primary         
    ## # ... with 3 more variables: hub_type <chr>, year <int>, passengers <int>

To complete this map, we’re going to need the latitude & longitude for
each city in our data set. I found a csv file with the longitude &
latitude for all the cities
[here](https://simplemaps.com/data/us-cities).

First, we read in the data. Then we use select() to pick the columns we
need. Next, we filter the data set by the state of interest (IL). To
make joining the two data frames easier later, I used mutate to add a
column with the state. Then I used select to drop the state\_id column.
Once again, we use head to look at our data & make sure everything still
looks good.

``` r
long_lat_df <- read_csv("us.cities.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   city = col_character(),
    ##   city_ascii = col_character(),
    ##   state_id = col_character(),
    ##   state_name = col_character(),
    ##   county_fips = col_integer(),
    ##   county_name = col_character(),
    ##   lat = col_double(),
    ##   lng = col_double(),
    ##   population = col_double(),
    ##   population_proper = col_integer(),
    ##   density = col_double(),
    ##   source = col_character(),
    ##   incorporated = col_character(),
    ##   timezone = col_character(),
    ##   zips = col_character(),
    ##   id = col_integer()
    ## )

``` r
long_lat_il_df <- long_lat_df %>%
  select(city, state_id, lat, lng) %>%
  filter(state_id == "IL") %>%
  mutate(state = state_id) %>%
  select(-state_id)

head(long_lat_il_df)
```

    ## # A tibble: 6 x 4
    ##   city            lat   lng state
    ##   <chr>         <dbl> <dbl> <chr>
    ## 1 Olmsted        37.2 -89.1 IL   
    ## 2 McClure        37.3 -89.4 IL   
    ## 3 Pleasant Hill  39.4 -90.9 IL   
    ## 4 Burgess        41.1 -90.6 IL   
    ## 5 Toledo         39.3 -88.2 IL   
    ## 6 Lodge          40.1 -88.6 IL

Now that our longitude & latitude data frame is set, let’s go back to
our original data set.

First, we use select() to get the columns we need for this analysis.
Then we filter by state. I used to distinct() to make sure that we only
have one record for each airport.

Next, I used mutate\_if to clean up some of the city names. In the
airport data, some of the cities are a bit strange. Using
str\_replace\_all, I can search for a pattern & replace it with the
pattern of my choice.

Last of all, I used mutate to remove everything from the city names in
parentheses.

``` r
IL_airport_df <- data %>%
  select(yearly_rank, state, city, airport_name) %>%
  filter(state == "IL") %>%
  distinct() %>%
  mutate_if(is.character, str_replace_all, pattern = "Bloomington-Normal Airport", replacement = "Bloomington") %>%
  mutate_if(is.character, str_replace_all, pattern = "De Kalb", replacement = "DeKalb") %>%
  mutate_if(is.character, str_replace_all, pattern = "DuPage", replacement = "West Chicago") %>%
  mutate_if(is.character, str_replace_all, pattern = "Romeo", replacement = "Romeoville") %>%
  mutate(city = trimws(str_replace(city, "\\(.*?\\)", "")))

head(IL_airport_df)
```

    ## # A tibble: 6 x 4
    ##   yearly_rank state city        airport_name                              
    ##         <int> <chr> <chr>       <chr>                                     
    ## 1           3 IL    Chicago     Chicago O'Hare International              
    ## 2          24 IL    Chicago     Chicago Midway International              
    ## 3         133 IL    Moline      Quad City International                   
    ## 4         158 IL    Peoria      General Downing - Peoria International    
    ## 5         174 IL    Bloomington Central IL Regional Airport at Bloomingto…
    ## 6         223 IL    Rockford    Chicago/Rockford International

Now that our airport data is cleaned up, we can merge it with the
longitude/latitude data from before. Here I used left\_join(). The first
data frame is the Illinois airport data frame. Order matters here. When
using left join, the join function will keep all the rows in the first
data frame listed in the command.

There is also a “group” value we need for plotting the map. A quick look
at the data frame to plot the map shows the group for Illinois is “12”.
I used mutate to add a group column with a value of
“12”.

``` r
IL_df <- left_join(IL_airport_df, long_lat_il_df, by = c("state", "city")) %>%
  mutate(group = "12")

head(IL_df)
```

    ## # A tibble: 6 x 7
    ##   yearly_rank state city     airport_name                  lat   lng group
    ##         <int> <chr> <chr>    <chr>                       <dbl> <dbl> <chr>
    ## 1           3 IL    Chicago  Chicago O'Hare Internation…  41.8 -87.7 12   
    ## 2          24 IL    Chicago  Chicago Midway Internation…  41.8 -87.7 12   
    ## 3         133 IL    Moline   Quad City International      41.5 -90.5 12   
    ## 4         158 IL    Peoria   General Downing - Peoria I…  40.8 -89.6 12   
    ## 5         174 IL    Bloomin… Central IL Regional Airpor…  40.5 -89.0 12   
    ## 6         223 IL    Rockford Chicago/Rockford Internati…  42.3 -89.1 12

The next part sets up the data frames to draw the map of Illinois & it’s
counties. I used
[this](https://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html)
as a guideline to figure out how to do this.

``` r
states <- map_data("state")
il_df <- subset(states, region == "illinois")
counties <- map_data("county")
il_county <- subset(counties, region == "illinois")
```

Let’s start by plotting just the state of Illinois & the county
outlines.

``` r
ggplot(data = il_df, mapping = aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)
```

![](IL.airport.choropleth_files/figure-gfm/state/county%20plot-1.png)<!-- -->

Looks good\! Next let’s plot a point for each of our airports. We add
geom\_point(). We have to specify the data frame that our data comes
from using “data =”. Then to plot the actual points we use the aes()
call. I also added “size =”. I used yearly\_rank to determine the size
of the point.

``` r
ggplot(data = il_df, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) +
  geom_point(data = IL_df, aes(x = lng, y = lat, group = group, size = yearly_rank))
```

![](IL.airport.choropleth_files/figure-gfm/all%20plot-1.png)<!-- -->

This is a good starting point\! Now let’s clean it up. I want to start
by removing the background panel, grid lines, axis tick marks, axis
labels, & axis titles. All of these can be done from the theme() call.

``` r
ggplot(data = il_df, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) +
  geom_point(data = IL_df, aes(x = lng, y = lat, group = group, size = yearly_rank)) +
  theme(panel.background = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank())
```

![](IL.airport.choropleth_files/figure-gfm/theme%20change%20plot-1.png)<!-- -->

Next thing to work on is the point size. We want the smaller values
(higher ranks) to have a larger point size than the higher values (lower
rank). To do this, we can take the inverse of the yearly\_rank. We do
this by using “1/yearly\_rank” in the size call.

``` r
ggplot(data = il_df, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) +
  geom_point(data = IL_df, aes(x = lng, y = lat, group = group, size = 1/yearly_rank)) +
  theme(panel.background = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank())
```

![](IL.airport.choropleth_files/figure-gfm/change%20point%20size%20plot-1.png)<!-- -->

This looks better. Now let’s play with the color. First, I changed the
background color of the entire state to “navyblue”. I did this in the
first geom\_polygon() call. I also changed the dots to an orange color
(Go Bears\!). I removed the third geom\_polygon call because it was
adding an black outline to the state portion. It didn’t work with my
color theme.

``` r
ggplot(data = il_df, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "navyblue") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_point(data = IL_df, aes(x = lng, y = lat, group = group, size = 1/yearly_rank), color = "#FF8300") +
  theme(panel.background = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank())
```

![](IL.airport.choropleth_files/figure-gfm/change%20color%20plot-1.png)<!-- -->

Next, I’m going to remove the legend using the theme() call. I’m also
going to play with the point size. I’d like to see a bit more variation
in the smaller points. This can be changed through the scale\_size().
You can play around with the range to get the sizes you’d like.

``` r
ggplot(data = il_df, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "navyblue") +
  geom_polygon(data = il_county, fill = NA, color = "white") +
  geom_point(data = IL_df, aes(x = lng, y = lat, group = group, size = 1/yearly_rank), color = "#FF8300") +
  theme(legend.position = "none",
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank()) +
  scale_size(range = c(2, 10))
```

![](IL.airport.choropleth_files/figure-gfm/final%20plot-1.png)<!-- -->

Looks good\! Any comments or questions, you can reach out to me via
[Twitter](https://twitter.com/sapo83).
