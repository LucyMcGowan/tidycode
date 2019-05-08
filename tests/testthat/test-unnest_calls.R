context("test-unnest_calls")

test_that("errors if given the wrong type", {
  d <- tibble::tibble(x = 1:5)
  expect_error(unnest_calls(d, x),
               "The class of the `input` parameter must be")
  d <- tibble::tibble(x = list("library(tidycode)"))
  expect_error(unnest_calls(d, x),
               "The class of the `input` parameter must be")
})


test_that("works as expected for character vector", {
  d <- tibble::tibble(x = c("library(tidycode)", "lm(mpg ~ cyl, mtcars)"))
  expect_equal(unnest_calls(d, x)[1, 1, drop = TRUE], "library")
})

test_that("works as expected for .R file", {
  d <- read_rfiles(tidycode_example("example_plot.R"))
  expect_equal(unnest_calls(d, expr)[1, 3, drop = TRUE], "library")
})
