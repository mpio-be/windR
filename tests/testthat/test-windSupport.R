context('windSupport')

test_that('windSupport is double', {

  expect_type( windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5),  'double' )

})













