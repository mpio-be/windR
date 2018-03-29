context('windSupport')



test_that('windSupport is double', {

  expect_type( windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5),  'double' )
  expect_type( windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5, crosswind = TRUE),  'double' )

})

test_that('windSupport gives correct wind support and crosswind', {

  expect_equal( windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5),  2.701512, tolerance = .000001 )
  expect_equal( windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5, crosswind = TRUE),  4.207355, tolerance = .000001 )
  expect_output( windSupport(g_direction = NA, g_speed = 15, w_direction = 1, w_speed = 5), NA)
  expect_output( windSupport(g_direction = NA, g_speed = 15, w_direction = 1, w_speed = 5, crosswind = TRUE), NA)

})












