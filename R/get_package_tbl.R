#' Create a tibble of all functions included in all packages used in your analysis
#'
#' @param pkg_names Character vector of the names of all packages used in analysis
#'
#' @return Tibble with two columns, `package` and `func`
#' @export
get_packages_tbl <- function(pkg_names = NULL) {
  if (is.null(pkg_names)) {
    return(.tidycode$cran_tbl)
  }
  pkg_names <- c(pkg_names, "stats", "methods", "grDevices", "graphics",
                 "datasets", "base")
  if ("tidyverse" %in% pkg_names) {
    pkg_names <- c(pkg_names, "ggplot2", "purrr", "dplyr", "tibble", "tidyr",
                   "readr", "stringr", "forcats")
  }
  .tidycode$cran_tbl[(.tidycode$cran_tbl$package %in% pkg_names) &
                       !is.na(.tidycode$cran_tbl$func), ]
}
