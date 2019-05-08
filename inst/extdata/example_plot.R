library(tidyverse)

starwars %>%
  select(height, mass) %>%
  filter(!is.na(mass), !is.na(height)) %>%
  ggplot(aes(height, mass)) +
  geom_point()
