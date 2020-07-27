context("test-is_pipe")

test_that("the treachery of images", {
  expect_true(is_pipe(quote(`%>%`)))
  expect_true(is_pipe(quote(foo_foo %>% hopped())))
  expect_false(is_pipe(quote(hopped(foo_foo))))
})

test_that("the treachery of images, vectorized", {
  expect_true(all(
    is_pipe(c(
      quote(foo_foo %>% hopped()),
      quote(hopped %>% through_forest())
    ))
  ))
  expect_false(all(
    is_pipe(c(
      quote(hopped(foo_foo)),
      quote(hopped(through_forest))
    ))
  ))
})
