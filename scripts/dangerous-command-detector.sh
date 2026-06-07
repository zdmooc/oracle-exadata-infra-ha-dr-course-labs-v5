#!/usr/bin/env bash
set -uo pipefail
patterns='(^|[[:space:];|`])(rm[[:space:]]+-rf|drop[[:space:]]+database|drop[[:space:]]+disk|alter[[:space:]]+system|shutdown[[:space:]]+(immediate|abort|normal)|reboot|poweroff|srvctl[[:space:]]+stop|crsctl[[:space:]]+stop|ifconfig[[:space:]].*[[:space:]]down|ip[[:space:]]+link[[:space:]]+set[[:space:]].*[[:space:]]down)'
find modules labs templates docs scripts -type f ! -path 'scripts/dangerous-command-detector.sh' -print0 | xargs -0 grep -RInE "$patterns" 2>/dev/null || true
