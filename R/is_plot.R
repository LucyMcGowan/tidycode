#' Check if an expression is calling a plot function
#'
#' @param x an R call or list of R calls
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' plot(1:10)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' is_plot(expr)
#' matahari::dance_remove()

is_plot <- function(x) {
  if(is.list(x) | (is.character(x) & length(x) > 1)) {
    return(purrr::map_lgl(x, is_plot))
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
  }
  any(x %in% .tidycode$plot_tbl$plot_fx)
}

