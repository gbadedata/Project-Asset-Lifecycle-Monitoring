-- Project : Asset Lifecycle Monitoring & Anomaly Escalation
-- Author: Olywagbade Odimayo
-- Database: asset_ops.db

PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vw_lifecycle_anomalies;

CREATE VIEW vw_lifecycle_anomalies AS
WITH base AS (

  -- A1) Asset removed but removal_date missing
  SELECT
    'REMOVED_WITHOUT_DATE' AS anomaly_type,
    'HIGH' AS severity,
    a.meter_id,
    a.meter_type,
    a.region,
    a.status,
    a.install_date,
    a.removal_date,
    NULL AS event_id,
    NULL AS event_type,
    NULL AS event_date,
    NULL AS reading_value,
    NULL AS new_status,
    'meter_asset' AS source_table,
    'Asset status REMOVED but removal_date is NULL' AS rule_description
  FROM meter_asset a
  WHERE a.status = 'REMOVED' AND a.removal_date IS NULL

  UNION ALL

  -- A2) removal_date earlier than install_date
  SELECT
    'REMOVAL_BEFORE_INSTALL' AS anomaly_type,
    'CRITICAL' AS severity,
    a.meter_id,
    a.meter_type,
    a.region,
    a.status,
    a.install_date,
    a.removal_date,
    NULL, NULL, NULL, NULL, NULL,
    'meter_asset',
    'removal_date < install_date'
  FROM meter_asset a
  WHERE a.removal_date IS NOT NULL
    AND a.install_date IS NOT NULL
    AND a.removal_date < a.install_date

  UNION ALL

  -- A3) Event recorded before install_date
  SELECT
    'EVENT_BEFORE_INSTALL' AS anomaly_type,
    'HIGH' AS severity,
    a.meter_id,
    a.meter_type,
    a.region,
    a.status,
    a.install_date,
    a.removal_date,
    e.event_id,
    e.event_type,
    e.event_date,
    e.reading_value,
    e.new_status,
    'meter_event',
    'event_date < install_date'
  FROM meter_event e
  JOIN meter_asset a ON a.meter_id = e.meter_id
  WHERE a.install_date IS NOT NULL
    AND e.event_date < a.install_date

  UNION ALL

  -- A4) Event recorded after removal_date
  SELECT
    'EVENT_AFTER_REMOVAL' AS anomaly_type,
    'CRITICAL' AS severity,
    a.meter_id,
    a.meter_type,
    a.region,
    a.status,
    a.install_date,
    a.removal_date,
    e.event_id,
    e.event_type,
    e.event_date,
    e.reading_value,
    e.new_status,
    'meter_event',
    'event_date > removal_date (asset should be inactive)'
  FROM meter_event e
  JOIN meter_asset a ON a.meter_id = e.meter_id
  WHERE a.removal_date IS NOT NULL
    AND e.event_date > a.removal_date

  UNION ALL

  -- A5) Negative reading values
  SELECT
    'NEGATIVE_READING' AS anomaly_type,
    'HIGH' AS severity,
    e.meter_id,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    e.event_id,
    e.event_type,
    e.event_date,
    e.reading_value,
    e.new_status,
    'meter_event',
    'reading_value < 0 for READING events'
  FROM meter_event e
  WHERE e.event_type = 'READING'
    AND e.reading_value < 0

  UNION ALL

  -- A6) Asset status mismatches latest STATUS_CHANGE event
  SELECT
    'STATUS_MISMATCH' AS anomaly_type,
    'CRITICAL' AS severity,
    a.meter_id,
    a.meter_type,
    a.region,
    a.status,
    a.install_date,
    a.removal_date,
    e.event_id,
    e.event_type,
    e.event_date,
    e.reading_value,
    e.new_status,
    'meter_asset + meter_event',
    'Asset status differs from STATUS_CHANGE event new_status'
  FROM meter_asset a
  JOIN meter_event e ON e.meter_id = a.meter_id
  WHERE e.event_type = 'STATUS_CHANGE'
    AND a.status <> e.new_status
)
SELECT
  anomaly_type,
  severity,
  meter_id,
  meter_type,
  region,
  status,
  install_date,
  removal_date,
  event_id,
  event_type,
  event_date,
  reading_value,
  new_status,
  source_table,
  rule_description
FROM base;
