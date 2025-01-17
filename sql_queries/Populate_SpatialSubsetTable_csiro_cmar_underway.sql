SET SEARCH_PATH = marvl3, public;
-- CSIRO UNDERWAY
\echo 'CSIRO UNDERWAY'
INSERT INTO spatial_subset(
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
d."SURVEY_ID",
avg(d."LONGITUDE"),
max(d."POSITION_QC"),
avg(d."LATITUDE"),
max(d."POSITION_QC"),
date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'),
'1',
0,
'1',
avg(d."SEA_SURFACE_TEMP"),
CASE
	WHEN max(d."SEA_SURFACE_TEMP_QC") BETWEEN 0 AND 63 THEN '1'
	WHEN max(d."SEA_SURFACE_TEMP_QC") BETWEEN 64 AND 127 THEN '3'
	WHEN max(d."SEA_SURFACE_TEMP_QC") BETWEEN 128 AND 191 THEN '4'
	WHEN max(d."SEA_SURFACE_TEMP_QC") BETWEEN 192 AND 255 THEN '0'
	ELSE '4'
END,
avg(d."SALINITY"),
CASE
	WHEN max(d."SALINITY_QC") BETWEEN 0 AND 63 THEN '1'
	WHEN max(d."SALINITY_QC") BETWEEN 64 AND 127 THEN '3'
	WHEN max(d."SALINITY_QC") BETWEEN 128 AND 191 THEN '4'
	WHEN max(d."SALINITY_QC") BETWEEN 192 AND 255 THEN '0'
	ELSE '4'
END,
ST_GeometryFromText(COALESCE('POINT('||avg(d."LONGITUDE")||' '||avg(d."LATITUDE")||')'), '4326') -- geom is re-created from averaged positions over 1min
FROM aodn_csiro_cmar.aodn_csiro_cmar_underway_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'aodn_csiro_cmar_underway_data'
AND d."TIME" >= '1995-01-01'
AND d."TIME" < '2015-01-01'
AND EXTRACT(MINUTE FROM date_trunc('minute', d."TIME" AT TIME ZONE 'UTC')) IN (0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) -- only keep 1 sample every 5min
GROUP BY s.source_id, d."SURVEY_ID", date_trunc('minute', d."TIME" AT TIME ZONE 'UTC'); -- at 10knots, 1min <=> ~300m (distance over which averaging is still sensible)
