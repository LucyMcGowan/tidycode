#' List packages
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of packages called.
#' @export
#'
#' @examples
#' ls_packages(
#'   list(
#'     quote(library(tidycode)),
#'     quote(library(purrr)))
#'   )
ls_packages <- function(x) {
  if (is.call(x)) {
    x <- deparse(x)
  }
  packages <- x[is_package(x)]
  unique(
    trimws(
      gsub("library\\(|require\\(|\\)|\\\"|\\\'|::(.*)|.*<-", "", packages)
    )
  )
}
