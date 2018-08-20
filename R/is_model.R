#' Check if an expression is calling a model function
#'
#' @param x an R call or list of R calls
#'
#' @return logical
#' @export
#'
#' @examples
#' matahari::dance_start()
#' m <- lm(mpg ~ cyl, mtcars)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' is_model(expr)
#' matahari::dance_remove()

is_model <- function(x) {
  if(is.list(x)) {
    return(purrr::map_lgl(x, is_model))
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
    return(any(x %in% .tidycode$model_tbl$model_fx))
  } else FALSE
}


