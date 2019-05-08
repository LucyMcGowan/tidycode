context("test-read_rfiles")

test_that("reading R files into tidy data frame works", {
  d <- read_rfiles(tidycode_example("example_plot.R"))
  expect_s3_class(d, "tbl_df")
  expect_equal(colnames(d), c("file", "expr", "line"))
})

test_that("reading R files fails if file does not exist", {
  expect_error(read_rfiles("foo.R"), "The following")
})
