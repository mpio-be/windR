## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
# Packages
sapply(c('magrittr', 'data.table', 'foreach', 'windR', 'raster', 'foreach', 'doParallel', 'ggplot2', 'stringr'),
       function(x) suppressPackageStartupMessages(require(x , character.only = TRUE, quietly = TRUE) ) )

# Projection (polar Lambert azimuthal equal-area with longitude origin 156.65° W)
PROJ   = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '

# Specify directory
wd = tempdir() # temporary in this case (choose yourself)


