#' List packages
#'
#' @param x an R call or list of R calls
#'
#' @return Character. Vector of packages called.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' library(tidycode)
#' expr <- matahari::dance_tbl()$expr
#' ls_packages(expr)
#' matahari::dance_remove()
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
