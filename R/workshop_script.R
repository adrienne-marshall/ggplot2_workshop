#Load libraries: ------------

#Data organizing:
library(tidyverse)
library(data.table)

#Palettes and visualization:
library(viridis)
library(RColorBrewer)
library(wesanderson)
library(ggthemes)
library(ggjoy)

#Data
library(gapminder)
library(maptools)


# Diamonds data: -----------
head(diamonds)

##
ggplot(data = diamonds)

##
ggplot(data = diamonds,
       aes(x = carat, y = price))

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point()

##
ggplot(data = diamonds, 
       aes(x = carat, y = price, color = clarity)) +
  geom_point()

##
ggplot(data = diamonds, 
       aes(x = carat, y = price), color = clarity) +
  geom_point()

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(color = "magenta")

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity))

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth()

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2)

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2) +
  theme_few()

##
ggplot(data = diamonds, 
       aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  geom_smooth(color = "black", size = 0.8, linetype = 2) +
  facet_wrap(~cut)

##
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = clarity), size = 0.5) +
  facet_grid(color~cut)

##
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = clarity)) +
  theme_few() + 
  scale_color_brewer(type = "qual", palette = "Set2")

##
ggplot(data = diamonds, 
       aes(x = clarity, y = price)) +
  geom_violin() 

##
ggplot(data = diamonds, 
       aes(x = price, y = cut)) +
  geom_joy()

##
ggplot(data = diamonds, 
       aes(x = price, y = cut, color = cut, fill = cut)) +
  geom_joy(alpha = 0.6, scale = 5) +
  scale_fill_viridis(option = "A", discrete = TRUE) +
  scale_color_viridis(option = "A", discrete = TRUE) + 
  theme_few()

##
ggplot(data = diamonds, 
       aes(x = price, y = cut, fill = cut)) +
  geom_joy(alpha = 1, scale = 5) +
  scale_fill_manual(values = wes_palette("Darjeeling")) +
  theme_few()

## Iris data: -------------
head(iris)

##
iris_long <- melt(iris, id.vars = ("Species"))
head(iris_long)

##
ggplot(iris_long, aes(x = Species, y = value, fill = variable)) +
  geom_bar(stat = 'identity', width = 1) +
  theme_bw()

##
ggplot(iris_long, 
       aes(x = Species, y = value, color = variable, fill = variable)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar(theta = 'x') +
  theme_bw()

## Gapminder data: ----------------
head(gapminder)

##
ggplot(gapminder,
       aes(x = year, y = lifeExp, color = gdpPercap)) +
  geom_line(aes(group = country)) +
  facet_grid(continent~.) +
  scale_color_viridis(trans = "log") +
  theme_few()

##
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

##
gapminder %>% filter(gdpPercap > 60000)

##
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_hex()

##
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_density2d(aes(color = ..level..), bins = 20) +
  scale_color_viridis()

##
p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop), alpha = 0.8) +
  scale_x_continuous(trans = 'log') +
  facet_wrap(~year) +
  scale_color_brewer(type = "Qual", palette = "Accent") +
  theme_hc(bgc = 'darkunica') +
  theme(text = element_text(size = 9))
p

#Make a map:
country_df <- map_data('world') %>%
  rename("country" = "region") 
country_df$country[country_df$country == "USA"] <- "United States"

#Take the mean across all years for each country:
gapminder_means <- gapminder %>% 
  group_by(country, continent) %>%
  summarise(lifeExp = mean(lifeExp),
            pop = mean(pop),
            gdpPercap = mean(gdpPercap))

##
plot_dat <- left_join(gapminder_means, country_df, by = "country")

ggplot(plot_dat) +
  geom_polygon(aes(x = long, y = lat, fill = lifeExp, group = group)) +
  scale_fill_viridis(option = "A") + 
  coord_quickmap() +
  theme_few()

