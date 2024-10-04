# Glacial Pv: Process Data/Images to DB

# Variables ------------------------------------------------------
years <- c(
  #2020, 
  #2021, 
  2024
  )

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
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              password = Sys.getenv("admin_pw"))

# RPostgreSQL::dbSendQuery(con, "DELETE FROM surv_pv_gla.tbl_images WHERE image_name LIKE \'glacial_2024%\'")
# RPostgreSQL::dbSendQuery(con, "DELETE FROM surv_pv_gla.geo_images_meta WHERE meta_file LIKE \'glacial_2024%\'")

# Set initial working directory
wd <- "//akc0ss-n086/NMML_Polar_Imagery/Surveys_HS/Glacial/Originals"
setwd(wd)

# Create list of camera folders within which data need to be processed 
for (i in 1:length(years)){
  wd_year <- paste(wd, years[i], sep = "/")
  dir <- list.dirs(wd_year, full.names = TRUE, recursive = FALSE)

  dir <- list.dirs(dir, full.names = TRUE, recursive = FALSE)
  dir <- data.frame(path = dir[grep("deg", dir)], stringsAsFactors = FALSE)
  
  image_dir <- merge(dir, c("left_view", "center_view", "right_view"), ALL = true)
  colnames(image_dir) <- c("path", "camera_loc")
  image_dir$camera_dir <- paste(image_dir$path, image_dir$camera_loc, sep = "/")
  
  # Process images and meta.json files
  images2DB <- data.frame(image_name = as.character(""), dt = as.character(""), image_type = as.character(""), stringsAsFactors = FALSE)
  images2DB <- images2DB[which(images2DB$image_name != ""), ]
  
  meta2DB <- data.frame(rjson::fromJSON(paste(readLines(paste(wd_year, "Template4Import.json", sep = "/"), warn = FALSE), collapse="")))
  meta2DB$meta_file <- ""
  meta2DB$dt <- ""
  meta2DB$flight <- ""
  meta2DB$camera_view <- ""
  meta2DB <- meta2DB[which(meta2DB == "test"), ]
  
  for (j in 1:nrow(image_dir)){
    RPostgreSQL::dbGetQuery(con, "SELECT * FROM surv_pv_gla.geo_glaciers LIMIT 1")
    files <- list.files(image_dir$camera_dir[j], full.names = FALSE, recursive = FALSE)
    files <- data.frame(image_name = files[which(startsWith(files, paste("glacial_", years[i], sep = "")) == TRUE)], stringsAsFactors = FALSE)
    
    files$dt <- paste(sapply(strsplit(files$image_name, "_"), function(x) x[[5]]), sapply(strsplit(files$image_name, "_"), function(x) x[[6]]), sep = "_")
    files$image_type <- ifelse(grepl("rgb", files$image_name) == TRUE, "rgb_image", 
                               ifelse(grepl("ir", files$image_name) == TRUE, "ir_image",
                                      ifelse(grepl("uv", files$image_name) == TRUE, "uv_image", 
                                             ifelse(grepl("meta", files$image_name) == TRUE, "meta.json", "Unknown"))))
    files$image_dir <- image_dir$camera_dir[j]
    
    images <- files[which(grepl("image", files$image_type)), ]
    images2DB <- rbind(images2DB, images)

    meta <- files[which(files$image_type == "meta.json"), ]
    if (nrow(meta) > 1) {
      for (k in 1:nrow(meta)){
        meta_file <- paste(image_dir$camera_dir[j], meta$image_name[k], sep = "/")
        file.info(meta_file)$size
        if (file.info(meta_file)$size > 0) {
          metaJ <- data.frame(rjson::fromJSON(paste(readLines(meta_file), collapse="")), stringsAsFactors = FALSE)
          metaJ$meta_file <- basename(meta_file)
          metaJ$dt <- paste(sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[5]]), sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[6]]), sep = "_") 
          metaJ$flight <- sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[3]]) 
          metaJ$camera_view <- sapply(strsplit(metaJ$meta_file, "_"), function(x) x[[4]]) 
          metaJ$camera_model <- basename(image_dir$path[i])
          meta2DB <- plyr::rbind.fill(meta2DB, metaJ)} else next
      }
    }
  }
  
  colnames(meta2DB) <- gsub("\\.", "_", colnames(meta2DB))
  meta2DB$project_id <- paste("glacial_", years[i], sep = "")
  
  images2DB$flight <- sapply(strsplit(images2DB$image_name, "_"), function(x) x[[3]]) 
  images2DB$camera_view <- sapply(strsplit(images2DB$image_name, "_"), function(x) x[[4]])
  images2DB$ir_nuc <- NA
  images2DB$rgb_manualreview <- NA
  images2DB$project_id <- paste("glacial_", years[i], sep = "")
  
  # Clean up known issues in data
  if (years[i] == 2020){
    meta2DB$effort <- ifelse(meta2DB$effort == 'TEST' & meta2DB$flight == 'fl01', 'ON', meta2DB$effort)
    meta2DB$effort <- ifelse(meta2DB$dt <= '20200902_002000' & meta2DB$flight == 'fl01', 'OFF', meta2DB$effort)
    meta2DB$effort <- ifelse(meta2DB$dt == '20200902_011733.748910' & meta2DB$flight == 'fl01', 'ON', meta2DB$effort)
    meta2DB$effort <- ifelse(meta2DB$dt < '20200904_001000' & meta2DB$flight == 'fl03', 'OFF', meta2DB$effort)
  }
  if (years[i] == 2024){
    meta2DB$sys_cfg <- ifelse(meta2DB$flight == "fl09", "images_21deg_N56RF", meta2DB$sys_cfg)
  }
  
  # Assign survey ID to flight segments
  meta2DB$survey_id <- 'do_not_use'
  
  # Insert data into  DB -----------------------------------------------------------
  # Create list of data to process
  df <- list(images2DB, meta2DB)
  dat <- c("tbl_images", "geo_images_meta")
  
  # Push data to pepgeo database and process data to spatial datasets where appropriate
  for (m in 1:length(dat)){
    if (dat[m] == "geo_images_meta") {
    # RPostgreSQL::dbSendQuery(con, paste("ALTER TABLE surv_pv_gla.", dat[i], " DROP COLUMN geom", sep = ""))
    }
    
    RPostgreSQL::dbWriteTable(con, c("surv_pv_gla", dat[m]), data.frame(df[m]), append = TRUE, row.names = FALSE)
    
    if (dat[m] == "geo_images_meta") {
     # sql1 <- paste("ALTER TABLE surv_pv_gla.", dat[m], " ADD COLUMN geom geometry(POINT, 4326)", sep = "")
      sql2 <- paste("UPDATE surv_pv_gla.", dat[m], " SET geom = ST_SetSRID(ST_MakePoint(ins_longitude, ins_latitude), 4326)", sep = "")
     # RPostgreSQL::dbSendQuery(con, sql1)
      RPostgreSQL::dbSendQuery(con, sql2)
    }
  }
}

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con, df, dat, i, #sql, sql1,
   sql2)
