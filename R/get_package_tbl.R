#' Create a tibble of all functions included in all packages used in your analysis
#'
#' @param pkg_names Character vector of the names of all packages used in analysis
#'
#' @return A `tbl_df` with two columns:
#'  * `package`: the name of the R package
#'  * `func`: the name of the R function
#'
#' @export
get_packages_tbl <- function(pkg_names = NULL) {
  if (is.null(pkg_names)) {
    return(deal_with_pipe(.tidycode$cran_tbl))
  }
  pkg_names <- c(pkg_names, "stats", "methods", "grDevices", "graphics",
                 "datasets", "base")
  if ("tidyverse" %in% pkg_names) {
    pkg_names <- c(pkg_names, "ggplot2", "purrr", "dplyr", "tibble", "tidyr",
                   "readr", "stringr", "forcats")
  }
  t <- .tidycode$cran_tbl[(.tidycode$cran_tbl$package %in% pkg_names) &
                       !is.na(.tidycode$cran_tbl$func), ]
  deal_with_pipe(t)
}


# TODO: This is a bit of a patch for now, maybe come up with a larger solution
deal_with_pipe <- function(x) {
  if ("%>%" %in% x$func) {
    x <- x[x$func != "%>%", ]
    x <- tibble::add_row(x, func = "%>%", package = "magrittr")
  }
  return(x)
}
