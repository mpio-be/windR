context('closestDatetime')

# Example data
d1 = as.POSIXct("2014-06-09 21:44:25 CEST")
dt = as.POSIXct( c("2014-06-08 23:00:00 CEST", "2014-06-09 05:00:00 CEST", "2014-06-09 11:00:00 CEST", "2014-06-09 17:00:00 CEST",
                   "2014-06-09 23:00:00 CEST", "2014-06-09 23:00:00 CEST", "2014-06-10 11:00:00 CEST", "2014-06-10 17:00:00 CEST") )


test_that('closestDatetime is POSIXct', {

  expect_s3_class( closestDatetime(datetime_ = d1, datetimes = dt), 'POSIXct' )

})


test_that('closestDatetime is as expected', {

  expect_equal(closestDatetime(datetime_ = d1, datetimes = dt), as.POSIXct('2014-06-09 23:00:00 CEST') )

})

