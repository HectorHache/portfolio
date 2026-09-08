# Deploy guide: portfolio + dash landing (Cloudflare Pages)

**Status: prepared 2026-09-08. NOT executed. Gate: Mick's green light after final review.**

## What gets published where
| Artifact | Source dir | CF Pages project | Custom domains |
|---|---|---|---|
| Portfolio | `site/` | `portfolio-hache` | `hache.app` (apex) + `portfolio.pym.one` |
| Dash landing | `dash-landing/` | `dash-hache` | `dash.hache.app` |

Site is fully static + deterministic (single file, no build step). `deploy.sh` = `npx wrangler pages deploy <dir> --project-name=<name>` (wrangler not installed yet; npx pulls it on first run, or `bunx wrangler`).

---

## Step 1: Cloudflare Pages projects (in the browser, ~5 min)

1. cloudflare.com → log in → left menu **Workers & Pages** → **Create** → **Pages** tab → **Upload assets** (direct upload, no git needed).
2. **Project `portfolio-hache`**: name it exactly, then upload the **`site/` folder** (contains index.html + assets/). Deploy.
3. **Project `dash-hache`**: same flow, upload the **`dash-landing/` folder**.
4. Note each project's `*.pages.dev` URL (shown on the project page after deploy), e.g. `portfolio-hache.pages.dev`.

Alternative (CLI): `npx wrangler login` once in a terminal, then `./deploy.sh`.

## Step 2: Custom domains (per project → **Custom domains** → **Add custom domain**)

Cloudflare shows the exact DNS records it wants **after you type the domain**. It needs the pages.dev project to be live first (cert issuance). Add each record in the registrar's DNS panel, then click **Activate** once CF reports the record verified.

### portfolio.pym.one → project `portfolio-hache`
1. CF: add custom domain `portfolio.pym.one` → it shows (a) a **CNAME** and (b) a **TXT** `_cf-custom-hostname.portfolio` with a verification value.
2. **pym.one DNS panel** (the registrar that hosts pym.one; likely Porkbun, same account as hector.app):
   - Add **CNAME**: Host `portfolio` → Answer `<portfolio-hache>.pages.dev` → TTL 600.
   - Add **TXT**: Host `_cf-custom-hostname.portfolio` → Answer = the value CF showed.
3. Back in CF → Activate. Cert issue + activation takes seconds to minutes.
4. **Delete the OLD public A record**: in the same pym.one panel, delete the A record with Host `portfolio` (or `portfolio.pym.one`) pointing to `100.123.82.89`. (Verified 2026-09-08 via `dig @1.1.1.1` — it exists and publicly leaks the tailnet IP.) Keeping it would split traffic between the old tailnet IP and Cloudflare.
5. **Remove the NextDNS Rewrite** (see "NextDNS cleanup" below). This one is critical: the rewrite shadows public DNS for all tailnet devices, so without removing it your laptop/phone would keep hitting the (now-dead) tailnet server instead of Cloudflare.

### hache.app apex → project `portfolio-hache`
1. CF: add custom domain `hache.app` → for an apex on a non-CF zone CF shows **A/AAAA records** (or offers ALIAS guidance).
2. **hache.app DNS panel** (Porkbun): add those A/AAAA records for Host `hache.app` (or a Porkbun **ALIAS** `hache.app` → `<portfolio-hache>.pages.dev` if CF presents it) + the TXT verification CF shows.
3. Existing subdomains are untouched: `chat.hache.app` (tailnet, NextDNS rewrite + root Caddy), `drops.hache.app` (already CF Pages), `dash.hache.app` (below).

### dash.hache.app → project `dash-hache`
1. CF: add custom domain `dash.hache.app` → CNAME + TXT shown.
2. Porkbun: **CNAME** Host `dash` → `<dash-hache>.pages.dev` + the TXT.
3. NextDNS: **no rewrite exists or should exist** for dash.hache.app — it must resolve publicly.

## NextDNS cleanup (the rewrite to drop)
- Dashboard: nextdns.io → **Setup** → the profile used by the tailnet (the one whose endpoint is configured in Tailscale Admin DNS, or per-device) → **Rewrites** tab.
- Find the row `portfolio.pym.one` → **delete** it. (It currently maps `portfolio.pym.one` → `100.123.82.89`, the Mac's tailnet IP, so only tailnet devices could resolve it during review.)
- Why: after publish, public DNS must answer for portfolio.pym.one (CNAME → pages.dev). If the NextDNS rewrite survives, every tailnet device would resolve it to the dead tailnet IP instead of Cloudflare = "works on phone LTE, broken on laptop" split-brain. Deleting it makes tailnet devices fall back to public DNS, which now points at Cloudflare.
- Verify after deletion: `dig @100.100.100.100 portfolio.pym.one` (tailnet DNS) should show the pages.dev CNAME chain, NOT `100.123.82.89`.
- The Tailscale Admin DNS **nameserver entry** for NextDNS stays; only the Rewrite row goes.

## Step 3: Verify before take-down
```bash
curl -sI https://portfolio.pym.one            # expect 200 from pages.dev edge
curl -sI https://hache.app                    # expect 200
curl -sI https://dash.hache.app               # expect 200
curl -sI https://hache.app/assets/og-card.png # expect 200 image/png (1200x630)
dig @100.100.100.100 portfolio.pym.one        # must NOT show 100.123.82.89
```

## Step 4: Take-down (only after green light + verify)
1. Kill the review server: `kill $(pgrep -f 'serve.py')` (bound 100.123.82.89:8777).
2. Porkbun: confirm the old portfolio A record is gone (Step 2.4).
3. NextDNS: confirm the rewrite is gone (Step "NextDNS cleanup").
4. Optional: uninstall nothing else; the serve.py file stays for local-only serving.

## Troubleshooting the review server (learned 2026-09-08)
- Symptom "can't reach portfolio.pym.one:8777 from any device": the server process had **died** (no crash logs; check first before blaming DNS/firewall).
- Diagnose: `ps aux | grep serve.py`, `lsof -nP -iTCP:8777 -sTCP:LISTEN`, `curl -s -o /dev/null -w '%{http_code}' http://100.123.82.89:8777/`.
- Restart: `cd ~/Projects/portfolio && nohup python3 serve.py > /tmp/portfolio_server.out 2>&1 &` (restored 2026-09-08, PID verified).
- Optional hardening before publish: a tiny launchd KeepAlive agent so it survives reboots (proposed, not installed — Mick decides).

## Notes / gotchas
- No redirect between drops.hache.app and dash.hache.app (Mick's explicit decision: each keeps its own artifact).
- `og:url`/canonical in the site point to `https://hache.app/`; hector.app stays the LinkedIn/contact redirect (Porkbun URL forwarding, verified working 2026-09-08: 301 → linkedin.com/in/hectormm, www added).
- og-card.png was rasterized with a fallback pipeline (qlmanage + pngtool); re-render cleanly before publish if desired (source: site/assets/og-card.svg).
- Determinism: site is a single static file; re-deploys are byte-stable unless content changes. No `_headers`/`_redirects` needed.
