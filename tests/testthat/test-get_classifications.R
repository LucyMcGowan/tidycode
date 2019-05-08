context("test-get_classifications")

test_that("get classifications from leeklab", {
  d <- get_classifications("leeklab")
  expect_equal(nrow(d), 642)
  expect_equal(ncol(d), 3)
  expect_equal(colnames(d), c("func", "classification", "score"))
})

test_that("get classifications from crowdsource", {
  d <- get_classifications("crowdsource")
  expect_equal(nrow(d), 3539)
  expect_equal(ncol(d), 3)
  expect_equal(colnames(d), c("func", "classification", "score"))
})

test_that("get classifications drop duplicates", {
  d <- get_classifications(include_duplicates = FALSE)
  expect_equal(colnames(d), c("lexicon", "func", "classification"))
})
