# Glacial Pv Surveys: Create project folders and store exif data in images

# STARTING VARIABLES (enter values as degrees)
survey_year <- 2020
offset_center <- 0
offset_left <- 21.5   # left view should have positive offset value (after tests with Pix4D)
offset_right <- -21.5 # right view should have negative offset value (after tests with Pix4D)

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
wd <- paste("//nmfs/akc-nmml/Polar_Imagery/SurveyS_HS/Glacial/Projects/Surveys Glacial Sites Counts", survey_year, "_ReadyForMosaic", sep = "/")

if (file.exists(wd) == TRUE) {
  # unlink(wd, recursive = TRUE)
}

dir.create(wd)
setwd(wd)

image_path <- paste("//nmfs/akc-nmml/Polar_Imagery/SurveyS_HS/Glacial/Originals", survey_year, sep = "/")

# Get data from the DB for processing
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

meta <- RPostgreSQL::dbGetQuery(con, paste("select * from surv_pv_gla.tbl_images_4processing where (survey_method_lku = \'M\' or survey_method_lku = \'T\') and survey_year::integer = ", survey_year,  sep = "")) %>%
  mutate(ImageSurveyID = image_survey_id,
         ImagePath = ifelse(camera_view == 'C', paste(image_path, flight, "center_view", image_name, sep = "/"),
                             ifelse(camera_view == 'L', paste(image_path, flight, "left_view", image_name, sep = "/"), 
                                    paste(image_path, flight, "right_view", image_name, sep = "/"))),
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
         Roll = ifelse(ins_roll_adj < 0, abs(ins_roll_adj), 360 - ins_roll_adj)) 

surveys <- meta %>%
  select(ImageSurveyID, survey_id, survey_rep_f) %>%
  distinct()

meta <- meta %>%
  select(ImageSurveyID, ImagePath, SourceFile, FocalLength, DateTimeOriginal, SubSecTimeOriginal, GPSDateStamp, GPSTimeStamp, GPSLatitude, GPSLatitudeRef, GPSLongitude, GPSLongitudeRef, GPSAltitude, Yaw, Pitch, Roll)

for (j in 1:nrow(surveys)) {
  copy_project <- paste(wd, surveys$ImageSurveyID[j], sep = "/")
  dir.create(copy_project)
  
  copy_path <- paste(wd, surveys$ImageSurveyID[j], "01_Images", sep = "/")
  dir.create(copy_path)
  
  images2process <- meta %>%
    filter(ImageSurveyID == surveys$ImageSurveyID[j])
  
  for (i in 1:nrow(images2process)){
    RPostgreSQL::dbGetQuery(con, "SELECT * FROM surv_pv_gla.lku_site")
    
    file.copy(images2process$ImagePath[i], paste(copy_path, basename(images2process$ImagePath[i]), sep = "/"))
    
    exiftool_cmd <- paste("C:/Users/stacie.hardy/Work/Work/PortablePrograms/exiftool-12.18/exiftool.exe -config C:/Users/stacie.hardy/Work/Work/PortablePrograms/exiftool-12.18/pix4d.config -overwrite_original -FocalLength=\"", images2process$FocalLength[i], "\" ", 
                          "-DateTimeOriginal=\"", images2process$DateTimeOriginal[i], "\" ", 
                          "-SubSecTimeOriginal=\"", images2process$SubSecTimeOriginal[i], "\" ", 
                          "-GPSDateStamp=\"", images2process$GPSDateStamp[i], "\" ", 
                          "-GPSTimeStamp=\"", images2process$GPSTimeStamp[i], "\" ", 
                          "-GPSLatitude=\"", images2process$GPSLatitude[i], "\" ", 
                          "-GPSLatitudeRef=\"", images2process$GPSLatitudeRef[i], "\" ", 
                          "-GPSLongitude=\"", images2process$GPSLongitude[i], "\" ", 
                          "-GPSLongitudeRef=\"", images2process$GPSLongitudeRef[i], "\" ", 
                          "-GPSAltitude=\"", images2process$GPSAltitude[i], "\" ", 
                          "-Camera:Yaw=", images2process$Yaw[i], " ", 
                          "-Camera:Pitch=", images2process$Pitch[i], " ",
                          "-Camera:Roll=", images2process$Roll[i], " \"",
                          paste(copy_path, basename(images2process$ImagePath[i]), sep = "/"), "\"", sep= "")
    system(exiftool_cmd)
  }
  
  RPostgreSQL::dbSendQuery(con, paste("UPDATE surv_pv_gla.tbl_flyovers f SET data_status_lku = \'D\' FROM surv_pv_gla.tbl_event e WHERE f.event_id = e.id AND e.survey_id = \'", 
                                      surveys$survey_id[j], 
                                      "\' AND f.survey_rep = ",
                                      surveys$survey_rep_f[j],
                                      sep = ''))
}

RPostgreSQL::dbDisconnect(con)
rm(con)