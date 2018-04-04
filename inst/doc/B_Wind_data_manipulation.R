## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
# Clear working enviroment
rm(list = ls())

# Packages
sapply(c('rgdal', 'gdalUtils', 'raster', 'data.table', 'magrittr', 'sp', 'rgeos', 'raster'),
       function(x) suppressPackageStartupMessages(require(x , character.only = TRUE, quietly = TRUE) ) )

# Projections
# polar Lambert azimuthal equal-area with longitude origin 0° W
PROJ_0 = '+proj=laea +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '
# polar Lambert azimuthal equal-area with longitude origin 156.65° W (Barrow)
PROJ   = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '

# Define study area
Barrow  = SpatialPoints(data.frame(x = 0, y = -1950000), proj4string = CRS(PROJ)) # spatial point at Barrow
datBdry = gBuffer(Barrow, width = 250000, quadsegs = 100) %>% gEnvelope(.) # 250 km around Barrow

# Specify directory
wd = tempdir() # temporary in this case (choose yourself)


## ------------------------------------------------------------------------

# run for both u- and v-wind component
var = 'u'
var = 'v'

# assign path to NetCDF (data within windR package or change to your downladed file)
netcdf = system.file('/ERA_Interrim', 'ERA_Interrim_850mb_4_7_June_2014.nc', package = 'windR')

# create raster brick
tmp = brick(netcdf, varname = var)

# get dates
dd = data.table(rastNam = names(tmp))
dd[, datetime_ := substring(rastNam, 2, 14) %>% strptime(., '%Y.%m.%d.%H') %>% as.POSIXct]

write.table(dd, paste0(wd, '/ERA_Interrim_850mb_4_7_June_2014_names.txt'), sep = ';', row.names = FALSE)

# change y from 0 to 360 tp -180 to 180
tmp = rotate(tmp)

tmp2 = projectRaster(tmp, crs = PROJ_0)
plot(tmp2[[1]])


tmp3 = projectRaster(tmp2, crs = PROJ)

plot(tmp3[[1]])
plot(datBdry, add=TRUE)


tmp4 = crop(tmp3, datBdry)

plot(tmp4[[1]])

# write raster
writeRaster(tmp4, filename = paste0(wd, '/ERA_Interim_', var, '_wind_850mb_2014.tif'), overwrite=TRUE)



## ------------------------------------------------------------------------

# run for both u- and v-wind component
var = 'u'
var = 'v'

s = paste0(wd, '/ERA_Interim_', var, '_wind_850mb_2014.tif')
t = paste0(wd, '/ERA_Interim_', var, '_wind_850mb_2014_10km.tif')  # name of the output file

# gdalinfo(s) # check file
gdalwarp(srcfile = s, dstfile= t,  r = "cubic", tr = c(10000,10000) ) # does a cubic interpolation to a 10 km resolution

# check interpolated data
r1 = brick(paste0(wd, '/ERA_Interim_', var, '_wind_850mb_2014.tif'))
plot(r1[[1]])

r2 = brick(paste0(wd, '/ERA_Interim_', var, '_wind_850mb_2014_10km.tif'))
plot(r2[[1]])



## ---- eval=FALSE---------------------------------------------------------
#  
#  # Load data and assign datetime
#  dd = read.table(paste0(wd, '/ERA_Interrim_850mb_4_7_June_2014_names.txt'), stringsAsFactors = FALSE, sep = ';', header = TRUE) %>% data.table
#  dd[, datetime_ := as.POSIXct(datetime_) ]
#  
#  u = brick(paste0(wd, '/ERA_Interim_u_wind_850mb_2014_10km.tif'))
#  names(u) = dd$rastNam
#  
#  v = brick(paste0(wd, '/ERA_Interim_v_wind_850mb_2014_10km.tif'))
#  names(v) = dd$rastNam
#  
#  
#  # transform data for each layer
#  nlayers(u) # check number of layers
#  
#  o = foreach(i = 1:nlayers(u) ) %do% {
#  
#    # u wind component
#    xu = as(u[[i]] , "SpatialPixelsDataFrame")
#    xu = xu %>% as.data.frame %>% data.table
#  
#    xu[, datetime_ := dd$datetime_[i]]
#    setnames(      xu, c('u', 'x', 'y', 'datetime_'))
#    setcolorder(   xu, c('x', 'y', 'datetime_', 'u'))
#    xu[, xy        := paste0(x, '_',y)]
#  
#    # u wind component
#    xv = as(v[[i]] , "SpatialPixelsDataFrame")
#    xv = xv %>% as.data.frame %>% data.table
#  
#    xv[, datetime_ := dd$datetime_[i]]
#    setnames(      xv, c('v', 'x', 'y', 'datetime_'))
#    setcolorder(   xv, c('x', 'y', 'datetime_', 'v'))
#    xv[, xy        := paste0(x, '_',y)]
#  
#    # merge u and v
#    xuv = merge(xu, xv[, c('xy', 'v', 'datetime_'), with = FALSE], by = c('xy', 'datetime_') )
#  
#    # get rid of useless columns
#    xuv[, ':=' (xy = NULL)]
#  
#    cat(i)
#  
#    xuv
#  
#  }
#  
#  
#  w = rbindlist(o)
#  
#  
#  
#  # shift the time zone to Barrow (-8 hours)
#  w[, datetime_ := datetime_ - 60*60*8]
#  
#  
#  saveRDS(w, paste0(wd, '/ERA_Interrim_850mb_4_7_June_2014_10km.RDS'))
#  

## ------------------------------------------------------------------------
sessionInfo()

