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
#' purrr::map_lgl(expr, is_pipe)
#' matahari::dance_remove()
#'
is_pipe <- function(x) {
  if (class(x) %in% c("call", "<-")) {
    x <- pryr::fun_calls(x)
    return(any(x == "%>%"))
  } else FALSE
}
