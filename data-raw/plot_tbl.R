library(tidyverse)
library(rprojroot)
library(ggplot2)
df <- tibble(
  plot_fx = c(ls("package:graphics"),
              ls("package:ggplot2"))
)

write_csv(df, path = find_package_root_file("inst", "extdata", "plot_tbl.csv"))
