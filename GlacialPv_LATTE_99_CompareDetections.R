# Match bounding boxes between RGB datasets for glacial LATTE processing review

# Variables
survey_id <- "dbay_20200904_sample_1"

file_folder <- "\\\\akc0ss-n086\\NMML_Polar_Imagery\\Surveys_HS\\Glacial\\Projects\\Surveys Glacial Sites Counts\\2020\\dbay_20200904_sample_1"

# file_allrgb_model <- "dbay_20200904_sample_1_all_rgb_detections_20220426_processed.csv" # not using for DBay
file_ir2rgb_ir_model_C <- "dbay_20200904_sample_1_C_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_ir_model_L <- "dbay_20200904_sample_1_L_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_ir_model_R <- "dbay_20200904_sample_1_R_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_rgb_model_C <- "dbay_20200904_sample_1_C_trigger_detectionsRGB_20220426_processed.csv"
file_ir2rgb_rgb_model_L <- "dbay_20200904_sample_1_L_trigger_detectionsRGB_20220426_processed.csv"
file_ir2rgb_rgb_model_R <- "dbay_20200904_sample_1_R_trigger_detectionsRGB_20220426_processed.csv"
file_allrgb_manual <- "dbay_20200904_sample_1_all_rgb_manualReview_20220916_final.csv"
file_ir2rgb_manual_C <- "dbay_20200904_sample_1_C_ir-rgb_manualReview_rgbDetections_20220810.csv"
file_ir2rgb_manual_L <- "dbay_20200904_sample_1_L_ir-rgb_manualReview_rgbDetections_20220908.csv"
file_ir2rgb_manual_R <- "dbay_20200904_sample_1_R_ir-rgb_manualReview_rgbDetections_20220912.csv"

### Need to copy data locally for work in Seward


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
install_pkg("tidyverse")
install_pkg("RPostgreSQL")

# Process data --------------------------------------------------
setwd(file_folder)
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              #port = Sys.getenv("pep_port"), 
                              user = Sys.getenv("pep_admin"), 
                              password = Sys.getenv("admin_pw"))

# Get NUC images
nuc_rgb <- RPostgreSQL::dbGetQuery(con, paste("SELECT image_name, ir_nuc FROM surv_pv_gla.tbl_images_4processing_latte WHERE image_survey_id = \'",
                                              survey_id,
                                              "\' AND image_type = \'rgb_image\' and ir_nuc = \'Y\'", sep = ""))
### This also needs to include cases where IR images is dropped.

# Get processed detection data
allrgb_model <- read.csv(file_allrgb_model, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                         col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                       "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("allrgb_model_", .x)) 

ir2rgb_ir_model <- read.csv(file_ir2rgb_ir_model_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                         col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                       "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_ir_model_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_ir_model_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("ir2rgb_ir_model_", .x))

ir2rgb_rgb_model <- read.csv(file_ir2rgb_rgb_model_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                            col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                          "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_rgb_model_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_rgb_model_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("ir2rgb_rgb_model_", .x))
 
                         
allrgb_manual <- read.csv(file_allrgb_manual, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                         col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                       "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  full_join(nuc_rgb, by = "image_name") %>%
  rename_with( ~ paste0("allrgb_manual_", .x))

ir2rgb_manual <- read.csv(file_ir2rgb_manual_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                            col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                          "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_manual_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_manual_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("ir2rgb_manual_", .x))

# Merge datasets together
data <- original %>%
  full_join(processed, by = "image_name") %>%
  select(image_name, o_detection, p_detection, o_left, o_right, p_left, p_right, o_top, o_bottom, p_top, p_bottom, o_score, o_detection_type, p_detection_type, o_average_x, p_average_x, o_average_y, p_average_y) %>%
  mutate(intersect_LR = ifelse(p_right < o_left | p_left > o_right, "no", "yes"),
         intersect_TB = ifelse(p_top > o_bottom | p_bottom < o_top, "no", "yes"))

intersecting <- data %>%
  filter(intersect_LR == "yes" & intersect_TB == "yes") %>%
  mutate(distance = (sqrt(((o_average_x - p_average_x) ^ 2) + ((o_average_y - p_average_y) ^ 2)))) %>%
  group_by(image_name, p_detection) 
  
if(method == "minimum_distance") {
  intersecting <- intersecting %>%
    slice(which.min(distance))
  } else if (method == "maximum_score") {
  intersecting <- intersecting %>%
    slice(which.max(o_score))
  }

intersecting4missing <- intersecting %>%
  select(image_name, o_detection, p_detection)

missing_o <- original %>%
  full_join(intersecting4missing, by = c("image_name", "o_detection")) %>%
  filter(is.na(p_detection))

missing_p <- processed %>%
  full_join(intersecting4missing, by = c("image_name", "p_detection")) %>%
  filter(is.na(o_detection))

# Tidy up workspace and disconnect from DB
RPostgreSQL::dbDisconnect(con)
rm(con, intersecting4missing, data)