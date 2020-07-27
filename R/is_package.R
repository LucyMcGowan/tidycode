# Check if an expression is loading an R package
#
# @param x an R call or list of R calls
#
# @return logical value or list of logical values
#
# @examples
# is_package(quote(library(tidycode)))
# is_package(quote(tidycode::is_package))
# is_package(
#   list(
#     quote(library(tidycode)),
#     quote(library(purrr)))
#   )

is_package <- function(x) {
  if (!(is.list(x) | is.character(x) | is.call(x))) {
    return(FALSE)
  }
  if (is.list(x) | (is.character(x) & length(x) > 1)) {
    return(purrr::map_lgl(x, is_package))
  }
  if (is.character(x)) {
    x <- rlang::parse_expr(x)
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
  }
  if (!is.character(x)) {
    return(FALSE)
  }
  any(x %in% c("library", "require", "::"))
}
