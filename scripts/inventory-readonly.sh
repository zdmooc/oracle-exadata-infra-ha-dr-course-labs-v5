#!/usr/bin/env bash
set -uo pipefail
out="inventory-readonly-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$out"
echo "[READ-ONLY] collecte inventaire" | tee "$out/README.txt"
(command -v imageinfo >/dev/null && imageinfo > "$out/imageinfo.txt" 2>&1) || true
(command -v crsctl >/dev/null && crsctl stat res -t > "$out/crsctl_stat_res_t.txt" 2>&1) || true
(command -v asmcmd >/dev/null && asmcmd lsdg > "$out/asmcmd_lsdg.txt" 2>&1) || true
