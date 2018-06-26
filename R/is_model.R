#' Check if value is of a model class
#'
#' @param x value of R expression
#'
#' @return logical
#' @export
#'
#' @examples
#' val <- matahari::dance_tbl()$value
#' purrr::map_lgl(val, is_model)

is_model <- function(x) {
  any(class(x) %in% c("lm", "glm", "train", "recipe", "lme4"))
}


