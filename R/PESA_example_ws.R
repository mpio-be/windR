
#' Example Pectoral Sandpiper tracks including wind support
#'
#' Write a description of the data set... Same as PESA_example_tracks plus ground speed,
#' wind support, etc. stuff calculated in vignette 4_Wind_support_and_track_animation
#'
#' @name PESA_example_ws
#'
#' @docType data
#'
#' @usage data(PESA_example_ws)
#'
#' @format A data.table with some short example tracks around Barrow
#' \itemize{
#'   \item bird_patch_id: Tag ID and number of left tenure location with this track
#'   \item datetime_: Date and time of the position
#'   \item x: Latitude
#'   \item y: Longitude
#'   \item year_: Year
#'   \item w_date: Closest datetime with wind data
#'   \item id: running ID
#'   \item u: u-wind component
#'   \item v: v-wind component
#'   \item x2: Latitude of next point
#'   \item y2: Longitude of next point
#'   \item dist: Distance between this and the next point
#'   \item datetime_2: Time of the next point
#'   \item TbtwPoints: Time between those two points
#'   \item g_speed: Ground speed of the bird
#'   \item g_direction: Ground direction of the bird
#'   \item w_direction: Wind direction
#'   \item w_speed: Wind speed
#'   \item Ws: Wind support
#'   \item rWs: Relative wind support
#'   \item Wc: Cross wind
#'   }
#'
#' @keywords datasets
#'
#' @references Still to come
#'
#' @examples
#' PESA_example_ws
#'
NULL
