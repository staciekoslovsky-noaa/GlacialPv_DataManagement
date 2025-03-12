# Glacial: Label detections as duplicates (either due to "suppressed" or cross-camera view validation)

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

# Extract data from DB 
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"),
                              password = Sys.getenv("admin_pw"))

# Create fields for tracking QA/QC, if it doesn't already exist
RPostgreSQL::dbSendQuery(con, "ALTER TABLE surv_pv_gla.geo_detections ADD COLUMN IF NOT EXISTS qaqc_duplicate CHARACTER VARYING(25)")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_detections SET qaqc_duplicate = \'to_evaluate\'")

RPostgreSQL::dbSendQuery(con, "ALTER TABLE surv_pv_gla.tbl_detections_processed_rgb ADD COLUMN IF NOT EXISTS qaqc_duplicate CHARACTER VARYING(25)")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.tbl_detections_processed_rgb SET qaqc_duplicate = \'to_evaluate\'")

# Mark "suppressed" detections as such in qaqc_duplicate field in tbl_detections_processed_rgb and geo_detections
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_detections SET qaqc_duplicate = \'suppressed\' WHERE suppressed = \'true\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.tbl_detections_processed_rgb SET qaqc_duplicate = \'suppressed\' 
                         WHERE detection_id IN (SELECT detection_id FROM surv_pv_gla.geo_detections WHERE suppressed = \'true\')")

# Create index on detection_id field to streamline processing
RPostgreSQL::dbSendQuery(con, "CREATE INDEX IF NOT EXISTS index_detection_id ON surv_pv_gla.geo_detections(detection_id)")
RPostgreSQL::dbSendQuery(con, "CREATE INDEX IF NOT EXISTS index_detection_id ON surv_pv_gla.tbl_detections_processed_rgb(detection_id)")

# Identify cross-camera view duplicates and mark as such in tbl_detections_processed_rgb and geo_detections
dupes <- RPostgreSQL::dbGetQuery(con, "SELECT * FROM surv_pv_gla.qaqc_cocoa_xcamera_duplicates")

for (i in 1:nrow(dupes)){
  RPostgreSQL::dbSendQuery(con, paste0("UPDATE surv_pv_gla.geo_detections SET qaqc_duplicate = \'xcamera\' 
                         WHERE detection_id = \'", dupes$duplicate_detection[i], "\'"))
  
  RPostgreSQL::dbSendQuery(con, paste0("UPDATE surv_pv_gla.tbl_detections_processed_rgb SET qaqc_duplicate = \'xcamera\' 
                         WHERE detection_id = \'", dupes$duplicate_detection[i], "\'"))
}

# Assign remaining detections as not_duplicate
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_detections SET qaqc_duplicate = \'not_duplicate\' WHERE qaqc_duplicate = \'to_evaluate\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.tbl_detections_processed_rgb SET qaqc_duplicate = \'not_duplicate\' WHERE qaqc_duplicate = \'to_evaluate\'")

# Disconnect for database and delete unnecessary variables 
dbDisconnect(con)
rm(con)