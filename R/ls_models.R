#' List models
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of unique models called during matahari session.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' ls_models(expr)
#' matahari::dance_remove()
ls_models <- function(x) {
  if (is.call(x)) {
    x <- deparse(x)
  }
  models <- x[is_model(x)]
  unique(as.character(models))
}
