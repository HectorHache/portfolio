# Deploy guide: portfolio + dash landing (Cloudflare Pages)

**Status: prepared 2026-09-08. NOT executed. Gate: Mick's green light after final review.**

## What gets published where
| Artifact | Source dir | CF Pages project | Custom domains |
|---|---|---|---|
| Portfolio | `site/` | `portfolio-hache` | `hache.app` (apex) + `portfolio.pym.one` |
| Dash landing | `dash-landing/` | `dash-hache` | `dash.hache.app` |

Site is fully static + deterministic (single file, no build step). `deploy.sh` = `npx wrangler pages deploy <dir> --project-name=<name>` (wrangler not installed yet; npx pulls it on first run, or `bunx wrangler`).

## Step 1: Cloudflare Pages projects
1. Log into Cloudflare → Workers & Pages → Create → Pages → "Upload assets" (direct upload is fine; no git needed).
2. Project `portfolio-hache`: upload `site/`. Project `dash-hache`: upload `dash-landing/`.
3. Note the `*.pages.dev` URLs each project gets.

## Step 2: Custom domains (per project in the CF dashboard → Custom domains → Add)
Cloudflare will show the exact DNS records it wants (usually a CNAME + a TXT verification). Add them in the zone's registrar (Porkbun unless noted).

### portfolio.pym.one → `portfolio-hache`
- Porkbun (pym.one zone): add **CNAME** `portfolio` → `<portfolio-hache>.pages.dev` (TTL 600).
- Add the **TXT** `_cf-custom-hostname.portfolio` → value CF shows (verifies ownership).
- **Remove** the existing public **A record** `portfolio.pym.one → 100.123.82.89` (currently leaks the tailnet IP publicly; verified 2026-09-08 via 1.1.1.1).
- **NextDNS**: delete the Rewrite `portfolio.pym.one → 100.123.82.89` (tailnet-only alias; no longer needed once CF serves it).

### hache.app (apex) → `portfolio-hache`
- Porkbun (hache.app zone): apex cannot use CNAME → use the **A/AAAA records** CF shows in the custom-domain flow, or a Porkbun **ALIAS** `hache.app → <portfolio-hache>.pages.dev` if CF presents it.
- Add the **TXT** verification CF shows (`_cf-custom-hostname` or `hache.app` TXT).
- Existing subdomains are untouched: `chat.hache.app` (tailnet via NextDNS rewrite + root Caddy), `drops.hache.app` (already CF Pages), `dash.hache.app` (below).

### dash.hache.app → `dash-hache`
- Porkbun: add **CNAME** `dash` → `<dash-hache>.pages.dev` + the **TXT** verification CF shows.
- NextDNS: **no** rewrite for dash.hache.app (must resolve publicly).

## Step 3: Verify before take-down
- `curl -sI https://portfolio.pym.one` → 200 from pages.dev edge.
- `curl -sI https://hache.app` → 200.
- `curl -sI https://dash.hache.app` → 200.
- Check og:image loads: `curl -sI https://hache.app/assets/og-card.png` → 200 image/png (1200x630).

## Step 4: Take-down (only after green light + verify)
1. Kill the review server: `kill <pid of serve.py>` (bound 100.123.82.89:8777).
2. Remove the public A record + NextDNS rewrite for portfolio.pym.one (above).
3. Confirm `serve.py` removal note in PLAN.md; archive this guide in git history.

## Notes / gotchas
- No redirect between drops.hache.app and dash.hache.app (Mick's explicit decision: each keeps its own artifact).
- `og:url`/canonical in the site point to `https://hache.app/`; hector.app stays the LinkedIn/contact redirect (Porkbun URL forwarding, verified working 2026-09-08: 301 → linkedin.com/in/hectormm, www now added).
- Determinism: site is a single static file; re-deploys are byte-stable unless content changes. No `_headers`/`_redirects` needed.
