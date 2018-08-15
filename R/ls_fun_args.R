#' List arguments in R call
#'
#' @param x an R call
#'
#' @return List, all arguments in an R call
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' ls_fun_args(expr[[3]])
#' matahari::dance_remove()
ls_fun_args <- function (x) {
  if (is.function(x)) {
    c(fun_args(formals(x)), fun_args(body(f)))
  }
  else if (is.call(x)) {
    args <- as.list(x[-1])
    c(list(args), unlist(lapply(x[-1], fun_args), use.names = FALSE, recursive = FALSE))
  }
}
