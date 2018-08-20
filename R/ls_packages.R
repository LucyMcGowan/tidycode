#' List packages
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of packages called.
#' @export
#'
#' @examples
#' ls_packages(quote(library(tidyverse)))
ls_packages <- function(x) {
  if (is.call(x)) {
    x <- deparse(x)
  }
  packages <- x[is_package(x)]
  unique(
    gsub("library\\(|require\\(|\\)|\\\"|\\\'|::(.*)", "", packages)
  )
}
