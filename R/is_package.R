#' Check if an expression is loading an R package
#'
#' @param x an R call or list of R calls
#'
#' @return logical value or list of logical values
#' @export
#'
#' @examples
#' is_package(quote(library(tidycode)))
#' is_package(quote(tidycode::is_package))
#' is_package(
#'   list(
#'     quote(library(tidycode)),
#'     quote(library(matahari)))
#'   )

is_package <- function(x) {
  if(is.list(x) | (is.character(x) & length(x) > 1)) {
    return(purrr::map_lgl(x, is_package))
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
  }
  any(x %in% c("library", "require", "::"))
}


