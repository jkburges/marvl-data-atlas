﻿SET SEARCH_PATH = marvl3, public;

DROP TABLE IF EXISTS source;
CREATE TABLE source (
	"ORGANISATION" text,
	"FACILITY" text,
	"SUBFACILITY" text,
	"PRODUCT" text,
	feature_type text,
	schema_name text,
	table_name text,
	ref_column text
);

INSERT INTO source (SELECT 'IMOS/AODN', 'AATAMS', 'SATTAG', 'DM', 'trajectoryProfile', 'aatams_sattag_dm', 'aatams_sattag_dm_profile_data','profile_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ACORN', '', '', 'gridded','','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANFOG', '', 'DM', 'trajectoryProfile','anfog_dm','anfog_dm_trajectory_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'CTD', 'NRS', 'profile','anmn_nrs_ctd_profiles','anmn_nrs_ctd_profiles_data','cruise_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'Acidification', 'DM', 'timeSeriesProfile','anmn_am_dm','anmn_am_dm_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'Burst average', '', 'timeSeriesProfile','anmn_burst_avg','anmn_burst_avg_timeseries_data','timeseries_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'RT bio', 'NRS', 'timeSeriesProfile','anmn_nrs_rt_bio','anmn_nrs_rt_bio_timeseries_data','timeseries_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'RT meteo', 'NRS', 'timeSeriesProfile','anmn_nrs_rt_meteo','anmn_nrs_rt_meteo_timeseries_data','timeseries_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', 'DarYon', 'NRS', 'timeSeriesProfile','anmn_nrs_dar_yon','anmn_nrs_yon_dar_timeseries_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'Temperature regridded', 'timeSeriesProfile','anmn_t_regridded','anmn_regridded_temperature_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'TS', 'timeSeriesProfile','anmn_ts','anmn_ts_timeseries_data','timeseries_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'ANMN', '', 'Velocity', 'timeSeriesProfile','anmn_velocity','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'AODN', '', 'DSTO', 'trajectoryProfile','aodn_dsto','aodn_dsto_trajectory_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'AODN', '', 'NT hawksbills', 'trajectoryProfile','aodn_nt_sattag_hawksbill','aodn_nt_sattag_hawksbill_profile_data','profile_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'Argo', '', '', 'trajectoryProfile','argo','profile_download','platform_number');
INSERT INTO source (SELECT 'IMOS/AODN', 'AUV', '', '', 'trajectoryProfile','auv','auv_trajectory_b_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'FAIMMS', '', '', 'timeSeriesProfile','faimms','faimms_timeseries_data','channel_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'XBT', 'DM', 'trajectoryProfile','soop_xbt_dm','soop_xbt_dm_profile_data','profile_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'CO2', '', 'trajectoryProfile','soop_co2','soop_co2_trajectory_data','cruise_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'TRV', '', 'trajectoryProfile','soop_trv','soop_trv_trajectory_data','trip_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'SST', 'DM', 'trajectoryProfile','soop_sst','soop_sst_dm_trajectory_data','trajectory_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'SST', 'RT', 'trajectoryProfile','soop_sst','soop_sst_nrt_trajectory_data','trajectory_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'ASF', 'MT', 'trajectoryProfile','soop_asf_mt','soop_asf_mt_trajectory_data','cruise_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SOOP', 'TMV', 'DM', 'trajectoryProfile','soop_tmv','soop_tmv_trajectory_data','file_id');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'Altimetry', '', 'timeSeriesProfile','srs_altimetry','srs_altimetry_timeseries_data','site_name');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'Salinity', '', 'gridded','','','');
INSERT INTO source (SELECT 'IMOS/AODN', 'SRS', 'SST', '', 'gridded','','','');
INSERT INTO source (SELECT 'CSIRO', '', 'ADCP', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_adcp_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'CTD', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_ctd_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'Hydrology', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_hydrology_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'Mooring', '', 'timeSeriesProfile','aodn_csiro_cmar','aodn_csiro_cmar_mooring_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'Trajectory', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_trajectory_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'Underway', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_underway_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'CSIRO', '', 'XBT', '', 'trajectoryProfile','aodn_csiro_cmar','aodn_csiro_cmar_xbt_data','"SURVEY_ID"');
INSERT INTO source (SELECT 'RAN', '', 'CTD', '', 'trajectoryProfile','aodn_ran_ctd','aodn_ran_ctd_data','file_id');
INSERT INTO source (SELECT 'RAN', '', 'SST', '', 'timeSeriesProfile','aodn_ran_sst','ran_sst_data','file_id');
INSERT INTO source (SELECT 'WODB', '', 'APB', '', 'profile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'CTD', '', 'trajectoryProfile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'GLD', '', 'trajectoryProfile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'MBT', '', 'profile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'OSD', '', 'profile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'PFL', '', 'profile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'SUR', '', 'trajectoryProfile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'UOR', '', 'profile','wodb','','');
INSERT INTO source (SELECT 'WODB', '', 'XBT', '', 'trajectoryProfile','wodb','','');

ALTER TABLE source ADD COLUMN source_id bigserial;
ALTER TABLE source ADD PRIMARY KEY (source_id);