# Glacial Pv Surveys: Write meta.json data to image exif
# S. Hardy, 16Feb2021

# STARTING VARIABLES (enter values as degrees)
survey_id <- "northwestern_20200911b"
offset_center <- 0
offset_left <- -21.5   # left view should have negative offset value
offset_right <- 21.5 # right view should have positive offset value

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
install_pkg("RPostgreSQL")
install_pkg("tidyverse")

# Run code -------------------------------------------------------
# Set initial working directory 
wd <- "//nmfs/akc-nmml/Polar/Users/Hardy/northwestern_20200911b"

# Get data from the DB for processing
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

meta <- RPostgreSQL::dbGetQuery(con, paste("select survey_id, flight, camera_view, dt, image_name, ins_longitude, ins_latitude, ins_altitude, ins_heading, ins_pitch, ins_roll
                                        from surv_pv_gla.geo_images_meta 
                                        left join surv_pv_gla.tbl_images
                                        using (flight, camera_view, dt)
                                        where survey_id = \'", survey_id, "\'
                                        and image_type = \'RGB Image\' and camera_view = \'R\'", sep = "")) %>%
  mutate(ImagePath = ifelse(camera_view == 'C', paste(wd, "center_view", image_name, sep = "/"),
                             ifelse(camera_view == 'L', paste(wd, "left_view", image_name, sep = "/"), 
                                    paste(wd, "right_view", image_name, sep = "/"))),
         ins_roll_adj = ifelse(camera_view == 'C', ins_roll,
                               ifelse(camera_view == 'L', ins_roll + offset_left, ins_roll + offset_right)),
         lat_d = floor(ins_latitude),
         lat_m = floor((ins_latitude - lat_d) * 60), 
         lat_s = round((((ins_latitude - lat_d) * 60) - floor((ins_latitude - lat_d) * 60)) * 60), 
         long_d = floor(abs(ins_longitude)),
         long_m = floor((abs(ins_longitude) - long_d) * 60), 
         long_s = round((((abs(ins_longitude) - long_d) * 60) - floor((abs(ins_longitude) - long_d) * 60)) * 60), 
         SourceFile = image_name, 
         FocalLength = as.character(85),
         DateTimeOriginal = as.character(paste(substring(dt, 1, 4), ":", substring(dt, 5, 6), ":", substring(dt, 7, 8), " ",
                                        substring(dt, 10, 11), ":", substring(dt, 12, 13), ":", substring(dt, 14, 15), sep = "")),
         SubSecTimeOriginal = as.character(substring(dt, 17, 19)),
         GPSDateStamp = as.character(paste(substring(dt, 1, 4), ":", substring(dt, 5, 6), ":", substring(dt, 7, 8), sep = "")),
         GPSTimeStamp = as.character(paste(substring(dt, 10, 11), ":", substring(dt, 12, 13), ":", substring(dt, 14, 15), sep = "")),
         GPSLatitude = as.character(paste(lat_d, lat_m,  lat_s, sep = " ")),
         GPSLatitudeRef = 'N',
         GPSLongitude = as.character(paste(long_d, long_m,  long_s, sep = " ")),
         GPSLongitudeRef = ifelse(ins_longitude < 0, "W", "E"),
         GPSAltitude = ins_altitude,
         Yaw = ins_heading,
         Pitch = ifelse(ins_pitch < 0, ins_pitch + 360, ins_pitch),
         Roll = ifelse(ins_roll_adj < 0, abs(ins_roll_adj), 360 - ins_roll_adj)) %>%
  select(ImagePath, SourceFile, FocalLength, DateTimeOriginal, SubSecTimeOriginal, GPSDateStamp, GPSTimeStamp, GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef, GPSAltitude, Yaw, Pitch, Roll)

 for (i in 1:nrow(meta)){
   exiftool_cmd <- paste("C:/Users/stacie.hardy/Work/Work/PortablePrograms/exiftool-12.18/exiftool.exe -config C:/Users/stacie.hardy/Work/Work/PortablePrograms/exiftool-12.18/pix4d.config -overwrite_original -FocalLength=\"", meta$FocalLength[i], "\" ", 
                         "-DateTimeOriginal=\"", meta$DateTimeOriginal[i], "\" ", 
                         "-SubSecTimeOriginal=\"", meta$SubSecTimeOriginal[i], "\" ", 
                         "-GPSDateStamp=\"", meta$GPSDateStamp[i], "\" ", 
                         "-GPSTimeStamp=\"", meta$GPSTimeStamp[i], "\" ", 
                         "-GPSLatitude=\"", meta$GPSLatitude[i], "\" ", 
                         "-GPSLatitudeRef=\"", meta$GPSLatitudeRef[i], "\" ", 
                         "-GPSLongitude=\"", meta$GPSLongitude[i], "\" ", 
                         "-GPSLongitudeRef=\"", meta$GPSLongitudeRef[i], "\" ", 
                         "-GPSAltitude=\"", meta$GPSAltitude[i], "\" ", 
                         "-Camera:Yaw=", meta$Yaw[i], " ", 
                         "-Camera:Pitch=", meta$Pitch[i], " ",
                         "-Camera:Roll=", meta$Roll[i], " ",
                         meta$ImagePath[i], sep= "")
   system(exiftool_cmd)
 }

RPostgreSQL::dbDisconnect(con)
rm(con, i, exiftool_cmd)