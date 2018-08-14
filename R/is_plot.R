#' Check if an expression is calling a plot function
#'
#' @param x an R call
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' plot(1:10)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' purrr::map_lgl(expr, is_plot)
#' matahari::dance_remove()

is_plot <- function(x) {
  if (class(x) %in% c("call", "<-")) {
    x <- pryr::fun_calls(x)
    return(any(x %in% .tidycode$plot_tbl$plot_fx))
  } else FALSE
}

