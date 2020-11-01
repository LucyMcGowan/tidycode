context("test-get_package_functions")

test_that("get_package_functions fails if package isn't installed", {
  expect_error(get_package_functions(quote(library(thisisatotallyfakepackage))))
})

