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


## ------------------------------------------------------------------------

# load wind data
wind_data = system.file('ERA_Interrim', 'ERA_Interrim_850mb_4_7_June_2014_10km.RDS', package = 'windR')
wA = readRDS(wind_data)

# get extent of the wind data, defining the extent of the map
w1 = wA[datetime_ == unique(wA$datetime_[1])]
wp = SpatialPoints(cbind(w1$x, w1$y), proj4string = CRS(PROJ))
datBdry = gEnvelope(wp)

# load high resolution map of area and crop with data boundary
map_data = system.file('Map', 'Arctic_map.RDS', package = 'windR')
arctic = readRDS(map_data)

BRW = arctic %>% gIntersection(datBdry)

plot(arctic)
plot(BRW, col = 'red', add = TRUE)

# example to get a simple map
# library(maptools)
# data(wrld_simpl)
# wrld_c = crop(wrld_simpl, extent(-180, -120, 45, 90)) # crop broad area
# wrld = spTransform(wrld_c, CRS(PROJ)) # change projection
# BRW = wrld %>% gIntersection(datBdry) # crop with border of the wind data

# Create simple base map
b  = datBdry %>% fortify %>% data.table
bb = gBuffer(datBdry, width = 30000) %>% gEnvelope %>% fortify %>% data.table
wr = BRW %>% fortify %>% data.table

bm =
  ggplot() + coord_equal() +
  labs(x = NULL, y = NULL) +
  geom_polygon(  data = bb, aes(long, lat), fill = NA, colour = 1, size = .1) +
  geom_polygon(  data = b,  aes(long, lat), fill = 'dodgerblue4', colour = 1, size = .1) +
  geom_polygon(  data = wr, aes(long, lat, group = group), fill   = 'steelblue4' , colour = 'white', size = .2) +
  ggsn::scalebar(data = b,  dist = 100, st.size = 3 ,height = .01) +
  rangeMapper::theme_rangemap()

print(bm)



## ---- eval=FALSE---------------------------------------------------------
#  
#  # define the temporal extent
#  time_start = as.POSIXct(as.Date('2014-06-04'))
#  time_end   = as.POSIXct(as.Date('2014-06-07'))
#  time_steps = '30 mins'
#  
#  ts = seq(time_start, time_end, time_steps)
#  
#  t_ext = ts
#  t_max = max(ts)
#  
#  # define the spatial extent
#  ext   = extent(datBdry)
#  x_ext = seq(ext[1], ext[2])
#  y_ext = seq(ext[3], ext[4])
#  
#  
#  # wind data
#  w = wA
#  setkey(w, datetime_)
#  w_datetime_  = unique(w$datetime_)       # get vector of available wind data
#  
#  # number of particles
#  NP_PP = 10       	                       # number of particles per picture created
#  NP    = NP_PP * length(ts)               # number of particles
#  TL    = 50                               # number of points for each track
#  NP*TL                                    # number of rows expected (will be smaller because some particles leave the map)
#  
#  
#  # loop to create random particles
#  o = foreach(i = 1:NP, .packages = c('data.table','rgdal', 'raster', 'magrittr', 'sp', 'rgeos', 'raster', 'windR') ) %do% {
#  
#    cat(i, '_of_', NP, '\n', file = paste0(wd, '/ProcessBar.txt'))
#  
#    for(k in 1:TL){
#  
#      if (k == 1) {
#  
#        # random start date
#        rd = sample(t_ext, 1)
#  
#        tmp = data.table(particle_id  = rep(i, TL),
#                         point_id     = 1:TL,
#                         datetime_    = seq(rd, rd + 1800 * (TL - 1), by = time_steps))
#  
#        setkey(tmp, point_id)
#        tmp[, w_date := closestDatetime(datetime_, w_datetime_), by = point_id]
#  
#        # random start point
#        set(tmp, 1L, 'x', value = sample(x_ext, 1, replace=TRUE))
#        set(tmp, 1L, 'y', value = sample(y_ext, 1, replace=TRUE))
#  
#        tmp[1, c('u', 'v') := getWind(x = x, y = y, w = w[J(w_date), nomatch=0L], PROJ)]
#  
#      } else {
#  
#        if (is.na(tmp[k-1, u]) | tmp[k, datetime_ > t_max]) {
#  
#          tmp = na.omit(tmp)
#  
#        } else {
#  
#          set(tmp, k , 5L, value = tmp[k-1, x] + tmp[k-1, u] * 1800)
#          set(tmp, k , 6L, value = tmp[k-1, y] + tmp[k-1, v] * 1800)
#  
#          tmp[k, c('u', 'v') := getWind(x = x, y = y, w = w[J(w_date), nomatch=0L], PROJ)]
#  
#        }
#      }
#    }
#  
#    tmp
#  
#  }
#  
#  
#  ob = rbindlist(o)
#  
#  saveRDS(ob, paste0(wd, '/Wind_particles.RDS'))
#  

## ---- eval=FALSE---------------------------------------------------------
#  
#  # load particles and calculate the wind speed
#  particle_data = system.file('Map', 'Wind_particles.RDS', package = 'windR')
#  ob = readRDS(particle_data)
#  setkey(ob, datetime_)
#  ob[, w_speed := sqrt(u^2 + v^2)]
#  
#  # Set time frame and path
#  ts = data.table(date = seq('2014-06-04' %>% as.Date %>% as.POSIXct, '2014-06-07' %>% as.Date %>% as.POSIXct, by = '30 mins') )
#  setkey(ts, date)
#  tmp_path = wd # change path
#  ts[, path := paste0(tmp_path, '/', str_pad(1:.N, 4, 'left', pad = '0'), '.png')   ]
#  
#  # Wind speed color scale
#  Ws_min = 0
#  Ws_max = max(ob$w_speed, na.rm = TRUE)
#  col_Ws = c('gold', 'springgreen3', 'springgreen4')
#  col_WS_v  = c(0, 0.5, 1)
#  
#  
#  
#  # register parallel computing
#  # cl = 20 %>% makePSOCKcluster; registerDoParallel(cl)
#  
#  # loop that creates pictures for the animation
#  foreach(i = 1:nrow(ts), .packages = c('scales', 'ggplot2', 'lubridate', 'stringr', 'data.table', 'windR') ) %dopar% {
#  
#    png(filename = ts[i, path], width = 700, height = 700, units = "px", pointsize = 9, bg = "white")
#  
#    # add track for particles
#    tail     = 20           # lenght of the running tail
#    tmp_date = ts[i]$date   # current date
#  
#    # subset particles
#    tmp_date_sub = seq(tmp_date  - 1800 * tail, tmp_date, by = '30 mins')
#    pi = ob[J(tmp_date_sub), nomatch=0L]
#  
#    if (nrow(pi) > 0) pi[, a :=  alphaAlong(datetime_, head = 70, skew = -2), by = particle_id] # alpha
#  
#    bm_w = bm +
#      geom_path(data = pi, aes(x = x, y = y, group = particle_id, color = w_speed), alpha = pi$a) +
#      scale_colour_gradientn(colours = col_Ws, values = col_WS_v, limits = c(Ws_min, Ws_max), name = 'Wind speed (m/s)') +
#      annotate('text', x = 0, y = -1730000,
#               label = paste0('2014 ', format(tmp_date, "%B %d %H:00")),
#               color = 'white', size = 8, fontface = 1) + # size = 5 normal resolution, 8 for high
#      theme(legend.direction = 'horizontal', legend.position = c(0.12, 0.13),
#            legend.title = element_text(face = 'bold', color = 'white'),
#            legend.text = element_text(face = 'bold', color = 'white'),
#            plot.margin = unit(c(-1, -1, -1, -1), 'cm')) +
#      guides(colour = guide_colourbar(title.position = 'top', title.hjust = 0.5, barwidth = 8))
#  
#  
#    print(bm_w)
#  
#    dev.off()
#  
#  }
#  
#  
#  # close parallel clusters
#  stopCluster(cl)
#  registerDoSEQ()
#  
#  
#  # merge png into animation using ffmpeg (or with a different programm)
#  
#  setwd(tmp_path)
#  system("ffmpeg -framerate 12 -pattern_type glob -i '*.png' -y -c:v libx264 -profile:v high -crf 1 -pix_fmt yuv420p WindParticleFlow_Barrow.mov")
#  
#  

## ------------------------------------------------------------------------
sessionInfo()

