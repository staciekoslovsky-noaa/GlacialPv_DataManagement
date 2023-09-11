# Glacial Harbor Seal Survey Data Management

This repository stores the code associated with managing glacial harbor seal survey data. Code numbered 0+ are intended to be run sequentially as the data are available for processing. Code numbered 99 are stored for longetivity, but are intended to only be run once to address a specific issue or run as needed, depending on the intent of the code.

The data management processing code is as follows:
* **GlacialPv_Data_01_ProcessData2DB.R** - code for importing KAMERA-collected glacial survey data into the DB 
* **GlacialPv_Data_01_ProcessFootprints2DB.R** - code for importing post-processing footprints into the DB
* **GlacialPv_Data_02_AssignSurveyID.R** - code for assigning images to glacial survey IDs in the DB; prior to this step, the flight information needs to be entered into the glacial database; and after the code is applied to the image data, the information needs to be reviewed in QGIS to ensure all the images have been correctly assigned to the right survey ID
* **GlacialPv_Data_02_CreateFootprintsTable.txt** - code for createing a table of footprints and associated information that is needed for later processing steps; prior to running this code, footprints need to be imported into the DB; after code is run, the ID field needs to be set as the primary key; code is to be run in PGAdmin
* **GlacialPv_Data_02_MarkNUCedIRimages.R** - code for identifying NUC IR images in the images inventory; prior to this step, the images need to be processed by BXH to identify NUC; code is to be run in PGAdmin

Processing code for LATTE data includes:
* **GlacialPv_LATTE_00_MarkOverlappingImages.txt** - code to identify which LATTE images from a survey overlap with images from earlier in the survey; this needs to be run after all other data processing steps are complete and before LATTE processing begins; code is to be run in PGAdmin
* **GlacialPv_LATTE_01_PrepareData4Viame.R** - code to prepare data for use in VIAME; exports image lists that will either be run through detection models and reviewed for seals or manually reviewed for seals (depending on the availability of corresponding thermal images)
(AFTER ANNOTATION-SPECIFIC PROCESSING IS COMPLETE: detections reviewed; manual review completed; detections have been imported into the DB and exported for post-processing; post-processing has been completed, including the import of footprints)
* **GlacialPv_LATTE_02_ExportFootprints4Analysis.R** - code for exporting footprints in the necessary format for the LATTE abundance estimates
* **GlacialPv_LATTE_99_CompareDetections.Rmd** - code for generating a report to compare counting methods of LATTE data (this was important and necessary before we decided on a processing method); this was a one-time process for evaluating methods
* **GlacialPv_LATTE_99_CreateFootprintViews.txt** - code for generating the queries used for exporting footprints4analysis; the DB stores the queries; code to be run in PGAdmin

Processing code for mosaic data includes:
* **GlacialPv_Mosaic_01_PrepareData4Pix4D.R** - code to prepare mosaic data for Pix4D; this is probably outdated code that will not be used; still working on identifying our processing steps for these data

Other code in the repository includes:
* Code for generating footprints (based on older processing steps before moving to the KAMERA system):
	* GlacialPv_Data_99_CalculateFootprints.R
* Code for creating geo_glaciers layer in database:
	* GlacialPv_Data_99_CreateGeoPolys.txt (code to be run in PGAdmin)
* Code for creating the query used to export glacial data for abundance analyses:
	* GlacialPv_Data_99_ExportQuery4Analysis.txt (query is stored in the DB; this is backup; code to be run in PGAdmin)
* Code for processing data for PARR:
	* GlacialPv_Data_99_ProcessData4PARR.R (requires the DB to be up-to-date with network paths to the data required for PARR)
* Code for updating network paths to the 2020 data (after the data were reorganized):
	* GlacialPv_Data_99_Update2020NetworkPaths_AfterReorg.txt (code to be run in PGAdmin; this should have been a one-time data issue, but storing the code, in case it's needed again later)