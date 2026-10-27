# Playbook: Automated Security Operations Pipeline

## Overview
This playbook automates the end-to-end SOC workflow: log parsing, threat intelligence enrichment, alert triage, and reporting.

## Trigger
Manual execution via Google Colab. In production, this logic would be integrated into a SOAR platform (Cortex XSOAR, Tines, or Splunk SOAR) and triggered automatically on new incidents.

## Steps

### Step 1: Parse Authentication Logs
- **Input:** `sample-data/auth_logs.json`
- **Logic:** Count failed logins per source IP. Flag IPs with 5+ failures as brute force (MITRE T1110.001). Detect impossible travel by checking for the `impossible_travel` reason code. Flag after-hours logins (before 8am or after 6pm).
- **Output:** List of brute force IPs, impossible travel events, after-hours logins

### Step 2: Enrich Suspicious IPs
- **API:** VirusTotal API v3 (`GET /api/v3/ip_addresses/{ip}`)
- **Authentication:** API key passed in `x-apikey` header
- **Rate Limiting:** 15-second delay between requests (free tier: 4 requests/min)
- **Risk Scoring:** >5 malicious detections = HIGH, >0 = MEDIUM, 0 = LOW
- **Error Handling:** Try/except wraps all API calls; graceful fallback on timeout or rate limit

### Step 3: Auto-Triage Endpoint Alerts
- **Input:** `sample-data/endpoint_alerts.json`
- **Decision Logic:**
  - Critical severity → ESCALATE (P1 ticket, page on-call, 15-min SLA)
  - High severity → ESCALATE (P2 ticket, assign analyst, 1-hour SLA)
  - Medium severity → INVESTIGATE (triage queue, 4-hour SLA)
  - Low/Info → LOG (weekly review, next business day)
- **Output:** Action and SLA per alert

### Step 4: Generate Daily SOC Report
- **Output:** Combined report with auth stats, alert counts by severity, enrichment results, triage actions, and MITRE techniques observed
- **Format:** Printed summary + JSON file

## APIs Used
- VirusTotal API v3 (IP reputation lookup)

## MITRE ATT&CK Coverage
- T1110.001 — Brute Force: Password Guessing
- T1204.002 — User Execution: Malicious File
- T1059.001 — Command and Scripting Interpreter: PowerShell
- T1078 — Valid Accounts (Impossible Travel)
- T1071.001 — Application Layer Protocol (C2)
- T1003.001 — OS Credential Dumping
- T1021.002 — SMB/Windows Admin Shares (Lateral Movement)

## Error Handling
- Missing API key: script continues with placeholder enrichment
- API errors: caught by try/except, logged, does not halt pipeline
- Missing files: returns empty list, does not crash
