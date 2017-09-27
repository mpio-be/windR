
#' pointCircle
#'
#' This function caclulates the position of points in a circle around a start point. The circle is based on the distance of the second point that is provided. This allows for example to compare the the wind conditions in all directions.
#'
#' @param x Longitude of point 1
#' @param y Latitude of point 1
#' @param x2 Longitude of point 2
#' @param y2 Latitude of point 2
#' @param id Bird ID
#' @param point_id Point ID
#' @param pointN The number of points that should be created on the circle
#' @param PROJ The projection of the points (should be equal area)
#'
#' @return
#' @export
#'
#' @examples
#'
#' id       = 'bird1'
#' point_id = 1
#' x        = 10
#' y        = 10
#' x2       = 100
#' y2       = 600
#' pointN   = 36
#' PROJ     = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '
#'
#' dp = pointCircle(x, y, x2, y2, id, point_id, pointN = 36, PROJ)
#'
#' # visualization of the example
#' PS  = SpatialPointsDataFrame(dp[1, .(x,y)], dp[1, .(id, pointType)], proj4string = CRS(PROJ), match.ID = TRUE)
#' PS2 = SpatialPointsDataFrame(dp[, .(x2,y2)], dp[, .(id, pointType)], proj4string = CRS(PROJ), match.ID = TRUE)
#'
#' plot(PS2[PS2@data$pointType == 'estimated', ], col = 'red')         # estimated points
#' plot(PS2[PS2@data$pointType == 'real', ], col = 'blue', add = TRUE) # second point
#' plot(PS, add = TRUE)                                                # first point

pointCircle = function(x, y, x2, y2, id, point_id, pointN = 36, PROJ){

  dt = data.table(id = id,
                  point_id = point_id,
                  x = x,
                  y = y,
                 x2 = x2,
                 y2 = y2,
                 pointType = 'real' )

  # distance between the two points
  P_dist = sqrt(sum((c(x, y) - c(x2, y2))^2))

  # create spatial points
  PS = SpatialPointsDataFrame(dt[, .(x,y)], dt[, .(id)], proj4string = CRS(PROJ), match.ID = TRUE)
  PS2 = SpatialPointsDataFrame(dt[, .(x2,y2)], dt[, .(id)], proj4string = CRS(PROJ), match.ID = TRUE )

  # create a circle around the point with the distance of the second point
  PS_buffer = gBuffer(PS, width = P_dist, quadsegs = 10)
  PS_line = as(PS_buffer, "SpatialLines")

  # sample points on the circle
  PS_points = spsample(PS_line, n = pointN, type = 'regular')

  dE = as.data.table(PS_points)

  d2 = data.table(id = dt$id,
                  point_id = dt$point_id,
                  x  = rep(dt$x, nrow(dE)),
                  y  = rep(dt$y, nrow(dE)),
                  x2 = dE$x,
                  y2 = dE$y,
                  pointType = rep('estimated', nrow(dE)) )

  d = rbind(dt, d2)

  return(d)

}






