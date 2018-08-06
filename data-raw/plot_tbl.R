library(tidyverse)
library(rprojroot)

df <- tibble(
  plot_fx = c("plot", "abline", "arrows", "asp",
  "assocplot", "Axis", "axis",
  "axTicks", "barplot", "bxp", "cdplot", "clip",
  "co.intervals", "contour", "coplot", "curve",
  "dotchart", "filled.contour", "fourfoldplot",
  "frame", "grconvertX", "grconvertY", "grid",
  "hist", "identify", "image", "lcm",
  "legend", "lines", "locator", "matlines", "matplot",
  "matpoints", "mosaicplot", "mtext", "pairs", "panel.smooth",
  "par", "pch", "points", "polygon", "polypath", "rasterImage",
  "rect", "rug", "segments", "smoothScatter", "spineplot",
  "stars", "stem", "strheight", "stripchart", "strwidth",
  "sunflowerplot", "symbols", "text", "title", "xinch", "xlim",
  "xspline", "xyinch", "yinch", "ylim",
  "ggplot", "bmp", "jpeg", "png", "tiff")
)

write_csv(df, path = find_package_root_file("inst", "extdata", "plot_tbl.csv"))
