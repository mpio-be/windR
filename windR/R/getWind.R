#' get Wind - connects points with wind data
#'
#' @param x
#' @param y
#' @param w
#' @param PROJ
#'
#' @return
#' @export
#'
#' @examples



getWind = function(x, y , w, PROJ) {

  wpx = SpatialPixelsDataFrame(w[, .(x,y)], w[, .(u, v)], proj4string = CRS(PROJ))
  o   = over(SpatialPoints(cbind(x, y), proj4string = CRS(PROJ)), wpx)

  list(o$u[1], o$v[1])

}
