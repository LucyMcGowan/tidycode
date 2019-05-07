#' Get a tidy data frame of classifications of all functions used in your analysis
#'
#' @param func_names Character vector of the names of all functions used in
#' analysis. If `NULL`, will return the full data frame of all classified functions.
#' @param include_duplicates Logical. Indicates whether to include all functions
#' and classifications along with their score (default, `TRUE`) - this may
#' result in multiple lines (with multiple classifications) for a single function.
#' If `FALSE`, the most prevalent classification will be selected.
#'
#' @return If `include_duplicates = TRUE`, tibble with four columns,
#' `classification` and `func`, `score`.
#' If `include_duplicates = FALSE`, tibble with two columns, `classification` and
#' `func`.
#'
#' @examples
#' # Get a data frame of all classifications
#' get_classifications()
#'
#' # Get a data frame of the most prevalent classifications
#' get_classifications(include_duplicates = FALSE)
#' @export
get_classifications <- function(func_names = NULL, include_duplicates = TRUE) {
  if (include_duplicates) {
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


