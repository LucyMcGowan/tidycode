#' Create a tibble of classifications of all functions used in your analysis
#'
#' @param func_names Character vector of the names of all functions used in analysis. If `NULL`,
#' will return the full data frame of all classified functions.
#'
#' @return Tibble with two columns, `classification` and `func`
#' @export
get_classification_tbl <- function(func_names = NULL) {
  if (is.null(func_names)) {
    return(.tidycode$classification_tbl)
  }
  .tidycode$classification_tbl[.tidycode$classification_tbl$func %in% func_names, ]
}
