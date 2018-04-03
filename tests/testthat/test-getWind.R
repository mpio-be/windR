# context('getWind')
#
# # warning because of w[, .(x, y, u, v)] in rasterFromXYZ, but I don't know why,
# # something to do with: http://lists.r-forge.r-project.org/pipermail/datatable-commits/2014-May/001255.html
#
# require(data.table)
# require(magrittr)
# require(raster)
# assignInNamespace('cedta.override', c(data.table:::cedta.override,'windR'), 'data.table')
#
# # Example data
# # Load example wind data
# PROJ = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '
# wind_data = system.file('ERA_Interrim', 'ERA_Interrim_850mb_4_7_June_2014_10km.RDS', package = 'windR')
# w = readRDS(wind_data) %>% data.table
#
# # Create example points within the boarders of the wind data (space and time)
# w1 = w[datetime_ == unique(w$datetime_[1])]
# wp = sp::SpatialPoints(cbind(w1$x, w1$y), proj4string = sp::CRS(PROJ))
# datBdry = rgeos::gEnvelope(wp)
#
# ext   = raster::extent(datBdry)
# x_ext = seq(ext[1], ext[2])
# y_ext = seq(ext[3], ext[4])
#
# x = sample(x_ext, 1, replace=TRUE)
# y = sample(y_ext, 1, replace=TRUE)
#
# w = w[datetime_ == as.POSIXct('2014-06-06 23:00:00 CEST'), .(x, y, u, v)]
#
#
# # complete function working
# gw = getWind(x = x, y = y, w = w, PROJ)
#
# test_that('getWind is list', {
#
#   expect_type( gw,  'list' )
#
# })
#
#
# # steps working
# wpx = raster::rasterFromXYZ(w, crs = PROJ)
# Pxy = sp::SpatialPoints(cbind(x, y), proj4string = sp::CRS(PROJ))
# o   = extract(wpx, Pxy)
#
# test_that('getWind parts are what they should be', {
#
#   expect_s4_class( wpx, 'BasicRaster' )
#   expect_s4_class( Pxy, 'SpatialPoints' )
#   expect_type( o, 'double' )
#
# })
#
#
# # Warning has something to do with this:
# # > wpx = raster::rasterFromXYZ(w, crs = PROJ)
# # Error in if (xn == xx) { : missing value where TRUE/FALSE needed
# #   In addition: Warning messages:
# #     1: In matrix(as.numeric(xyz), ncol = ncol(xyz), nrow = nrow(xyz)) :
# #     NAs introduced by coercion
# #   2: In min(dx) : no non-missing arguments to min; returning Inf
# #   3: In min(x) : no non-missing arguments to min; returning Inf
# #   4: In max(x) : no non-missing arguments to max; returning -Inf
#
