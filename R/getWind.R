#' Connect points to closest wind data in space and time
#'
#' This function takes given points (and their datetime) and connects them with the closest wind data in space.
#'
#' @param x Longitude of the point
#' @param y Latitude of the point
#' @param w Data table with wind data containing u & v wind component and the datetime
#' @param PROJ Projection of the point and wind data (has to be the same)
#'
#' @return A list containing the u and v component for the point
#' @export
#'
#' @importFrom sp SpatialPoints over SpatialPixelsDataFrame
#' @examples
#' # Load example wind data
#' PROJ = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '
#' wind_data = system.file('ERA_Interrim', 'ERA_Interrim_850mb_4_7_June_2014_10km.RDS', package = 'windR')
#' w = readRDS(wind_data)
#' setkey(w, datetime_)
#'
#' # Create example points within the boarders of the wind data (space and time)
#' library(raster)
#' library(rgeos)
#' # Get extent of the wind data, defining the extent of the map
#' w1 = w[datetime_ == unique(w$datetime_[1])]
#' wp = SpatialPoints(cbind(w1$x, w1$y), proj4string = CRS(PROJ))
#' datBdry = gEnvelope(wp)
#'
#' ext   = extent(datBdry)
#' x_ext = seq(ext[1], ext[2])
#' y_ext = seq(ext[3], ext[4])
#'
#' n_points = 100
#'
#' d = data.table(point_id  = 1:n_points,
#'                x         = sample(x_ext, n_points, replace=TRUE),
#'                y         = sample(y_ext, n_points, replace=TRUE),
#'                datetime_ = c(sample(w$datetime_, n_points)) + 60*60) # existing wind data + 1 hour
#'
#' # Assign closest datetime of wind data
#' setkey(d, point_id)
#' d[, w_date := closestDatetime(datetime_, unique(w$datetime_)), by = point_id]
#'
#' # Assign closest wind data
#' d[, c('u', 'v') := getWind(x = x, y = y, w = w[J(w_date), nomatch=0L], PROJ), by = point_id]

getWind = function(x, y , w, PROJ) {

  wpx = sp::SpatialPixelsDataFrame(w[, .(x,y)], w[, .(u, v)], proj4string = CRS(PROJ))
  o   = sp::over(SpatialPoints(cbind(x, y), proj4string = CRS(PROJ)), wpx)

  return(list(o$u[1], o$v[1]))

}

