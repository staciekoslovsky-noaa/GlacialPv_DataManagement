# Coastal Pv Surveys: Extract exif from full coverage sites to identify date/time offset
# S. Hardy, 12JUL2018

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

# Install libraries ----------------------------------------------
# Installation of exifr requires portable perl to be stored at the following location on computer: C:\Strawberry!!!
install_pkg("exifr")
install_pkg("dplyr")
install_pkg("lubridate")
install_pkg("rgdal")
install_pkg("sp")
install_pkg("maptools")
install_pkg("dplyr")
install_pkg("sf")
install_pkg("nabor")
install_pkg("spatstat")
#install_pkg("devtools")
#devtools::install_github("paleolimbot/exifr")

# Run code -------------------------------------------------------
# Set initial working directory -------------------------------------------------------
wd <- "//akc0SS-N086/NMML_Users/Stacie.Hardy/Work/Projects/AS_HarborSeal_Glacial/Images/yale_20150801"
gps_file <- "glacial_20150801_georef.gpx"

# Get list of images
images <- list.files(wd, pattern = "CCam.jpg$|CCam.JPG$", full.names = TRUE)

# Extract exif data from images and process for use in interpolation
tags <- c("SourceFile", "FileName", "SubSecDateTimeOriginal")
exif <- exifr::read_exif(images, tags = tags)
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
 
# Import GPS trackline data
track <- data.frame(readOGR(paste(wd, gps_file, sep = "/"), layer="track_points"), stringsAsFactors = FALSE)
track$gps_dt <- strptime(paste(substr(as.character(track$time), 1, 19), ".00", sep = ""), format = "%Y/%m/%d %H:%M:%OS", tz = "UTC")
track$latitude <- track$coords.x2
track$longitude <- track$coords.x1
track$altitude <- track$ele
track <- track[, c("gps_dt", "latitude", "longitude", "altitude")]

# Interpolate coordinates for image
exif$latitude <- 0.01
exif$longitude <- 0.01
exif$altitude <- 0.01

for (i in 1:nrow(exif)){
  for (j in 1:nrow(track)){
    track$timing[j] <- ifelse(is.na(exif$image_dt[i]), "no_data", 
                              ifelse(exif$image_dt[i] == track$gps_dt[j], "equal",
                                     ifelse(exif$image_dt[i] > track$gps_dt[j], "before", "after")))
  }
  rm(j)
  if (nrow(subset(track, timing == "no_data")) == nrow(track)) {
    # WRITE CODE TO HANDLE THIS CASE
  } else if (nrow(subset(track, timing == "equal")) > 0) {
    exif$latitude[i] <- track[which(track$timing == "equal"), c("latitude")]
    exif$longitude[i] <- track[which(track$timing == "equal"), c("longitude")]
    exif$altitude[i] <- track[which(track$timing == "equal"), c("altitude")]
  } else if (nrow(subset(track, timing == "before")) > 0) {
    if (nrow(subset(track, timing == "after")) > 0) {
      coord_before <- track[which(row.names(track) == max(which(track$timing == "before"))), ]
      coord_after <- track[which(row.names(track) == min(which(track$timing == "after"))), ]
      img_bearing <- geosphere::bearing(c(coord_before$longitude[1], coord_before$latitude[1]), c(coord_after$longitude[1], coord_after$latitude[1]))
      pt_time <- as.numeric(difftime(coord_after$gps_dt[1], coord_before$gps_dt[1], units = "sec"))
      img_time <- as.numeric(difftime(exif$image_dt[i], coord_before$gps_dt[1], units = "sec"))
      img_dist <- geosphere::distHaversine(c(coord_before$longitude[1], coord_before$latitude[1]), c(coord_after$longitude[1], coord_after$latitude[1])) * (img_time / pt_time)
      new_coord <- geosphere::destPoint(c(coord_before$longitude[1], coord_before$latitude[1]), img_bearing, img_dist)
      exif$latitude[i] <- new_coord[2]
      exif$longitude[i] <- new_coord[1]
      exif$altitude[i] <- (coord_before$altitude + coord_after$altitude) /2
    } else {
      # WRITE CODE FOR DOING NOTHING
    }
  } else {
    # WRITE CODE FOR DOING NOTHING
  }
}

write.csv(exif, "C:/skh/interpolated_centers_yale_20150801.csv", row.names = FALSE)
