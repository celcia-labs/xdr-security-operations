# XDR Security Operations — Detection, Hunting & Automation

A hands-on security operations project built on the Microsoft XDR suite (Defender for Endpoint, Entra ID). Simulates real-world attacks, detects them with KQL hunting queries, and automates security workflows with Python — all mapped to MITRE ATT&CK.

## Architecture

```
Attack Simulation (brute force, malware, impossible travel)
                |
                v
Microsoft Defender for Endpoint (EDR) + Entra ID (Identity)
                |
                v
Defender Advanced Hunting — KQL Detection Queries
                |
                v
Python Automation (log parsing, API enrichment, triage, reporting)
                |
                v
Custom Detection Rule (automated alerting on logon spikes)
```

## What's Inside

| Component | Language | Purpose |
|-----------|----------|---------|
| Logon spike detection | KQL | Flags 5+ logons from one IP per hour — brute force indicator |
| Cloud app activity summary | KQL | Groups all logon activity by type and hour |
| User logon detail | KQL | Shows who logged in, from where, and which app |
| Log parser | Python | Parses auth logs, detects brute force, impossible travel, after-hours logins |
| VirusTotal enrichment | Python | Checks suspicious IPs against VirusTotal API for threat intelligence |
| Auto-triage + daily report | Python | Triages alerts by severity and generates a daily SOC operations report |

## MITRE ATT&CK Mapping

| Technique | Name | Detection Method |
|-----------|------|------------------|
| T1110.001 | Brute Force: Password Guessing | KQL logon spike query + Entra ID sign-in logs |
| T1204.002 | User Execution: Malicious File | Defender for Endpoint — EICAR test detection |
| T1059.001 | PowerShell Execution | Defender behavioral detection |
| T1078 | Valid Accounts (Impossible Travel) | Entra ID risk detection |
| T1071.001 | C2 Communication | Endpoint alert — outbound to suspicious domain |
| T1003.001 | Credential Dumping | Endpoint alert — Mimikatz signature |
| T1021.002 | SMB Lateral Movement | Endpoint alert — net.exe lateral movement |

## Attack Simulations Performed

- **Brute force login** — 10 failed password attempts against Entra ID test user, triggering smart lockout
- **EICAR test malware** — Industry-standard test file detected and quarantined by Defender for Endpoint
- **Impossible travel** — Sign-ins from two countries within minutes via VPN

## Technologies

KQL · Python · Microsoft Defender for Endpoint · Microsoft Entra ID · VirusTotal API · MITRE ATT&CK · Google Colab · Azure Cloud Shell

## How to Use

1. KQL queries: run in Microsoft Defender → Hunting → Advanced Hunting
2. Python scripts: open `Security_Operations_Automation.ipynb` in Google Colab
3. Sample data: realistic auth logs and endpoint alerts in `sample-data/`

## Author

Celciamerlyn Rajan — Security Operations & Automation | CompTIA Security+ Certified
