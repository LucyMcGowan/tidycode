context("test-is_package")

test_that("catches packages", {
  expect_true(is_package(quote(library(tidycode))))
  expect_true(all(is_package(c(quote(library(tidycode)),
                               quote(library(matahari)))))
  )
  expect_true(is_package("library(tidycode)"))
  expect_false(is_package("library"))
  expect_false(is_package(quote(lm(mpg ~ cyl, mtcars))))
  expect_false(is_package(quote(lm(library ~ chicken))))
  expect_false(is_package(1))
})

