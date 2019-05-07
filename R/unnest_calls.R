#' Unnest R calls
#'
#' @param x an R call or list of R calls
#' @param drop `logical`. Whether the original input R call(s) should be dropped.
#'
#' @return a tibble of the unnested R calls with three columns: `line`: the line number of the call
#'  (if a list was supplied), `func`: the name of the function called, `args`: a list of arguments
#' @export
#'
#' @examples
#' # Unnest a model call
#' unnest_calls(quote(lm(mpg ~ cyl, mtcars)))
#'
#' # Unnest a model call and keep the call itself using the drop parameter
#' unnest_calls(quote(lm(mpg ~ cyl, mtcars)), drop = FALSE)
unnest_calls <- function(x, drop = TRUE) {
  d <- .unnest_calls(x)
  if (!drop) {
    if (!is.list(x)) {
      x <- list(x)
      }
    x <- rep(x,
             times = stats::aggregate(d$line,
                               by = list(line = d$line),
                               FUN = length)$x
             )
    d$call <- x
  }
  d
}

.unnest_calls <- function(x) {
  if (is.list(x)) {
    m <- purrr::map(x, unnest_calls)
    line <- rep(1:length(m), times = purrr::map_dbl(m, nrow))
    d <- do.call(rbind, m)
    d$line <- line
  }
  if (is.call(x)) {
    c <-  ls_fun_calls(x)
    a <- ls_fun_args(x)
    d <- tibble::tibble(func = unlist(c),
                        args = rep(a, purrr::map_dbl(c, length)),
                        line = 1)
  }
  if (is.name(x)) {
    d <- tibble::tibble(func = as.character(x),
                        args = list(character(0)),
                        line = 1)
  }
  return(d)
}
