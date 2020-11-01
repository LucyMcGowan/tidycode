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
  not_installed <- pkgs[!(pkgs %in% utils::installed.packages()[,"Package"])]
  if(length(not_installed) > 0) {
    stop_glue("Some of the packages in your call list have not been installed.\n",
              "Please install the following package before proceeding:\n",
              "{glue::glue_collapse(glue::glue(' * {not_installed}'), sep = '\n')}")
    } else {
    invisible(lapply(pkgs, require, character.only = TRUE))
  }
}
