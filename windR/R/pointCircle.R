
#' pointCircle
#'
#' This function caclulates the position of points in a circle around a start point. The circle is based on the distance of the second point that is provided. This allows for example to compare the the wind conditions in all directions.
#'
#' @param x
#' @param y
#' @param x2
#' @param y2
#' @param wind
#'
#' @return
#' @export
#'
#' @examples
#'


# Packages, settings
sapply(c('rgdal', 'RSQLite', 'magrittr', 'graticule', 'rgeos', 'ggplot2', 'raster', 'data.table', 'zoo', 'foreach'),
       function(x) suppressPackageStartupMessages(require(x , character.only = TRUE, quietly = TRUE) ) )

PROJ   = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '



# load tracking data
load('//ds/grpkempenaers/Hannes/sea_ice_flights/DATA/P_Speed.RData')

d = d[point_id == 1]
d = d[bird_patch_id == '42700_1']


PS = SpatialPointsDataFrame(d[, .(x,y)], d[, .(bird_patch_id, bird_id, patchid, datetime_)], proj4string = CRS(PROJ), match.ID = TRUE )


plot(PS)


PS[, dist       := sqrt(sum((c(x, y) - c(x2, y2))^2)) , by = 1:nrow(PS)]

Barrow250 = gBuffer(PS, width = 250000, quadsegs = 100)




windCircle = function(x, y, x2, y2, datetime_, TbtwPoints){

d = data.table( x = d$x,
                y = d$y,
               x2 = d$x2,
               y2 = d$y2,
               type = 'real',
               datetime_ = d$datetime_)



  # distance between points
  d[, dist       := sqrt(sum((c(x, y) - c(x2, y2))^2)) , by = 1:nrow(d)]

  PS = SpatialPointsDataFrame(d[, .(x,y)], d[, .(datetime_)], proj4string = CRS(PROJ), match.ID = TRUE )
  PS2 = SpatialPointsDataFrame(d[, .(x2,y2)], d[, .(datetime_)], proj4string = CRS(PROJ), match.ID = TRUE )

  PS_buffer = gBuffer(PS, width = d$dist, quadsegs = 10)

  PS_line = as(PS_buffer, "SpatialLines")

  PS_points = spsample(PS_line, n = 36, type = 'regular')

  dE = as.data.table(PS_points)



  d2 = data.table(x  = rep(d$x, nrow(dE)),
                  y  = rep(d$y, nrow(dE)),
                  x2 = dE$x,
                  y2 = dE$y,
                  type = rep('estimated', nrow(dE)),
                  datetime_ = rep(d$datetime_, nrow(dE)))

  d[, dist := NULL]

  d = rbind(d, d2)


  plot(PS_buffer)
  plot(PS, add = TRUE)

  plot(PS_points, add = TRUE, col = 'red')
  plot(PS2, add = TRUE, col = 'blue')



}






