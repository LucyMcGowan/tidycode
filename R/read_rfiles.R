#' Read R file(s) as a tidy data frame
#'
#' @param ... One or more quoted R file paths to read
#'
#' @return A tidy data frame, a `tbl_df`, with one row per R call. There will be three columns,
#'   * `file`: the path of the original R file
#'   * `expr`: the R call
#'   * `line`: the line of the R call
#' @export
#'
#' @examples
#' d <- read_rfiles(
#'   tidycode_example("example_plot.R"),
#'   tidycode_example("example_analysis.R")
#' )
read_rfiles <- function(...) {

  files <- list(...)
  files <- purrr::flatten(files)
  urls <- files[purrr::map_lgl(files, is_url)]

  if (!is.null(urls)) {
    url_files <- purrr::map(urls, handle_url)
  }

  file_paths <- files
  file_paths[purrr::map_lgl(files, is_url)] <- url_files

  if (!all(check_r(files))) {
    stop(glue::glue("All files must be .R files.",
                    "\nYou are trying to read the following files:",
                    "\n * {glue::glue_collapse(files, sep = '\n * ')}"),
         call. = FALSE
    )
  }

  if (!all(file.exists(unlist(file_paths)))) {
    stop(glue::glue("The following file(s) do not exist:",
                    "\n * {glue::glue_collapse(files[!file.exists(unlist(file_paths))],
                    sep = '\n * ')}"),
         call. = FALSE
    )
  }
  d <- purrr::map2(file_paths, files, get_expr)
  d <- do.call(rbind, d)
  d
}

get_expr <- function(x, y) {
  d <- tibble::tibble(
    file = y,
    expr = matahari::dance_recital(x, evaluate = FALSE)[['expr']]
  )
  d$line <- 1:nrow(d)
  d
}

handle_url <- function(x) {
  x <- url(x)
  on.exit(close(x))
  open(x, "rb")
  r <- readLines(x)
  tmp <- tempfile()
  path <- glue::glue("{tmp}.R")
  writeLines(r, path)
  path
}

check_r <- function(x) {
  if (is.list(x)) {
    purrr::map(x, check_r)
  }
  grepl("*.r$", x, ignore.case = TRUE)
}

is_url <- function(path) {
  grepl("^((http|ftp)s?|sftp)://", path)
}
