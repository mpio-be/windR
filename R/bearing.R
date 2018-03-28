
#' Calculate the bearing given two points
#'
#' This function calculates the bearing (direction) for something (e.g. an animal) moving from point 1 to point 2.
#'
#' @param x Longitude of point 1
#' @param y Latitude of point 1
#' @param x2 Longitude of point 2
#' @param y2 Latitude of point 2
#'
#' @return Bearing in radians from point 1 to point 2 (from -pi to pi)
#' @export
#'
#' @examples
#' # Example 1
#' bearing(x = 0, y = 0, x2 = 2, y2 = 2)
#'
#' # Example 2
#' library(data.table)
#'
#' d = data.table(x  = rep(0, 21),
#'                y  = rep(0, 21),
#'                x2 = seq(-10, 10, 1),
#'                y2 = rep(2, 21) )
#'
#'                d[, bearing := bearing(x, y, x2, y2), by = 1:nrow(d)]
#'
#'                plot(bearing ~ x2, d, type = 'l')

bearing <- function(x, y, x2, y2){

  # distance between the points
  if (is.na(x2)) {
    xx = 0
  } else {
    xx = x2 - x
  }

  if (is.na(y2)) {
    yy = 0
  } else {
    yy = y2 - y
  }

  b = sign(xx)
  b[b == 0] = 1  #corrects for the fact that sign(0) == 0
  tempangle = b * (yy < 0) * pi + atan(xx/yy)

  tempangle

}



