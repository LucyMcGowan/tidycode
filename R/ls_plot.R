#' List plots
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of plot calls during matahari session.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' plot(mtcars$mpg)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' ls_plots(expr)
#' matahari::dance_remove()
ls_plots <- function(x) {
  if (is.call(x)) {
    x <- deparse(x)
  }
  plots <- x[is_plot(x)]
  unique(as.character(plots))
}
