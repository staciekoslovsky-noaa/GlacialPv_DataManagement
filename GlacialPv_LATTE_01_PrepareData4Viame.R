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
  mutate(image_path = image_dir
         #ifelse(camera_view == 'C', paste(image_path, flight, "center_view", image_name, sep = "/"),
                      #       ifelse(camera_view == 'L', paste(image_path, flight, "left_view", image_name, sep = "/"), 
                      #              paste(image_path, flight, "right_view", image_name, sep = "/")))
         ) 

surveys <- meta %>%
  select(image_survey_id, survey_id, survey_rep_f) %>%
  distinct()

for (j in 1:nrow(surveys)) {
  copy_path <- paste(wd, surveys$image_survey_id[j], sep = "/")
  dir.create(copy_path)
  
  images2process <- meta %>%
    filter(image_survey_id == surveys$image_survey_id[j]) 
  
  # Create image list of all RGB images -- all will be reviewed without IR images -- one file for all images
  image_list_rgb <- images2process %>%
    filter(image_type == 'rgb_image') %>%
    mutate(rgb_image_name = image_name,
           rgb_image_path = image_path) %>%
    select(flight, camera_view, dt, rgb_image_name, rgb_image_path)
  
  # Create image list of all IR images -- just a starting point for other lists
  image_list_ir <- images2process %>%
    filter(image_type == 'ir_image') %>%
    mutate(ir_image_name = image_name,
           ir_image_path = image_path) %>%
    select(flight, camera_view, dt, ir_image_name, ir_nuc, ir_image_path) 
  
  # Create image list of all paired images -- just a starting point for other lists
  image_list_paired <- image_list_ir %>%
    full_join(image_list_rgb, by = c("flight", "camera_view", "dt")) 
  
  # Create image list of all non-NUC IR images with RGB images --  export both for each C, L, R
  image_list_irwithRGB <- image_list_paired %>%
    filter(!is.na(rgb_image_name) & ir_nuc == "N" & !is.na(ir_image_name)) %>%
    select(flight, camera_view, dt, ir_image_name, ir_nuc, ir_image_path)
  
  for (i in c("C", "L", "R")) {
    camera_sub <- i
    
    image_list_irwithRGB_sub <- image_list_irwithRGB %>%
      filter(camera_view == camera_sub) %>%
      select(ir_image_path)
    
    write.table(image_list_irwithRGB_sub, paste(copy_path, "/", surveys$image_survey_id[j], "_", camera_sub, "_irWithRGB_images_", format(Sys.time(), "%Y%m%d"), ".txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE)
  }
  
  image_list_rgbWithIR <- image_list_paired %>%
    filter(!is.na(rgb_image_name) & ir_nuc == "N" & !is.na(ir_image_name)) %>%
    select(flight, camera_view, dt, rgb_image_name, rgb_image_path)
  
  for (i in c("C", "L", "R")) {
    camera_sub <- i
    
    image_list_rgbWithIR_sub <- image_list_rgbWithIR %>%
      filter(camera_view == camera_sub) %>%
      select(rgb_image_path)
    
    write.table(image_list_rgbWithIR_sub, paste(copy_path, "/", surveys$image_survey_id[j], "_", camera_sub, "_rgbWithIR_images_", format(Sys.time(), "%Y%m%d"), ".txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE)
  }
  
  # Create image list of all RGB images where corresponding IR image is NUC or missing -- one file for all images
  image_list_rgbNoIR <- image_list_paired %>%
    filter(is.na(ir_image_name) | ir_nuc == "Y") %>%
    #select(flight, camera_view, dt, rgb_image_name, rgb_image_path)
    select(rgb_image_path)
  write.table(image_list_rgbNoIR, paste(copy_path, "/", surveys$image_survey_id[j], "_all_rgbWithoutIR_images_", format(Sys.time(), "%Y%m%d"), ".txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE)
  
  # Finish processing RGB image list
  image_list_rgb <- image_list_rgb %>%
    select(rgb_image_path)
  write.table(image_list_rgb, paste(copy_path, "/", surveys$image_survey_id[j], "_all_rgb_images_", format(Sys.time(), "%Y%m%d"), ".txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE)
  
  # Update DB to indicate data have been processed
  RPostgreSQL::dbSendQuery(con, paste("UPDATE surv_pv_gla.tbl_flyovers f SET data_status_lku = \'V\' FROM surv_pv_gla.tbl_event e WHERE f.event_id = e.id AND e.survey_id = \'", 
                                      surveys$survey_id[j], 
                                      "\' AND f.survey_rep = ",
                                      surveys$survey_rep_f[j],
                                      sep = ''))
}

RPostgreSQL::dbDisconnect(con)
rm(con)