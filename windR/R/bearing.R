
#' bearing
#'
#' @param x
#' @param y
#' @param x2
#' @param y2
#'
#' @return
#' @export
#'
#' @examples
#'


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

  return(tempangle)

}



