﻿SET SEARCH_PATH = marvl3, public;

-- ANFOG DM
\echo 'ANFOG DM'
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
d.file_id,
avg(CASE WHEN d."LONGITUDE_quality_control" = '9' THEN NULL ELSE d."LONGITUDE" END), -- we don't want to average values when their flag is 9
max(replace(replace(d."LONGITUDE_quality_control", '8', '2'), '9', '')), -- we assume interpolated values as probably good data and we set missing values to NULL so that they don't interfer with max()
avg(CASE WHEN d."LATITUDE_quality_control" = '9' THEN NULL ELSE d."LATITUDE" END),
max(replace(replace(d."LATITUDE_quality_control", '8', '2'), '9', '')),
date_trunc('minute', CASE WHEN d."TIME_quality_control" = '9' THEN NULL ELSE d."TIME" AT TIME ZONE 'UTC'END), -- WODB provides a timestamp every ~1min to ~5min
max(replace(replace(d."TIME_quality_control", '8', '2'), '9', '')),
(width_bucket(CASE WHEN d."DEPTH" IS NOT NULL THEN CASE WHEN d."DEPTH_quality_control" = '9' THEN NULL ELSE d."DEPTH" END ELSE -gsw_z_from_p(CASE WHEN d."PRES_quality_control" = '9' THEN NULL ELSE d."PRES" END, CASE WHEN d."LATITUDE_quality_control" = '9' THEN NULL ELSE d."LATITUDE" END) END, -2.5, 502.5, 101)-1)*5, --we are binning from surface to 500m limit every 5m. DEPTH is sometimes NULL while PRES (relative pressure here) is not.
max(replace(replace(CASE WHEN d."DEPTH" IS NOT NULL THEN d."DEPTH_quality_control" ELSE d."PRES_quality_control" END, '8', '2'), '9', '')),
avg(CASE WHEN d."TEMP_quality_control" = '9' THEN NULL ELSE d."TEMP" END),
max(replace(replace(d."TEMP_quality_control", '8', '2'), '9', '')),
avg(CASE WHEN d."PSAL_quality_control" = '9' THEN NULL ELSE d."PSAL" END),
max(replace(replace(d."PSAL_quality_control", '8', '2'), '9', '')),
ST_GeometryFromText(COALESCE('POINT('||avg(CASE WHEN d."LONGITUDE_quality_control" = '9' THEN NULL ELSE d."LONGITUDE" END)||' '||avg(CASE WHEN d."LATITUDE_quality_control" = '9' THEN NULL ELSE d."LATITUDE" END)||')'), '4326') -- geom is re-created from averaged positions
FROM anfog_dm.anfog_dm_trajectory_data d, marvl3."500m_isobath" p, marvl3.source s, marvl3."australian_continent" pp
WHERE ST_CONTAINS(p.geom, d.geom)
AND ST_CONTAINS(pp.geom, d.geom) = FALSE
AND s.table_name = 'anfog_dm_trajectory_data'
GROUP BY s.source_id, d.file_id, date_trunc('minute', CASE WHEN d."TIME_quality_control" = '9' THEN NULL ELSE d."TIME" AT TIME ZONE 'UTC'END), width_bucket(CASE WHEN d."DEPTH" IS NOT NULL THEN CASE WHEN d."DEPTH_quality_control" = '9' THEN NULL ELSE d."DEPTH" END ELSE -gsw_z_from_p(CASE WHEN d."PRES_quality_control" = '9' THEN NULL ELSE d."PRES" END, CASE WHEN d."LATITUDE_quality_control" = '9' THEN NULL ELSE d."LATITUDE" END) END, -2.5, 502.5, 101);
