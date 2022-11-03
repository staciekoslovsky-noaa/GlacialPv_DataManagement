# Match bounding boxes between RGB datasets for glacial LATTE processing review

# Variables
# survey_id <- "dbay_20200904_sample_1"
# file_folder <- "\\\\akc0ss-n086\\NMML_Polar_Imagery\\Surveys_HS\\Glacial\\Projects\\Surveys Glacial Sites Counts\\2020\\dbay_20200904_sample_1"
# 
# # file_allrgb_model <- "dbay_20200904_sample_1_all_rgb_detections_20220426_processed.csv" # not using for DBay
# file_ir2rgb_ir_model_C <- "dbay_20200904_sample_1_C_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
# file_ir2rgb_ir_model_L <- "dbay_20200904_sample_1_L_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
# file_ir2rgb_ir_model_R <- "dbay_20200904_sample_1_R_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
# file_ir2rgb_rgb_model_C <- "dbay_20200904_sample_1_C_trigger_detectionsRGB_20220426_processed.csv"
# file_ir2rgb_rgb_model_L <- "dbay_20200904_sample_1_L_trigger_detectionsRGB_20220426_processed.csv"
# file_ir2rgb_rgb_model_R <- "dbay_20200904_sample_1_R_trigger_detectionsRGB_20220426_processed.csv"
# file_allrgb_manual <- "dbay_20200904_sample_1_all_rgb_manualReview_20220916_final.csv"
# file_ir2rgb_manual_C <- "dbay_20200904_sample_1_C_ir-rgb_manualReview_rgbDetections_20220810.csv"
# file_ir2rgb_manual_L <- "dbay_20200904_sample_1_L_ir-rgb_manualReview_rgbDetections_20220908.csv"
# file_ir2rgb_manual_R <- "dbay_20200904_sample_1_R_ir-rgb_manualReview_rgbDetections_20220912.csv"


survey_id <- "columbia_20200909_sample_1"
file_folder <- "\\\\akc0ss-n086\\NMML_Polar_Imagery\\Surveys_HS\\Glacial\\Projects\\Surveys Glacial Sites Counts\\2020\\columbia_20200909_sample_1"

# file_allrgb_model <- "columbia_20200909_sample_1_all_rgb_detections_20220426_processed.csv" 
file_ir2rgb_ir_model_C <- "columbia_20200909_sample_1_C_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_ir_model_L <- "columbia_20200909_sample_1_L_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_ir_model_R <- "columbia_20200909_sample_1_R_trigger_detectionsIR_20220426_processed_transposedRGB.csv"
file_ir2rgb_rgb_model_C <- "columbia_20200909_sample_1_C_trigger_detectionsRGB_20220426_processed.csv"
file_ir2rgb_rgb_model_L <- "columbia_20200909_sample_1_L_trigger_detectionsRGB_20220426_processed.csv"
file_ir2rgb_rgb_model_R <- "columbia_20200909_sample_1_R_trigger_detectionsRGB_20220426_processed.csv"
file_allrgb_manual <- "columbia_20200909_sample_1_all_rgb_manual_review_20220426.csv"
file_ir2rgb_manual_C <- "columbia_20200909_sample_1_C_ir-rgb_manualReview_rgbDetections_20220909.csv"
file_ir2rgb_manual_L <- "columbia_20200909_sample_1_L_ir-rgb_manualReview_rgbDetections_20220912.csv"
file_ir2rgb_manual_R <- "columbia_20200909_sample_1_R_ir-rgb_manualReview_rgbDetections_20220912.csv"


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

merge_and_intersect <- function(data1, data2) {
  # data1 <- allrgb_manual
  # data2 <- ir2rgb_manual
  # var1 <- "allrgb_manual"
  # var2 <- "ir2rgb_manual"
  
  var1 <- deparse(substitute(data1))
  var2 <- deparse(substitute(data2))
  
  data <- data1 %>%
    full_join (data2, by = setNames(paste0(var2, "_image_name"), paste0(var1, "_image_name"))) %>%
    mutate(image_name = ifelse(
      is.na(!!as.name(paste0(var1, "_image_name"))), 
      !!as.name(paste0(var2, "_image_name")), 
      !!as.name(paste0(var1, "_image_name")))) %>%
    mutate(intersect_LR = ifelse(!!as.name(paste0(var1, "_bound_right")) < !!as.name(paste0(var2, "_bound_left")) |
                                   !!as.name(paste0(var1, "_bound_left")) > !!as.name(paste0(var2, "_bound_right")), "no", "yes"),
           intersect_TB = ifelse(!!as.name(paste0(var1, "_bound_top")) > !!as.name(paste0(var2, "_bound_bottom")) |
                                   !!as.name(paste0(var1, "_bound_bottom")) < !!as.name(paste0(var2, "_bound_top")), "no", "yes"))
  
  intersecting <- data %>%
    filter(intersect_LR == "yes" & intersect_TB == "yes") %>%
    mutate(distance = sqrt(
      ((!!as.name(paste0(var1, "_average_x")) - !!as.name(paste0(var2, "_average_x"))) ^ 2) + 
        ((!!as.name(paste0(var1, "_average_y")) - !!as.name(paste0(var2, "_average_y"))) ^ 2)) ) %>%
    group_by(image_name, !!as.name(paste0(var2, "_id"))) %>%
    slice(which.min(distance)) %>%
    filter(distance < 50) %>%
    select(image_name, paste0(var1, "_id"), paste0(var2, "_id"), distance) %>%
    ungroup()
  
  # data2 <- data2 %>%
  #   rename(image_name = paste0(var2, "_image_name"))
  # 
  # merged <- intersecting %>%
  #   right_join(data2, by = c("image_name", paste0(var2, "_id")))
}

# Install libraries ----------------------------------------------
install_pkg("tidyverse")
install_pkg("RPostgreSQL")

# Process data --------------------------------------------------
setwd(file_folder)
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              password = Sys.getenv("admin_pw"))

# Get NUC images
unprocessed_rgb <- RPostgreSQL::dbGetQuery(con, paste("SELECT image_name FROM surv_pv_gla.tbl_images_4processing_latte WHERE image_survey_id = \'",
                                              survey_id,
                                              "\' AND image_type = \'rgb_image\' AND
                                              (ir_nuc = \'Y\' 
                                                OR 
                                              image_name IN (SELECT rgb_image_name FROM surv_pv_gla.summ_data_inventory WHERE ir_image = \'N\'))", sep = "")) %>%
  mutate(unprocessed = "TRUE")

# Get processed detection data
# allrgb_model <- read.csv(file_allrgb_model, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
#                          col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
#                                        "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
#   data.frame(stringsAsFactors = FALSE) %>%
#   mutate(image_name = basename(image_name)) %>%
#   filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
#   select(detection, image_name, bound_left, bound_top, bound_right, bound_bottom, score, detection_type) %>%
#   mutate(average_x = (bound_left + bound_right)/2,
#          average_y = (bound_top + bound_bottom)/2) %>%
#   rename_with( ~ paste0("allrgb_model_", .x)) 

mnC <- read.csv(file_allrgb_manual, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                          col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                        "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(image_name = basename(image_name)) %>%
  mutate(id = row_number()) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(id, detection, image_name, bound_left, bound_top, bound_right, bound_bottom, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  left_join(unprocessed_rgb, by = "image_name") %>%
  rename_with( ~ paste0("mnC_", .x))

mnT <- read.csv(file_ir2rgb_manual_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                          col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                        "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_manual_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_manual_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(id = row_number()) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal" | detection_type == "harbor_seal_offThermal" | detection_type == "harbor_seal_partial" | detection_type == "off_ir") %>%
  select(id, detection, image_name, bound_left, bound_top, bound_right, bound_bottom, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("mnT_", .x))

mdT <- read.csv(file_ir2rgb_ir_model_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                         col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                       "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_ir_model_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_ir_model_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(id = row_number()) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(id, detection, image_name, bound_left, bound_top, bound_right, bound_bottom, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("mdT_", .x))

mdC <- read.csv(file_ir2rgb_rgb_model_C, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                            col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                                          "score", "length", "detection_type", "type_score", "att1", "att2")) %>%
  rbind(read.csv(file_ir2rgb_rgb_model_L, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  rbind(read.csv(file_ir2rgb_rgb_model_R, skip = 2, header = FALSE, stringsAsFactors = FALSE, 
                 col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", 
                               "score", "length", "detection_type", "type_score", "att1", "att2"))) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  mutate(id = row_number()) %>%
  mutate(image_name = basename(image_name)) %>%
  filter(detection_type == "harbor_seal" | detection_type == "split_harbor_seal") %>%
  select(id, detection, image_name, bound_left, bound_top, bound_right, bound_bottom, detection_type) %>%
  mutate(average_x = (bound_left + bound_right)/2,
         average_y = (bound_top + bound_bottom)/2) %>%
  rename_with( ~ paste0("mdC_", .x))
 
# Merge datasets together
mnC_2_mnT <- merge_and_intersect(mnC, mnT) %>%
  rename(mnC2mnT_distance = distance)
mnC_2_mdT <- merge_and_intersect(mnC, mdT )%>%
  rename(mnC2mdT_distance = distance) %>%
  select(-image_name)
mnC_2_mdC <- merge_and_intersect(mnC, mdC) %>%
  rename(mnC2mdC_distance = distance) %>%
  select(-image_name) 
mnT_2_mdT <- merge_and_intersect(mnT, mdT) %>%
  rename(mnT2mdT_distance = distance) %>%
  rename(temp = image_name,
         mdT_id_temp = mdT_id)
mnT_2_mdC <- merge_and_intersect(mnT, mdC) %>%
  rename(mnT2mdC_distance = distance) %>%
  rename(temp = image_name,
         mdC_id_temp = mdC_id)
mdT_2_mdC <- merge_and_intersect(mdT, mdC) %>%
  rename(mdT2mdC_distance = distance) %>%
  rename(temp = image_name,
         mdC_id_temp = mdC_id)

summary <- mnC_2_mnT %>%
  left_join(mnC_2_mdT, by = "mnC_id") %>%
  left_join(mnC_2_mdC, by = "mnC_id") %>%
  full_join(mnT_2_mdT, by = "mnT_id") %>% #c("mnT_id", "mdT_id")) %>%
  mutate(image_name = ifelse(is.na(image_name), temp, image_name),
         mdT_id = ifelse(is.na(mdT_id), mdT_id_temp, mdT_id)) %>%
  select(-temp, -mdT_id_temp) %>%
  full_join(mnT_2_mdC, by = "mnT_id") %>% #by = c("mnT_id", "mdC_id")) %>%
  mutate(image_name = ifelse(is.na(image_name), temp, image_name),
         mdC_id = ifelse(is.na(mdC_id), mdC_id_temp, mdC_id)) %>%
  select(-temp, -mdC_id_temp) %>%
  full_join(mdT_2_mdC, by = "mdT_id") %>% #by = c("mdT_id", "mdC_id")) %>%
  mutate(image_name = ifelse(is.na(image_name), temp, image_name),
         mdC_id = ifelse(is.na(mdC_id), mdC_id_temp, mdC_id)) %>%
  select(-temp, -mdC_id_temp) %>%
  select(image_name, mnC_id, mnT_id, mdC_id, mdT_id, 
         mnC2mnT_distance, mnC2mdC_distance, mnC2mdT_distance, mnT2mdC_distance, mnT2mdT_distance, mdT2mdC_distance) %>%
  left_join(unprocessed_rgb, by = "image_name") %>%
  left_join(mnC %>% select(mnC_id, mnC_detection_type), by = "mnC_id") %>%
  left_join(mnT %>% select(mnT_id, mnT_detection_type), by = "mnT_id") %>%
  left_join(mdC %>% select(mdC_id, mdC_detection_type), by = "mdC_id") %>%
  left_join(mdT %>% select(mdT_id, mdT_detection_type), by = "mdT_id")

# Tidy up workspace and disconnect from DB
RPostgreSQL::dbDisconnect(con)
rm(con)