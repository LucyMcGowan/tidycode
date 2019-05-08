library(tidyverse)
library(rms)

starwars %>%
  mutate(bmi = mass / ((height / 100) ^ 2)) %>%
  select(bmi, gender) -> starwars

dd <- datadist(starwars)
options(datadist = "dd")

mod <- ols(bmi ~ gender, data = starwars) %>%
  summary()

plot(mod)
