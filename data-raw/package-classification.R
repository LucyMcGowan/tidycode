library(tidyverse)


## Crowdsourced classification: data from lucy.shinyapps.io/classify ----

d <- read_csv("data-raw/2019-03-14_classify-data.csv")

safe_parse <- possibly(rlang::parse_expr, NULL)

classes <- tibble(
  calls = map(d$code, safe_parse),
  classification = d$class
)

classes <- classes %>%
  filter(
    !map_lgl(calls, is.null),
    !map_lgl(calls, ~ all(is.na(.x))),
    !map_lgl(calls, is.character),
    !map_lgl(calls, is.numeric)
  )


crowdsource_classification_tbl <- classes %>%
  unnest_calls(calls) %>%
  filter(classification != "not sure") %>%
  group_by(func, classification) %>%
  summarise(n = n()) %>%
  mutate(score = n / sum(n)) %>%
  ungroup() %>%
  select(-n) %>%
  arrange(func, -score)

write_csv(crowdsource_classification_tbl, "inst/extdata/crowdsource_classification_tbl.csv")

## Leek lab classification ----

library(googlesheets)

id <- "1I_jcI_qQRnT642McsJf1a666DpUdwmZsXr0cIZ2-RH0"
d <- gs_read(gs_key(id, lookup = TRUE))

d <- d[, 1:9]
colnames(d) <- c(
  "time", "url", "setup", "exploratory", "cleaning",
  "modeling", "evaluation", "other", "analysis"
)
cleanup <- function(x) {
  x <- unlist(strsplit(x, ","))
  trimws(x)
}
d <- d %>%
  filter(analysis == "Yes")

leeklab_classification_tbl <- tibble::tibble(
  classification = "setup",
  func = cleanup(d$setup),
) %>%
  add_row(
    classification = "exploratory",
    func = cleanup(d$exploratory)
  ) %>%
  add_row(
    classification = "data cleaning",
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
  mutate(score = n / sum(n)) %>%
  ungroup() %>%
  select(-n) %>%
  arrange(func, -score)

write_csv(leeklab_classification_tbl, "inst/extdata/leeklab_classification_tbl.csv")


classification_tbl <-
  bind_rows(list(
    crowdsource = crowdsource_classification_tbl,
    leeklab = leeklab_classification_tbl
  ),
  .id = "lexicon"
  )

write_csv(classification_tbl, "inst/extdata/classification_tbl.csv")
