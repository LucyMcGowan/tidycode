library(tidyverse)

## Haven't figured out what to do with "exportPattern"
## Currently there are 14,449 repos on CRAN (don't know how to pull this number from API?)

n <- 14500
pages <- 1:(n / 100)
get_repos <- function(page) {
  repos <- gh::gh("/users/:username/repos",
    username = "cran",
    per_page = 100,
    page = page
  )
  map_chr(repos, "name")
}

repos <- unlist(map(pages, get_repos))

tibble(
  cran_packages = repos
) %>%
  write_csv("inst/extdata/cran_packages.csv")

get_namespace <- function(repo) {
  safe_gh <- purrr::possibly(gh::gh, NULL)
  d <- safe_gh("/repos/:owner/:repo/contents/:path",
    owner = "cran",
    repo = repo,
    path = "NAMESPACE"
  )
  if (is.null(d)) {
    return(
      list(
        repo = repo,
        namespace = NULL
      )
    )
  }

  b <- jsonlite::base64_dec(d$content)
  list(
    repo = repo,
    namespace = readBin(b, character())
  )
}

extract_namespace <- function(x, thing) {
  if (is.null(x)) {
    return(NA_character_)
  }
  str <- stringr::str_extract_all(x, glue::glue("{thing}\\((?:([^\\)]*)(?:[^\\)]|$))\\)"))
  if (length(str[[1]]) == 0) {
    return(NA_character_)
  }
  str <- stringr::str_remove_all(
    unlist(str),
    glue::glue("\\n|\\\"| |{thing}\\(|\\)")
  )
  if (thing == "S3method") {
    return(gsub(",", ".", str))
  }
  unlist(stringr::str_split(str, ","))
}

get_namespace_tbl <- function(repo, verbose = TRUE) {
  d <- get_namespace(repo)
  if (verbose) {
    message(glue::glue("Got repo: {repo}"))
  }

  list(
    export_methods = extract_namespace(d$namespace, "exportMethods"),
    export_classes = extract_namespace(d$namespace, "exportClasses"),
    export = extract_namespace(d$namespace, "export"),
    s3_methods = extract_namespace(d$namespace, "S3method")
  ) %>%
    enframe("namespace_directive", "func") %>%
    unnest() %>%
    mutate(package = d$repo)
}

slowly <- function(f, delay = 0.75) {
  function(...) {
    Sys.sleep(delay)
    f(...)
  }
}

namespace_tbl <- map_df(repos, slowly(get_namespace_tbl))

write_csv(namespace_tbl, "inst/extdata/namespace_tbl.csv")

## make sure the ones with all NAs didn't just hit a rate limit
## or something
# check <- namespace_tbl %>%
#   group_by(package) %>%
#   filter(all(is.na(func))) %>%
#   pull(package) %>%
#   unique()
#
# checked <- map_df(check, get_namespace_tbl)
#
# test <- checked %>%
#   group_by(package) %>%
#   filter(all(is.na(func))) %>%
#   pull(package) %>%
#   unique()
## looks good!

## Pull all .R files for packages that don't export anything.

get_export_pattern <- function(repo, verbose = TRUE) {
  d <- get_namespace(repo)
  if (verbose) {
    message(glue::glue("Got repo: {repo}"))
  }

  tibble::tibble(
    repo = repo,
    export_pattern = extract_namespace(d$namespace, "exportPattern")
  )
}



check_export_pattern <- namespace_tbl %>%
  filter(namespace_directive == "export", is.na(func)) %>%
  pull(package)

export_pattern_tbl <- map_df(check_export_pattern, get_export_pattern)


many <- export_pattern_tbl %>%
  filter(!is.na(export_pattern)) %>%
  distinct() %>%
  group_by(repo) %>%
  filter(n() > 1)

export_pattern_repos <- export_pattern_tbl %>%
  filter(!is.na(export_pattern)) %>%
  pull(repo) %>%
  unique()

get_r_paths <- function(repo) {
  safe_gh <- purrr::possibly(gh::gh, NULL)
  d <- safe_gh("/repos/:owner/:repo/contents/:path",
    owner = "cran",
    repo = repo,
    path = "R"
  )
  tibble::tibble(
    repo = repo,
    path = map_chr(d, "path")
  )
}

r_paths <- map_df(export_pattern_repos, get_r_paths)

map2(d$repo, d$path, ~ gh::gh("/repos/:owner/:repo/contents/:path",
  owner = "cran",
  repo = .x,
  path = .y
))
