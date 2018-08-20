#' Check if an expression includes a pipe
#'
#' @param x an R call
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' mtcars$mpg %>% mean()
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' is_pipe(expr)
#' matahari::dance_remove()
#'
is_pipe <- function(x) {
  if (is.list(x)) {
    return(purrr::map_lgl(x, is_pipe))
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
    return(any(x == "%>%"))
  } else if (is.character(x)) {
    return(grepl("%>%", x))
  } else FALSE
}
