# Project — Asset Lifecycle Monitoring & Anomaly Escalation

## Overview

This project implements a **rule-based asset lifecycle monitoring and anomaly escalation workflow** using SQL and Excel.  
It simulates how a **Data Operations Analyst** detects, validates, and escalates **high-risk data integrity issues** in meter asset data under operational time constraints.

The output is an **escalation-ready anomalies pack** containing:
- Row-level evidence
- Severity classification
- Management-ready summaries
- Clear rule explanations

The workflow is fully **reproducible, auditable, and aligned with real operational data practices**.

---

## Business Context

In energy and asset-heavy environments, incorrect lifecycle data can result in:
- Incorrect billing
- Regulatory exposure
- Asset misreporting
- Poor operational decision-making

This project mirrors how such risks are proactively managed by Data Operations teams through **SQL-based validation rules** and **structured escalation artefacts**.

---

## What This Project Demonstrates

- Lifecycle integrity validation using SQL  
- Temporal consistency checks across assets and events  
- Evidence-based anomaly escalation  
- Clear separation of detection logic and reporting outputs  
- High-quality Excel delivery for internal and external stakeholders  

---

## Technology Stack

- SQLite (DB Browser for SQLite)  
- SQL  
- Microsoft Excel  

No external APIs, drivers, or licensed connectors are required.

---

## Data Sources

### Tables

- `meter_asset`  
  Asset lifecycle data (install date, removal date, status, region, meter type)

- `meter_event`  
  Asset events (readings, status changes, timestamps, source systems)

---

## Lifecycle Anomaly Rules Implemented

1. Asset marked **REMOVED** but `removal_date` is NULL  
2. `removal_date` occurs before `install_date`  
3. Event occurs before asset installation  
4. Event occurs after asset removal  
5. Negative readings for `READING` events  
6. Asset status differs from `STATUS_CHANGE.new_status`  

Each rule produces **row-level evidence**, not just aggregated counts.

---

## Repository Structure

```text
Project-Asset-Lifecycle-Monitoring/
│
├── database/
│   └── asset_ops.db
│
├── sql/
│   └── 01_lifecycle_anomalies.sql
│
├── outputs/
│   ├── csv/
│   │   └── lifecycle_anomalies.csv
│   └── excel/
│       └── lifecycle_anomalies_escalation_pack.xlsx
│
├── report/
│   └── asset_lifecycle_monitoring_report.md
│
├── diagrams/
│   └── data_flow.png
│
├── screenshots/
│   └── excel/
│   │   ├── 01_anomalies_sheet.png
│   │   ├── 02_summary_pivots.png
│   │   └── 03_conditional_formatting.png
│   └── db_browser
│       ├── 01_tables_loaded.png
│       ├── 02_script_ran_successfully.png
│       ├── 03_view_exists.png
│       ├── 04_view_returns_rows.png
│       ├── 05_severity_counts.png
│       ├── 06_anomaly_counts.png
│          
└── README.md
