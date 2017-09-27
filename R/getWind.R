#' get Wind (data)
#'
#' This function connects points with the closest wind data in space and time.
#'
#' @param x Longitude of the point
#' @param y Latitude of the point
#' @param w Data table with wind data containing u & v wind component and the datetime
#' @param PROJ Projection of the point and wind data (has to be the same)
#'
#' @return A list containing the u and v component for the point
#' @export
#'
#' @examples



getWind = function(x, y , w, PROJ) {

  wpx = SpatialPixelsDataFrame(w[, .(x,y)], w[, .(u, v)], proj4string = CRS(PROJ))
  o   = over(SpatialPoints(cbind(x, y), proj4string = CRS(PROJ)), wpx)

  return(list(o$u[1], o$v[1]))

}
