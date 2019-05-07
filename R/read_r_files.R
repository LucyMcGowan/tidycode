read_r_files <- function(...) {
  files <- list(...)
  d <- purrr::map(files, get_expr)
  d <- do.call(rbind, d)
  d
}

get_expr <- function(x) {
  tibble::tibble(expr = matahari::dance_recital(x, evaluate = FALSE)[['expr']],
                 file = x)
}
