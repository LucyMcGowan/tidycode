context("test-ls_packages")

test_that("listing packages from list of calls works", {
  pkgs <- ls_packages(list(
    quote(library(tidycode)),
    quote(library(chicken)),
    quote(foo::bar),
    quote(lm(mpg ~ cyl, mtcars)))
  )
  expect_equal(pkgs, c("tidycode", "chicken", "foo"))
})

test_that("listing packages from data frame works", {
  d <- read_rfiles(tidycode_example("example_plot.R"))
  pkgs <- ls_packages(d$expr)
  expect_equal(pkgs, "tidyverse")
})

test_that("can list packages from an individual call", {
  expect_equal(ls_packages(quote(library(tidycode))), "tidycode")
})
