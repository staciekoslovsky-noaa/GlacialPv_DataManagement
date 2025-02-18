# Glacial Harbor Seal Survey Data Management

This repository stores the code associated with managing glacial harbor seal survey data. Code numbered 0+ are intended to be run sequentially as the data are available for processing. Code numbered 99 are stored for longetivity, but are intended to only be run once to address a specific issue or run as needed, depending on the intent of the code.

The Datasheets folder contains the KAMERA-specific datasheets for glacial surveys.

The LEGACYcode folder contains outdated code, kept for archive.

The data management processing code is as follows:
* **GlacialPv_Data_01_ProcessData2DB.R** - code for importing KAMERA-collected glacial survey data into the DB 
* **GlacialPv_Data_01_ProcessFootprints2DB.R** - code for importing post-processing footprints into the DB
* **GlacialPv_Data_01b_AssignImageGroup.txt** - code to assign image groups identifiers to data for simplified querying across tables
* **GlacialPv_Data_02_AssignSurveyID.R** - code for assigning images to glacial survey IDs in the DB; prior to this step, the flight information needs to be entered into the glacial database; and after the code is applied to the image data, the information needs to be reviewed in QGIS to ensure all the images have been correctly assigned to the right survey ID
* **GlacialPv_Data_02_MarkNUCedIRimages.R** - code for identifying NUC IR images in the images inventory; prior to this step, the images need to be processed by BXH to identify NUC; code is to be run in PGAdmin

Processing code for LATTE data includes:
* **GlacialPv_LATTE_01_PrepareData4Viame.R** - code to prepare data for use in VIAME; exports image lists that will either be run through detection models and reviewed for seals or manually reviewed for seals (depending on the availability of corresponding thermal images)
* **GlacialPv_LATTE_02_ImportProcessedRGB2DB_byYear.R** - imports processed RGB detections to the DB by year and by survey area
* **GlacialPv_LATTE_03_ExportData4PostProcessing.R** - exports reformatted processed RGB detections and associated image lists (exported by flight, rather than by survey area) for running the data through the KAMERA post-processing script
* **GlacialPv_LATTE_04_ImportDetectionShp2DB.R** - imports the detection shapefiles (output from KAMERA post-processing) into the DB for further processing in the glacial project
* **GlacialPv_LATTE_05_ExportFootprints4Analysis.R** - code for exporting footprints in the necessary format for the LATTE abundance estimates
* **GlacialPv_LATTE_99_CompareDetections.Rmd** - code for generating a report to compare counting methods of LATTE data (this was important and necessary before we decided on a processing method); this was a one-time process for evaluating methods
* **GlacialPv_LATTE_99_CreateFootprintViews.txt** - code for generating the queries used for exporting footprints4analysis; the DB stores the queries; code to be run in PGAdmin

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
	
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.