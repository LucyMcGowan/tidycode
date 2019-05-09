context("test-tidycode_example")

test_that("tidycode example outputs all examples if input is null", {
  expect_equal(tidycode_example(),
               c("example_analysis.R",
                 "example_plot.R"))
})
