
#' Creates different size values along a vector
#'
#' @param x vector along which alpha is created
#' @param head numeric parameter influencing the lenght of the head
#' @param to numeric vector including the minimum and maximum size
#'
#' @return numeric verctor with different size values
#' @export
#'
#' @examples
#' library(ggplot2)
#' d = data.frame(x = 1:100, y = 1:100, s = sizeAlong(1:100, head = 70, to = c(0.1, 5)))
#' bm =  ggplot(d, aes(x, y))
#' bm + geom_path(size = 1)
#' bm + geom_path(size = d$s, lineend = 'round')

sizeAlong = function(x, head = 20, to = c(0.1, 2.5) ) {
  if(head >= length(x)) head = as.integer( length(x) * 0.5 )

  x = as.numeric(x)
  he = rescale( x[ (length(x) -head) : length(x)   ], to )
  ta = rep( min(he), length.out = length(x) -head -1)
  c(ta, he)
}
