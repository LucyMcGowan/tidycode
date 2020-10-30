#' Get Package Functions
#'
#' Loads all packages called in a list of R calls and creates a data frame of
#' all functions included in these packages. Packages that were not previously
#' loaded that are loaded as part of this call will be detached.
#'
#' @param x an R call or list of R calls
#'
#' @return a data frame with the following columns:
#'  * `package`: The name of the package
#'  * `func`: The name of the function
#' @export
#'
#' @examples
#' get_package_functions(
#'   list(
#'     quote(library(tidycode)),
#'     quote(library(purrr))
#'   )
#' )
get_package_functions <- function(x) {
  current_pkgs <- .packages()
  load_packages(x)
  pkgs <- .packages()
  funcs <- purrr::map(pkgs, ~ls(glue::glue("package:{.x}")))
  unload_pkgs <- pkgs[!(pkgs %in% current_pkgs)]
  suppressWarnings(
    purrr::walk(unload_pkgs, ~detach(glue::glue("package:{.x}"),
                                     character.only = TRUE,
                                     unload = TRUE,
                                     force = TRUE))
  )
  tibble::tibble(
    package = rep(pkgs, times = purrr::map_dbl(funcs, length)),
    func = unlist(funcs)
  )
}
