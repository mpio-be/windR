% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/windSupport.R
\name{windSupport}
\alias{windSupport}
\title{Calculate wind support or crosswind}
\usage{
windSupport(g_direction, g_speed, w_direction, w_speed, crosswind = FALSE)
}
\arguments{
\item{g_direction}{The bearing (Can be calculated based on two points using the function bearing)}

\item{g_speed}{The ground speed (Can be calculated as distance (between two points) / time (between two points))}

\item{w_direction}{Can be calculated from u and v wind component: atan2(u, v)}

\item{w_speed}{Can be calculated from u and v wind component: sqrt(u^2 + v^2)}

\item{crosswind}{If TRUE the function returns the cross wind instead of the wind support}
}
\value{
Wind support or cross wind
}
\description{
This function calculates the wind support based on the ground direction and speed
(e.g. of an animal track) and the wind direction and speed. The wind support can be
positive (tailwinds) or negative (headwinds). Logical wind speed and ground speed
should be in the same unit (e.g. m/s)
}
\examples{
# Example 1
windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5)
windSupport(g_direction = 0, g_speed = 15, w_direction = 1, w_speed = 5, crosswind = TRUE)

# Example 2: constant ground direction, different wind direction
d = data.table(w_direction = seq(-pi, pi, pi/24),
               w_speed     = rep(5, 49),
               g_direction = rep(0, 49),
               g_speed     = rep(15, 49) )

               d[, Ws := windSupport(g_direction, g_speed, w_direction, w_speed),
                   by = 1:nrow(d)]
               d[, Wc := windSupport(g_direction, g_speed, w_direction, w_speed,
                   crosswind = TRUE), by = 1:nrow(d)]

               plot(Ws ~ w_direction, d, type = 'l', ylab = 'Ws (black) / Wc (red)',
                         xlab = 'Wind direction')
               lines(Wc ~ w_direction, d, col = 'red')
}
