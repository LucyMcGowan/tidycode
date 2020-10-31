context("test-load_packages")

test_that("load packages fails if package isn't installed", {
  expect_error(load_packages(quote(library(thisisatotallyfakepackage))))
})
