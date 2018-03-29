context('bCounter')


test_that('bCounter is integer', {

  expect_type( bCounter(c(rep(1, 5), rep(0, 2), rep(1, 4), rep(0, 2))),  'integer' )

})


test_that('bCounter in expected range', {

  expect_lt( max(bCounter(c(rep(1, 5), rep(0, 2), rep(1, 4), rep(0, 2)))), 5 )
  expect_gt( min(bCounter(c(rep(1, 5), rep(0, 2), rep(1, 4), rep(0, 2)))), 0 )

})


