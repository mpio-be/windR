#' closestDatetime
#'
#' Function that finds the closest datetime_ within a vector of given datetimes. E.g. one has a point of a track at a given time and searches for the closest wind data.
#'
#' @param datetime_ Given time as POSIXct
#' @param datetimes Vector of possible datetimes as POSIXct
#'
#' @return Closest datetime as POSIXct
#' @export
#'
#' @examples
#' d1 = as.POSIXct("2014-06-09 21:44:25 CEST")
#' dt = as.POSIXct( c("2014-06-08 23:00:00 CEST", "2014-06-09 05:00:00 CEST", "2014-06-09 11:00:00 CEST", "2014-06-09 17:00:00 CEST",
#'                    "2014-06-09 23:00:00 CEST", "2014-06-10 05:00:00 CEST", "2014-06-10 11:00:00 CEST", "2014-06-10 17:00:00 CEST") )
#' closestDatetime(datetime_ = d1, datetimes = dt)

closestDatetime = function(datetime_, datetimes){

  cN = which(abs(datetimes - datetime_) == min(abs(datetimes - datetime_)))
  cD = as.POSIXct(datetimes[cN])

  cD[1]

}


