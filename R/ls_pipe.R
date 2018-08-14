#' List pipes
#'
#' @param x list of R calls
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
  pipes <- x[purrr::map_lgl(x, is_pipe)]
  unique(as.character(pipes))
}
