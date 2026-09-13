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

Prereq: `npx wrangler login` (OAuth, pythonmalone@gmail.com). `./deploy.sh` in `~/Projects/portfolio` deploys the three workers (hub/portfolio/dash) and then runs `verify-live.sh`, which fetches the live portfolio and asserts the current claims are present and the stale ones are gone. A failed smoke test exits non-zero, so a wrong-but-deployed state is visible immediately instead of silent. Run the smoke test alone with `./verify-live.sh`. Drops deploys itself via Pages git integration on push.

## Preview (workers.dev) URLs

`workers_dev = true` (deliberately kept, it buys preview URLs). These are public, unlisted duplicates of the production sites. Do not share them; if they ever need to disappear, set `workers_dev = false` in the worker's `wrangler.toml` and redeploy.

| Preview URL | Mirrors |
|---|---|
| `hector-landing.pythonmalone.workers.dev` | `hector.app` |
| `hector-portfolio.pythonmalone.workers.dev` | `portfolio.hector.app` |
| `hector-dash.pythonmalone.workers.dev` | `dash.hector.app` |

## Notes / gotchas (all learned the hard way)

- Workers custom domains REQUIRE the zone inside the CF account (dashboard 10000 / token 10405 / wrangler 10082 = same cause; full playbook in skill `cf-workers-custom-domain-external-zone`).
- After zone moves, CF auto-imports registrar records → delete conflicting apex A / www CNAME (100117) before attaching custom domains.
- pym.one retired (2026-09-09): worker + CF zone + domain removed.
- GitHub: 6 public repos under HectorHache, all MIT, default branch `main`, pushes via `git@github.com-hectorhache` SSH alias (`~/.ssh/id_ed25519_hectorhache`).
- Email at hector.app: MX fwd1/fwd2.porkbun.com + SPF + DMARC(p=none) — Porkbun forwarders hello/hey/hola/admin → personal inboxes.
- Workers static assets default to `html_handling = "auto-trailing-slash"`: `/foo.html` 307s to `/foo` (the canonical form). Reference the extensionless path directly, and never bolt `?v=N` onto a `.html` URL for cache busting — the redirect drops the query, so it does nothing.
- Assets ship `cache-control: public, max-age=0, must-revalidate`. That is correct here, not an oversight: filenames carry no content hash, so long-lived caching would serve stale pages after a deploy. Workers assets also have no `_headers` file mechanism (that is a Pages feature). Real long caching would need content-hashed filenames from a build step.
- `site/.assetsignore` (and `dash-landing/.assetsignore`) exist so junk like `.DS_Store` can never ship. Wrangler's "Read N files" count includes the asset directories themselves, so it reads one higher than the actual file count.
- Token files (`~/.cfhh`) are credentials — never committed, never printed.
