#' List models
#'
#' @param x list of R calls
#'
#' @return Character. Vector of unique models called during matahari session.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' matahari::dance_remove()
ls_models <- function(x) {
  models <- x[purrr::map_lgl(x, is_model)]
  unique(as.character(models))
}
