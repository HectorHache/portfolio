# Deploy guide — portfolio + pym.one launcher (Cloudflare Workers)

**Status: 2026-09-08 — LIVE.** The `pym.one` zone is on Cloudflare (NS etta/bruce.ns.cloudflare.com, account: Pythonmalone@gmail.com's Account). Three custom domains registered account-wide. Everything below supersedes the old Pages-era DEPLOY.md.

## What is live / where

| Host | Serves | CF Worker / Project | Source dir |
|---|---|---|---|
| `portfolio.pym.one` | Portfolio (v9+) | `portfolio-hache` (Worker) | `~/Projects/portfolio/site` |
| `pym.one` + `www.pym.one` | Launcher landing | `pym-home` (Worker) | `~/Projects/portfolio/pym-home/site` |
| `drops.hache.app` | Drops watchdog | Pages project `drops-watchdog` (zone-less custom domain, SAME account) | `~/Documents/Workspaces/drops` |

## Deploy (deterministic, byte-stable)

Prereq: `npx wrangler login` once (browser OAuth — carries full account perms; API tokens hit the 10405 wall on Workers custom domains).

```bash
cd ~/Projects/portfolio          && npx wrangler deploy   # portfolio-hache
cd ~/Projects/portfolio/pym-home && npx wrangler deploy   # pym-home
```

Or `./deploy.sh` for both. Each project has its own `wrangler.toml`: name, compatibility_date, `workers_dev = true` (**REQUIRED** — omitting it disables the workers.dev URL on deploy), `assets.directory`, and `routes` with `custom_domain = true`. Re-deploys are idempotent; unchanged assets upload nothing.

## Custom domains on Workers — the rules (learned the hard way, 2026-09-08)

- Workers custom domains **require the hostname's zone inside the CF account**. All three symptom paths mean exactly that, no auth/settings fix exists:
  - Dashboard add → code 10000 "Unable to check" (silent revert, "does nothing")
  - API token `POST /accounts/{id}/workers/domains` → 10405
  - wrangler deploy → 10082 "Can't infer zone from route"
  - Fix: move the zone's nameservers to CF, then attach via wrangler OAuth `custom_domain` route.
- After the NS move, CF auto-imports old registrar records → attach fails with 100117 until you delete the conflicting apex A / www CNAME (keep subdomain CNAMEs that point at your workers.dev; MX/TXT harmless).
- Full playbook: managed skill `cf-workers-custom-domain-external-zone` — also covers the macOS mDNSResponder stale-negative-cache trap (curl "Could not resolve host" while dig works → `sudo killall -HUP mDNSResponder && dscacheutil -flushcache`).

## DNS / zone state

| Domain | Nameservers | Notes |
|---|---|---|
| `pym.one` | Cloudflare (active) | apex → launcher; `portfolio.pym.one` → portfolio |
| `hache.app` | Porkbun | `drops.hache.app` CNAME → `drops-watchdog.pages.dev` (zone-less Pages custom domain); NO public records for chat/dash/www/apex |
| `chat.hache.app` | none public | tailnet-only via NextDNS rewrite → `100.123.82.89` (Mac tailnet IP); TLS LE cert `CN=chat.hache.app`; uvicorn terminator |

## ChatUI stack map (tailnet-only)

- `open-webui serve` (uvicorn, 127.0.0.1:8390, launchd `org.hache.chat.openwebui`)
- bridge `server.mjs` (node, :8484), whisper_worker.py (:8499), watchdog (300s probes)
- 443 terminator = uvicorn + LE cert for chat.hache.app (owner process to pin during migration; caddy user agent retired 2026-09-04, root daemon plist exists but no caddy process runs)

## Roadmap — persona consolidation (Mick-driven, in progress)

- `hector.app` → stays the LinkedIn redirect ONLY (Porkbun URL forwarding, verified 301).
- `hache.app` → **retire**. Move everything under `pym.one`:
  - drops: `drops.hache.app` → `drops.pym.one` (Pages custom-domain swap; same account → safe)
  - dash: attach `dash-hache` worker to `dash.pym.one` (worker already exists, no custom domain yet)
  - chat: `chat.hache.app` → `chat.pym.one` (NextDNS rewrite + LE cert reissue + terminator swap)
  - then delete hache.app records at Porkbun
- Text: remove "/ Hache" persona refs (landing done 2026-09-08; portfolio copy sweep pending)
- Projects: consolidate under one tidy path — dry-run inventory done 2026-09-08 (Mick picks what/how/when; **no moves yet**)

## Housekeeping log (2026-09-08)

- Killed orphaned review server `serve.py` (was 100.123.82.89:8777) ✓
- Old portfolio A record + NextDNS rewrite: already gone ✓
- `.cftemp` API token: file deleted locally; **revoke in CF dashboard** (self-revoke returns 403 — needs User.Tokens Write)
