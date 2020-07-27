#' Get a tidy data frame of classifications of all functions used in your analysis
#'
#' @param lexicon Character. The classification lexicon to retrieve. Either
#'   "crowdsource" or "leeklab". If `NULL` (default), will return all lexicons.
#' @param include_duplicates Logical. Indicates whether to include all functions
#'   and classifications along with their score (default, `TRUE`) - this may
#'   result in multiple lines (with multiple classifications) for a single function.
#'   If `FALSE`, the most prevalent classification will be selected.
#'
#' @return A `tbl_df` with columns:
#'   * `func`: the function
#'   * `classification`: the classification
#'
#'   If `include_duplicates = TRUE`, will include a column:
#'   * `score`: the score
#'
#'   If `lexicon` is `NULL`, will include a column:
#'   * `lexicon`: the classification lexicon
#'
#' @examples
#' # Get a data frame of all classifications
#' get_classifications()
#'
#' # Get a data frame of the most prevalent classifications
#' get_classifications(include_duplicates = FALSE)
#'
#' # Get a data frame of only `leeklab` classifications
#' get_classifications("leeklab")
#' @export
get_classifications <- function(lexicon = NULL, include_duplicates = TRUE) {
  if (include_duplicates) {
    classification_tbl <- .tidycode$classification_tbl
  } else {
    classification_tbl <- .tidycode$classification_tbl[
      !duplicated(.tidycode$classification_tbl[, c("lexicon", "func")]), c("lexicon", "func", "classification")
    ]
  }
  if (is.null(lexicon)) {
    return(classification_tbl)
  }
  classification_tbl <- classification_tbl[classification_tbl$lexicon %in% lexicon, ]
  classification_tbl[["lexicon"]] <- NULL
  classification_tbl
}
