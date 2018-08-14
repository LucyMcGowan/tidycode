#' Check if an expression is calling a model function
#'
#' @param x an R call
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' purrr::map_lgl(expr, is_model)
#' matahari::dance_remove()

is_model <- function(x) {
  if (class(x) %in% c("call", "<-")) {
    x <- pryr::fun_calls(x)
    return(any(x %in% .tidycode$model_tbl$model_fx))
  } else FALSE
}


