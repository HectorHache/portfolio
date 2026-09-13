# Starting Line — Portfolio Direction (debate output, 2026-09-07)

> Produced by the 4-voice debate: Craft (claude-opus-4-8), Market (gpt-5.6-sol), Ecosystem (gemini-3.8-flash), Contrarian (deepseek-v4-flash).
> R1 independent takes → R2 cross-examination → split judgment (Opus rules F2+F4, Sol rules F1+F3).
> This document becomes the Opus-5 one-shot build brief AFTER Mick's approval gate (open decisions at the bottom).

---

## 1. POSITIONING — the one-liner (Sol's ruling, Fork 1)

**WINNER (#2):** *"I built systems that ran call centers for over 10 years. Now I build systems that run themselves."* (revised 2026-09-07 by human gate: "a decade" → "over 10 years" — matches CV figures)

**Runner-up (#1):** *"I made +10.000-agent operations predictable. Today I build the agents."* (revised 2026-09-07 by human gate: +10k scale promoted to lead, EU dot thousands separator; compound-adjective 's' flipped per Mick's approval)

**Rationale:** cleanest rhythm, clearest pivot, no unverified number to decode in a 60-second skim. The parallel ("systems that ran / systems that run") is the whole story in one breath. The live agent-stack evidence immediately clarifies "run themselves" means agentic systems, not generic automation.
**Use #1 as the supporting line / proof-point** on the hero or about section — it carries the explicit "agents" word and the 10.000-agent scale signal that Market and Ecosystem championed.

## 2. VISUAL LANGUAGE (Opus's ruling, Fork 2)

**WINNER: (b) editorial-minimal** — Swiss type, whitespace, restraint; **the live dashboard is the only thing that moves** so its drama is earned.

**Runner-up:** (a) terminal-dramatic.

**Key argument (Craft's synthesis, adopted by Opus):** "Swiss type and whitespace let the live dashboard be the only thing that moves, so the one dramatic element earns its drama." Live-beats-static survives inside a minimal frame. Phosphor-everywhere reads script-kiddie to NL/EU hiring committees vetting a Klarna/Microsoft-scale veteran.

**Opus-suggested middle path (for Mick):** editorial-minimal shell + hero dashboard rendered in terminal-telemetry styling — the instrument-panel energy without the gamer aesthetic.

## 3. PROJECT HIERARCHY (Sol's ruling, Fork 3)

1. **agent-stack** — the thesis made literal: 18→8 sessions, 6.7→4.8 GB RAM, self-healing. Un-fakeable first-scroll proof.
2. **drops** — public live artifact, fastest for a recruiter to verify.
3. **chat-hache** — real-user value before abstract matrices.
4. **providers** — ecosystem + health-verification depth.
5. **setupclone** — concrete inspection path for technical reviewers (alternate 5th: job-pipeline, if setupclone's repo isn't polished enough).

## 4. PROOF ANCHORS — hero trio (Opus's ruling, Fork 4)

1. **drops.hector.app** (live, public, un-fakeable running delivery)
2. **RAM table** (18→8 sessions / 6.7→4.8 GB — quantified systems discipline)
3. **26-account / 181-model health matrix** (visible verified scale)

**Cut to body:** setupclone public repo (pays off on click → better for the hiring-manager verification step than a skim-level hero signal).

**The trio's logic (Ecosystem's "airtight loop"):** breadth (providers) + low-level discipline (RAM) + running delivery (drops) — "he doesn't just prompt APIs, he orchestrates, optimizes, and ships unbreakable systems."

## 5. ANTI-PATTERNS (what the debate killed — don't resurrect)

- ❌ "Ask my stack: it never sleeps…" (pre-shortlist DROP — weakest credibility/clarity)
- ❌ Phosphor/terminal EVERYWHERE — noise a hiring manager tunes out; hobbyist signal in NL/EU
- ❌ Glassy-SaaS template look — instant anonymity
- ❌ Playful-cards — undercuts a decade of enterprise ops
- ❌ Unverifiable numbers as the lead hook ("10.000-agent" needs proof behind it, not on top of it)
- ❌ Provider count as lead signal (a count proves cataloging, not reliability)
- ❌ Jargon front-loading (Erlang-C in the hook — dies on a recruiter)
- ❌ Static case-study first scroll ("live beats static" must be legible above the fold)

## 6. GATE RESOLUTION (Mick's rulings, 2026-09-07)

| # | Decision | Ruling | Status |
|---|---|---|---|
| D1 | One-liner | **#2 hook, #1 supporting** | ✅ APPROVED |
| D2 | Visual language | **editorial-minimal** (Opus ruling; no terminal styling) | ✅ APPROVED |
| D3 | Hero trio 3rd slot | Providers matrix REJECTED (API-injection critique); **topology/tailnet network diagram = main hero** | ✅ APPROVED |

**D3 follow-on scope (Mick, same session):**
- **Home server rebuild** (Docker containers on the Fedora homelab) → include as portfolio project, demonstrating Docker/Linux/scripting/apps breadth. CAREFUL framing: arr stack is piracy-adjacent → present as self-hosted media-automation engineering, zero piracy references.
- **Chat·hector demo**: recruiters get a small public version with **RAG over the architecture** (no PID ever) — natural-language Q&A about the system; Vertex/Gemini backend; **soft token budgets** (per-session caps, graceful quota messages — NO hard limits that could look like config failure).
- **Meta-card**: THIS portfolio pipeline (debate → gate → build → verify) becomes a portfolio project itself — "a portfolio built by its own system."
- **Mermaid.js diagrams** embedded site-wide (topology, pipeline, architecture, homelab).

## 7. D3 MEMO — 3rd proof-anchor recommendations (for Mick's approval)

The locked anchors: **drops.hector.app** (live delivery) + **RAM table** (measured discipline). The 3rd slot must survive the same test Mick just applied: **not reproducible by anyone who can inject an API, not dependent on free-credit pools, verifiable today.**

**RECOMMENDATION 1 — Chat·hector live gateway** (product + real users + security engineering)
*Blurred screenshot + one-line architecture (Google SSO, LE TLS over a tailnet-only domain, zero data leaks).*
- Beats the API-injection test: it's a deployed, OAuth-secured product with real daily users — "anyone can inject an API, not everyone ships a private household gateway with Let's Encrypt DNS-01 over a dead Tailscale NS-delegation."
- NL/EU bonus: "private by design" is data-protection maturity — exactly the message that lands here.
- Live NOW (verifiable today); metrics counts come later.
- Risk: counts not yet meaningful — mitigated by showing SSO+TLS+architecture rather than usage numbers.

**RECOMMENDATION 2 — setupclone public repo** (inspectable code + one-paste installers)
*Public GitHub link + repo screenshot.*
- Closes the "verify the claim" gap: technical reviewers can read real code and run the installers — Craft+Market's convergent concession, and the strongest anti-"AI-generated" signal on the page.
- Live NOW, public-safe, deterministic auto-deploy.
- Risk: Contrarian's attack — "installers prove packaging, not agentic systems"; also less glanceable than a live artifact (needs a click to pay off).

**RECOMMENDATION 3 — Network/tailnet engineering artifact** (to-make: interactive topology diagram)
*Interactive diagram of the hand-built network: Tailscale tailnet, NextDNS rewrites, LE DNS-01 via Porkbun, Caddy root daemons, TCC forensics.*
- Proves "builder since before it was cool": hand-built home network predating the AI pivot, plus genuinely non-trivial engineering (dead Tailscale NS-delegation → DNS-01 workaround, TCC root-daemon forensics) that API-injection skills can't fake.
- Fits the editorial-minimal aesthetic as the one interactive element.
- Risk: NOT built yet (to-make); hero needs it soon or it becomes a body artifact.

**Synthesis recommendation:** **Chat·hector (R1) as the hero third, setupclone as the first body card linked from the hero** — product + users + security in the trio; code inspection one click away. Topology diagram becomes the about-section's interactive showpiece.

---

*Next: on Mick's approval → Opus-5 one-shot build brief → build (mobile-first, LCP <2s, ego-browser verify) → Cloudflare Workers on hector.app.*
