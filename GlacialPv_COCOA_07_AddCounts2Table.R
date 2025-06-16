# Glacial COCOA: Add glacial counts to tbl_counts

# Variables ------------------------------------------------------
project_id <- 'glacial_2020'

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
survey_year <- substring(project_id, nchar(project_id) - 3, nchar(project_id))

# Extract data from DB 
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_user"),
                              password = Sys.getenv("user_pw"))

# Get counts and ID
id <- RPostgreSQL::dbGetQuery(con, "SELECT max(id) FROM surv_pv_gla.tbl_counts")
counts <- RPostgreSQL::dbGetQuery(con, paste0("SELECT * FROM surv_pv_gla.summ_count_cocoa_4tbl_count WHERE project_id = \'", project_id, "\'")) 

# Delete existing counts associated with this project_id
RPostgreSQL::dbSendQuery(con, paste0("DELETE FROM surv_pv_gla.tbl_counts c USING surv_pv_gla.tbl_event e WHERE e.id = c.event_id AND count_type_lku = \'A\' AND survey_id LIKE \'%",
                                     survey_year,
                                     "%\'"))

# Process new counts to DB
counts <- counts %>%
  mutate(id = (1:nrow(counts) + id$max),
         count_type_lku = "A",
         std_error = as.numeric(NA),
         count_comments = paste0("Count auto-populated based on tbl_detections on ", Sys.Date())) %>%
  select(id, event_id, count_type_lku, num_seals, std_error, count_comments)
  
RPostgreSQL::dbWriteTable(con, c("surv_pv_gla", "tbl_counts"), counts, append = TRUE, row.names = FALSE)

# Update sequence field in DB to reflect next # after import
new_max <- as.integer(max(counts$id)) + 1
RPostgreSQL::dbSendQuery(con, paste0("ALTER SEQUENCE surv_pv_gla.tbl_counts_id_seq RESTART WITH ", new_max))

# Clean-up workspace
RPostgreSQL::dbDisconnect(con)
rm(con, counts, id, new_max)
