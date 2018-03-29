context('alphaAlong and sizeAlong')


test_that('Along is double', {

  expect_type( alphaAlong(1:100, head = 20, skew = -2),  'double' )
  expect_type( sizeAlong(1:100, head = 70, to = c(0.1, 5)),  'double' )

})

test_that('Along is in expected range', {

  expect_lt( max(alphaAlong(1:100, head = 20, skew = -2)), 1.1 )
  expect_gt( min(alphaAlong(1:100, head = 20, skew = -2)), 0 )
  expect_lt( max(sizeAlong(1:100, head = 70, to = c(0.1, 5))), 5.1 )
  expect_gt( min(sizeAlong(1:100, head = 70, to = c(0.1, 5))), 0 )

})

