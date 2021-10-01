# Glacial Pv Surveys: Create footprint (effective area surveyed based 
#   on field of view) for mosaic surveys
# Adapted code originally written by Paul Conn for BOSS data processing
# S. Hardy, 15MAY2018

# Variables to update --------------------------------------------
# Path where csv and shapefiles are stored
wd <- "//nmfs/akc-nmml/Polar_Imagery/Surveys_HS/Glacial/Projects/Surveys Glacial Sites Counts/2015/20150808"
# GPS file used for interpolating locations
gps_file <- "glacial_20150808_georef.gpx"
# Location and date of survey
survey <- "dbay_20150808"
# Map folder
map_folder <- "dbay_20150808_forCounting"
# Shapefile containing the seal locations (do not include .shp in the shapefile name)
seal_locs <- "dbay_20150808_seal_locs"
# Targeted altitude for the flight in meters
survey_altitude <- 305 
# Name for the exported shapefile containing footprints and image counts (do not include .shp in the shapefile name)
export_shp <- "dbay_20150808_footprints_skhtest"

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

# Function to calculate footprints for center camera
get_footprint_corners_center <- function(angles, roll, bearing, coords, alt){  
  # NOTE: only works when abs(roll) < (horiz/2 - offset)
  angles <- angles[which(angles$camera == "Center"), ]
  vert_width_port <- alt / cos(0.5 * angles[, "horiz"] + roll) * sin(0.5 * angles[, "vert"])
  vert_width_starboard <- alt / cos(0.5 * angles[, "horiz"] - roll) * sin(0.5 * angles[, "vert"])
  horiz_dist_port <- alt * tan(0.5 * angles[ ,"horiz"] + roll)
  horiz_dist_starboard <- alt * tan(0.5 * angles[ ,"horiz"] - roll)
  # Locate a point orthogonal to aircraft bearing at the outer edge of photograph that is closest (tangent) to the plane
  if(bearing <= (0.5 * pi)){
    Tmp <- c(-cos(0.5 * pi - bearing), sin(0.5 * pi - bearing)) 
  }
  if(bearing > (0.5 * pi) & bearing <= pi){
    Tmp <- c(-cos(bearing - 0.5 * pi), -sin(bearing - 0.5 * pi)) 
  }
  if(bearing > pi & bearing <= (1.5 * pi)){
    Tmp <- c(cos(1.5 * pi - bearing), -sin(1.5 * pi - bearing))
  }  
  if(bearing > (1.5 * pi)){
    Tmp <- c(cos(bearing - 1.5 * pi), sin(bearing - 1.5 * pi)) 
  }
  C_port <- horiz_dist_port * Tmp + coords
  C_starboard <- -horiz_dist_starboard * Tmp + coords
  Poly_points <- matrix(0, 5, 2)
  m <- tan(bearing)
  tmp <- sqrt(1 + m^2)
  Tmp <- rep(vert_width_port/tmp, 2)
  Tmp[2] <- Tmp[2] * m
  Poly_points[1, ] <- C_port - Tmp
  Poly_points[2, ] <- C_port + Tmp
  Tmp <- rep(vert_width_starboard/tmp, 2)
  Tmp[2] <- Tmp[2] * m
  Poly_points[3, ] <- C_starboard + Tmp
  Poly_points[4, ] <- C_starboard - Tmp
  Poly_points[5, ] <- Poly_points[1, ]
  Poly_points
}

# Function to calculate footprints for port camera
get_footprint_corners_port <- function(angles, roll, bearing, coords, alt){
  #note: only works when abs(roll)< (horiz/2-offset)
  angles <- angles[which(angles$camera == "Starboard"), ]
  vert_width_far = alt/cos(angles[,"offset"]+0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  vert_width_near = alt/cos(angles[,"offset"]-0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  horiz_dist_far = alt*tan(0.5*angles[,"horiz"]+angles[,"offset"]-roll)
  horiz_dist_near = alt*tan(angles[,"offset"]-roll-0.5*angles[,"offset"])
  #locate a point orthogonal to aircraft bearing at the outer edge of photograph that is closest (tangent) to the plane
  if(bearing<=(0.5*pi)){
    Tmp = c(cos(0.5*pi-bearing),-sin(0.5*pi-bearing))
  }
  if(bearing>(0.5*pi) & bearing<=pi){
    Tmp = c(cos(bearing-0.5*pi),sin(bearing-0.5*pi))
  }
  if(bearing>pi & bearing<=(1.5*pi)){
    Tmp = c(-cos(1.5*pi - bearing),sin(1.5*pi - bearing))
  }
  if(bearing>(1.5*pi)){
    Tmp = c(-cos(bearing-1.5*pi),-sin(bearing-1.5*pi))
  }
  C_far = horiz_dist_far * Tmp + coords
  C_near = horiz_dist_near * Tmp + coords
  Poly_points = matrix(0,5,2)
  m=tan(bearing)
  tmp = sqrt(1+m^2)
  Tmp = rep(vert_width_far/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[1,] = C_far - Tmp
  Poly_points[2,] = C_far + Tmp
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[3,] = C_near + Tmp
  Poly_points[4,] = C_near - Tmp
  Poly_points[5,]=Poly_points[1,]
  Poly_points
}

# Function to calculate rectangles for port camera
get_rectangle_corners_port <- function(angles, roll, bearing, coords, alt){
  #note: only works when abs(roll)< (horiz/2-offset)
  angles <- angles[which(angles$camera == "Starboard"), ]
  vert_width_far = alt/cos(angles[,"offset"]+0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  vert_width_near = alt/cos(angles[,"offset"]-0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  horiz_dist_far = alt*tan(0.5*angles[,"horiz"]+angles[,"offset"]-roll)
  horiz_dist_near = alt*tan(angles[,"offset"]-roll-0.5*angles[,"offset"])
  #locate a point orthogonal to aircraft bearing at the outer edge of photograph that is closest (tangent) to the plane
  if(bearing<=(0.5*pi)){
    Tmp = c(cos(0.5*pi-bearing),-sin(0.5*pi-bearing))
  }
  if(bearing>(0.5*pi) & bearing<=pi){
    Tmp = c(cos(bearing-0.5*pi),sin(bearing-0.5*pi))
  }
  if(bearing>pi & bearing<=(1.5*pi)){
    Tmp = c(-cos(1.5*pi - bearing),sin(1.5*pi - bearing))
  }
  if(bearing>(1.5*pi)){
    Tmp = c(-cos(bearing-1.5*pi),-sin(bearing-1.5*pi))
  }
  C_far = horiz_dist_far * Tmp + coords
  C_near = horiz_dist_near * Tmp + coords
  Poly_points = matrix(0,5,2)
  m=tan(bearing)
  tmp = sqrt(1+m^2)
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[1,] = C_far - Tmp
  Poly_points[2,] = C_far + Tmp
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[3,] = C_near + Tmp
  Poly_points[4,] = C_near - Tmp
  Poly_points[5,]=Poly_points[1,]
  Poly_points
}

# Function to calculate footprints for starboard camera
get_footprint_corners_starboard <- function(angles, roll, bearing, coords, alt){
  # NOTE: only works when abs(roll) < (horiz/2 - offset)
  angles <- angles[which(angles$camera == "Port"), ]
  vert_width_far = alt/cos(angles[,"offset"]+0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  vert_width_near = alt/cos(angles[,"offset"]-0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  #horiz_width = alt*tan(0.5*angles[,"horiz"])
  horiz_dist_far = alt*tan(0.5*angles[,"horiz"]+angles[,"offset"]+roll)
  horiz_dist_near = alt*tan(angles[,"offset"]+roll-0.5*angles[,"offset"])
  #locate a point orthogonal to aircraft bearing at the outer edge of photograph that is closest (tangent) to the plane
  if(bearing<=(0.5*pi)){
    Tmp = c(-cos(0.5*pi-bearing),sin(0.5*pi-bearing))
  }
  if(bearing>(0.5*pi) & bearing<=pi){
    Tmp = c(-cos(bearing-0.5*pi),-sin(bearing-0.5*pi))
  }
  if(bearing>pi & bearing<=(1.5*pi)){
    Tmp = c(cos(1.5*pi-bearing),-sin(1.5*pi-bearing))
  }
  if(bearing>(1.5*pi)){
    Tmp = c(cos(bearing-1.5*pi),sin(bearing-1.5*pi))
  }
  C_far = horiz_dist_far * Tmp + coords
  C_near = horiz_dist_near * Tmp + coords
  Poly_points = matrix(0,5,2)
  m=tan(bearing)
  tmp = sqrt(1+m^2)
  Tmp = rep(vert_width_far/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[1,] = C_far - Tmp
  Poly_points[2,] = C_far + Tmp
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[3,] = C_near + Tmp
  Poly_points[4,] = C_near - Tmp
  Poly_points[5,]=Poly_points[1,]
  Poly_points
}

# Function to calculate rectangles for starboard camera
get_rectangle_corners_starboard <- function(angles, roll, bearing, coords, alt){
  # NOTE: only works when abs(roll) < (horiz/2 - offset)
  angles <- angles[which(angles$camera == "Port"), ]
  vert_width_far = alt/cos(angles[,"offset"]+0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  vert_width_near = alt/cos(angles[,"offset"]-0.5*angles[,"horiz"]+roll)*sin(0.5*angles[,"vert"])
  #horiz_width = alt*tan(0.5*angles[,"horiz"])
  horiz_dist_far = alt*tan(0.5*angles[,"horiz"]+angles[,"offset"]+roll)
  horiz_dist_near = alt*tan(angles[,"offset"]+roll-0.5*angles[,"offset"])
  #locate a point orthogonal to aircraft bearing at the outer edge of photograph that is closest (tangent) to the plane
  if(bearing<=(0.5*pi)){
    Tmp = c(-cos(0.5*pi-bearing),sin(0.5*pi-bearing))
  }
  if(bearing>(0.5*pi) & bearing<=pi){
    Tmp = c(-cos(bearing-0.5*pi),-sin(bearing-0.5*pi))
  }
  if(bearing>pi & bearing<=(1.5*pi)){
    Tmp = c(cos(1.5*pi-bearing),-sin(1.5*pi-bearing))
  }
  if(bearing>(1.5*pi)){
    Tmp = c(cos(bearing-1.5*pi),sin(bearing-1.5*pi))
  }
  C_far = horiz_dist_far * Tmp + coords
  C_near = horiz_dist_near * Tmp + coords
  Poly_points = matrix(0,5,2)
  m=tan(bearing)
  tmp = sqrt(1+m^2)
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[1,] = C_far - Tmp
  Poly_points[2,] = C_far + Tmp
  Tmp = rep(vert_width_near/tmp,2)
  Tmp[2]=Tmp[2]*m
  Poly_points[3,] = C_near + Tmp
  Poly_points[4,] = C_near - Tmp
  Poly_points[5,]=Poly_points[1,]
  Poly_points
}

# Install libraries ----------------------------------------------
# Installation of exifr requires portable perl to be stored at the following location on computer: C:\Strawberry!!!
install_pkg("exifr")
install_pkg("dplyr")
install_pkg("lubridate")
install_pkg("rgdal")
install_pkg("sp")
install_pkg("maptools")
install_pkg("plyr")
install_pkg("sf")
install_pkg("nabor")
install_pkg("spatstat")
install_pkg("data.table")
#install_pkg("devtools")
#devtools::install_github("paleolimbot/exifr")

# Run code -------------------------------------------------------
# Get list of images
images <- list.files(paste(wd, survey, "photos", sep = "/"), pattern = "jpg$|JPG$", full.names = TRUE)

# Extract exif data from images and process for use in interpolation
exif <- exifr::read_exif(images, tags = c("SourceFile", "FileName", "SubSecDateTimeOriginal"))
exif <- data.frame(lapply(exif, as.character), stringsAsFactors = FALSE)
colnames(exif) <- c("source_file", "file_name", "image_dt")
exif$image_dt <- ifelse(substr(exif$image_dt, 8, 8) == ":", 
                        exif$image_dt, 
                        paste(substr(exif$image_dt, 1, 5), "0", substr(exif$image_dt, 6, nchar(exif$image_dt)), sep = ""))
exif$image_dt <- ifelse(substr(exif$image_dt, 11, 11) == " ", 
                        exif$image_dt, 
                        paste(substr(exif$image_dt, 1, 8), "0", substr(exif$image_dt, 9, nchar(exif$image_dt)), sep = ""))
exif$image_dt <- ifelse(substr(exif$image_dt, 14, 14) == ":", 
                        exif$image_dt, 
                        paste(substr(exif$image_dt, 1, 11), "0", substr(exif$image_dt, 12, nchar(exif$image_dt)), sep = ""))
substr(exif$image_dt, 5, 5) <- "-"
substr(exif$image_dt, 8, 8) <- "-"
exif$image_dt <- strptime(exif$image_dt, format = "%Y-%m-%d %H:%M:%OS", tz = "America/Anchorage")

# Create list of paired port-center-starboard images
firstP <- exif[grep("PCam", exif$file_name)[1], ]
firstC <- exif[grep("CCam", exif$file_name)[1], ]
firstS <- exif[grep("SCam", exif$file_name)[1], ]

first <- rbind(firstP, firstC, firstS)
first <- min(first$image_dt)
diffS <- as.numeric(firstS$image_dt - first)
diffC <- as.numeric(firstC$image_dt - first)
diffP <- as.numeric(firstP$image_dt - first)

exif$image_dt_newP <- exif$image_dt - diffP
exif$image_dt_newC <- exif$image_dt - diffC
exif$image_dt_newS <- exif$image_dt - diffS

exifP <- exif[grepl("PCam", exif$file_name) == TRUE, c("source_file", "file_name", "image_dt_newP")]
colnames(exifP) <- c("source_file", "file_name", "image_dt_new")
exifC <- exif[grepl("CCam", exif$file_name) == TRUE, c("source_file", "file_name", "image_dt_newC")]
colnames(exifC) <- c("source_file", "file_name", "image_dt_new")
exifC <- exifC[order(exifC$image_dt_new), ]
exifS <- exif[grepl("SCam", exif$file_name) == TRUE, c("source_file", "file_name", "image_dt_newS")]
colnames(exifS) <- c("source_file", "file_name", "image_dt_new")

rm(firstP, firstC, firstS, first, diffS, diffC, diffP)

# Calculate missing date/times in center camera before fuzzy merging data
setDT(exifP)
setDT(exifC)
setDT(exifS)

# Create missing center date/times
exifC[, tdiff := difftime(image_dt_new, shift(image_dt_new, fill=image_dt_new[1L]), units="secs")]
missing_times <- data.frame(image_dt_new = exifC$image_dt_new[1])
missing_times <- missing_times[-c(1), ]

for (i in 1:nrow(exifC)){
  if (exifC$tdiff[i] > 5) {
    ts <- seq.POSIXt(as.POSIXct(exifC$image_dt_new[i-1] + 2,'%m/%d/%y %H:%M:%S'), as.POSIXct(exifC$image_dt_new[i]-1,'%m/%d/%y %H:%M:%S'), by = "sec")
    #ts <- ts[seq(1, length(ts), 2)]
    df <- data.frame(image_dt_new = ts)
    missing_times <- rbind(missing_times, df)
    rm(ts, df)
  }
}
rm(i)

if (length(missing_times) > 0) {
  missing_times$file_name <- paste("dummy_", as.numeric(rownames(missing_times)), sep = '')
  missing_times$source_file <- paste("dummy_", as.numeric(rownames(missing_times)), sep = '')
  missing_times <- missing_times[, c("source_file", "file_name", "image_dt_new")]
  
  exifC <- exifC[, c("source_file", "file_name", "image_dt_new")]
  exifC <- rbind(exifC, missing_times)
  exifC <- exifC[order(exifC$image_dt_new), ]
} else {
  exifC <- exifC[, c("source_file", "file_name", "image_dt_new")]
  exifC <- exifC[order(exifC$image_dt_new), ]
}

# Merge data with center camera
setDT(exifC)
setkey(exifC, file_name, image_dt_new)#[, image_dt_new:=image_dt_new]
paired <- exifC[exifP, roll = 'nearest', on = "image_dt_new"]
paired <- paired[exifS, roll = 'nearest', on = "image_dt_new"]
colnames(paired) <- c("center_source", "center_image", "image_dt", "port_source", "port_image", "star_source", "star_image")
paired <- paired[, c("image_dt", "center_source", "center_image", "port_source", "port_image", "star_source", "star_image")]

missingP <- subset(exifP, !(file_name %in% paired$port_image))
colnames(missingP) <- c("port_source", "port_image", "image_dt")
missingC <- subset(exifC, !(file_name %in% paired$center_image) & grepl("dummy", exifC$file_name) == FALSE)
colnames(missingC) <- c("center_source", "center_image", "image_dt")
missingS <- subset(exifS, !(file_name %in% paired$star_image))
colnames(missingS) <- c("star_source", "star_image", "image_dt")

paired <- plyr::rbind.fill(paired, missingP)
paired <- plyr::rbind.fill(paired, missingC)
paired <- plyr::rbind.fill(paired, missingS)

rm(exifC, exifP, exifS, missingP, missingC, missingS, missing_times)

# Import GPS trackline data
track <- data.frame(readOGR(paste(wd, gps_file, sep = "/"), layer="track_points"), stringsAsFactors = FALSE)
track$gps_dt <- strptime(paste(substr(as.character(track$time), 1, 19), ".00", sep = ""), format = "%Y/%m/%d %H:%M:%OS", tz = "UTC")
track$latitude <- track$coords.x2
track$longitude <- track$coords.x1
track <- track[, c("gps_dt", "latitude", "longitude")]

# Interpolate coordinates for image
paired$latitude <- 0.01
paired$longitude <- 0.01

for (i in 1:nrow(paired)){
  for (j in 1:nrow(track)){
    track$timing[j] <- ifelse(is.na(paired$image_dt[i]), "no_data", 
                              ifelse(paired$image_dt[i] == track$gps_dt[j], "equal",
                                     ifelse(paired$image_dt[i] > track$gps_dt[j], "before", "after")))
  }
  rm(j)
  if (nrow(subset(track, timing == "no_data")) == nrow(track)) {
    # WRITE CODE TO HANDLE THIS CASE
  } else if (nrow(subset(track, timing == "equal")) > 0) {
    paired$latitude[i] <- track[which(track$timing == "equal"), c("latitude")]
    paired$longitude[i] <- track[which(track$timing == "equal"), c("longitude")]
  } else if (nrow(subset(track, timing == "before")) > 0) {
    if (nrow(subset(track, timing == "after")) > 0) {
      coord_before <- track[which(row.names(track) == max(which(track$timing == "before"))), ]
      coord_after <- track[which(row.names(track) == min(which(track$timing == "after"))), ]
      img_bearing <- geosphere::bearing(c(coord_before$longitude[1], coord_before$latitude[1]), c(coord_after$longitude[1], coord_after$latitude[1]))
      pt_time <- as.numeric(difftime(coord_after$gps_dt[1], coord_before$gps_dt[1], units = "sec"))
      img_time <- as.numeric(difftime(paired$image_dt[i], coord_before$gps_dt[1], units = "sec"))
      img_dist <- geosphere::distHaversine(c(coord_before$longitude[1], coord_before$latitude[1]), c(coord_after$longitude[1], coord_after$latitude[1])) * (img_time / pt_time)
      new_coord <- geosphere::destPoint(c(coord_before$longitude[1], coord_before$latitude[1]), img_bearing, img_dist)
      paired$latitude[i] <- new_coord[2]
      paired$longitude[i] <- new_coord[1]
    } else {
      # WRITE CODE FOR DOING NOTHING
    }
  } else {
    # WRITE CODE FOR DOING NOTHING
  }
}
rm(i, coord_before, coord_after, img_bearing, pt_time, img_time, img_dist, new_coord)

paired <- paired[order(paired$image_dt), ]

# Create spatial frame of center locations
center <- paired
coordinates(center) <- ~longitude+latitude
proj4string(center) <- CRS("+init=epsg:4326")
center <- sp::spTransform(center, CRS("+init=epsg:3338"))

# Calculate bearing between points ------------------------------------------------------------------------------
# Calculate bearing
max_n <- nrow(center)
bearing <- rep(0, max_n)
bearing = as.numeric(atan2(center@coords[2:max_n, 2] - center@coords[1:(max_n-1), 2], center@coords[2:max_n, 1] - center@coords[1:(max_n-1), 1]))
bearing[max_n] = bearing[max_n-1]
bearing[2:(max_n - 1)] = 0.5*(bearing[1:(max_n-2)] + bearing[2:(max_n-1)])
rm(max_n)

# Calculate distance between points
last_dist <- 0L
for (i in 2:nrow(center)) {
  dist <- crossdist(center@coords[i, 1], center@coords[i, 2], center@coords[i-1, 1], center@coords[i-1, 2])
  last_dist <- c(last_dist, dist)
}
rm(i, dist)
next_dist <- 0L
for (i in nrow(center):2) {
  dist <- crossdist(center@coords[i, 1], center@coords[i, 2], center@coords[i-1, 1], center@coords[i-1, 2])
  next_dist <- c(next_dist, dist)
}
rm(i, dist)
next_dist <- rev(next_dist)

# Correct any "off" bearings
bearing <- as.data.frame(bearing)
bearing <- cbind(bearing, last_dist)
bearing <- cbind(bearing, next_dist)
bearing <- cbind(bearing, center$center_image)
bearing$last_b <- dplyr::lag(bearing$bearing)
bearing$next_b <- dplyr::lead(bearing$bearing)

bearing$bearing_new <- ifelse(bearing$last_dist > 200 & bearing$next_dist < 200, bearing$next_b, 
                              ifelse(bearing$last_dist < 200 & bearing$next_dist > 200, bearing$last_b, 
                                     ifelse(bearing$last_dist > 200 & bearing$next_dist > 200,
                                            ifelse(bearing$last_dist > bearing$next_dist, bearing$next_b, bearing$last_b),
                                            bearing$bearing)))
bearing$bearing_new[nrow(bearing)] <- dplyr::lag(bearing$bearing_new)[nrow(bearing)-1]
bearing <- bearing[, c("center$center_image", "bearing_new")]
colnames(bearing) <- c("image_name", "bearing")
rm(next_dist, last_dist)

# Create table that gives camera angles, offset by aircraft, lens, and camera position --------------------------
# Information from Gavin:
### For 2010 it was the Canon EOS-1Ds Mark III and I think they used the Canon 85mm lenses. The angle should be the same (as BOSS).
### Just talked with John and he's pretty sure they used the Zeiss 85 lenses even back in 2010. Quite likely the same lenses they used for BOSS.
angles <- expand.grid(aircraft = c("Otter"), camera=c("Starboard", "Port", "Center"), lens = c(85)) 
angles$vert <- 16.07
angles$horiz <- 23.85
angles[which(angles$aircraft == "Otter" & angles$camera == "Center"), "offset" ] = 0
angles[which(angles$aircraft == "Otter" & angles$camera == "Port"), "offset" ] = 25.5
angles[which(angles$aircraft == "Otter" & angles$camera == "Starboard"), "offset" ] = 25.5
angles[ ,c("vert", "horiz", "offset")] = angles[ ,c("vert", "horiz", "offset")] * pi / 180

# Process center points through footprint corners functions for each camera and create polygons -----------------
poly_df <- data.frame(id = 1:nrow(center))
port_pitch <- -25.5 * pi / 180
starboard_pitch <- 25.5 * pi / 180

## CENTER
poly_c <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[1], center@coords[1, ], 305))
poly_c <- SpatialPolygons(list(Polygons(list(poly_c), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[i], center@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  poly_c <- maptools::spRbind(poly_c, temp)
}
poly_c <- SpatialPolygonsDataFrame(poly_c, poly_df)
poly_c$image_name <- center$center_image
poly_c$camera <- 'Center'

rect <- poly_c
poly <- poly_c

# Process rectangles for port and starboard images
## PORT
rect_p <- Polygon(get_rectangle_corners_port(angles, 0, bearing$bearing[1], center@coords[1, ], 305))
rect_p <- SpatialPolygons(list(Polygons(list(rect_p), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_rectangle_corners_port(angles, 0, bearing$bearing[i], center@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  rect_p <- maptools::spRbind(rect_p, temp)
}

rect_p_pts <- data.frame(coordinates(rect_p))
coordinates(rect_p_pts) <- ~X1+X2
proj4string(rect_p_pts) <- CRS("+init=epsg:3338")
rect_p_pts <- sp::spTransform(rect_p_pts, CRS("+init=epsg:3338"))

rect_p <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[1], rect_p_pts@coords[1, ], 305))
rect_p <- SpatialPolygons(list(Polygons(list(rect_p), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[i], rect_p_pts@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  rect_p <- maptools::spRbind(rect_p, temp)
}
rect_p <- SpatialPolygonsDataFrame(rect_p, poly_df)
rect_p <- spChFIDs(rect_p, as.character(c(nrow(rect) + 1:nrow(rect_p) * 2)))

rect_p$image_name <- center$port_image
rect_p$camera <- 'Port'

rect <- maptools::spRbind(rect, rect_p)
rect <- spChFIDs(rect, as.character(c(1:nrow(rect))))

## STARBOARD
rect_s <- Polygon(get_rectangle_corners_starboard(angles, 0, bearing$bearing[1], center@coords[1, ], 305))
rect_s <- SpatialPolygons(list(Polygons(list(rect_s), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_rectangle_corners_starboard(angles, 0, bearing$bearing[i], center@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  rect_s <- maptools::spRbind(rect_s, temp)
}

rect_s_pts <- data.frame(coordinates(rect_s))
coordinates(rect_s_pts) <- ~X1+X2
proj4string(rect_s_pts) <- CRS("+init=epsg:3338")
rect_s_pts <- sp::spTransform(rect_s_pts, CRS("+init=epsg:3338"))

rect_s <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[1], rect_s_pts@coords[1, ], 305))
rect_s <- SpatialPolygons(list(Polygons(list(rect_s), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_footprint_corners_center(angles, 0, bearing$bearing[i], rect_s_pts@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  rect_s <- maptools::spRbind(rect_s, temp)
}
rect_s <- SpatialPolygonsDataFrame(rect_s, poly_df)
rect_s <- spChFIDs(rect_s, as.character(c(nrow(rect) + 1:nrow(rect_s))))

rect_s$image_name <- center$star_image
rect_s$camera <- 'Starboard'

rect <- maptools::spRbind(rect, rect_s)
rect <- spChFIDs(rect, as.character(c(1:nrow(rect))))

# Final rect processing
rect <- rect[which(!is.na(rect$image_name)), !(names(rect) %in% c("id"))]
rect <- rect[!grepl("dummy", rect$image_name), ]
rect <- rect[order(rect$image_name), ]

rm()

# Process footprints for port and starboard images
## PORT
poly_p <- Polygon(get_footprint_corners_port(angles, 0, bearing$bearing[1], center@coords[1, ], 305))
poly_p <- SpatialPolygons(list(Polygons(list(poly_p), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_footprint_corners_port(angles, 0, bearing$bearing[i], center@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  poly_p <- maptools::spRbind(poly_p, temp)
}
poly_p <- SpatialPolygonsDataFrame(poly_p, poly_df)
poly_p <- spChFIDs(poly_p, as.character(c(nrow(poly) + 1:nrow(poly_p) * 2)))

poly_p$image_name <- center$port_image
poly_p$camera <- 'Port'

poly <- maptools::spRbind(poly, poly_p)
poly <- spChFIDs(poly, as.character(c(1:nrow(poly))))

## STARBOARD
poly_s <- Polygon(get_footprint_corners_starboard(angles, 0, bearing$bearing[1], center@coords[1, ], 305))
poly_s <- SpatialPolygons(list(Polygons(list(poly_s), ID = 1)), proj4string=CRS("+init=epsg:3338"))
for (i in 2:nrow(center)){
  temp <- Polygon(get_footprint_corners_starboard(angles, 0, bearing$bearing[i], center@coords[i, ], 305))
  temp <- SpatialPolygons(list(Polygons(list(temp), ID = i)), proj4string=CRS("+init=epsg:3338"))
  poly_s <- maptools::spRbind(poly_s, temp)
}
poly_s <- SpatialPolygonsDataFrame(poly_s, poly_df)
poly_s <- spChFIDs(poly_s, as.character(c(nrow(poly) + 1:nrow(poly_s))))

poly_s$image_name <- center$star_image
poly_s$camera <- 'Starboard'

poly <- maptools::spRbind(poly, poly_s)
poly <- spChFIDs(poly, as.character(c(1:nrow(poly))))

# Final poly processing
poly <- poly[which(!is.na(poly$image_name)), !(names(poly) %in% c("id"))]
poly <- poly[!grepl("dummy", poly$image_name), ]
poly <- poly[order(poly$image_name), ]

# Clean up memory
rm (rect_p, rect_p_pts, rect_s, rect_s_pts, poly_c, poly_p, poly_s, poly_df, temp, bearing, angles, center, i, track)

# Process seal locations and spatial join to rectangles -------------------------------------------------------
# Convert rect data to sf format
rect <- sf::st_as_sf(rect, crs = 3338)
rect$id <- 1:nrow(rect)

# Load and process seal data
seal <- rgdal::readOGR(dsn = paste(wd, survey, map_folder, sep = "/"), layer = seal_locs)
seal <- sp::spTransform(seal, CRS("+init=epsg:3338"))
seal <- sf::st_as_sf(seal, crs = 3338)
seal_total <- nrow(seal[which(seal$dupl_seal == "N" | is.na(seal$dupl_seal)), ])
seal$sealid <- 1:nrow(seal)

# Process seals with image name -----------------
sealWimage <- seal[which(!is.na(seal$img_name)), ]

if(nrow(sealWimage) > 0){
  sealWimage <- sealWimage[, c("sealid", "img_name")]
  sealWimage$img_name <- paste(sealWimage$img_name, ".JPG", sep = "")
  sealWimage <- as.data.frame(st_intersection(sealWimage, rect))
  sealWimage <- sealWimage[which(sealWimage$image_name == sealWimage$img_name), ]
  sealWimage <- sealWimage[, c("sealid", "image_name", "camera")]
}


# Process seals without image name --------------
sealOimage <- seal[which(is.na(seal$img_name)), ]

# Spatial join seals to rectangles
seal_join <- as.data.frame(st_intersection(sealOimage, rect))

# Create seals dataset that fall within image rectangle
seal_in <- seal_join[, c("sealid", "image_name", "camera")]

# Create seals dataset that fall withing two image rectangles
seal_double <- seal_in[duplicated(seal_in$sealid), ]
seal_double <- seal[seal$sealid %in% seal_double$sealid, ]
seal_in <- seal_in[!seal_in$sealid %in% seal_double$sealid, ]

# Process seals that fall outside image rectangle
seal_miss <- seal[!seal$sealid %in% seal_join$sealid, ]
seal_miss <- seal_miss[!seal_miss$sealid %in% sealWimage$sealid, ]

if(nrow(seal_miss) > 0) {
  seal4near <- rbind(seal_double, seal_miss)
  seal4near$id <- 1:nrow(seal4near)

  seal.knn <- sf::st_coordinates(seal4near)
  rect.knn <- sf::st_coordinates(sf::st_centroid(rect))

  seal_near <- as.data.frame(nabor::knn(rect.knn, seal.knn, k = 1))
  seal_near$id <- 1:nrow(seal_near)
  colnames(seal_near) <- c("image_id", "dist", "id")

  seal_near <- merge(seal_near, rect, by.x = "image_id", by.y = "id")
  seal_near <- merge(seal_near, seal4near, by = "id")
  seal_near <- seal_near[, c("sealid", "image_name", "camera")]
  seal_in <- rbind(seal_in, seal_near)
  rm(seal4near, seal.knn, rect.knn, seal_near)
}

# Merge in and out seals and get count per image
if(nrow(sealWimage) > 0){
  seal_image <- rbind(sealWimage, seal_in)
} else{
  seal_image <- seal_in
}
seal_count <- data.frame(table(seal_image$image_name, seal_image$camera), stringsAsFactors = FALSE)
colnames(seal_count) <- c("image_name", "camera", "seals")
seal_count$image_name <- as.character(seal_count$image_name)
seal_count$camera <- as.character(seal_count$camera)

rm(seal, seal.knn, rect, rect.knn, seal_join, seal_in, seal_miss, seal_near, seal_image, seal4near, seal_double, sealOimage, sealWimage)

# Merge counts per image with footprints
poly <- merge(poly, seal_count, by = c("image_name", "camera"), all.x = TRUE)
poly$seals <- as.integer(ifelse(is.na(poly$seals), 0 , poly$seals))
poly$total <- as.integer(c(seal_total, rep(0, nrow(poly) - 1)))
poly <- poly[, c("image_name", "camera", "seals", "total")]
rm(seal_count)

# Remove dummy center images if applicable
poly <- poly[which((!grepl("dummy", poly$image_name) & poly$camera == 'Center') | poly$camera != 'Center'), ]

# Export shapefile
rgdal::writeOGR(obj = poly, dsn = paste(wd, survey, map_folder, sep = "/"), layer = export_shp, driver = "ESRI Shapefile", overwrite_layer = TRUE)
#rgdal::writeOGR(obj = rect, dsn = path, layer = "rectangles", driver = "ESRI Shapefile", overwrite_layer = TRUE)