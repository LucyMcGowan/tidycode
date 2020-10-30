#' Load packages
#'
#' Loads all R packages in the list of R calls.
#'
#' @param x an R call or list of R calls
#'
#' @export
#'
#' @examples
#' load_packages(
#'   list(
#'     quote(library(tidycode)),
#'     quote(library(purrr))
#'   )
#' )
load_packages <- function(x) {
  pkgs <- ls_packages(x)
  invisible(lapply(pkgs, require, character.only = TRUE))
}
