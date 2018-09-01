#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom purrr %>%
#' @usage lhs \%>\% rhs
NULL

.tidycode <- new.env(parent = emptyenv())

.tidycode$plot_tbl <-
  system.file("extdata", "plot_tbl.csv", package = "tidycode") %>%
  read.csv(stringsAsFactors = FALSE) %>%
  tibble::as_tibble()

.tidycode$model_tbl <-
  system.file("extdata", "model_tbl.csv", package = "tidycode") %>%
  read.csv(stringsAsFactors = FALSE) %>%
  tibble::as_tibble()

.tidycode$cran_tbl <-
  system.file("extdata", "namespace_tbl_1000.csv", package = "tidycode") %>%
  read.csv(stringsAsFactors = FALSE) %>%
  tibble::as_tibble()

.tidycode$classification_tbl <-
  system.file("extdata", "classification_tbl.csv", package = "tidycode") %>%
  read.csv(stringsAsFactors = FALSE) %>%
  tibble::as_tibble()
