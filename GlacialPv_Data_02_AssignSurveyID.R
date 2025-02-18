# In Flight System: Process Data/Images to DB
# S. Koslovsky

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

# Run code -------------------------------------------------------

# Update data in DB 
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              password = Sys.getenv("admin_pw"))

# Assign survey ID to flight segments
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = NULL")

#### Use surv_pv_gla.tbl_surveyid_4assignment to get surveyIDs, flights and start times for data
#### Review outputs in \\akc0ss-n086\NMML_Polar\Data\Survey_HarborSeal_Glacial\SurveyID_ReviewAssignments.qgz

#### 2020 data
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20200901_sample_1'\ WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl01\' AND dt >= \'20200902_001800\' AND dt <= \'20200902_012259\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20200903_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_204100\' AND dt <= \'20200903_204759\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20200903_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_204900\' AND dt <= \'20200903_210159\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20200903_fullmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_210300\' AND dt <= \'20200903_210959\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20200903_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_215400\' AND dt <= \'20200903_215859\' ")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20200903_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_220200\' AND dt <= \'20200903_220659\' ") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20200903_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_222800\' AND dt <= \'20200903_223059\' ") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20200903_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl02\' AND dt >= \'20200903_223200\' AND dt <= \'20200903_223459\' ") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20200903_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl03\' AND dt >= \'20200904_005300\' AND dt <= \'20200904_005559\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20200903_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl03\' AND dt >= \'20200904_005900\' AND dt <= \'20200904_010259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20200903_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl03\' AND dt >= \'20200904_012700\' AND dt <= \'20200904_012959\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20200903_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl03\' AND dt >= \'20200904_013400\' AND dt <= \'20200904_013659\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20200904_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl04\' AND dt >= \'20200904_212500\' AND dt <= \'20200904_222759\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'malaspina_20200904_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl04\' AND dt >= \'20200904_225300\' AND dt <= \'20200904_230559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20200904_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl04\' AND dt >= \'20200904_231700\' AND dt <= \'20200904_234959\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20200905_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl06\' AND dt >= \'20200905_215300\' AND dt <= \'20200905_215759\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20200905_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl06\' AND dt >= \'20200905_215900\' AND dt <= \'20200905_220159\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20200905_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl06\' AND dt >= \'20200905_220300\' AND dt <= \'20200905_220859\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'margerie_20200905_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl06\' AND dt >= \'20200905_221000\' AND dt <= \'20200905_221359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'margerie_20200905_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl06\' AND dt >= \'20200905_221400\' AND dt <= \'20200905_221459\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20200905_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl07\' AND dt >= \'20200906_002200\' AND dt <= \'20200906_002410\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20200905_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl07\' AND dt >= \'20200906_002500\' AND dt <= \'20200906_002710\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20200905_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl07\' AND dt >= \'20200906_010000\' AND dt <= \'20200906_011259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20200905_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl07\' AND dt >= \'20200906_011400\' AND dt <= \'20200906_011759\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'drybay_20200906_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_192600\' AND dt <= \'20200906_192959\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'drybay_20200906_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_193100\' AND dt <= \'20200906_193459\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'malaspina_20200906_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_200700\' AND dt <= \'20200906_200859\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'malaspina_20200906_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_200900\' AND dt <= \'20200906_201059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'malaspina_20200906_targetedmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_201100\' AND dt <= \'20200906_201459\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20200906_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl08\' AND dt >= \'20200906_204600\' AND dt <= \'20200906_211559\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'ellsworth_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_193500\' AND dt <= \'20200909_193859\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'ellsworth_20200909_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_194000\' AND dt <= \'20200909_194359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'ellsworth_20200909_fullmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_194500\' AND dt <= \'20200909_194859\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_195500\' AND dt <= \'20200909_195859\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20200909_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_200000\' AND dt <= \'20200909_200359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_201300\' AND dt <= \'20200909_201559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20200909_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_201700\' AND dt <= \'20200909_201959\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20200909_fullmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_202100\' AND dt <= \'20200909_202359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20200909_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_202400\' AND dt <= \'20200909_203459\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20200909_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_203600\' AND dt <= \'20200909_204359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_204600\' AND dt <= \'20200909_204840\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20200909_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_204900\' AND dt <= \'20200909_205110\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'blackstone_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_210000\' AND dt <= \'20200909_211059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harriman_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_211600\' AND dt <= \'20200909_211759\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_211900\' AND dt <= \'20200909_212140\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20200909_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_212200\' AND dt <= \'20200909_212430\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_212700\' AND dt <= \'20200909_214059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20200909_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_214200\' AND dt <= \'20200909_220559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20200909_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_220700\' AND dt <= \'20200909_224559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20200909_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_224800\' AND dt <= \'20200909_234559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20200909_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl09\' AND dt >= \'20200909_235500\' AND dt <= \'20200910_000059\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20200910_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_194200\' AND dt <= \'20200910_194559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20200910_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_194700\' AND dt <= \'20200910_195059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20200910_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_195800\' AND dt <= \'20200910_200259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20200910_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_201800\' AND dt <= \'20200910_204559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20200910_sample_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_205200\' AND dt <= \'20200910_215159\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20200910_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_230300\' AND dt <= \'20200910_230459\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20200910_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_230600\' AND dt <= \'20200910_231659\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20200910_targetedmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl10\' AND dt >= \'20200910_231800\' AND dt <= \'20200910_232859\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_202000\' AND dt <= \'20200911_202135\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20200911_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_202200\' AND dt <= \'20200911_202259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'holgate_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_202900\' AND dt <= \'20200911_203259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'pedersen_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_203400\' AND dt <= \'20200911_204559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_204700\' AND dt <= \'20200911_205059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20200911_fullmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_205500\' AND dt <= \'20200911_210259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_210400\' AND dt <= \'20200911_213059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_213300\' AND dt <= \'20200911_214259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_214300\' AND dt <= \'20200911_214959\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_215100\' AND dt <= \'20200911_215359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20200911_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_215500\' AND dt <= \'20200911_220259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_221300\' AND dt <= \'20200911_222559\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'blackstone_20200911_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_222600\' AND dt <= \'20200911_223259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_224600\' AND dt <= \'20200911_224710\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20200911_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_224800\' AND dt <= \'20200911_224930\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20200911_targetedmosaic_3\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_225100\' AND dt <= \'20200911_225159\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_225600\' AND dt <= \'20200911_230159\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20200911_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_232100\' AND dt <= \'20200911_232359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20200911_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl11\' AND dt >= \'20200911_232500\' AND dt <= \'20200911_232805\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20200912_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_204800\' AND dt <= \'20200912_205759\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20200912_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_205900\' AND dt <= \'20200912_210359\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'copperriver_20200912\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_215300\' AND dt <= \'20200912_215459\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20200912_targetedmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_231400\' AND dt <= \'20200912_231710\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20200912_targetedmosaic_2\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_231800\' AND dt <= \'20200912_232059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'pedersen_20200912_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_232500\' AND dt <= \'20200912_232659\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'holgate_20200912_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_232800\' AND dt <= \'20200912_233259\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20200912_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_233400\' AND dt <= \'20200912_234059\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20200912_fullmosaic_1\' WHERE evt_header_frame_id = \'ins_evt\' AND flight = \'fl12\' AND dt >= \'20200912_234200\' AND dt <= \'20200912_234859\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'do_not_use\' WHERE dt >= \'20200901_000000\' AND dt <= \'20200913_235959\' AND survey_id IS NULL") 

#### 2021 data
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20210829_sample_1'\ WHERE flight = \'fl11\' AND dt >= \'20210829_211500\' AND dt <= \'20210829_221459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20210829_sample_1'\ WHERE flight = \'fl11\' AND dt >= \'20210829_225500\' AND dt <= \'20210829_233859\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20210830_fullmosaic_1'\ WHERE flight = \'fl13\' AND dt >= \'20210830_212200\' AND dt <= \'20210830_212859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20210830_fullmosaic_2'\ WHERE flight = \'fl13\' AND dt >= \'20210830_213100\' AND dt <= \'20210830_213759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20210830_fullmosaic_3'\ WHERE flight = \'fl13\' AND dt >= \'20210830_213900\' AND dt <= \'20210830_214659\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210830_fullmosaic_1'\ WHERE flight = \'fl14\' AND dt >= \'20210831_000700\' AND dt <= \'20210831_000959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210830_fullmosaic_2'\ WHERE flight = \'fl14\' AND dt >= \'20210831_001200\' AND dt <= \'20210831_001559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210830_fullmosaic_3'\ WHERE flight = \'fl14\' AND dt >= \'20210831_001800\' AND dt <= \'20210831_002059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210830_fullmosaic_1'\ WHERE flight = \'fl14\' AND dt >= \'20210831_003600\' AND dt <= \'20210831_003959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210830_fullmosaic_2'\ WHERE flight = \'fl14\' AND dt >= \'20210831_004200\' AND dt <= \'20210831_004559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210830_fullmosaic_3'\ WHERE flight = \'fl14\' AND dt >= \'20210831_004800\' AND dt <= \'20210831_004959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210830_fullmosaic_4'\ WHERE flight = \'fl14\' AND dt >= \'20210831_005400\' AND dt <= \'20210831_005659\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20210831_sample_1'\ WHERE flight = \'fl15\' AND dt >= \'20210831_220700\' AND dt <= \'20210831_232859\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20210901_targetedmosaic_1'\ WHERE flight = \'fl16\' AND dt >= \'20210901_222800\' AND dt <= \'20210901_223059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20210901_targetedmosaic_2'\ WHERE flight = \'fl16\' AND dt >= \'20210901_223300\' AND dt <= \'20210901_223559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20210901_targetedmosaic_3'\ WHERE flight = \'fl16\' AND dt >= \'20210901_223600\' AND dt <= \'20210901_223859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210901_targetedmosaic_1'\ WHERE flight = \'fl16\' AND dt >= \'20210901_231400\' AND dt <= \'20210901_231659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210901_targetedmosaic_2'\ WHERE flight = \'fl16\' AND dt >= \'20210901_231800\' AND dt <= \'20210901_232059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210901_targetedmosaic_3'\ WHERE flight = \'fl16\' AND dt >= \'20210901_232400\' AND dt <= \'20210901_232659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20210901_fullmosaic_1'\ WHERE flight = \'fl16\' AND dt >= \'20210901_232900\' AND dt <= \'20210901_233659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210901_targetedmosaic_1'\ WHERE flight = \'fl16\' AND dt >= \'20210901_235300\' AND dt <= \'20210901_235559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210901_targetedmosaic_2'\ WHERE flight = \'fl16\' AND dt >= \'20210901_235600\' AND dt <= \'20210901_235759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20210901_fullmosaic_1'\ WHERE flight = \'fl16\' AND dt >= \'20210902_000100\' AND dt <= \'20210902_000559\' AND effort = \'ON\'")

#### 2024 data
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240805_fullcount_1'\ WHERE flight = \'fl01\' AND dt >= \'20240805_225500\' AND dt <= \'20240805_230159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240805_fullcount_2'\ WHERE flight = \'fl01\' AND dt >= \'20240805_230300\' AND dt <= \'20240805_230559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240805_fullcount_3'\ WHERE flight = \'fl01\' AND dt >= \'20240805_231100\' AND dt <= \'20240805_231459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20240805_targetedcount_1'\ WHERE flight = \'fl01\' AND dt >= \'20240805_232200\' AND dt <= \'20240805_232459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20240805_targetedcount_2'\ WHERE flight = \'fl01\' AND dt >= \'20240805_232900\' AND dt <= \'20240805_233159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20240805_targetedcount_3'\ WHERE flight = \'fl01\' AND dt >= \'20240805_233500\' AND dt <= \'20240805_233759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20240805_targetedcount_1'\ WHERE flight = \'fl01\' AND dt >= \'20240806_000000\' AND dt <= \'20240806_000259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240805_fullcount_1'\ WHERE flight = \'fl01\' AND dt >= \'20240806_002800\' AND dt <= \'20240806_003059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240805_fullcount_2'\ WHERE flight = \'fl01\' AND dt >= \'20240806_003700\' AND dt <= \'20240806_004059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20240805_targetedcount_1'\ WHERE flight = \'fl01\' AND dt >= \'20240806_004600\' AND dt <= \'20240806_004959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20240805_targetedcount_2'\ WHERE flight = \'fl01\' AND dt >= \'20240806_005600\' AND dt <= \'20240806_005959\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20240806_targetedcount_1'\ WHERE flight = \'fl02\' AND dt >= \'20240806_232700\' AND dt <= \'20240806_234559\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20240811_targetedcount_1'\ WHERE flight = \'fl03\' AND dt >= \'20240811_213400\' AND dt <= \'20240811_213559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20240811_targetedcount_2'\ WHERE flight = \'fl03\' AND dt >= \'20240811_213700\' AND dt <= \'20240811_213859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20240811_targetedcount_1'\ WHERE flight = \'fl03\' AND dt >= \'20240811_220800\' AND dt <= \'20240811_220959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'holgate_20240811_targetedcount_1'\ WHERE flight = \'fl03\' AND dt >= \'20240811_222100\' AND dt <= \'20240811_222259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20240811_targetedcount_1'\ WHERE flight = \'fl03\' AND dt >= \'20240811_223100\' AND dt <= \'20240811_223259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20240811_targetedcount_2'\ WHERE flight = \'fl03\' AND dt >= \'20240811_223600\' AND dt <= \'20240811_223859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bear_20240811_sample_1'\ WHERE flight = \'fl03\' AND dt >= \'20240811_225300\' AND dt <= \'20240811_231959\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'blackstone_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_205200\' AND dt <= \'20240812_205359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'blackstone_20240812_targetedcount_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_205500\' AND dt <= \'20240812_205859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240812_hybrid_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_212500\' AND dt <= \'20240812_220359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240812_hybrid_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_221100\' AND dt <= \'20240812_221359\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_221800\' AND dt <= \'20240812_221959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240812_targetedcount_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_222200\' AND dt <= \'20240812_222359\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240812_targetedcount_3'\ WHERE flight = \'fl04\' AND dt >= \'20240812_222500\' AND dt <= \'20240812_222759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_223400\' AND dt <= \'20240812_223659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240812_targetedcount_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_223800\' AND dt <= \'20240812_224159\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20240812_sample_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_224600\' AND dt <= \'20240812_230559\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_231500\' AND dt <= \'20240812_231659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240812_targetedcount_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_232000\' AND dt <= \'20240812_232159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_232700\' AND dt <= \'20240812_232759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20240812_targetedcount_2'\ WHERE flight = \'fl04\' AND dt >= \'20240812_232800\' AND dt <= \'20240812_232959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20240812_targetedcount_3'\ WHERE flight = \'fl04\' AND dt >= \'20240812_233000\' AND dt <= \'20240812_233259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240812_235200\' AND dt <= \'20240812_235359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20240812_sample_1'\ WHERE flight = \'fl04\' AND dt >= \'20240813_000100\' AND dt <= \'20240813_001159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240812_targetedcount_1'\ WHERE flight = \'fl04\' AND dt >= \'20240813_002300\' AND dt <= \'20240813_002459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'ellsworth_20240812_sample_1'\ WHERE flight = \'fl04\' AND dt >= \'20240813_004000\' AND dt <= \'20240813_004459\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_195600\' AND dt <= \'20240813_195659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20240813_fullcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_200600\' AND dt <= \'20240813_200859\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'holgate_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_201200\' AND dt <= \'20240813_201359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'pedersen_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_201600\' AND dt <= \'20240813_201759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'aialik_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_202200\' AND dt <= \'20240813_202359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bear_20240813_sample_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_202900\' AND dt <= \'20240813_210459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'ellsworth_20240813_sample_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_211600\' AND dt <= \'20240813_212159\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_213000\' AND dt <= \'20240813_213459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20240813_targetedcount_2'\ WHERE flight = \'fl05\' AND dt >= \'20240813_213500\' AND dt <= \'20240813_213659\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'blackstone_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_215300\' AND dt <= \'20240813_215459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_220600\' AND dt <= \'20240813_220959\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_221500\' AND dt <= \'20240813_221659\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240813_targetedcount_2'\ WHERE flight = \'fl05\' AND dt >= \'20240813_222000\' AND dt <= \'20240813_222259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240813_targetedcount_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_223200\' AND dt <= \'20240813_223459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240813_targetedcount_2'\ WHERE flight = \'fl05\' AND dt >= \'20240813_223700\' AND dt <= \'20240813_223859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240813_hybrid_1'\ WHERE flight = \'fl05\' AND dt >= \'20240813_224700\' AND dt <= \'20240813_232059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240813_hybrid_2'\ WHERE flight = \'fl05\' AND dt >= \'20240813_232600\' AND dt <= \'20240813_232859\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240813_hybrid_3'\ WHERE flight = \'fl05\' AND dt >= \'20240813_232900\' AND dt <= \'20240813_233159\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'columbia_20240813_hybrid_4'\ WHERE flight = \'fl05\' AND dt >= \'20240813_233400\' AND dt <= \'20240813_233659\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20240814_sample_1'\ WHERE flight = \'fl07\' AND dt >= \'20240814_005300\' AND dt <= \'20240814_013959\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bering_20240816_targetedcount_1'\ WHERE flight = \'fl08\' AND dt >= \'20240816_215800\' AND dt <= \'20240816_221959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20240816_sample_1'\ WHERE flight = \'fl08\' AND dt >= \'20240816_225700\' AND dt <= \'20240817_001859\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20240817_targetedcount_1'\ WHERE flight = \'fl09\' AND dt >= \'20240817_215000\' AND dt <= \'20240817_215259\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20240817_targetedcount_2'\ WHERE flight = \'fl09\' AND dt >= \'20240817_215700\' AND dt <= \'20240817_215759\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20240817_targetedcount_3'\ WHERE flight = \'fl09\' AND dt >= \'20240817_220000\' AND dt <= \'20240817_220159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20240817_targetedcount_4'\ WHERE flight = \'fl09\' AND dt >= \'20240817_220400\' AND dt <= \'20240817_220659\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'margerie_20240817_targetedcount_1'\ WHERE flight = \'fl09\' AND dt >= \'20240817_222800\' AND dt <= \'20240817_223159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20240817_targetedcount_1'\ WHERE flight = \'fl09\' AND dt >= \'20240817_223600\' AND dt <= \'20240817_223859\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20240817_targetedcount_2'\ WHERE flight = \'fl09\' AND dt >= \'20240817_223900\' AND dt <= \'20240817_224359\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'icy_20240818_sample_1'\ WHERE flight = \'fl10\' AND dt >= \'20240818_214300\' AND dt <= \'20240818_231459\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20240820_sample_1'\ WHERE flight = \'fl11\' AND dt >= \'20240820_200300\' AND dt <= \'20240820_203307\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'dbay_20240820_sample_1'\ WHERE flight = \'fl11\' AND dt >= \'20240820_203344\' AND dt <= \'20240820_205459\' AND effort = \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_205000\' AND dt <= \'20240821_205459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20240821_fullcount_2'\ WHERE flight = \'fl12\' AND dt >= \'20240821_205700\' AND dt <= \'20240821_210259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_212600\' AND dt <= \'20240821_213059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_214900\' AND dt <= \'20240821_215159\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mcbride_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_224700\' AND dt <= \'20240821_224959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'margerie_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_230500\' AND dt <= \'20240821_2320459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'jhi_20240821_fullcount_1'\ WHERE flight = \'fl12\' AND dt >= \'20240821_232400\' AND dt <= \'20240821_233459\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20240823_fullcount_1'\ WHERE flight = \'fl13\' AND dt >= \'20240823_211200\' AND dt <= \'20240823_211759\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20240823_fullcount_2'\ WHERE flight = \'fl13\' AND dt >= \'20240823_211900\' AND dt <= \'20240823_212359\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'leconte_20240823_fullcount_3'\ WHERE flight = \'fl13\' AND dt >= \'20240823_212300\' AND dt <= \'20240823_213559\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20240823_fullcount_1'\ WHERE flight = \'fl13\' AND dt >= \'20240823_220600\' AND dt <= \'20240823_220959\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'endicott_20240823_fullcount_2'\ WHERE flight = \'fl13\' AND dt >= \'20240823_221100\' AND dt <= \'20240823_221459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20240823_fullcount_1'\ WHERE flight = \'fl13\' AND dt >= \'20240823_223600\' AND dt <= \'20240823_223959\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tracy_20240823_fullcount_2'\ WHERE flight = \'fl13\' AND dt >= \'20240823_224400\' AND dt <= \'20240823_224759\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_204200\' AND dt <= \'20240825_204359\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'meares_20240825_targetedcount_2'\ WHERE flight = \'fl14\' AND dt >= \'20240825_204600\' AND dt <= \'20240825_204759\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_205100\' AND dt <= \'20240825_205459\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'yale_20240825_targetedcount_2'\ WHERE flight = \'fl14\' AND dt >= \'20240825_205700\' AND dt <= \'20240825_205959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_210200\' AND dt <= \'20240825_210359\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'harvard_20240825_targetedcount_2'\ WHERE flight = \'fl14\' AND dt >= \'20240825_210500\' AND dt <= \'20240825_211259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_211900\' AND dt <= \'20240825_212159\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'barry_20240825_targetedcount_2'\ WHERE flight = \'fl14\' AND dt >= \'20240825_212300\' AND dt <= \'20240825_212859\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'surprise_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_213000\' AND dt <= \'20240825_213459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_215500\' AND dt <= \'20240825_220059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'chenega_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_220800\' AND dt <= \'20240825_221459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240825_fullcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_221600\' AND dt <= \'20240825_221859\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20240825_targetedcount_1'\ WHERE flight = \'fl14\' AND dt >= \'20240825_222500\' AND dt <= \'20240825_22XX59\' AND effort = \'ON\'") 

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'mccarty_20240826_targetedcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_201700\' AND dt <= \'20240826_201759\' AND effort = \'ON\'") # check start time
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20240826_fullcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_202800\' AND dt <= \'20240826_203059\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'northwestern_20240826_fullcount_2'\ WHERE flight = \'fl15\' AND dt >= \'20240826_203000\' AND dt <= \'20240826_203259\' AND effort = \'ON\'") # overlapping start time; need to go to seconds, most likely
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'holgate_20240826_targetedcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_204800\' AND dt <= \'20240826_204959\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'excelsior_20240826_targetedcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_211000\' AND dt <= \'20240826_211259\' AND effort = \'ON\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'bainbridge_20240826_targetedcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_212900\' AND dt <= \'20240826_213459\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'tiger_20240826_fullcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_213800\' AND dt <= \'20240826_214359\' AND effort = \'ON\'") 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'nelliejuan_20240826_fullcount_1'\ WHERE flight = \'fl15\' AND dt >= \'20240826_215000\' AND dt <= \'20240826_215459\' AND effort = \'ON\'") 


#### Update any remaining data
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_images_meta SET survey_id = \'do_not_use\' WHERE survey_id IS NULL") 

# Create spatial dataset with surveyIDs assigned
RPostgreSQL::dbSendQuery(con, "DROP TABLE surv_pv_gla.geo_images_footprint_network_path")

RPostgreSQL::dbSendQuery(con, "CREATE TABLE surv_pv_gla.geo_images_footprint_network_path AS
                              SELECT f.id, i.flight, i.camera_view, i.image_name, i.image_dir || \'\\' || i.image_name as image_path, m.survey_id, f.geom
                              FROM surv_pv_gla.geo_images_meta m
                              INNER JOIN surv_pv_gla.geo_images_footprint f USING (flight, camera_view, dt)
                              INNER JOIN surv_pv_gla.tbl_images i USING (flight, camera_view, dt)
                              WHERE i.image_type = \'rgb_image\' AND f.image_type = \'rgb_image\'
                              AND m.survey_id <> \'do_not_use\'")

RPostgreSQL::dbSendQuery(con, "ALTER TABLE surv_pv_gla.geo_images_footprint_network_path ADD PRIMARY KEY (id)")

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con)
