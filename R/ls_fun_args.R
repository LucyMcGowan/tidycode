# List arguments in R call
#
# @param x an R call
#
# @return List, all arguments in an R call
#
# @examples
# ls_fun_args(quote(lm(mpg ~ cyl, mtcars)))
ls_fun_args <- function (x) {
  if (is.function(x)) {
    c(ls_fun_args(formals(x)), ls_fun_args(body(x)))
  }
  else if (is.call(x)) {
    args <- as.list(x[-1])
    c(list(args), unlist(lapply(x[-1], ls_fun_args), use.names = FALSE, recursive = FALSE))
  }
}
