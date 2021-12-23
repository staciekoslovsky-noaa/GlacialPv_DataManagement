# Glacial Pv Surveys: Create project folders and store exif data in images

# STARTING VARIABLES (enter values as degrees)
survey_year <- 2020

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
wd <- paste("//nmfs/akc-nmml/Polar_Imagery/SurveyS_HS/Glacial/Projects/Surveys Glacial Sites Counts", survey_year, "_ReadyForLATTE", sep = "/")

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

meta <- RPostgreSQL::dbGetQuery(con, paste("select * from surv_pv_gla.tbl_images_4processing_latte where survey_method_lku = \'L\' and survey_year::integer = ", survey_year,  sep = "")) %>%
  mutate(ImageSurveyID = image_survey_id,
         ImagePath = ifelse(camera_view == 'C', paste(image_path, flight, "center_view", image_name, sep = "/"),
                             ifelse(camera_view == 'L', paste(image_path, flight, "left_view", image_name, sep = "/"), 
                                    paste(image_path, flight, "right_view", image_name, sep = "/")))) 

surveys <- meta %>%
  select(ImageSurveyID, survey_id, survey_rep_f) %>%
  distinct()

for (j in 1:nrow(surveys)) {
  copy_project <- paste(wd, surveys$ImageSurveyID[j], sep = "/")
  dir.create(copy_project)
  
  copy_path <- paste(wd, surveys$ImageSurveyID[j], sep = "/")
  dir.create(copy_path)
  
  images2process <- meta %>%
    filter(ImageSurveyID == surveys$ImageSurveyID[j]) 
  
  # Create image list of all RGB images -- one for each C, L, R
  image_list_rgbOnly <- images2process %>%
    filter(image_type == 'rgb_image') %>%
    mutate(rgb_image_name = image_name) %>%
    select(flight, camera_view, dt, rgb_image_name)
  
  # Create image list of all IR images
  image_list_irOnly <- images2process %>%
    filter(image_type == 'ir_image') %>%
    mutate(ir_image_name = image_name) %>%
    select(flight, camera_view, dt, ir_image_name, ir_nuc)
  
  # Create image list of all RGB images where corresponding IR image is NUC
  image_list_rgbWhereIRnuc <- image_list_rgbOnly %>%
    full_join(image_list_irOnly, by = C("flight", "camera_view", "dt"))
    filter(image_type == 'rgb_image' & ir_nuc == 'Y')
  
  # Create image list of all RGB images where corresponding IR image is not NUC
  image_list_rgbWhereIRnotNUC <- images2process %>%
    filter(image_type == 'rgb_image'& ir_nuc == 'N')
  
  # Create image list of all non-NUC IR images
  image_list_irOnly <- images2process %>%
    filter(image_type == 'ir_image' & ir_nuc == 'N')
  
  RPostgreSQL::dbSendQuery(con, paste("UPDATE surv_pv_gla.tbl_flyovers f SET data_status_lku = \'V\' FROM surv_pv_gla.tbl_event e WHERE f.event_id = e.id AND e.survey_id = \'", 
                                      surveys$survey_id[j], 
                                      "\' AND f.survey_rep = ",
                                      surveys$survey_rep_f[j],
                                      sep = ''))
}

RPostgreSQL::dbDisconnect(con)
rm(con)