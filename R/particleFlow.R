
# Packages
sapply(c('magrittr', 'data.table', 'foreach', 'windR', 'raster', 'foreach', 'doParallel'),
       function(x) suppressPackageStartupMessages(require(x , character.only = TRUE, quietly = TRUE) ) )

# Projection
PROJ   = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 '




# set altitude
# altitude = '10m'
Taltitude = '925mb'
# altitude = '850mb'


# Example data
# 2 Tracks
load('//ds/grpkempenaers/Hannes/sea_ice_flights/DATA/P_Windsupport_allAltitudes.RData')
d = d[bird_patch_id == '114307_1' | bird_patch_id == '114293_1']

min(d$datetime_) - 60*60*24
max(d$datetime_) + 60*60*24

# load wind data
w = readRDS(paste0('//ds/raw_data_kemp/AVES/REMOTE_SENSING/ERA_Interim_Reanalysis/WIND/DATA/ERA_Interim_u_v_wind_2012_2014_', Taltitude, '_10km.RDS'))
w = w[datetime_ >= min(d$datetime_) - 60*60*24 & datetime_ <= max(d$datetime_) + 60*60*24]

# Load data boundary
load('//ds/grpkempenaers/Hannes/sea_ice_flights/DATA/STUDY_AREA/wBdry.RData')


# register cores with DoParallel
cl = 70 %>% makePSOCKcluster; registerDoParallel(cl)


t1 = c(min(d$datetime_) - 60*60*24) %>% as.Date %>% as.POSIXct
tl = c(max(d$datetime_) + 60*60*2 ) %>% as.Date %>% as.POSIXct

ob2 = particleFlow(time_start = t1, time_end = tl, time_steps = '30 mins', datBdry = datBdry, wind_data = w, PROJ = PROJ, n_particles = 10, tail = 50)





#' particleFlow uruur6uru
#'
#' @param time_start
#' @param time_end
#' @param time_steps
#' @param datBdry
#' @param wind_data
#' @param PROJ
#' @param n_particles
#' @param tail
#'
#' @return
#' @export
#'
#' @examples
#'
#'
#'
#'


particleFlow = function(time_start, time_end, time_steps, datBdry, wind_data, PROJ, n_particles = 100, tail = 50){

  # define the temporal extent
  time_start = time_start
  time_end   = time_end
  time_steps = time_steps

  ts = seq(time_start, time_end, time_steps)

  t_ext = ts
  t_max = max(ts) #

  # define the spatial extent
  ext   = extent(datBdry)
  x_ext = seq(ext[1], ext[2])
  y_ext = seq(ext[3], ext[4])


  # wind data
  w = wind_data
  setkey(w, datetime_)
  w_datetime_  = unique(w$datetime_)       # get vector of available wind data

  # number of particles
  NP_PP = n_particles	                     # number of particles per picture created
  NP    = NP_PP * length(ts)               # number of particles
  TL    = tail                             # number of points for each track
  NP*TL                                    # number of rows expected (will be smaller because some particles leave the map)

  # loop to create random particles
  o = foreach(i = 1:NP, .packages = c('data.table','rgdal', 'raster', 'magrittr', 'sp', 'rgeos', 'raster', 'windR') ) %dopar% {

    cat(i, '_of_', NP, '\n', file = paste0('./ProcessBar_', NP_PP,'.txt'))

    for(k in 1:TL){

      if (k == 1) {

        # random start date
        rd = sample(t_ext, 1)

        tmp = data.table(particle_id  = rep(i, TL),
                         point_id     = 1:TL,
                         datetime_    = seq(rd, rd + 1800 * (TL - 1), by = time_steps))

        setkey(tmp, point_id)
        tmp[, w_date := w_datetime_[which.min(abs(w_datetime_ - datetime_))], by = point_id]

        # random start point
        set(tmp, 1L, 'x', value = sample(x_ext, 1, replace=TRUE))
        set(tmp, 1L, 'y', value = sample(y_ext, 1, replace=TRUE))

        tmp[1, c('u', 'v') := getWind(x = x, y = y, w = w[J(w_date), nomatch=0L], PROJ)]

      } else {

        if (is.na(tmp[k-1, u]) | tmp[k, datetime_ > t_max]) {

          tmp = na.omit(tmp)

        } else {

          set(tmp, k , 5L, value = tmp[k-1, x] + tmp[k-1, u] * 1800)
          set(tmp, k , 6L, value = tmp[k-1, y] + tmp[k-1, v] * 1800)

          tmp[k, c('u', 'v') := getWind(x = x, y = y, w = w[J(w_date), nomatch=0L], PROJ)]

        }
      }
    }

    tmp

  }


  ob = rbindlist(o)
  ob

}


stopCluster(cl)
registerDoSEQ()







# saveRDS(ob, paste0('./DATA/ParticleFlow_', Tyear, '_', altitude,'_NP_PP_', NP_PP, '_high_res.RDS'))
