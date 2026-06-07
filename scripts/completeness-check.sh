#!/usr/bin/env bash
set -uo pipefail
echo "Modules: $(find modules -maxdepth 1 -name "*.md" | wc -l)"
echo "Labs: $(find labs -maxdepth 1 -name "*.md" | wc -l)"
echo "Templates: $(find templates -maxdepth 1 -name "*.md" | wc -l)"
echo "Diagrams: $(find diagrams -maxdepth 1 -name "*.mmd" | wc -l)"
echo "Scripts: $(find scripts -maxdepth 1 -type f | wc -l)"
for i in $(seq -w 0 27); do ls modules/${i}-*.md >/dev/null || echo "MISSING module $i"; done
for i in $(seq -w 1 19); do ls labs/${i}-*.md >/dev/null || echo "MISSING lab $i"; done
