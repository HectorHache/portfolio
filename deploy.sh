#!/usr/bin/env bash
# Deterministic publish: hector.app umbrella (Cloudflare Workers).
# GATE: run ONLY after Mick's green light. Requires: npx wrangler login (OAuth) once.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "==> 1/3 hub (hector-landing/site/) -> hector-landing (hector.app + www)"
(cd "$ROOT/hector-landing" && npx wrangler deploy)

echo "==> 2/3 portfolio (site/) -> hector-portfolio (portfolio.hector.app)"
(cd "$ROOT" && npx wrangler deploy)

echo "==> 3/3 dash landing (dash-landing/) -> hector-dash (dash.hector.app)"
(cd "$ROOT/dash-landing" && npx wrangler deploy)

echo "==> Done. Verify: https://hector.app https://portfolio.hector.app https://dash.hector.app"
