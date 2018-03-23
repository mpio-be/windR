
#' Creates different alpha values along a vector
#'
#' @param x Vector along which alpha is created
#' @param head Numeric parameter influencing the lenght of the head
#' @param skew Numeric parameter influencing the skew of alpha
#'
#' @return Numeric verctor with different alpha values
#' @export
#'
#' @examples
#' library(ggplot2)
#' d = data.frame(x = 1:100, y = 1:100, a = alphaAlong(1:100, head = 20, skew = -2))
#' bm = ggplot(d, aes(x, y))
#' bm + geom_path(size = 10)
#' bm + geom_path(size = 10, alpha = d$a, lineend = 'round')

alphaAlong = function(x, head = 20, skew = -2) {
  if(head >= length(x)) head = as.integer( length(x) * 0.5 )
  x = as.numeric(x)
  he = exp(rescale( x[ (length(x) -head) : length(x)   ],c(skew, 0) ) )
  ta = rep( min(he), length.out = length(x) -head -1)
  c(ta, he)
}
