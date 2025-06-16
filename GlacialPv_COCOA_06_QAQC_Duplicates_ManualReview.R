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


# Mark manually-identified duplicate detections as such in qaqc_duplicate field in tbl_detections_processed_rgb and geo_detections
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_detections SET qaqc_duplicate = \'dupe_manual_review\' WHERE detection_id IN (SELECT detection_id FROM surv_pv_gla.tbl_detections_cocoa_manual_duplicates)")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.tbl_detections_processed_rgb SET qaqc_duplicate = \'dupe_suppressed\' 
                         WHERE detection_id IN (SELECT detection_id FROM surv_pv_gla.tbl_detections_cocoa_manual_duplicates)")

# Disconnect for database and delete unnecessary variables 
dbDisconnect(con)
rm(con)