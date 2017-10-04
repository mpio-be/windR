#' get Temperature (data)
#'
#' This function connects points with the closest temperature data in space.
#'
#' @param x Longitude of the point
#' @param y Latitude of the point
#' @param t Name of the variable
#' @param PROJ Projection of the point and enviromental data (has to be the same)
#'
#' @return A list containing the temperature for this point
#' @export
#'
#' @examples

getTemp = function(x, y , t, PROJ) {

  wpx = SpatialPixelsDataFrame(t[, .(x,y)], t[, .(t)], proj4string = CRS(PROJ))
  o   = over(SpatialPoints(cbind(x, y), proj4string = CRS(PROJ)), wpx)

  return(list(o$t[1]))

}
