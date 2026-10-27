#!/bin/bash
# Environment Security Check Script
# Run in Azure Cloud Shell or any Linux/macOS terminal
# Checks system health and security posture

echo "========================================"
echo "  Security Operations - Environment Check"
echo "  $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "========================================"
echo ""

# System info
echo "[+] System Information"
echo "    Hostname : $(hostname)"
echo "    OS       : $(uname -s) $(uname -r)"
echo "    User     : $(whoami)"
echo ""

# Network check
echo "[+] Network Connectivity"
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "    Internet : CONNECTED"
else
    echo "    Internet : DISCONNECTED - check firewall rules"
fi
echo ""

# Check for security tools
echo "[+] Security Tools Installed"
for tool in python3 pip3 curl jq nmap; do
    if command -v $tool > /dev/null 2>&1; then
        echo "    $tool : FOUND ($(command -v $tool))"
    else
        echo "    $tool : NOT FOUND"
    fi
done
echo ""

# Python packages check
echo "[+] Python Security Packages"
for pkg in requests json csv datetime; do
    python3 -c "import $pkg" 2>/dev/null && echo "    $pkg : installed" || echo "    $pkg : missing"
done
echo ""

# Disk usage
echo "[+] Disk Usage"
df -h / 2>/dev/null | tail -1 | awk '{print "    Used: "$3" / "$2" ("$5" full)"}'
echo ""

# Recent login attempts (if available)
echo "[+] Recent Login Activity"
if command -v last > /dev/null 2>&1; then
    last -5 2>/dev/null || echo "    (not available in this environment)"
else
    echo "    (last command not available)"
fi
echo ""

echo "========================================"
echo "  Environment check complete"
echo "========================================"
