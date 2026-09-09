# Opus-5 One-Shot Build Brief (2026-09-07 13:35, pool-warm window)

> Produced from the locked Starting Line (starting-line.md). Opus-5 (craft) builds the full static site in ONE pass. Gates verified after: mobile-first, LCP <2s, ego-browser verify, deterministic deploy to Cloudflare Pages on hache.app.

## 1. Mission
Recruiter-facing portfolio for Héctor Miguel (Hache/Mick), NL/EU-remote AI-engineering roles (ZZP/payroll, part-time 20-32h). Prove he is NOT a generic AI-course grad: 10+ yrs operations discipline (Erlang-C, 10,000-agent call centers, Klarna/Microsoft/5CA) + a real 24/7 self-running agent stack he built himself. Seed creator lane (internal only, never in copy).

## 2. Starting line (LOCKED — do not deviate)
- **One-liner hook (#2):** "I built systems that ran call centers for a decade. Now I build systems that run themselves."
- **Supporting line (#1):** "I spent a decade making 10,000-agent operations predictable. Now I build the agents."
- **Visual language: editorial-minimal.** Swiss type, generous whitespace, restraint. The ONE dramatic element = the live/interactive hero. No terminal-phosphor styling anywhere. No gradients-as-decor, no glassy cards, no playful tilt.
- **Hierarchy (hero → body):** agent-stack → drops → chat-hache → providers → setupclone → [new cards below].
- **Proof anchors:** drops.hache.app (live), RAM table (18→8 sessions / 6.7→4.8 GB), **interactive network topology diagram = the HERO** (asset file provided at /assets/topology.html — embed it, do not redraw).

## 3. Site structure (single static page, sections)
1. **Hero**: one-liner #2 (large, editorial), supporting #1 as small line, then the interactive topology diagram (full-width, contained), CTA-less (no "hire me" buttons — confidence is quiet).
2. **The stack strip**: 3 un-fakeable proof numbers (18→8 sessions, 6.7→4.8 GB RAM, 24/7 uptime) in restrained type. Live dashboard link.
3. **Projects** (cards, ordered): agent-stack, drops, chat-hache, providers, setupclone, **homelab (status REBUILDING — placeholder copy)**, **chat-demo (status COMING SOON — placeholder)**, **meta-portfolio ("This portfolio, built by its own system" — SHIPPING)**, karaoke, pvault, skills-library. Each card: status tag (SHIPPED/GROWING/SHIPPING/REBUILDING/COMING), one-line "what it proves", evidence line.
4. **About**: the pivot story in 3 short paragraphs (ops discipline → why agents → what the stack is). Include "systems thinker, pattern recognizer" only as subtle voice, no jargon walls.
5. **Method**: the debate → gate → build pipeline, with a Mermaid.js diagram (source provided below) — the meta-proof.
6. **Footer**: minimal, "Built by its own subject. Verified with browser automation."

## 4. Anti-patterns (killed in debate — do NOT resurrect)
- "Ask my stack: it never sleeps" · terminal/phosphor everywhere · glassy-SaaS template look · playful-cards · unverifiable numbers as lead hook · provider-count as lead signal · Erlang-C in the hook · static first scroll · "hire me" begging · AI-generated copy tells (unai: no "delve", no em-dash spam, no hollow superlatives) · long paragraphs (recruiter skim).

## 5. Content rules
- Public-safe ONLY: no keys, no internal paths, no PID, no household content beyond network topology. Chat·hector = blurred screenshots + counts-only. PVault = diagram only. Homelab card = media-automation engineering framing, zero piracy references. Providers card = honest (free pools dry up, channels hammer down, WAF walls — "gateway engineering with the scars").
- Every card carries an evidence line (link/screenshot/metric) — evidence rule.

## 6. Mermaid source (embed for Method section)
graph LR
  A[4-model debate<br/>Opus·Sol·Gemini·DeepSeek] --> B[Starting Line<br/>4 forks locked]
  B --> C[Mick's gate<br/>approval]
  C --> D[Opus-5 one-shot<br/>build]
  D --> E[ego-browser<br/>verification]
  E --> F[Cloudflare Pages<br/>hache.app]
  F --> G[rolling maintenance<br/>monthly ritual]
  G --> A

## 7. Technical gates
- Single static page (no build step) or minimal; pure HTML/CSS/JS; all assets inline or relative. Mobile-first (≤390px), LCP <2s on 4G, no external font/script blocking render (self-host or system fonts). Topology hero: embed /assets/topology.html via iframe or inline (file provided).
- Deterministic output: identical rebuild = identical bytes (no timestamps/randomness).
- Output files to: ~/Projects/portfolio/site/ (index.html + assets/). Keep it deployable to Cloudflare Pages root.

## 8. Deliverable
Complete site files + a 10-line summary of design decisions mapping to this brief. No chat loops; build, self-review against this brief, deliver.
