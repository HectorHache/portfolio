#!/usr/bin/env bash
# verify-live.sh — post-deploy smoke test for the portfolio worker.
#
# Proves the live site serves the CURRENT build, not a cached older one:
# asserts strings that must be present and strings that must be gone.
# Exits non-zero on any mismatch, so `deploy.sh` fails loudly instead of
# leaving a stale page live.
#
# Usage:  ./verify-live.sh [base-url]
# Default base: https://portfolio.hector.app

set -euo pipefail

BASE="${1:-https://portfolio.hector.app}"
fail=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

fetch() { # fetch <url> <outfile> -> prints nothing, returns nonzero on HTTP error
  curl -fsSL --max-time 15 "$1" -o "$2"
}

check() { # check <file> <must|must-not> <literal string> <label>
  local file="$1" mode="$2" needle="$3" label="$4"
  if [ "$mode" = "must" ]; then
    if grep -qF -- "$needle" "$file"; then
      printf 'ok    [%s] present: %s\n' "$label" "$needle"
    else
      printf 'FAIL  [%s] MISSING: %s\n' "$label" "$needle"; fail=1
    fi
  else
    if grep -qF -- "$needle" "$file"; then
      printf 'FAIL  [%s] STALE STRING STILL LIVE: %s\n' "$label" "$needle"; fail=1
    else
      printf 'ok    [%s] absent: %s\n' "$label" "$needle"
    fi
  fi
}

echo "== live smoke test: $BASE =="

if ! fetch "$BASE/" "$tmp/index.html"; then
  echo "FAIL  could not fetch $BASE/"; exit 1
fi
# Extensionless path on purpose: the canonical URL (assets/topology.html 307s here).
if ! fetch "$BASE/assets/topology" "$tmp/topology.html"; then
  echo "FAIL  could not fetch $BASE/assets/topology"; exit 1
fi

check "$tmp/index.html"    must      "I built systems that ran call centers"          "index/hook"
check "$tmp/index.html"    must      "26 provider accounts across 14 services"        "index/claims"
check "$tmp/index.html"    must      "181 distinct models"                            "index/claims"
check "$tmp/index.html"    must      "assets/topology\""                              "index/topology-ref"
check "$tmp/index.html"    must-not  "22 LLM providers"                               "index/stale"
check "$tmp/index.html"    must-not  "380 models"                                     "index/stale"
check "$tmp/index.html"    must-not  "topology.html?v="                               "index/dead-cachebuster"
check "$tmp/topology.html" must      "26 provider accounts across 14 services"        "topology/claims"
check "$tmp/topology.html" must      "181 distinct models"                            "topology/claims"
check "$tmp/topology.html" must-not  "behind the bridge"                              "topology/stale"

echo
if [ "$fail" -ne 0 ]; then
  echo "SMOKE TEST FAILED — the deploy is live but WRONG. Check the strings above."
  exit 1
fi
echo "SMOKE TEST PASSED"
