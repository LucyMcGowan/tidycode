#' List pipes
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of piped calls during matahari session.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' mtcars$mpg %>% mean()
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' matahari::dance_remove()
ls_pipes <- function(x) {
  if (is.call(x)) {
    x <- deparse(x)
  }
  pipes <- x[is_pipe(x)]
  unique(as.character(pipes))
}
