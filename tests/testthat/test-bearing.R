context('bearing')


test_that('bearing is double', {

  expect_type( bearing(x = 0, y = 0, x2 = 2, y2 = 2),  'double' )

})

test_that('bearing is between -pi/2 and pi/2', {

  expect_lt( bearing(x = 0, y = 0, x2 = 2, y2 = 2),  pi/2 )
  expect_gt( bearing(x = 0, y = 0, x2 = 2, y2 = 2),  -pi/2 )

})















