# In Flight System: Process Data/Images to DB
# S. Hardy, 30 September 2020

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
install_pkg("rjson")
install_pkg("plyr")
install_pkg("stringr")
install_pkg("tidyverse")

# Run code -------------------------------------------------------
# Set initial working directory
wd <- "//akc0ss-n086/NMML_Polar_Imagery/Surveys_HS/Glacial/Originals/2020"
setwd(wd)

# Create list of camera folders within which data need to be processed 
dir <- list.dirs(wd, full.names = FALSE, recursive = FALSE)
dir <- data.frame(path = dir[grep("fl", dir)], stringsAsFactors = FALSE)
image_dir <- merge(dir, c("left_view", "center_view", "right_view"), ALL = true)
colnames(image_dir) <- c("path", "camera_loc")
image_dir$camera_dir <- paste(wd, image_dir$path, image_dir$camera_loc, sep = "/")

# Process images and meta.json files
images2DB <- data.frame(image_name = as.character(""), dt = as.character(""), image_type = as.character(""), stringsAsFactors = FALSE)
images2DB <- images2DB[which(images2DB == "test"), ]
meta2DB <- data.frame(rjson::fromJSON(paste(readLines("Template4Import.json", warn = FALSE), collapse="")))
meta2DB$meta_file <- ""
meta2DB$dt <- ""
meta2DB$flight <- ""
meta2DB$camera_view <- ""
meta2DB <- meta2DB[which(meta2DB == "test"), ]

for (i in 1:nrow(image_dir)){
  files <- list.files(image_dir$camera_dir[i], full.names = FALSE, recursive = FALSE)
  files <- data.frame(image_name = files[which(startsWith(files, "glacial_2020") == TRUE)], stringsAsFactors = FALSE)
  files$dt <- paste(sapply(strsplit(files$image_name, "_"), function(x) x[[5]]), sapply(strsplit(files$image_name, "_"), function(x) x[[6]]), sep = "_")
  files$image_type <- ifelse(grepl("rgb", files$image_name) == TRUE, "RGB Image", 
                       ifelse(grepl("ir", files$image_name) == TRUE, "IR Image",
                              ifelse(grepl("uv", files$image_name) == TRUE, "UV Image", 
                                     ifelse(grepl("meta", files$image_name) == TRUE, "meta.json", "Unknown"))))
  
  images <- files[which(grepl("Image", files$image_type)), ]
  images2DB <- rbind(images2DB, images)
  
  meta <- files[which(files$image_type == "meta.json"), ]
  if (nrow(meta) > 1) {
    for (j in 1:nrow(meta)){
      meta_file <- paste(image_dir$camera_dir[i], meta$image_name[j], sep = "/")
      metaJ <- data.frame(rjson::fromJSON(paste(readLines(meta_file), collapse="")), stringsAsFactors = FALSE)
      metaJ$meta_file <- basename(meta_file)
      metaJ$dt <- paste(sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[5]]), sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[6]]), sep = "_") 
      metaJ$flight <- sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[3]]) 
      metaJ$camera_view <- sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[4]]) 
      meta2DB <- plyr::rbind.fill(meta2DB, metaJ)
    }
  }
}

colnames(meta2DB) <- gsub("\\.", "_", colnames(meta2DB))

images2DB$flight <- sapply(strsplit(images2DB$image_name, "_"), function(x) x[[3]]) 
images2DB$camera_view <- sapply(strsplit(images2DB$image_name, "_"), function(x) x[[4]]) 

# Clean up known issues in data
meta2DB$effort <- ifelse(meta2DB$effort == 'TEST' & meta2DB$flight == 'fl01', 'ON', meta2DB$effort)
meta2DB$effort <- ifelse(meta2DB$dt <= '20200902_002000' & meta2DB$flight == 'fl01', 'OFF', meta2DB$effort)
meta2DB$effort <- ifelse(meta2DB$dt == '20200902_011733.748910' & meta2DB$flight == 'fl01', 'ON', meta2DB$effort)
meta2DB$effort <- ifelse(meta2DB$dt < '20200904_001000' & meta2DB$flight == 'fl03', 'OFF', meta2DB$effort)

# Assign survey ID to flight segments
meta2DB$survey_id <- 'do_not_use'

# Process effort logs
# logs2DB <- data.frame(effort_log = as.character(""), gps_time = as.character(""), sys_time = as.character(""), note = as.character(""), stringsAsFactors = FALSE)
# logs2DB <- logs2DB[which(logs2DB == "test"), ]
# 
# for (i in 1:nrow(dir)){
#   logs <- list.files(dir$path[i], pattern = ".txt", full.names = FALSE, recursive = FALSE)
#   if (length(logs) != 0){
#     for (j in 1:length(logs)){
#       log <- paste(wd, dir$path[i], logs[j], sep = "/")
#       log_file <- scan(log,
#                        sep = "-",
#                        multi.line = TRUE,
#                        strip.white = TRUE, 
#                        what = "list")
#       log_file <- log_file[which(log_file != "")]
#       log_file <- data.frame(log_string = unlist(log_file), stringsAsFactors = FALSE)
#       log_file$effort_log <- logs[j]
#       
#       # Extract data from text
#       log_file$collection_mode <- str_match(log_file$log_string, "collection_mode: (.*?),")[, 2]
#       log_file$effort <- str_match(log_file$log_string, "effort: (.*?),")[, 2]
#       
#       log_file$gps_time <- str_match(log_file$log_string, "gps_time: (.*?),")[, 2]
#       log_file$gps_time <- gsub("!!timestamp ", "", log_file$gps_time)
#       log_file$gps_time <- as.POSIXct(log_file$gps_time, format="%Y-%m-%d%H:%M:%OS", tz = "UTC")
# 
#       log_file$note <- str_match(log_file$log_string, "note: (.*?), project")[, 2]
#       log_file$project <- str_match(log_file$log_string, "project: (.*?),")[, 2]
#       log_file$sys_time <- str_match(log_file$log_string, "sys_time: (.*?)")
#       
#       # Final processing
#       log_file <- log_file[, c("project", "gps_time", "collection_mode", "effort", "note", "effort_log")]
#       logs2DB <- rbind(logs2DB, log_file)
#     }
#   }
# }
# logs2DB$flight <- unlist(strsplit(logs2DB$effort_log, "_"))[c(4)] #substring(logs2DB$effort_log, 19, 22)

rm(meta, image_dir, images, metaJ, i, j, meta_file, wd, files, dir
   #, log, logs, log_file
   )

# Export data to PostgreSQL -----------------------------------------------------------
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Create list of data to process
df <- list(images2DB, #logs2DB, 
           meta2DB)
dat <- c("tbl_images", #"tbl_event_logs", 
         "geo_images_meta")

# Identify and delete dependencies for each table
for (i in 1:length(dat)){
  sql <- paste("SELECT fxn_deps_save_and_drop_dependencies(\'surv_pv_gla\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}
RPostgreSQL::dbSendQuery(con, "DELETE FROM deps_saved_ddl WHERE deps_ddl_to_run NOT LIKE \'%CREATE VIEW%\'")

# Push data to pepgeo database and process data to spatial datasets where appropriate
for (i in 1:length(dat)){
  if (dat[i] == "geo_images_meta") {
    RPostgreSQL::dbSendQuery(con, paste("ALTER TABLE surv_pv_gla.", dat[i], " DROP COLUMN geom", sep = ""))
  }
  
  RPostgreSQL::dbWriteTable(con, c("surv_pv_gla", dat[i]), data.frame(df[i]), 
                            overwrite = TRUE, 
                            #append = TRUE, 
                            row.names = FALSE)
  
  if (dat[i] == "geo_images_meta") {
    sql1 <- paste("ALTER TABLE surv_pv_gla.", dat[i], " ADD COLUMN geom geometry(POINT, 4326)", sep = "")
    sql2 <- paste("UPDATE surv_pv_gla.", dat[i], " SET geom = ST_SetSRID(ST_MakePoint(ins_longitude, ins_latitude), 4326)", sep = "")
    RPostgreSQL::dbSendQuery(con, sql1)
    RPostgreSQL::dbSendQuery(con, sql2)
  }
}

# Recreate table dependencies
for (i in length(dat):1) {
  sql <- paste("SELECT fxn_deps_restore_dependencies(\'surv_pv_gla\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con, df, dat, i, sql, sql1, sql2)
