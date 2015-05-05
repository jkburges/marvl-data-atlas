SET SEARCH_PATH = marvl3, public;
UPDATE marvl3.spatial_subset
SET "LONGITUDE_QC"=(SELECT CASE WHEN "LONGITUDE_QC"='Z' THEN '1' ELSE '3' END),
"LATITUDE_QC"=(SELECT CASE WHEN "LATITUDE_QC"='Z' THEN '1' ELSE '3' END),
"TIME_QC"=(SELECT CASE WHEN  "TIME_QC"='Z' THEN '1' ELSE '3' END),
"DEPTH_QC"=(SELECT CASE WHEN "DEPTH_QC"='Z' THEN '1' ELSE '3' END),
"TEMP_QC"=(SELECT CASE WHEN CASE "TEMP_QC"='Z' THEN '1' ELSE '3' END),
"PSAL_QC"=(SELECT CASE WHEN CASE "PSAL_QC"='Z' THEN '1' ELSE '3' END)
WHERE source_id IN(21,22);
 
