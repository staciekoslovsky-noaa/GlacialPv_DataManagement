# Glacial Pv Surveys: Export footprint shapefiles for abundance analysis

# STARTING VARIABLES
survey_id <- c('columbia_20200909_sample_1',
               'columbia_20200910_sample_1',
               'dbay_20200904_sample_1',
               'dbay_20200906_sample_1',
               'icy_20200901_sample_1',
               'icy_20200904_sample_1',
               'dbay_20210829_sample_1',
               'icy_20210829_sample_1',
               'icy_20210831_sample_1')

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
install_pkg("sf")
install_pkg("tidyverse")

# Run code -------------------------------------------------------
# Set initial working directory 
wd <- "C:/smk"
setwd(wd)

# Get data from the DB for processing
con <- RPostgreSQL::dbConnect(RPostgreSQL::PostgreSQL(),
                        dbname = Sys.getenv("pep_db"),
                        host = Sys.getenv("pep_ip"),
                        user = Sys.getenv("pep_admin"),
                        password = Sys.getenv("admin_pw"))

for (i in 1:length(survey_id)){
  footprints <- sf::st_read(con, query = paste0("SELECT * FROM surv_pv_gla.geo_images_footprint_latte WHERE survey_id = \'", survey_id[i], "\'"), geometry_column = "geom") %>%
    select(image_name, camera, seals, total) %>%
    st_transform(crs = 3338)
  sf::st_write(footprints, paste0(survey_id[i], "_footprints.shp"), append = FALSE)
}

RPostgreSQL::dbDisconnect(con)