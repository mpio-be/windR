
#' Calculate wind support or crosswind
#'
#' This function calculates the wind support based on the ground direction and speed (e.g. of an animal track) and the wind direction and speed. The wind support can be positive (tailwinds) or negative (headwinds). Logical wind speed and ground speed should be in the same unit (e.g. m/s)
#'
#' @param g_direction The bearing (Can be calculated based on two points using the function bearing)
#' @param g_speed The ground speed (Can be calculated as distance (between two points) / time (between two points))
#' @param w_direction Can be calculated from u and v wind component: atan2(u, v)
#' @param w_speed Can be calculated from u and v wind component: sqrt(u^2 + v^2)
#' @param crosswind If TRUE the function returns the cross wind instead of the wind support
#'
#' @return Wind support or cross wind
#' @export
#'
#' @examples
#' # Example 1
#' windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5)
#' windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5, crosswind = TRUE)
#'
#' # Example 2: constant ground direction, different wind direction
#' require(data.table)
#'
#' d = data.table(w_direction = seq(-pi, pi, pi/24),
#'                w_speed     = rep(5, 49),
#'                g_direction = rep(0, 49),
#'                g_speed     = rep(15, 49) )
#'
#'                d[, Ws := windSupport(g_direction, g_speed, w_direction, w_speed)                  , by = 1:nrow(d)]
#'                d[, Wc := windSupport(g_direction, g_speed, w_direction, w_speed, crosswind = TRUE), by = 1:nrow(d)]
#'
#'                plot(Ws ~ w_direction, d, type = 'l', ylab = 'Ws (black) / Wc (red)', xlab = 'Wind direction')
#'                lines(Wc ~ w_direction, d, col = 'red')

windSupport = function(g_direction, g_speed, w_direction, w_speed, crosswind = FALSE){

  # return NA if any NA in data
  if(is.na(g_direction) | is.na(g_speed) | is.na(w_direction) | is.na(w_speed)) {

    return(NA)

  }else{

    # get wind vectors
    u = w_speed * sin(w_direction)
    v = w_speed * cos(w_direction)

    # get ground vectors
    Xg = g_speed * sin(g_direction)
    Yg = g_speed * cos(g_direction)

    # get air direction (true heading) & speed
    Xa = Xg - u
    Ya = Yg - v

    a_direction = atan2(Xa, Ya)
    a_speed     = sqrt(Xa^2 + Ya^2)

    # windsupport and crosswind
    angle_g_w                        = w_direction - g_direction # get angle btw w and g
    if(angle_g_w < 0)   angle_g_w    = angle_g_w + pi*2          # normalize from 0 to 2*pi
    if(angle_g_w > pi)  angle_g_w    = 2 * pi - angle_g_w        # ignore site from which the wind comes (left or right)

    if(angle_g_w < pi/2) angle_w_Wc  = pi/2 - angle_g_w          # tailwind
    if(angle_g_w >= pi/2) angle_w_Wc = pi/2 - (pi - angle_g_w)   # headwind

    Ws = w_speed * sin(angle_w_Wc)                               # wind support
    if(angle_g_w > pi/2) Ws = Ws * -1                            # correct for headwind

    Wc = w_speed * cos(angle_w_Wc)                               # cross wind

    # return wind support or cross wind
    return(ifelse(crosswind == TRUE, Wc, Ws))

  }

}

