#' Get a tidy data frame of a "stopword" lexicon for R functions
#'
#' Get a data frame listing one function per row.
#' @return A `tbl_df` with one column:
#'   * `func`: the function identified as a "stopword"
#'
#' @export
#'
#' @examples
#' get_stopfuncs()
get_stopfuncs <- function() {
  tibble::tibble(func = c(
    "%>%",
    "+",
    "-",
    "=",
    ":=",
    "*",
    "<-",
    "/",
    "%%",
    "%/%",
    "^",
    "~",
    "::",
    "$",
    "==",
    "[",
    "!=",
    "c",
    "&",
    ":",
    "(",
    ")",
    "{",
    "}",
    "[[",
    "!",
    ">",
    "<",
    ">=",
    "<="
    )
  )
}
