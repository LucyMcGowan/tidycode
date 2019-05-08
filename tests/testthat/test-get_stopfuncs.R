context("test-get_stopfuncs")

test_that("get stopfuncs works", {
  d <- get_stopfuncs()
  expect_s3_class(d, "tbl_df")
})
