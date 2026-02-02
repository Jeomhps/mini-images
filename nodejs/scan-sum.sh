#!/bin/bash
set -e

IMAGES=(
  "node-alpine"
  "node-chainguard"
  "node-dhi"
  "node-google"
)

for img in "${IMAGES[@]}"; do
  echo "Scanning image: $img"

  json=$(trivy image --format json --quiet "$img" 2>/dev/null)

  summary=$(echo "$json" | jq '
    .Results
    | map(
        if .Vulnerabilities == null then {} 
        else .Vulnerabilities 
        | group_by(.Severity) 
        | map({(.[0].Severity): length}) 
        | add 
        end
      )
    | add
    | {CRITICAL: (.CRITICAL // 0), HIGH: (.HIGH // 0), MEDIUM: (.MEDIUM // 0), TOTAL: ((.CRITICAL // 0) + (.HIGH // 0) + (.MEDIUM // 0))}
  ')

  echo "$img : $summary"
  echo
done
