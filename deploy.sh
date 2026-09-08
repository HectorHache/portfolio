#!/usr/bin/env bash
# Portfolio + dash landing: deterministic publish to Cloudflare Pages.
# GATE: run ONLY after Mick's final green light (site + DNS + take-down all approved).
set -euo pipefail

echo "==> 1/2 portfolio (site/) -> project 'portfolio-hache'"
npx wrangler pages deploy site --project-name=portfolio-hache --branch=main

echo "==> 2/2 dash landing (dash-landing/) -> project 'dash-hache'"
npx wrangler pages deploy dash-landing --project-name=dash-hache --branch=main

echo "==> Done. Custom domains attach in the CF dashboard:
  hache.app (apex) + portfolio.pym.one  -> project portfolio-hache
  dash.hache.app                        -> project dash-hache
Then run take-down: kill :8777 server, remove portfolio.pym.one public A record
+pym.one NextDNS rewrite, remove tailnet bind. See DEPLOY.md."
