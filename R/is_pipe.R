is_pipe <- function(x) {
  if (is.list(x) | (is.character(x) & length(x) > 1)) {
    return(purrr::map_lgl(x, is_pipe))
  }
  if (is.call(x)) {
    x <- pryr::fun_calls(x)
  }
  any(x == "%>%")
}
