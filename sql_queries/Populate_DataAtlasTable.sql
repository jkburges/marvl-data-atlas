﻿SET SEARCH_PATH = marvl3, public;

-- data_atlas
\echo 'data_atlas'
INSERT INTO data_atlas (
"LONGITUDE_bin",
"LONGITUDE_bound_min",
"LONGITUDE_bound_max",
"LATITUDE_bin",
"LATITUDE_bound_min",
"LATITUDE_bound_max",
"TIME_bin",
"TIME_bound_min",
"TIME_bound_max",
"DEPTH_bin",
"DEPTH_bound_min",
"DEPTH_bound_max",
"TEMP_n",
"TEMP_min",
"TEMP_max",
"TEMP_mean",
"TEMP_stddev",
"PSAL_n",
"PSAL_min",
"PSAL_max",
"PSAL_mean",
"PSAL_stddev",
geom_bin
)
SELECT
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111 AS "LONGITUDE_bin", -- we consider LONGITUDE buckets of size 0.25 with first value centred on 111 : [110.875;111.125[, [111.125;111.375[, [111.375;111.625[, [111.625;111.875[, etc...
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875 AS "LONGITUDE_bound_min",
(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125 AS "LONGITUDE_bound_max",
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3 AS "LATITUDE_bin", -- we consider LATITUDE buckets of size 0.25 with first value centred on -3 : [-2.875;-3.125[, [-3.125;-3.375[, etc...
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125 AS "LATITUDE_bound_min",
(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875 AS "LATITUDE_bound_max",
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') + interval '14 days' AS "TIME_bin", -- we consider TIME buckets monthly with first value centred on 2007-01-15 : [2007-01-01;2007-01-31[, [2007-02-01;2007-02-28[, etc...
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') AS "TIME_bound_min",
date_trunc('month', s."TIME" AT TIME ZONE 'UTC') + interval '1 mons' AS "TIME_bound_max",
(width_bucket(CASE WHEN s."DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10 AS "DEPTH_bin", -- we consider DEPTH buckets of size 10 with first value centred on 0 : [-5;5[, [5;15[, etc... If field DEPTH is NULL, NOMINAL_DEPTH is considered.
(width_bucket(CASE WHEN s."DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10-5 AS "DEPTH_bound_min",
(width_bucket(CASE WHEN s."DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51)-1)*10+5 AS "DEPTH_bound_max",
count(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_n", -- measurements with QC flags no good are not considered, global range QC test (ARGO thresholds)
min(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_min", -- global range QC test (ARGO thresholds)
max(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_max", -- global range QC test (ARGO thresholds)
avg(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_mean", -- global range QC test (ARGO thresholds)
stddev(CASE WHEN s."TEMP_QC" IN ('0', '1', '2') AND s."TEMP" BETWEEN -2.5 AND 40 THEN s."TEMP" ELSE NULL END) AS "TEMP_stddev", -- global range QC test (ARGO thresholds)
count(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_n", -- checking for TEMP_QC is part of the salinity QC test (if TEMP is not good then PSAL must be not good), global range QC test (ARGO thresholds)
min(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_min", -- global range QC test (ARGO thresholds)
max(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_max", -- global range QC test (ARGO thresholds)
avg(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_mean", -- global range QC test (ARGO thresholds)
stddev(CASE WHEN (s."PSAL_QC" IN ('0', '1', '2') AND s."PSAL" BETWEEN 2 AND 41 AND s."TEMP_QC" IN ('0', '1', '2')) THEN s."PSAL" ELSE NULL END) AS "PSAL_stddev", -- global range QC test (ARGO thresholds)
ST_GeometryFromText(COALESCE('POLYGON(('||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-3.125||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+110.875||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||', '||(width_bucket(s."LONGITUDE", 110.875, 155.125, 177)-1)*0.25+111.125||' '||(width_bucket(s."LATITUDE", -2.875, -45.125, 169)-1)*-0.25-2.875||'))'), '4326') as geom_bin
FROM marvl3.spatial_subset s
WHERE s."LONGITUDE_QC" IN ('0', '1', '2') -- measurements with time and space location QC flags no good are not considered
AND s."LATITUDE_QC" IN ('0', '1', '2')
AND s."TIME_QC" IN ('0', '1', '2')
AND (
s."NOMINAL_DEPTH_QC" IN ('0', '1', '2')
OR s."DEPTH_QC" IN ('0', '1', '2')
)
AND s."TIME" BETWEEN '1995-01-01' AND now() -- impossible time QC test
AND s."LONGITUDE" BETWEEN 111 AND 155 -- impossible location QC test
AND s."LATITUDE" BETWEEN -45 AND -3
AND (
s."DEPTH" BETWEEN -5 AND 505
OR s."NOMINAL_DEPTH" BETWEEN -5 AND 505
)
GROUP BY width_bucket(s."LONGITUDE", 110.875, 155.125, 177), -- elements in same temporal and spatial buckets are grouped
width_bucket(s."LATITUDE", -2.875, -45.125, 169),
date_trunc('month', s."TIME" AT TIME ZONE 'UTC'),
width_bucket(CASE WHEN s."DEPTH_QC" IN ('0', '1', '2') THEN s."DEPTH" ELSE s."NOMINAL_DEPTH" END, -5, 505, 51);
