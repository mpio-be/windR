context('pointCircle')

assignInNamespace('cedta.override', c(data.table:::cedta.override,'windR'), 'data.table')

# Example data
x        = 10
y        = 10
x2       = 100
y2       = 600
pointN   = 36
PROJ     = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '


# complete function working
dp = pointCircle(x, y, x2, y2, pointN = 36, PROJ)


test_that('pointCircle is list', {

  expect_type( dp,  'list' )

})



# steps working
lon  = x
lat  = y
lon2 = x2
lat2 = y2

P_dist = sqrt(sum((c(lon, lat) - c(lon2, lat2))^2))
PS  = sp::SpatialPointsDataFrame( cbind(lon,lat), data.frame(pointType = 'real'), proj4string = sp::CRS(PROJ), match.ID = TRUE)
PS2 = sp::SpatialPointsDataFrame(cbind(lon2,lat2), data.frame(pointType = 'real'), proj4string = sp::CRS(PROJ), match.ID = TRUE )
PS_buffer = rgeos::gBuffer(PS, width = P_dist, quadsegs = 10)
PS_line = as(PS_buffer, "SpatialLines")
PS_points = sp::spsample(PS_line, n = pointN, type = 'regular')


test_that('pointCircle parts are what they should be', {

  expect_s4_class( PS, 'SpatialPointsDataFrame' )
  expect_s4_class( PS2, 'SpatialPointsDataFrame' )
  expect_s4_class( PS_buffer, 'SpatialPolygons' )
  expect_s4_class( PS_line, 'SpatialLines' )
  expect_s4_class( PS_points, 'SpatialPoints' )

})

