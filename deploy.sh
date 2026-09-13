#!/usr/bin/env bash
# Deterministic publish: hector.app umbrella (Cloudflare Workers).
# GATE: run ONLY after Mick's green light. Requires: npx wrangler login (OAuth) once.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "==> 1/4 hub (hector-landing/site/) -> hector-landing (hector.app + www)"
(cd "$ROOT/hector-landing" && npx wrangler deploy)

echo "==> 2/4 portfolio (site/) -> hector-portfolio (portfolio.hector.app)"
(cd "$ROOT" && npx wrangler deploy)

echo "==> 3/4 dash landing (dash-landing/) -> hector-dash (dash.hector.app)"
(cd "$ROOT/dash-landing" && npx wrangler deploy)

echo "==> 4/4 verify live (portfolio smoke test)"
"$ROOT/verify-live.sh"

echo "==> Done. Live: https://hector.app https://portfolio.hector.app https://dash.hector.app"
