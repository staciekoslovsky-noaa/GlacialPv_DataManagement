# Aerial Surveys: Create footprint for image-based surveys
# S. Hardy, 13 June 2020

# STARTING VARIABLES (enter values as degrees)
vfv <- 16
hfv <- 24
offset_center <- 0
offset_left <- 12   # left view should have positive offset value
offset_right <- -12 # right view should have negative offset value

altitude <- 609.6
pitch <- 0
#roll <- 25
center_file <- "glacialTest_2000ft_INSroll_0pitch_0heading_C"
left_file <- "glacialTest_2000ft_INSroll_0pitch_0heading_L"
right_file <- "glacialTest_2000ft_INSroll_0pitch_0heading_R"

# Create functions -----------------------------------------------
# Function to install packages needed
install_pkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Function to calculate footprints
get_footprint <- function(hfv, vfv, utmx, utmy, dt, altitude, heading, pitch, roll, offset){
  # Adopted from: http://rijesha.com/blog/aerial-cam-footprint/
  #               https://github.com/rijesha/CamFootprintTester/blob/master/CamFootprintTester/Quaternion.cs
  # Convert values to radians
  vfv <- vfv * pi / 180 / 2
  hfv <- hfv * pi / 180 / 2
  pitch <- (360 - pitch) * pi / 180
  roll <- (roll + offset) * pi / 180
  heading <- (360 - heading) * pi / 180
  
  # Calculate quaternion for aircraft
  cy <- cos(-heading * 0.5)
  sy <- sin(-heading * 0.5)
  cr <- cos(-roll * 0.5)
  sr <- sin(-roll * 0.5)
  cp <- cos(pitch * 0.5)
  sp <- sin(pitch * 0.5)
  
  ac_w <- cy * cr * cp + sy * sr * sp
  ac_x <- cy * sr * cp - sy * cr * sp
  ac_y <- cy * cr * sp + sy * sr * cp
  ac_z <- sy * cr * cp - cy * sr * sp
  rm(cy, sy, cr, sr, cp, sp)
  
  # Calculate quaternion for camera FOV
  cy <- cos(0)
  sy <- sin(0)
  
  ## Top right
  cr <- cos(-hfv * 0.5 * -1)
  sr <- sin(-hfv * 0.5 * -1)
  cp <- cos(vfv * 0.5)
  sp <- sin(vfv * 0.5)
  
  tr_w <- cy * cr * cp + sy * sr * sp
  tr_x <- cy * sr * cp - sy * cr * sp
  tr_y <- cy * cr * sp + sy * sr * cp
  tr_z <- sy * cr * cp - cy * sr * sp
  rm(cr, sr, cp, sp)
  
  ## Top left
  cr <- cos(-hfv * 0.5)
  sr <- sin(-hfv * 0.5)
  cp <- cos(vfv * 0.5)
  sp <- sin(vfv * 0.5)
  
  tl_w <- cy * cr * cp + sy * sr * sp
  tl_x <- cy * sr * cp - sy * cr * sp
  tl_y <- cy * cr * sp + sy * sr * cp
  tl_z <- sy * cr * cp - cy * sr * sp
  rm(cr, sr, cp, sp)
  
  ## Bottom right
  cr <- cos(-hfv * 0.5 * -1)
  sr <- sin(-hfv * 0.5 * -1)
  cp <- cos(vfv * 0.5 * -1)
  sp <- sin(vfv * 0.5 * -1)
  
  br_w <- cy * cr * cp + sy * sr * sp
  br_x <- cy * sr * cp - sy * cr * sp
  br_y <- cy * cr * sp + sy * sr * cp
  br_z <- sy * cr * cp - cy * sr * sp
  rm(cr, sr, cp, sp)
  
  ## Bottom left
  cr <- cos(-hfv * 0.5)
  sr <- sin(-hfv * 0.5)
  cp <- cos(vfv * 0.5 * -1)
  sp <- sin(vfv * 0.5 * -1)
  
  bl_w <- cy * cr * cp + sy * sr * sp
  bl_x <- cy * sr * cp - sy * cr * sp
  bl_y <- cy * cr * sp + sy * sr * cp
  bl_z <- sy * cr * cp - cy * sr * sp
  rm(cy, sy, cr, sr, cp, sp)
  
  # Multiply aircraft Q by corner Q
  tr1_x <- ac_x * tr_w + ac_y * tr_z - ac_z * tr_y + ac_w * tr_x
  tr1_y <- -ac_x * tr_z + ac_y * tr_w + ac_z * tr_x + ac_w * tr_y
  tr1_z <- ac_x * tr_y - ac_y * tr_x + ac_z * tr_w + ac_w * tr_z
  tr1_w <- -ac_x * tr_x - ac_y * tr_y - ac_z * tr_z + ac_w * tr_w
  
  tl1_x <- ac_x * tl_w + ac_y * tl_z - ac_z * tl_y + ac_w * tl_x
  tl1_y <- -ac_x * tl_z + ac_y * tl_w + ac_z * tl_x + ac_w * tl_y
  tl1_z <- ac_x * tl_y - ac_y * tl_x + ac_z * tl_w + ac_w * tl_z
  tl1_w <- -ac_x * tl_x - ac_y * tl_y - ac_z * tl_z + ac_w * tl_w
  
  br1_x <- ac_x * br_w + ac_y * br_z - ac_z * br_y + ac_w * br_x
  br1_y <- -ac_x * br_z + ac_y * br_w + ac_z * br_x + ac_w * br_y
  br1_z <- ac_x * br_y - ac_y * br_x + ac_z * br_w + ac_w * br_z
  br1_w <- -ac_x * br_x - ac_y * br_y - ac_z * br_z + ac_w * br_w
  
  bl1_x <- ac_x * bl_w + ac_y * bl_z - ac_z * bl_y + ac_w * bl_x
  bl1_y <- -ac_x * bl_z + ac_y * bl_w + ac_z * bl_x + ac_w * bl_y
  bl1_z <- ac_x * bl_y - ac_y * bl_x + ac_z * bl_w + ac_w * bl_z
  bl1_w <- -ac_x * bl_x - ac_y * bl_y - ac_z * bl_z + ac_w * bl_w
  
  # Convert to Euler
  ## Top right
  sin_tr_roll <- 2.0 * (tr1_w * tr1_x + tr1_y * tr1_z)
  cos_tr_roll <- 1.0 - 2.0 * (tr1_x * tr1_x + tr1_y * tr1_y)
  roll_tr <- atan2(sin_tr_roll, cos_tr_roll)
  
  sin_tr_pitch <- 2.0 * (tr1_w * tr1_y - tr1_z * tr1_x)
  if (abs(sin_tr_pitch) >= 1)
    pitch_tr <- (sin_tr_pitch / sin_tr_pitch) * pi / 2
  else
    pitch_tr <- asin(sin_tr_pitch)
  
  sin_tr_heading <- 2.0 * (tr1_w * tr1_z + tr1_x * tr1_y)
  cos_tr_heading <- 1.0 - 2.0 * (tr1_y * tr1_y + tr1_z * tr1_z)
  heading_tr <- atan2(sin_tr_heading, cos_tr_heading)
  
  ## Top left
  sin_tl_roll <- 2.0 * (tl1_w * tl1_x + tl1_y * tl1_z)
  cos_tl_roll <- 1.0 - 2.0 * (tl1_x * tl1_x + tl1_y * tl1_y)
  roll_tl <- atan2(sin_tl_roll, cos_tl_roll)
  
  sin_tl_pitch <- 2.0 * (tl1_w * tl1_y - tl1_z * tl1_x)
  if (abs(sin_tl_pitch) >= 1)
    pitch_tl <- (sin_tl_pitch / sin_tl_pitch) * pi / 2
  else
    pitch_tl <- asin(sin_tl_pitch)
  
  sin_tl_heading <- 2.0 * (tl1_w * tl1_z + tl1_x * tl1_y)
  cos_tl_heading <- 1.0 - 2.0 * (tl1_y * tl1_y + tl1_z * tl1_z)
  heading_tl <- atan2(sin_tl_heading, cos_tl_heading)
  
  ## Bottom right
  sin_br_roll <- +2.0 * (br1_w * br1_x + br1_y * br1_z)
  cos_br_roll <- 1.0 - 2.0 * (br1_x * br1_x + br1_y * br1_y)
  roll_br <- atan2(sin_br_roll, cos_br_roll)
  
  sin_br_pitch <- 2.0 * (br1_w * br1_y - br1_z * br1_x)
  if (abs(sin_br_pitch) >= 1)
    pitch_br <- (sin_br_pitch / sin_br_pitch) * pi / 2
  else
    pitch_br <- asin(sin_br_pitch)
  
  sin_br_heading <- 2.0 * (br1_w * br1_z + br1_x * br1_y)
  cos_br_heading <- 1.0 - 2.0 * (br1_y * br1_y + br1_z * br1_z)
  heading_br <- atan2(sin_br_heading, cos_br_heading)
  
  ## Bottom left
  sin_bl_roll <- +2.0 * (bl1_w * bl1_x + bl1_y * bl1_z)
  cos_bl_roll <- 1.0 - 2.0 * (bl1_x * bl1_x + bl1_y * bl1_y)
  roll_bl <- atan2(sin_bl_roll, cos_bl_roll)
  
  sin_bl_pitch <- 2.0 * (bl1_w * bl1_y - bl1_z * bl1_x)
  if (abs(sin_bl_pitch) >= 1)
    pitch_bl <- (sin_bl_pitch / sin_bl_pitch) * pi / 2
  else
    pitch_bl <- asin(sin_bl_pitch)
  
  sin_bl_heading <- 2.0 * (bl1_w * bl1_z + bl1_x * bl1_y)
  cos_bl_heading <- 1.0 - 2.0 * (bl1_y * bl1_y + bl1_z * bl1_z)
  heading_bl <- atan2(sin_bl_heading, cos_bl_heading)
  
  # Calculate coordinate for each corner
  ## Top right
  dx_tr <- altitude * tan(roll_tr)
  dy_tr <- altitude * tan(pitch_tr)
  
  utmx_tr <- dx_tr * cos(heading_tr) - dy_tr * sin(heading_tr) + utmx
  utmy_tr <- -dx_tr * sin(heading_tr) - dy_tr * cos(heading_tr) + utmy
  
  ## Top left
  dx_tl <- altitude * tan(roll_tl)
  dy_tl <- altitude * tan(pitch_tl)
  
  utmx_tl <- dx_tl * cos(heading_tl) - dy_tl * sin(heading_tl) + utmx
  utmy_tl <- -dx_tl * sin(heading_tl) - dy_tl * cos(heading_tl) + utmy
  
  ## Bottom right
  dx_br <- altitude * tan(roll_br)
  dy_br <- altitude * tan(pitch_br)
  
  utmx_br <- dx_br * cos(heading_br) - dy_br * sin(heading_br) + utmx
  utmy_br <- -dx_br * sin(heading_br) - dy_br * cos(heading_br) + utmy
  
  ## Bottom left
  dx_bl <- altitude * tan(roll_bl)
  dy_bl <- altitude * tan(pitch_bl)
  
  utmx_bl <- dx_bl * cos(heading_bl) - dy_bl * sin(heading_bl) + utmx
  utmy_bl <- -dx_bl * sin(heading_bl) - dy_bl * cos(heading_bl) + utmy
  
  # Create footprint
  coords <- cbind(c(utmx_tr, utmx_br, utmx_bl, utmx_tl, utmx_tr), 
                  c(utmy_tr, utmy_br, utmy_bl, utmy_tl, utmy_tr))
  footprint <- mapview::coords2Polygons(coords, ID = dt)
}

# Install libraries ----------------------------------------------
install_pkg("rgdal")
install_pkg("maptools")
install_pkg("RPostgreSQL")
install_pkg("tidyverse")
install_pkg("mapview")

# Run code -------------------------------------------------------
# Get data for images
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Get list of images
images <- RPostgreSQL::dbGetQuery(con, "SELECT flight, camera_view, dt, ins_pitch, ins_altitude, ins_longitude, ins_roll, ins_latitude, ins_heading from surv_test_kamera.geo_images_meta where flight = \'fl04\' and ins_latitude > 0 and dt >= \'20190510_001855.663317\' ORDER BY dt LIMIT 2000")

RPostgreSQL::dbDisconnect(con)

# Create spatial frame of frame locations
center <- images %>%
  filter(camera_view == "C")
coordinates(center) <- ~ins_longitude+ins_latitude
proj4string(center) <- CRS("+init=epsg:4326")
center <- sp::spTransform(center, CRS("+init=epsg:32603"))

left <- images %>%
  filter(camera_view == "L")
coordinates(left) <- ~ins_longitude+ins_latitude
proj4string(left) <- CRS("+init=epsg:4326")
left <- sp::spTransform(left, CRS("+init=epsg:32603"))

right <- images %>%
  filter(camera_view == "R")
coordinates(right) <- ~ins_longitude+ins_latitude
proj4string(right) <- CRS("+init=epsg:4326")
right <- sp::spTransform(right, CRS("+init=epsg:32603"))

# Create center footprints
#poly_c <- get_footprint(hfv, vfv, center@coords[1, 1], center@coords[1, 2], center$dt[1], center$ins_altitude[1], center$ins_heading[1], center$ins_pitch[1], center$ins_roll[1], offset_center)
poly_c <- get_footprint(hfv, vfv, center@coords[1, 1], center@coords[1, 2], center$dt[1], altitude, 0, pitch, center$ins_roll[1], offset_center)
for (i in 2:nrow(center)){
  #temp <- get_footprint(hfv, vfv, center@coords[i, 1], center@coords[i, 2], center$dt[i], center$ins_altitude[i], center$ins_heading[i], center$ins_pitch[i], center$ins_roll[i], offset_center)
  temp <- get_footprint(hfv, vfv, center@coords[i, 1], center@coords[i, 2], center$dt[i], altitude, 0, pitch, center$ins_roll[i], offset_center)
  poly_c <- maptools::spRbind(poly_c, temp)
}
poly_c$flight <- center$flight
poly_c$camera <- center$camera_view
poly_c$dt <- center$dt
proj4string(poly_c) <- CRS("+init=epsg:32603")
poly_c <- sp::spTransform(poly_c, CRS("+init=epsg:4326"))

# Create left footprints
#poly_l <- get_footprint(hfv, vfv, left@coords[1, 1], left@coords[1, 2], left$dt[1], left$ins_altitude[1], left$ins_heading[1], left$ins_pitch[1], left$ins_roll[1], offset_left)
poly_l <- get_footprint(hfv, vfv, left@coords[1, 1], left@coords[1, 2], left$dt[1], altitude, 0, pitch, left$ins_roll[1], offset_left)
for (i in 2:nrow(left)){
  #temp <- get_footprint(hfv, vfv, left@coords[i, 1], left@coords[i, 2], left$dt[i], left$ins_altitude[i], left$ins_heading[i], left$ins_pitch[i], left$ins_roll[i], offset_left)
  temp <- get_footprint(hfv, vfv, left@coords[i, 1], left@coords[i, 2], left$dt[i], altitude, 0, pitch, left$ins_roll[i], offset_left)
  poly_l <- maptools::spRbind(poly_l, temp)
}
poly_l$flight <- left$flight
poly_l$camera <- left$camera_view
poly_l$dt <- left$dt
proj4string(poly_l) <- CRS("+init=epsg:32603")
poly_l <- sp::spTransform(poly_l, CRS("+init=epsg:4326"))

# Create right footprints
#poly_r <- get_footprint(hfv, vfv, right@coords[1, 1], right@coords[1, 2], right$dt[1], right$ins_altitude[1], right$ins_heading[1], right$ins_pitch[1], right$ins_roll[1], offset_right)
poly_r <- get_footprint(hfv, vfv, right@coords[1, 1], right@coords[1, 2], right$dt[1], altitude, 0, pitch, right$ins_roll[1], offset_right)
for (i in 2:nrow(right)){
  #temp <- get_footprint(hfv, vfv, right@coords[i, 1], right@coords[i, 2], right$dt[i], right$ins_altitude[i], right$ins_heading[i], right$ins_pitch[i], right$ins_roll[i], offset_right)
  temp <- get_footprint(hfv, vfv, right@coords[i, 1], right@coords[i, 2], right$dt[i], altitude, 0, pitch, right$ins_roll[i], offset_right)
  poly_r <- maptools::spRbind(poly_r, temp)
}
poly_r$flight <- right$flight
poly_r$camera <- right$camera_view
poly_r$dt <- right$dt
proj4string(poly_r) <- CRS("+init=epsg:32603")
poly_r <- sp::spTransform(poly_r, CRS("+init=epsg:4326"))

# Export shapefile
rgdal::writeOGR(obj = poly_c, dsn = "C:/skh", layer = center_file, driver = "ESRI Shapefile", overwrite_layer = TRUE)
rgdal::writeOGR(obj = poly_l, dsn = "C:/skh", layer = left_file, driver = "ESRI Shapefile", overwrite_layer = TRUE)
rgdal::writeOGR(obj = poly_r, dsn = "C:/skh", layer = right_file, driver = "ESRI Shapefile", overwrite_layer = TRUE)