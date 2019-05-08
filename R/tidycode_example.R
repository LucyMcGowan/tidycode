#' Get path to example file
#'
#' tidycode comes bundled with a few small files to use in examples. This
#' function makes them easy to access.
#'
#' @param path Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' tidycode_example()
#' tidycode_example("example_plot.R")
tidycode_example <- function(path = NULL) {
  if (is.null(path)) {
    list.files(
      system.file("extdata", package = "tidycode"),
      pattern = "example"
    )
  } else {
    system.file("extdata", path, package = "tidycode", mustWork = TRUE)
  }
}
