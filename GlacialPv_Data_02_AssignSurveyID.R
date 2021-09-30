# In Flight System: Process Data/Images to DB
# S. Hardy

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
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Assign survey ID to flight segments
#### 2020 data
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = \'icy_20200901'\ WHERE evt_header_frame_id == \'ins_evt\' & flight == \'fl01\' & dt >= \'20200902_001800\' & dt <= \'20200902_012259\' & effort == \'ON\'")

RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = \'leconte_20200903a\' WHERE evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_204100\' & dt <= \'20200903_204759\'")
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 
RPostgreSQL::dbSendQuery(con, "UPDATE surv_pv_gla.geo_image_meta SET survey_id = 

survey_id <- ifelse(, , survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_204900\' & dt <= \'20200903_210159\', \'leconte_20200903b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_210300\' & dt <= \'20200903_210959\', \'leconte_20200903c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_215400\' & dt <= \'20200903_215859\', \'endicott_20200903a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_220200\' & dt <= \'20200903_220659\', \'endicott_20200903b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_222800\' & dt <= \'20200903_223059\', \'tracy_20200903a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl02\' & dt >= \'20200903_223200\' & dt <= \'20200903_223459\', \'tracy_20200903b\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl03\' & dt >= \'20200904_005300\' & dt <= \'20200904_005559\', \'jhi_20200903a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl03\' & dt >= \'20200904_005900\' & dt <= \'20200904_010259\', \'jhi_20200903b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl03\' & dt >= \'20200904_012700\' & dt <= \'20200904_012959\', \'mcbride_20200903a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl03\' & dt >= \'20200904_013400\' & dt <= \'20200904_013659\', \'mcbride_20200903b\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl04\' & dt >= \'20200904_212500\' & dt <= \'20200904_222759\', \'icy_20200904\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl04\' & dt >= \'20200904_225300\' & dt <= \'20200904_230559\', \'malaspina_20200904\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl04\' & dt >= \'20200904_231700\' & dt <= \'20200904_234959\', \'dbay_20200904\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl06\' & dt >= \'20200905_215300\' & dt <= \'20200905_215759\', \'jhi_20200905a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl06\' & dt >= \'20200905_215900\' & dt <= \'20200905_220159\', \'jhi_20200905b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl06\' & dt >= \'20200905_220300\' & dt <= \'20200905_220859\', \'jhi_20200905c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl06\' & dt >= \'20200905_221000\' & dt <= \'20200905_221359\', \'margerie_20200905a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl06\' & dt >= \'20200905_221400\' & dt <= \'20200905_221459\', \'margerie_20200905b\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl07\' & dt >= \'20200906_002200\' & dt <= \'20200906_002410\', \'tracy_20200905a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl07\' & dt >= \'20200906_002500\' & dt <= \'20200906_002710\', \'tracy_20200905b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl07\' & dt >= \'20200906_010000\' & dt <= \'20200906_011259\', \'leconte_20200905a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl07\' & dt >= \'20200906_011400\' & dt <= \'20200906_011759\', \'leconte_20200905b\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl08\' & dt >= \'20200906_192600\' & dt <= \'20200906_192959\', \'drybay_20200906a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl08\' & dt >= \'20200906_193100\' & dt <= \'20200906_193459\', \'drybay_20200906b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl08\' & dt >= \'20200906_200700\' & dt <= \'20200906_201459\', \'malaspina_20200906\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl08\' & dt >= \'20200906_204600\' & dt <= \'20200906_211559\', \'dbay_20200906\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_193500\' & dt <= \'20200909_193859\', \'ellsworth_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_194000\' & dt <= \'20200909_194359\', \'ellsworth_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_194500\' & dt <= \'20200909_194859\', \'ellsworth_20200909c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_195500\' & dt <= \'20200909_195859\', \'excelsior_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_200000\' & dt <= \'20200909_200359\', \'excelsior_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_201300\' & dt <= \'20200909_201559\', \'tiger_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_201700\' & dt <= \'20200909_201959\', \'tiger_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_202100\' & dt <= \'20200909_202359\', \'tiger_20200909c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_202400\' & dt <= \'20200909_203459\', \'chenega_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_203600\' & dt <= \'20200909_204359\', \'chenega_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_204600\' & dt <= \'20200909_204840\', \'nellie_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_204900\' & dt <= \'20200909_205110\', \'nellie_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_210000\' & dt <= \'20200909_211059\', \'blackstone_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_211600\' & dt <= \'20200909_211759\', \'harriman_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_211900\' & dt <= \'20200909_212140\', \'surprise_20200909a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_212200\' & dt <= \'20200909_212430\', \'surprise_20200909b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_212700\' & dt <= \'20200909_214059\', \'barry_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_214200\' & dt <= \'20200909_220559\', \'yale_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_220700\' & dt <= \'20200909_224559\', \'harvard_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_224800\' & dt <= \'20200909_234559\', \'columbia_20200909\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl09\' & dt >= \'20200909_235500\' & dt <= \'20200910_000059\', \'meares_20200909\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_194200\' & dt <= \'20200910_194559\', \'yale_20200910a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_194700\' & dt <= \'20200910_195059\', \'yale_20200910b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_195800\' & dt <= \'20200910_200259\', \'harvard_20200910a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_201800\' & dt <= \'20200910_204559\', \'harvard_20200910b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_205200\' & dt <= \'20200910_215159\', \'columbia_20200910\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_230300\' & dt <= \'20200910_230459\', \'bering_20200910a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_230600\' & dt <= \'20200910_230759\', \'bering_20200910b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl10\' & dt >= \'20200910_232000\' & dt <= \'20200910_232859\', \'bering_20200910c\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_202000\' & dt <= \'20200911_202135\', \'aialik_20200911a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_202200\' & dt <= \'20200911_202259\', \'aialik_20200911b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_202900\' & dt <= \'20200911_203259\', \'holgate_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_203400\' & dt <= \'20200911_204559\', \'pedersen_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_204700\' & dt <= \'20200911_205059\', \'northwestern_20200911a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_205500\' & dt <= \'20200911_210259\', \'northwestern_20200911b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_210400\' & dt <= \'20200911_213059\', \'mccarty_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_213300\' & dt <= \'20200911_214259\', \'excelsior_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_214300\' & dt <= \'20200911_214959\', \'tiger_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_215100\' & dt <= \'20200911_215359\', \'chenega_20200911a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_215500\' & dt <= \'20200911_215759\', \'chenega_20200911b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_215900\' & dt <= \'20200911_220259\', \'chenega_20200911c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_221300\' & dt <= \'20200911_222559\', \'nellie_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_222600\' & dt <= \'20200911_223259\', \'blackstone_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_224600\' & dt <= \'20200911_224710\', \'surprise_20200911a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_224800\' & dt <= \'20200911_224930\', \'surprise_20200911b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_225100\' & dt <= \'20200911_225159\', \'surprise_20200911c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_225600\' & dt <= \'20200911_230159\', \'barry_20200911\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_232100\' & dt <= \'20200911_232359\', \'meares_20200911a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl11\' & dt >= \'20200911_232500\' & dt <= \'20200911_232805\', \'meares_20200911b\', survey_id)

survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_204800\' & dt <= \'20200912_205259\', \'bering_20200912a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_205400\' & dt <= \'20200912_205759\', \'bering_20200912b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_205900\' & dt <= \'20200912_210359\', \'bering_20200912c\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_215300\' & dt <= \'20200912_215459\', \'copperriver_20200912\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_231400\' & dt <= \'20200912_231710\', \'aialik_20200912a\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_231800\' & dt <= \'20200912_232059\', \'aialik_20200912b\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_232500\' & dt <= \'20200912_232659\', \'pedersen_20200912\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_232800\' & dt <= \'20200912_233259\', \'holgate_20200912\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_233400\' & dt <= \'20200912_234059\', \'northwestern_20200912\', survey_id)
survey_id <- ifelse(evt_header_frame_id == \'ins_evt\' & flight == \'fl12\' & dt >= \'20200912_234200\' & dt <= \'20200912_234859\', \'mccarty_20200912\', survey_id)

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con, df, dat, i, sql, sql1, sql2)
