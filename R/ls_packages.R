#' List packages
#'
#' @param x list of R calls
#'
#' @return Character. Vector of packages called during matahari session.
#' @export
#'
#' @examples
#' matahari::dance_start()
#' library(tidycode)
#' matahari::dance_stop()
#' expr <- matahari::dance_tbl()$expr
#' matahari::dance_remove()
ls_packages <- function(x) {
  packages <- x[purrr::map_lgl(x, is_package)]
  gsub("library\\(|require\\(|\\)|\\\"|\\\'", "", packages)
}
