#' List functions in R call
#'
#' @param x an R call
#'
#' @return Character, all functions in an R call
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' ls_fun_calls(expr[[3]])
#' matahari::dance_remove()
ls_fun_calls <- function (x) {
  if (is.function(x)) {
    c(fun_calls(formals(x)), fun_calls(body(x)))
  }
  else if (is.call(x)) {
    fname <- as.character(x[[1]])
    c(fname, unlist(lapply(x[-1], fun_calls), use.names = FALSE))
  }
}
