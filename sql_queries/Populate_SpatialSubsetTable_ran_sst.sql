﻿SET SEARCH_PATH = marvl3, public;

-- RAN SST
\echo 'RAN SST'
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
d."LONGITUDE",
'1',
d."LATITUDE",
'1',
date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'),
'1',
0,
'1',
avg(d."SST"),
'1',
NULL,
NULL,
d.geom
FROM aodn_ran_sst.ran_sst_data d, marvl3."500m_isobath" p, marvl3.source s
WHERE ST_CONTAINS(p.geom, d.geom)
AND s.table_name = 'ran_sst_data'
GROUP BY s.source_id, d.file_id, d."LONGITUDE", d."LATITUDE", date_trunc('hour', d."TIME" AT TIME ZONE 'UTC'), d.geom
ORDER BY d.file_id, date_trunc('hour', d."TIME" AT TIME ZONE 'UTC');