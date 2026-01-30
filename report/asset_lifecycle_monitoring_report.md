# Asset Lifecycle Monitoring & Anomaly Escalation

## 1. Objective

The objective of this project is to simulate **continuous lifecycle monitoring** of meter assets and identify data integrity issues that pose operational, billing, or regulatory risk.

The project focuses on **detecting anomalies, validating findings, and delivering escalation-ready outputs** rather than performing data remediation.

---

## 2. Data Assets

### Source Tables

- **meter_asset**  
  Contains asset lifecycle attributes including installation date, removal date, operational status, region, and meter type.

- **meter_event**  
  Contains event-level records such as meter readings, status change events, timestamps, and source systems.

Database used: `asset_ops.db`

---

## 3. Monitoring Logic

Lifecycle integrity rules were implemented using SQL to detect the following anomalies:

1. **REMOVED_WITHOUT_DATE**  
   Asset status is REMOVED but no removal date is recorded.

2. **REMOVAL_BEFORE_INSTALL**  
   Removal date occurs earlier than installation date.

3. **EVENT_BEFORE_INSTALL**  
   Events recorded before the asset installation date.

4. **EVENT_AFTER_REMOVAL**  
   Events recorded after the asset has been removed.

5. **NEGATIVE_READING**  
   Negative values recorded for READING events.

6. **STATUS_MISMATCH**  
   Asset status differs from the corresponding STATUS_CHANGE event.

Each rule generates **row-level evidence**, ensuring traceability.

---

## 4. Severity Classification

Anomalies were classified into severity levels to support prioritisation:

- **CRITICAL** — high operational or regulatory risk  
- **HIGH** — data quality issues likely to distort reporting or billing  
- **MEDIUM** — inconsistencies requiring review but not immediate escalation  

Severity was embedded directly in the SQL logic to ensure consistency.

---

## 5. Outputs Delivered

The following artefacts were produced:

- `outputs/csv/lifecycle_anomalies.csv`  
  Immutable evidence extract containing all detected anomalies.

- `outputs/excel/lifecycle_anomalies_escalation_pack.xlsx`  
  Escalation-ready Excel pack containing:
  - Full anomaly detail
  - Severity-based conditional formatting
  - Summary PivotTables for management review

- `diagrams/data_flow.png`  
  Logical representation of data flow and escalation process.

---

## 6. Validation Performed

- Summary counts reconcile exactly with row-level anomaly records  
- No anomalies are excluded or manually adjusted  
- Rule definitions are explicitly documented  
- SQL logic is deterministic and reproducible  

---

## 7. Assumptions

- Lifecycle rules accurately define invalid data conditions  
- Asset and event timestamps are reliable  
- STATUS_CHANGE events are authoritative for status transitions  

---

## 8. Limitations

- Detection is rule-based and does not identify unknown anomaly patterns  
- No automated remediation or correction workflow is included  
- Designed for monitoring and escalation, not root-cause fixing  

---

## 9. Conclusion

This project demonstrates a **robust, auditable lifecycle monitoring process** aligned with real Data Operations responsibilities.

It shows the ability to:
- Detect high-risk data integrity issues
- Validate findings rigorously
- Communicate issues clearly through structured escalation artefacts
- Operate under operational constraints with accuracy and accountability
