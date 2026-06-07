#!/usr/bin/env bash
set -uo pipefail
out="monitoring-readonly-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$out"
for cmd in "crsctl stat res -t" "tfactl print status" "emctl status agent"; do echo "[READ-ONLY] $cmd"; bash -lc "$cmd" > "$out/${cmd// /_}.txt" 2>&1 || true; done
(command -v cellcli >/dev/null && cellcli -e "list alerthistory detail" > "$out/cell_alerthistory.txt" 2>&1) || true
