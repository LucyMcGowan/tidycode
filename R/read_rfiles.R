#' Read R file(s) as a tidy data frame
#'
#' @param ... One or more quoted R file paths to read
#'
#' @return A tidy data frame, a `tbl_df`, with one row per R call. There will be three columns,
#'   * `file`: the path of the original R file
#'   * `expr`: the R call
#'   * `line`: the line of the R call
#' @export
#'
#' @examples
#' d <- read_rfiles(
#'   tidycode_example("example_plot.R"),
#'   tidycode_example("example_analysis.R")
#' )
read_rfiles <- function(...) {
  files <- list(...)
  d <- purrr::map(files, get_expr)
  d <- do.call(rbind, d)
  d
}

get_expr <- function(x) {
  d <- tibble::tibble(
    file = x,
    expr = matahari::dance_recital(x, evaluate = FALSE)[['expr']]
  )
  d$line <- 1:nrow(d)
  d
}
