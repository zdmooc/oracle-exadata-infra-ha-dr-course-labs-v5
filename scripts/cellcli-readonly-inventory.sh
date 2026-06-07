#!/usr/bin/env bash
set -uo pipefail
out="cellcli-readonly-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$out"
echo "[READ-ONLY] CellCLI inventory"
for q in "list cell detail" "list physicaldisk detail" "list celldisk detail" "list griddisk attributes name,status,asmmodestatus,asmdeactivationoutcome" "list flashcache detail" "list alerthistory detail"; do echo "$q"; cellcli -e "$q" > "$out/${q// /_}.txt" 2>&1 || true; done
