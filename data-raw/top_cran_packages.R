library(cranlogs)
library(adjustedcranlogs)

cran <- read_csv("inst/extdata/cran_packages.csv")

pull_pkg_count <- function(start, end) {
  x <- cran_downloads(cran$cran_packages[start:end], from = "2018-01-01", to = "last-day")
  x %>%
    group_by(package) %>%
    summarise(count = sum(count))
}

start_end <- tibble(
  start = seq(1, 14449, by = 500),
  end = c(seq(500, 14449, by = 500), 14449)
)

df <- map2_df(start_end$start, start_end$end, pull_pkg_count)

df %>%
  arrange(desc(count)) %>%
  head(1000)

fun_df <- read_csv("inst/extdata/namespace_tbl.csv")

df %>%
  arrange(desc(count)) %>%
  head(1000) %>%
  mutate(rank = 1:n()) %>%
  left_join(fun_df) %>%
  group_by(package) %>%
  filter(all(is.na(func)), namespace_directive == "export_methods")


namespace_tbl_1000 <- df %>%
  arrange(desc(count)) %>%
  select(-count) %>%
  head(1000) %>%
  left_join(fun_df)

write_csv(namespace_tbl_1000, "inst/extdata/namespace_tbl_1000.csv")
