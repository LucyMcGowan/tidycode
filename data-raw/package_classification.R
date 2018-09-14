library(googlesheets)
library(tidyverse)
id <- "1I_jcI_qQRnT642McsJf1a666DpUdwmZsXr0cIZ2-RH0"
d <- gs_read(gs_key(id, lookup = TRUE))

colnames(d) <- c("time", "url", "setup", "exploratory", "cleaning",
                 "modeling", "evaluation", "other", "analysis")
cleanup <- function(x) {
  x <- unlist(strsplit(x, ","))
  trimws(x)
}
d <- d %>%
  filter(analysis == "Yes")

classification_tbl <- tibble::tibble(
  classification = "setup",
  func = cleanup(d$setup),
) %>%
  add_row(
    classification = "exploratory",
    func = cleanup(d$exploratory)
  ) %>%
  add_row(
    classification = "cleaning",
    func = cleanup(d$cleaning)
  ) %>%
  add_row(
    classification = "modeling",
    func = cleanup(d$modeling)
  ) %>%
  add_row(
    classification = "evaluation",
    func = cleanup(d$evaluation)
  ) %>%
  filter(!is.na(func)) %>%
  group_by(func, classification) %>%
  summarise(n = n()) %>%
  mutate(prevalence = n / sum(n))
write_csv(classification_tbl, "inst/extdata/classification_tbl.csv")
