﻿SET SEARCH_PATH = marvl3, public;

-- WODB UOR
\echo 'WODB UOR'
INSERT INTO spatial_subset (
source_id,
origin_id,
"LONGITUDE",
"LONGITUDE_QC",
"LATITUDE",
"LATITUDE_QC",
"TIME",
"TIME_QC",
"DEPTH",
"DEPTH_QC",
"TEMP",
"TEMP_QC",
"PSAL",
"PSAL_QC",
geom
)
SELECT
s.source_id,
m."CAST_ID",
m."LONGITUDE",
'1',
m."LATITUDE",
'1',
m."TIME",
'1',
d.depth,
'1',
CASE WHEN d.temperature = 999999 THEN NULL ELSE d.temperature END,
CASE WHEN d.temperature = 999999 THEN '9' ELSE '1' END,
CASE WHEN d.salinity = 999999 THEN NULL ELSE d.salinity END,
CASE WHEN d.salinity = 999999 THEN '9' ELSE '1' END,
m.geom
FROM marvl3."500m_isobath" p, source s, marvl3."australian_continent" pp, wodb.uor_deployments m
INNER JOIN wodb.uor_measurements d
ON m."CAST_ID" = d.cast_id
WHERE ST_CONTAINS(p.geom, m.geom)
AND ST_CONTAINS(pp.geom, m.geom) = FALSE
AND s."SUBFACILITY" = 'UOR'
AND s.schema_name = 'wodb'
AND m."TIME" >= '1995-01-01'
AND m."TIME" < '2015-01-01';
