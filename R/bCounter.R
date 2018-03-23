
#' A function that counts bouts within a vector
#'
#' @param x Numeric vector
#'
#' @return Numeric vector with counted bouts
#' @export
#'
#' @examples
#' x = c(rep(1, 5), rep(0, 2), rep(1, 4), rep(0, 2))
#' bCounter(x)
#'
#' data.frame(x = x,
#'            bout = bCounter(x))

bCounter = function(x){

  n  = length(x)
  y  = x[-1] != x[-n]
  i  = c( which(y | is.na(y)), n) # last bout
  lengths = diff(c(0L, i))
  bout_length = rep(lengths, lengths)
  ids = 1:length(lengths)
  bout_id = rep(ids, lengths)

  bout_id

}

