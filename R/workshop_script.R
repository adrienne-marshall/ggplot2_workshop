#Load packages: ------------

#Data organizing:
library(dplyr)
library(data.table)

#Palettes and visualization:
library(ggplot2)
library(viridis)
library(RColorBrewer)
library(wesanderson)
library(ggthemes)
library(ggjoy)

#Data
library(gapminder)
library(maptools)


# Diamonds data: -----------
#Head shows the columns of the dataset "diamonds".
head(diamonds)

ggplot(data = diamonds)

## Aesthetics: aes()
ggplot(data = diamonds,
       aes(x = carat, y = price))

## Geometric object: geom_
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point()

## Add more aesthetics...
ggplot(data = diamonds, 
       aes(x = carat, y = price, color = clarity)) +
  geom_point()


## Why didn't we do this?
ggplot(data = diamonds, 
       aes(x = carat, y = price), color = clarity) +
  geom_point()

## We could get this instead:
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(color = "magenta")


## Our original plot
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity))

## Add more geoms:
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth()

## Change geom appearance:
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2)

## Make it look nicer:
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2) +
  theme_few()

## Try facets!
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2) +
  facet_wrap(~cut)

## Two-dimensional facets:
ggplot(data = diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point(size = 0.5) +
  facet_grid(color~cut)

## Try out color scales
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  theme_few() + 
  scale_color_brewer(type = "qual", palette = "Set2")

## Different plot types?
ggplot(data = diamonds, 
       aes(x = clarity, y = price)) +
  geom_violin() 


## Try an extension:
ggplot(data = diamonds, 
       aes(x = price, y = cut)) +
  geom_joy()

## Choose colors: scale_color_...
ggplot(data = diamonds, 
       aes(x = price, y = cut, color = cut, fill = cut)) +
  geom_joy(alpha = 0.8, scale = 5) +
  scale_fill_viridis(option = "A", discrete = TRUE) +
  scale_color_viridis(option = "A", discrete = TRUE) + 
  theme_few()


## Another color scale: 
ggplot(data = diamonds, 
       aes(x = price, y = cut, fill = cut)) +
  geom_joy(alpha = 1, scale = 5) +
  scale_fill_manual(values = wes_palette("Darjeeling")) +
  theme_few()

## Sometimes we need to transform data.
head(iris)

## Wide or long?
iris_long <- melt(iris, id.vars = ("Species"))
kable(head(iris_long))

## Plot the data:
ggplot(iris_long, aes(x = Species, y = value, fill = variable)) +
  geom_bar(stat = 'identity', width = 1) +
  theme_bw()

## Change coordinates
ggplot(iris_long, 
       aes(x = Species, y = value, color = variable, fill = variable)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar(theta = 'x') +
  theme_bw()

## A more interesting dataset:
head(gapminder)

## A scatter plot:
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

## Who's the outlier?
gapminder %>% filter(gdpPercap > 60000)

## Deal with overplotting:
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_hex()

## Another way to avoid overplotting:
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_density2d(aes(color = ..level..), bins = 20) +
  scale_color_viridis()

## A little more complicated:
p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop), alpha = 0.8) +
  scale_x_continuous(trans = 'log') +
  facet_wrap(~year) +
  scale_color_brewer(type = "Qual", palette = "Accent") +
  theme_hc(bgc = 'darkunica') +
  theme(text = element_text(size = 9))

p


## Let's make a map!
country_df <- map_data('world') %>%
  rename("country" = "region") 
country_df$country[country_df$country == "USA"] <- "United States"

#Take the mean across all years for each country:
gapminder_means <- gapminder %>% 
  group_by(country, continent) %>%
  summarise(lifeExp = mean(lifeExp),
            pop = mean(pop),
            gdpPercap = mean(gdpPercap))

plot_dat <- left_join(gapminder_means, country_df, by = "country")

## Make the map: 
ggplot(plot_dat) +
  geom_polygon(aes(x = long, y = lat, fill = lifeExp, group = group)) +
  scale_fill_viridis(option = "A") + 
  coord_quickmap() +
  theme_few()

