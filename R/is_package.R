#' Check if an expression is loading an R package
#'
#' @param x an R expression
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' library(tidycode)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' purrr::map_lgl(expr, is_package)
#' matahari::dance_remove()

is_package <- function(x) {
  if (class(x) %in% c("call", "<-")) {
    x <- pryr::fun_calls(x)
    return(any(x %in% c("library", "require")))
  } else FALSE
}


