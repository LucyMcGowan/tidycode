#' Unnest R calls
#'
#' @param .data A data frame
#' @param input Input column that contains an R call or list of R calls to be
#'   split into individual functions
#' @param drop `logical`. Whether the original input column should be dropped.
#'
#' @return The original data frame with an additional three columns:
#'  * `line`: the line number of the call
#'  * `func`: the name of the function called
#'  * `args`: a list of arguments
#' @export
#'
#' @examples
#' d <- read_rfiles(tidycode_example("example_plot.R"))
#'
#' # Unnest a model call
#' d %>%
#'   unnest_calls(expr)
#'
#' # Unnest a model call and keep the call itself using the drop parameter
#' d %>%
#'   unnest_calls(expr, drop = FALSE)
unnest_calls <- function(.data, input, drop = TRUE) {
  x <- .data[[rlang::quo_name(rlang::enquo(input))]]
  if (is.character(x)) {
   x <- purrr::map(x, safe_parse)
  }
  d <- .unnest_calls(x)
  tbl <- .data[d$line, ]
  tbl <- tibble::add_column(tbl, func = d$func)
  tbl <- tibble::add_column(tbl, args = d$args)
  tbl$line <- d$line
  if (drop) {
    tbl[[rlang::quo_name(rlang::enquo(input))]] <- NULL
  }
  tbl
}

.unnest_calls <- function(x, input) {
  if (!(is.list(x) | is.call(x) | is.name(x))) {
    stop(glue::glue("The class of the `input` parameter must be one of the",
                    " following:",
                    "\n  * character vector",
                    "\n  * list containing R calls", sep = "\n"),
         call. = FALSE
    )
  }
  if (is.list(x)) {
    m <- purrr::map(x, .unnest_calls)
    line <- rep(1:length(m), times = purrr::map_dbl(m, nrow))
    d <- do.call(rbind, m)
    d$line <- line
  }
  if (is.call(x)) {
    c <-  ls_fun_calls(x)
    a <- ls_fun_args(x)
    d <- tibble::tibble(func = unlist(c),
                        args = rep(a, purrr::map_dbl(c, length)),
                        line = 1)
  }
  if (is.name(x)) {
    d <- tibble::tibble(func = as.character(x),
                        args = list(character(0)),
                        line = 1)
  }
  return(d)
}

safe_parse <- purrr::possibly(rlang::parse_expr, NULL)
