library(tidyverse)
## data from lucy.shinyapps.io/classify
d <- read_csv("data-raw/2019-03-14_classify-data.csv")

safe_parse <- possibly(rlang::parse_expr, NULL)
safe_unnest <- possibly(unnest_calls,
                        otherwise = tibble(func = NA_character_, args = NA_character_, line = NA_real_))

get_funcs <- function(x) {
  safe_unnest(x)$func
}
classes <- tibble(
  expr =  map(d$code, safe_parse),
  class = d$class)

classes <- classes %>%
  filter(!map_lgl(expr, is.null),
         !map_lgl(expr, ~ all(is.na(.x))),
         !map_lgl(expr, is.character),
         !map_lgl(expr, is.numeric))


classification_tbl <- tibble(
  func = map(classes$expr, get_funcs),
  classification = classes$class) %>%
  unnest(func)  %>%
  filter(classification != "not sure") %>%
  group_by(func, classification) %>%
  summarise(n = n()) %>%
  mutate(score = n / sum(n)) %>%
  select(- n) %>%
  arrange(func, - score)

write_csv(classification_tbl, "inst/extdata/classification_tbl.csv")
