# Deploy guide — hector.app umbrella (Cloudflare Workers)

**Status: 2026-09-09 — SETTLED.** Everything lives under hector.app. One domain, one persona, one GitHub account.

## Live map

| Host | Serves | Backend | Repo |
|---|---|---|---|
| `hector.app` + `www` | Hub landing (7 pills) | Worker `hector-landing` | HectorHache/portfolio (`hector-landing/site`) |
| `portfolio.hector.app` | Portfolio | Worker `hector-portfolio` | HectorHache/portfolio (`site/`) |
| `dash.hector.app` | Dashboard landing | Worker `hector-dash` | HectorHache/portfolio (`dash-landing/`) |
| `drops.hector.app` | Drops watchdog | **Pages** project `hector-drops` (git auto-deploy) | HectorHache/drops-watchdog (`docs/`) |
| `chat.hector.app` | ChatUI (tailnet-only) | caddy-cloudflare root daemon → OWUI :8390 | HectorHache/chat-ui (code mirror) |

## Deploy

Prereq: `npx wrangler login` (OAuth, pythonmalone@gmail.com). `./deploy.sh` in `~/Projects/portfolio` deploys the three workers (hub/portfolio/dash). Drops deploys itself via Pages git integration on push. Workers.dev previews stay live (`workers_dev = true`).

## Notes / gotchas (all learned the hard way)

- Workers custom domains REQUIRE the zone inside the CF account (dashboard 10000 / token 10405 / wrangler 10082 = same cause; full playbook in skill `cf-workers-custom-domain-external-zone`).
- After zone moves, CF auto-imports registrar records → delete conflicting apex A / www CNAME (100117) before attaching custom domains.
- pym.one retired (2026-09-09): worker + CF zone + domain removed.
- GitHub: 6 public repos under HectorHache, all MIT, default branch `main`, pushes via `git@github.com-hectorhache` SSH alias (`~/.ssh/id_ed25519_hectorhache`).
- Email at hector.app: MX fwd1/fwd2.porkbun.com + SPF + DMARC(p=none) — Porkbun forwarders hello/hey/hola/admin → personal inboxes.
- Token files (`~/.cfhh`) are credentials — never committed, never printed.
