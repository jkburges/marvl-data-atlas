﻿SET SEARCH_PATH = marvl3, public;

DROP INDEX IF EXISTS data_atlas_idx;
CREATE INDEX data_atlas_idx
  ON marvl3.data_atlas
  USING btree
  (timezone('UTC'::text, "TIME"), "DEPTH");

DROP INDEX IF EXISTS spatial_subset_filtered_idx;
CREATE INDEX spatial_subset_filtered_idx
  ON marvl3.spatial_subset_filtered
  USING btree
  (feature_type_id COLLATE pg_catalog."default", timezone('UTC'::text, "TIME"), "NOMINAL_DEPTH", "DEPTH");

DROP INDEX IF EXISTS spatial_subset_filtered_gist_idx;
CREATE INDEX spatial_subset_filtered_gist_idx
  ON marvl3.data_atlas
  USING gist
  (geom);