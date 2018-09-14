#' Create a tibble of classifications of all functions used in your analysis
#'
#' @param func_names Character vector of the names of all functions used in
#' analysis. If `NULL`, will return the full data frame of all classified functions.
#' @param include_prevalence Logical. Indicates whether to include all functions
#' and classifications along with their prevalence (default, `TRUE`) - this may
#' result in multiple lines (with multiple classifications) for a single function.
#' If `FALSE`, the most prevalent classification will be selected.
#'
#' @return If `include_prevalence = TRUE`, tibble with four columns,
#' `classification` and `func`, `n`, `prevalence`.
#' If `include_prevalence = FALSE`, tibble with two columns, `classification` and
#' `func`.
#'
#' @export
get_classification_tbl <- function(func_names = NULL, include_prevalence = TRUE) {
  if (include_prevalence) {
    classification_tbl <- .tidycode$classification_tbl
  } else {
    classification_tbl <- .tidycode$classification_tbl[
      !duplicated(.tidycode$classification_tbl$func), c("func", "classification")
      ]
  }
  if (is.null(func_names)) {
    return(classification_tbl)
  }
  classification_tbl[classification_tbl$func %in% func_names, ]
}


