context("test-ls_fun_args")

test_that("extract function args", {
  args <- ls_fun_args(quote(library(tidycode)))
  expect_equal(unlist(args), list(quote(tidycode)))

  args <- ls_fun_args(quote(lm(mpg ~ cyl, mtcars)))
  expect_equal(args[[1]], list(quote(mpg ~ cyl), quote(mtcars)))
  expect_equal(args[[2]], list(quote(mpg), quote(cyl)))
})
