#' Unnest an R call
#'
#' @param x an R call
#' @param remove_assign logical, indicating whether to remove the assignment
#' portion of the call, default = `FALSE`.
#'
#' @return a list of the unnested R call
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' unnest_call(expr[[3]])
#' unnest_call(expr[[3]], remove_assign = TRUE)
#' matahari::dance_remove()

unnest_call <- function(x, remove_assign = FALSE) {
  if (remove_assign) {
    return(remove_assign(x))
  }
  .unnest_call(x)
}

remove_assign <- function(x) {
  if (inherits(x, "<-")) {
    x <- .unnest_call(x)[[3]]$outer
  }
  .unnest_call(x)
}

.unnest_call <- function(x) {
  stopifnot(class(x) %in% c("call", "<-"))
  purrr::map(1:length(x), ~ list(outer = x[[.x]], inner = x[-1:-.x]))
}

