#' List functions in R call
#'
#' @param x an R call or list of R calls
#'
#' @return Character, all functions in an R call
#' @export
#'
#' @examples
#' ls_fun_calls(quote(lm(mpg ~ cyl, mtcars)))
ls_fun_calls <- function (x) {
  if (is.function(x)) {
    c(ls_fun_calls(formals(x)), ls_fun_calls(body(x)))
  }
  else if (is.call(x)) {
    fname <- as.character(x[[1]])
    c(list(fname), unlist(lapply(x[-1], ls_fun_calls), use.names = FALSE, recursive = FALSE))
  }
}
