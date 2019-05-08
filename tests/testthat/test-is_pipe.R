context("test-is_pipe")

test_that("the treachery of images", {
  expect_true(is_pipe(quote(`%>%`)))
  expect_true(is_pipe(quote(foo_foo %>% hopped)))
  expect_false(is_pipe(quote(hopped(foo_foo))))
})
