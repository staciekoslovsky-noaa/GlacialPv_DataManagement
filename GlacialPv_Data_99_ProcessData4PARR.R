# Glacial Pv Surveys: Process data to GDB for PARR
# S. Hardy, 7MAY2019

# Variables to update --------------------------------------------
wd_data <- "I://Surveys_HS/Glacial/Projects/Surveys Glacial Sites Counts"
wd_gdb <- "C://skh/GlacialPv4PARR"

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
install_pkg("reticulate")
install_pkg("arcgisbinding")
install_pkg("RPostgreSQL")

# Run code -------------------------------------------------------
# Load Ersi license and Pyton packages
use_python("C:/Python27/ArcGISx6410.6/python.exe")
ARCPY <- import("arcpy")
arc.check_product()

# Get file list from DB 
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))
dat <- RPostgreSQL::dbGetQuery(con, "SELECT * FROM surv_pv_gla.tbl_survey_data")

# Create GDB
ARCPY$CreateFileGDB_management(wd_gdb, "glacialData4PARR")
geoDB <- paste(wd_gdb, "glacialData4PARR.gdb", sep = "/")

# Process shapefiles to GDB
for (i in 1:nrow(dat)) {
  if(dat$gis_extent[i] != 'X') {
    extent <- paste(wd_data, dat$gis_extent[i], sep = '/')
    ARCPY$CopyFeatures_management(extent, paste(geoDB, '/', dat$survey_id[i], '_extent', sep = ""))
  } else {
    print("Skipping extent...")
  }
  if(dat$gis_count[i] != 'X') {
    count <- paste(wd_data, dat$gis_count[i], sep = '/')
    ARCPY$CopyFeatures_management(count, paste(geoDB, '/', dat$survey_id[i], '_count', sep = ""))
  } else {
    print("Skipping count...")
  }
  if(dat$gis_footprint[i] != 'X') {
    footprint <- paste(wd_data, dat$gis_footprint[i], sep = '/')
    ARCPY$CopyFeatures_management(footprint, paste(geoDB, '/', dat$survey_id[i], '_footprint', sep = ""))
  } else {
    print("Skipping footprint...")
  }
}
