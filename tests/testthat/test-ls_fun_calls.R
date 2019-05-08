context("test-ls_fun_calls")

test_that("ls_fun_calls works", {
  fun <- ls_fun_calls(quote(library(tidycode)))
  expect_equal(fun, list("library"))

  fun <- ls_fun_calls(quote(lm(mpg ~ cyl, mtcars)))
  expect_equal(fun, list("lm", "~"))
})
