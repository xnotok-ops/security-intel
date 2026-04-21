### kamino/sessions/

- `session-3-summary.md` (Apr 20, 2026) — kfarms P1 is_farm_frozen PARKED. Deployment-state gate fail (0/476 mainnet farms have warmup>0). Skills v2.1/v1.8 deployed. Source for Config-Dormant Pattern.
- `session-4-P2-handoff.md` (Apr 20, 2026) — ready-to-paste handoff block for Session 4 P2 transfer_ownership kickoff.
- `session-3-README.md` (Apr 20, 2026) — install/commit instructions for Session 3 archive bundle.

### kamino/findings/

- `is_farm_frozen-fix-integrity.md` (Apr 20, 2026) — V1 Medium draft, ARCHIVED. PR#94 fix integrity gap. Config-dormant per mainnet verification (Session 3).
- `is_farm_frozen-fix-integrity-HIGH.md` (Apr 20, 2026) — V2 High draft with mainnet evidence placeholder, ARCHIVED.
- `session-4-summary.md` (Apr 20, 2026) — Session 4 FULL CLOSURE. P2+P3+P4+P5 all CLOSED. 30 hypotheses tested, 0 candidates. kfarms Tier 1 EXHAUSTED. SC skill never loaded. Pattern logged: Kamino overflow-handling asymmetry (rewards_issued_unclaimed via checked_add vs raw += across 3 call sites).

# Bounty Notes Index

Complete catalog of `bounty-notes` (PRIVATE repo at `C:\Users\USER\bounty-notes`). Use this index to identify which files to upload to Claude chat during audit sessions.

**How to use:** Tell Claude "upload [filename]" → Claude will ask you to upload from `C:\Users\USER\bounty-notes\[path]`.

**Last updated:** April 20, 2026

---

## References — cross-audit knowledge base

Located in `references/`. Upload these during any audit that matches the pattern.

| File | Description | Use when |
|------|-------------|----------|
| invalidation-library.md | 45 false-positive patterns from The Judge (heavyw8t) | Before submitting any finding — Gate 5 cross-check |
| pashov-attack-vectors.md | 266 SC attack vectors with D (detection) + FP markers | Any SC audit — primary cross-reference |
| pashov-judging.md | 4-gate finding validation framework | Calibrating finding severity |
| pashov-threat-profiles.md | 8 protocol-type threat models (lending, DEX, vault, bridge, governance, stablecoin, derivatives, LST) | Phase 0 — classify protocol, pick vectors |
| plamen-reference-bundle.md | 8 audit guides: EVM rules, governance, lending, vault, oracle, signatures, flash loans, confidence scoring | Protocol-specific deep dive |
| solana-rust-audit-checklist.md | Solana/Anchor: account validation, CPI safety, Token-2022, arithmetic, Rust quality (CDSecurity) | Any Solana/Anchor audit |
| web3-bug-classes.md | 10 DeFi bug classes with real paid examples (shuvonsec) | Pattern cross-reference |
| web3-grep-arsenal.md | 10 copy-paste grep blocks for SC audit (shuvonsec) | Quick vuln scanning |

### Audit Reports — `references/audit-reports/solana/frankcastle/`

| File | Description | Use when |
|------|-------------|----------|
| GMX_Solana_Zenith.pdf | GMX Solana audit (9H/23M/24L) | Perp DEX — cross-validate GMX patterns |
| Perena_Pashov.pdf | Perena stablecoin + staking (4C/3H/4M/3L) | Stablecoin audits — Midas / SG Forge prep |
| ORO_Cantina.pdf | ORO liquid staking + gold trading (11C/1H/5M/3L) | LST / oracle-heavy audits |
| CoalesceFinance_Pashov.pdf | Coalesce (Solend fork, 3H/14M/15L) | Lending patterns (fresh 2025) |
| BTRFI_Pashov.pdf | BTRFI staking/voting/vault (5C/2H/5M/13L) | Multi-component staking |

### Exploit Postmortems — `references/exploit-postmortems/`

| File | Description | Pattern |
|------|-------------|---------|
| subquery-sqt-exploit-apr2026.md | SubQuery SQT staking drain on Base ($128-160K) | Access control on settings/config proxy |
| governance-self-delegation-lock.md | NounsDAO delegation lock (Hexens disclosure) | Governance: delegate(address(0)) locks voting |
| rhea-finance-near-apr2026.md | Rhea Finance NEAR $7.6M fake-token oracle | Fresh pool oracle manipulation, asset registration bypass |
| lootbot-xloot-redeem-apr2026.md | LootBot xLoot staking redeem $9.6K | Array loop double-counting via late state update |

### Tools Tested — `references/tools-tested/`

| File | Description | Status |
|------|-------------|--------|
| txanalyzer-test-plan.md | TxAnalyzer eval: 3 test cases (LootBot, HB Token, XBIT), KEEP/ARCHIVE criteria | Pending test (post-Apr 27) |

---

## Claude Skills — `claude-skills/`

Uploaded to Claude.ai Settings → Skills. Mirror of local `C:\Users\USER\.claude\skills\`.

| Skill | Version | Description |
|-------|---------|-------------|
| bounty-workflow/SKILL.md | v1.6 | Phase 0 router: scope → triage → dispatch (SC/Web/Hybrid) + Pre-Deep-Dive Density Gate |
| smart-contract-audit/SKILL.md | v3.2 | Full SC audit: EVM/Solana/TON/Sui/Vyper, multi-expert 3-round, AI tools |
| bounty-lessons/SKILL.md | v1.2 | Report quality, rejection history, Gate 5 invalidation, pre-submit |
| security-research/SKILL.md | latest | Web/API: recon, IDOR, SSRF, JWT, GraphQL, smuggling, cache poison |
| ffuf-web-fuzzing/SKILL.md | latest | ffuf: dir/file, subdomain, parameter, authenticated fuzzing |
| blockchain-forensics.md | v1.0 | On-chain investigation, exploit tracing, fund flow |
| tiny-auditor.md | v1.0 | Phase 0 quick gate: WORTH DEEP DIVE / SKIP / BORDERLINE |
| pending-patterns.md | — | Pattern queue for next skill batch — 15 validated (O/P/Q added Apr 19 R2), target mid-May 2026 v3.3 |

---

## Active Programs

Currently being worked on. Upload relevant files when resuming session.

| Folder | Platform | Type | Status | Key Files |
|--------|----------|------|--------|-----------|
| xrpl-sherlock/ | Sherlock | SC (C++) | ACTIVE — 2 Med submitted, deadline Apr 27 | `xrpl-session-apr19-coverage.md`, `dynamic-tests/` |

See **xrpl-sherlock/** dedicated section below.

---

## Submitted / Under Review

Reports filed, awaiting judgment.

| Folder | Platform | Type | Status | Key Files |
|--------|----------|------|--------|-----------|
| midas/ | Cantina | SC | IN REVIEW (Finding #115) | `MIDAS-FINDINGS.md` |
| cronos-zkevm/ | HackenProof | SC | SUBMITTED | `cronos-zkevm-FINDINGS.md` |
| zest/ | — | SC | SUBMITTED | `zest-bounty-notes.md`, `zest-report-HIGH-final.md` |
| sherlock-clear-macro/ | Sherlock | SC | SUBMITTED (1 Med, waiting judge) | `FINDING-001-macro-not-in-digest.md` |
| btse/ | HackenProof | Web/API | PAUSED (2 reports submitted) | `BTSE-AUDIT-COMPLETE.md`, `BTSE-nonce-replay-report.md` |

---

## Parked / Done

Previously explored, no active work. Check coverage map before revival.

| Folder | Platform | Type | Status | Notes |
|--------|----------|------|--------|-------|
| **k2/** | **Code4rena** | **SC (Soroban)** | **PARKED Day 14** | **See dedicated section below** |
| cetus/ | Cantina | Web | PARKED | React auto-escape kills all XSS vectors |
| pumb/ | — | Web | PARKED | Ukrainian identity required for auth flows |
| near-intents/ | — | SC | PARKED | — |
| polymarket-cantina/ | Cantina | SC | CLOSED | 7 files reviewed, 0 findings (`notes/polymarket-research-summary.md`) |
| allbridge/ | — | SC | DONE | — |
| dexalot/ | — | SC | DONE (x2, skip) | — |
| coinstore/ | — | Web | DONE (x2) | — |
| bitmart/ | — | Web | DONE | — |
| cronos-sc/ | — | SC | DONE | — |
| symbiotic/ | — | SC | DONE | `AUDIT-CHECKLIST.md`, `FINDINGS.md` |
| whitechain-bridge/ | — | SC | DONE | `SUMMARY.md` |
| amlbot/ | — | Intel only | DONE | `AUDIT-SUMMARY.md` (no bounty) |

---

## k2/ — Code4rena K2 Lending (Soroban/Stellar)

**Status:** PARKED Day 14 (19 Apr 2026) — saturated static + property layers
**Platform:** Code4rena | **Chain:** Stellar/Soroban | **Lang:** Rust | **Pool:** $135K USDC
**Deadline:** 27 May 2026 | **Budget:** 14/40 days used | **Submits:** 0/2 PRESERVED

### Key files

| File | Purpose | Use when |
|------|---------|----------|
| **`k2-coverage-map.md`** | **Day 1-14 comprehensive catalog (60+ killed hypotheses, 15+ modules, untouched priorities, revival rules)** | **Before reviving K2 — ALWAYS re-read first** |
| `k2-coverage-status.md` | Concise coverage snapshot — module matrix, killed categories C1-C7, untouched P1/P2 priorities | Quick status check before revival session |
| `k2-session-starter.md` | Reusable revival session starter template with protocol checklist | Fresh chat session start for K2 revival |
| `V12-FINGERPRINT.md` | 106 unique V12 findings cross-ref | Pre-deep-dive density gate (Memory #26) |
| `K2-V12-Critical-output.md` | Raw Critical findings | Rule (i) dual-file crosscheck |
| `K2-V12-High-output.md` | Raw High findings | Rule (i) dual-file crosscheck |
| `K2-V12-Med-Low-output.md` | Raw Med/Low findings | Rule (i) dual-file crosscheck |
| `PRIOR-AUDITS-SUMMARY.md` | 12 WatchPug findings cross-ref | Pattern H scar check |
| `k2-watchpug-audit-report-rev3.pdf` | WatchPug PDF | Primary source for Pattern H inline tags |
| `k2-borrow-lend-protocol-ssc.pdf` | Halborn PDF — **NOT YET DEEP-READ** | Revival Priority 3 |
| `day-1-log.md` ... `day-14-log.md` | Per-session audit logs | Historical context |
| `irs-contract-dump.txt`, `*-dump.txt` | Source dumps for analyzed modules | Module re-examination |

### Patterns validated (3x each — queue v3.3)
- **Pattern H** — inline fix tags (`H-01`, `M-07`, `L-01`, `WP-C1`, `S-04`, `AC-02`, `C-02`) as saturation counter-signal
- **Pattern I** — broad-fix wrapper pattern gates entire sibling cluster as one V12 finding

### Untouched revival priorities
1. `redstone-adapter/*` — never density-gated, zero K2 mentions
2. `kinetic-router/storage.rs` (440 SLoC) Soroban tier semantics
3. `kinetic-router/views.rs` `update_reserve_state` mid-flash
4. Halborn PDF deep-read
5. Tier D Track 2 real `cargo` execution

### Revival protocol
1. Re-read `k2-coverage-map.md` + `pending-patterns.md` + bounty-lessons FIRST
2. SC skill stays UNLOADED until Gate 3 pass
3. 3-day sprint cap; zero Gate 3 = CLOSED permanent
4. Never re-examine 🔴 modules without NEW cross-contest pattern trigger

---

## xrpl-sherlock/ — Ripple XRPL Audit Contest ($550K)

**Status:** ACTIVE — 2 Medium submitted, waiting judging, deadline Apr 27 2026
**Platform:** Sherlock | **Chain:** XRP Ledger | **Lang:** C++, C | **Repo:** github.com/XRPLF/rippled (contest branch)
**Scope:** Batch, Permission Delegation, MPT DEX, Confidential Transfers, Sponsored Fees, Reserves

### Submitted findings
- #1 — MPT DEX `lsfMPTCanTrade` bypass (Medium)
- #2 — Batch × SponsoredFees `RequireSign` bypass (Medium, PoC confirmed)

### Research status
**EXHAUSTIVE** — static analysis (all 5 feature areas) + dynamic testing round 1 & 2 + design-flaw angles evaluated.

### Files

| File | Description |
|------|-------------|
| `xrpl-sherlock-rampup.md` | Pre-research, architecture notes |
| `xrpl-exploration-findings.md` | Early exploration leads |
| `xrpl-final-summary-apr16.md` | Post-static + dynamic summary (2 Med submitted) |
| `xrpl-session-apr15.md` | Static analysis session |
| `xrpl-session-apr16.md` | OfferCreate+CT clean, HybridxBatch dynamic tests pass |
| `xrpl-session-apr17.md` | Round 2 dynamic testing — 9 test cases, 0 findings |
| `xrpl-session-apr19-coverage.md` | Session Apr 19 coverage: V4-A Batch×MPT diagnostic, V2b/V2d invalidated, 4 angles closed, Patterns J/K/L queued |
| `session-apr19-round2.md` | Session Apr 19 Round 2: 5 angles killed (C-8, CT×PermDelegate, XLS-94 Dynamic MPT, Hybrid×Open cross, Stale Domain), Patterns O/P/Q queued |
| `tools/patch_v4a.py` | Python patch script to inject testBatchMPTCreateAuthorize into XRPLContest_test.cpp |
| `xrpl-offercreate-deepread-apr15.md` | OfferCreate applyHybrid 934 LOC deep read |
| `xrpl-diff-analysis.md` | Diff vs upstream rippled |
| `mpt-crypto-audit-findings.md` | mpt-crypto ZK library review |
| `batch-fix-verification-guide.md` | Batch patch verification |
| `sherlock-report-sponsor-bypass.md` | Submission report #2 |
| `sherlock-xrpl-finding-checkcreate-cantrade.md` | Submission report #1 |
| `dynamic-tests/XRPLContest_test_v5.cpp` | Final 9-case test file |
| `dynamic-tests/round2-final-results.log` | Full test run output, 0 failures |
| `wsl-backup/`, `wsl-backup-20260417/` | XRPL test code backups from WSL |

### Round 2 dynamic tests (Apr 17, all PASS)
- R2-1: Batch × Sponsor × Delegation triple combo → correctly rejected (Batch notDelegable)
- R2-2: Permission escalation via granular sandbox → 4 sub-attacks blocked (flag/limit/field)
- R2-3: MPT DEX cross-domain offer isolation → enforced

### Killed leads (for future reference)
- Credential/Domain delegable griefing — contest README excludes (issuer = trusted)
- Stale domain offer — OfferStream re-verifies at stream time
- Account-in-domain credential expiry bypass — `accountInDomain` calls `checkExpired()`
- sfAdditionalBooks atomic delete — OfferHelpers iterates all book dirs

---

## Research / Pattern Notes

Cross-protocol research. Upload relevant folder during audits matching the pattern.

| Folder | Type | Key Files | Patterns Covered |
|--------|------|-----------|------------------|
| glow-finance/ | SC research | `GLOW-FINANCE-RESEARCH.md`, `PATTERNS-MARGIN-LENDING.md` | Margin lending protocol |
| gmtrade/ | SC research | `GMTRADE-RESEARCH.md`, `PERP-DEX-PATTERNS.md` | Perp DEX (GMX-style) |
| intuition/ | SC research | `INTUITION-RESEARCH.md`, `PATTERNS-BONDING-CURVE-EMISSIONS.md` | Bonding curve + emissions |
| legion/ | SC research | `LEGION-RESEARCH.md`, `PATTERNS-TOKEN-SALE-VESTING.md` | Token sale + vesting |
| renegade/ | SC research | `RENEGADE-RESEARCH.md` | Dark pool / MPC protocols |
| synfutures/ | SC research | `synfutures-research.md` | Perp DEX (orderbook style) |
| ton-foundation/ | SC research | `ton-foundation-audit.md` | TON / FunC patterns |

---

## Patterns & Tools

| File / Folder | Description |
|---------------|-------------|
| `patterns/VULNERABILITY_CHECKLIST.md` | Master vulnerability checklist |
| `patterns/claude-code/` | Claude Code security research (11 files): bash injection, MCP, path validation, webfetch, permissions |
| `patterns-lending-strategy.md` | Lending protocol attack strategy |
| `wallet-telegram.md` | Telegram wallet security notes |
| `tools-to-setup.txt` | Tool catalog: [PENDING]/[INSTALLED] markers, install commands, use cases. **ALWAYS check before suggesting new tools** |
| `CHAT-HISTORY-SUMMARY-APR2026.md` | Chat history summary for context continuity |

---

## Quick Lookup by Protocol Type

Audit a specific protocol type? Upload these files:

| Protocol Type | Upload |
|---------------|--------|
| **EVM/Solidity (generic)** | `pashov-attack-vectors.md` |
| **Solana/Anchor** | `solana-rust-audit-checklist.md` |
| **Soroban/Stellar (Rust)** | `k2/k2-coverage-map.md` + `solana-rust-audit-checklist.md` (Rust patterns) |
| **Lending / Borrowing** | `plamen-reference-bundle.md` (Part 3), `glow-finance/PATTERNS-MARGIN-LENDING.md` |
| **Perp DEX** | `gmtrade/PERP-DEX-PATTERNS.md`, `gmtrade/GMTRADE-RESEARCH.md` |
| **Vault / ERC4626** | `plamen-reference-bundle.md` (Part 4) |
| **Governance / DAO** | `plamen-reference-bundle.md` (Part 2), `governance-self-delegation-lock.md` |
| **Oracle** | `plamen-reference-bundle.md` (Part 5) |
| **Bridge** | `pashov-threat-profiles.md` (Bridge section) |
| **Stablecoin** | `Perena_Pashov.pdf`, `pashov-threat-profiles.md` (Stablecoin) |
| **Liquid Staking** | `ORO_Cantina.pdf`, `BTRFI_Pashov.pdf`, `pashov-threat-profiles.md` (LST) |
| **Token Sale / Vesting** | `legion/PATTERNS-TOKEN-SALE-VESTING.md` |
| **Bonding Curve** | `intuition/PATTERNS-BONDING-CURVE-EMISSIONS.md` |
| **TON / FunC** | `ton-foundation/ton-foundation-audit.md` |
| **XRPL (C++/Rippled)** | `xrpl-sherlock/` (session logs + dynamic-tests + final-summary-apr16) |
| **Dark Pool / MPC** | `renegade/RENEGADE-RESEARCH.md` |
| **Staking exploit reference** | `subquery-sqt-exploit-apr2026.md`, `lootbot-xloot-redeem-apr2026.md` |
| **Oracle manipulation exploit ref** | `rhea-finance-near-apr2026.md` |
| **Before submit (any)** | `invalidation-library.md` |
| **Attack TX RCA test plan** | `txanalyzer-test-plan.md` + local tool at `C:\Users\USER\TxAnalyzer` |

## Kamino Immunefi

- **Status:** Session 4 closed Apr 20, post-mortem identified 10 unexplored angles (see kfarms-unexplored-angles.md). P1-P5 dead-zoned; Tier A queued for Session 5 (refresh_farm + slashed_amount + update_farm_config variants). 30 hypotheses killed, 0 candidates, ~3 day used.
- **Bounty:** 1.5M USD rolling, 150K Critical floor, Medium flat 10K, no stake, KYC done
- **Soft cap:** 10 hari total (Session 4 of ongoing), Tier 1 kfarms ~2.8 day remaining of 5 day cap
- **Dup-check command:** `grep -r -i "phrase" bounty-notes/kamino/audits-local/[component]/*.txt`
- **Realistic target:** Medium 10K USD flat, no stake = 0 risk
- **Parallel pipeline:** xrpl-sherlock still ACTIVE (deadline Apr 27) — Kamino primary post-XRPL

### Mapping Files

- `kfarms-unexplored-angles.md` (Apr 20, 2026) — 10 post-mortem angles missed in Session 4. Tier A/B/C ranked. MANDATORY read before Session 5.
- `kamino-session5-kickoff.md` (Apr 20, 2026) — fresh chat handoff template for Tier A audit (refresh_farm + slashed_amount + update_farm_config).

| File | Scope | Phase |
|---|---|---|
| `kamino/kamino-research-mapping.md` | Parent: 40 audits, 6 components, Tier queue | Phase 0 (Session 0) |
| `kamino/mappings/mapping-kfarms.md` | Sub: kfarms only, 26 ix classified, P1-P9 queue, dead-zone blocklist | Phase 1.0 (Session 2) |
| `kamino/kfarms-phase1-intel/` | Raw extraction outputs: A1 findings spine, A2 self-rejects, A3 cross-refs | Session 2 scratchpad |

### Audit Coverage (40 reports total)

- klend: 20 audits (incl 6 Certora FV versions 1.13.0-1.17.0) — Tier 3 brick wall
- kvault: 9 audits (incl Certora FV + vault_rewards dedicated) — Tier 2
- limo: 4 audits (incl Certora FV) — Tier 3
- scope: 3 audits (no FV) — Tier 2
- kliquidity: 2 audits (incl Certora FV) — Tier 3 hardened
- **farms: 2 audits (no FV) — Tier 1 P1, density 0.96 H/M per kLOC, PROCEED**

### kfarms Phase 1.0 Highlights (Session 2, Apr 20 2026)

- **Density verdict:** PROCEED — 5 H/M findings over 5.2 kLOC = 0.96 per kLOC, not saturated (below 2 threshold)
- **Self-reject cluster:** SKIPPED — 5 entries total, below 10-threshold per skill v1.7 rule
- **Dead-zone blocklist LOCKED:** 11 functions from Offside Labs (5 H/M + 2 Low) + Ottersec (2 H + 1 M + 1 L) — auto-kill Gate 2
- **Caller-constraint matrix:** 26 ix classified — 6 public, 10 farm_admin, 3 global_admin, 1 delegate, 6 user-owned, 1 permissionless-conditional (harvest)
- **Events inventory:** ZERO (no `#[event]`, no `emit!`) — kfarms relies on account-state polling, not event stream
- **Post-audit coverage gaps:** `transfer_ownership` (186 LoC, 8 validations), `reward_user_once`, `update_second_delegated_authority`, Token-2022 extension validation in `utils/constraints.rs`, `is_farm_frozen` fix (PR#94)
- **STRONG LEAD 🚨:** `is_farm_frozen` flag set @ `farm_operations.rs:1011` but **ZERO check sites** found via grep — Offside #4.4 fix integrity suspect. If confirmed incomplete → original pending-stake-stuck DoS returns. **P1 target Phase 2.**

### Phase 2 Priority Queue — kfarms (Tier 1)

1. ~~`is_farm_frozen` fix integrity audit~~ — **PARKED (Session 3)** — Gate 6 fail: 0/476 mainnet farms have warmup>0 (config-dormant)
2. ~~`handler_transfer_ownership.rs`~~ — **CLOSED (Session 4)** — 14 hypotheses killed, fix-integrity verified, precision chain dup to Offside 4.1 + OtterSec M01
3. ~~klend↔kfarms CPI boundary~~ — **CLOSED (Session 4)** — 5 hypotheses killed, RonnyX klend_rx line 579 fix verified via 3-pin chain (delegatee==obligation + PDA seed + init auth)
4. ~~`reward_user_once` + `expected_reward_issued_unclaimed` race~~ — **CLOSED (Session 4)** — 5 hypotheses killed, overflow-asymmetry pattern observed (trust-model sub-threshold)
5. ~~`add_rewards` permissionless abuse~~ — **CLOSED (Session 4)** — 5 hypotheses killed, refresh_farm strictly dominates as attack vector

**kfarms Tier 1 EXHAUSTED — all 5 priority targets processed. 30 hypotheses tested. 0 submission candidates. SC skill never loaded.**

### Cross-Component Signal (worth noting)

- klend↔kfarms CPI surface referenced in: `klend/kamino_lend_rx.txt:579` (RonnyX farm rewards drain via uncorrelated obligations), `klend/kamino_lend_ottersec.txt:671` (refresh farm type mismatch, fixed PR#115). Residual kfarms-side angles possible.

### Lessons (Phase 0 + Phase 1.0)

- **Phase 0 (MFD):** Verify raw audit count via `git clone` + `find` SEBELUM build mapping (21 assumed vs 40 actual caught)
- **Phase 1.0 (density gate):** Ottersec uses ToC-style severity tables — inline `Severity:` grep alone misses findings, cross-check with `Status: Resolved` + `OS-FRM-ADV-XX` ID table
- **Phase 1.0 (lead detection):** Sparse grep results (field def + set site + default init only, zero check sites) = empirical strong-lead signal for defensive flags
- **Phase 1.0 (caller-constraint):** Always grep `has_one =` per handler cross-referenced against ix semantic intent — catches permissionless-by-accident (add_rewards case)
- **Phase 1.0 (events absence):** Zero-event protocols change Phase 2 mental model — all state transitions inferred from account-data deltas, not event stream. Increases silent-state-drift bug risk.

---

## Web Patterns

- **async-lifecycle-race** (experimental, Apr 2026)
  — [`web-patterns/recon-checklist-experimental.md`](./web-patterns/recon-checklist-experimental.md)
  — Status: unvalidated, 1 pattern queued

- **second-order-sqli-worker-sink** (HIGH value)
  — [`web-patterns/second-order-sqli-worker-sink.md`](./web-patterns/second-order-sqli-worker-sink.md)
  — Canonical: CVE-2026-40871 Mailcow
  — Universal pattern (Python/PHP/Node)

## DeFi Patterns

- **layerzero-dvn-audit** (HIGH value)
  — [`defi-patterns/layerzero-dvn-audit.md`](./defi-patterns/layerzero-dvn-audit.md)
  — Canonical: Kelp DAO $292M (Apr 2026)
  — Includes governance-operational gap angle

## Smart Contract Patterns

- **cpp-blockchain-node-audit** (HIGHEST value, XRPL-urgent)
  — [`sc-patterns/cpp-blockchain-node-audit.md`](./sc-patterns/cpp-blockchain-node-audit.md)
  — Canonical: Pharos BlockChain audit by ExVul (Dec 2025, 101 findings)
  — 8 category pattern library + XRPL hypothesis mapping
  — PDF archive: bounty-notes/references/chain-audits/pharos-exvulsec-2025-12.pdf

## KAST (Immunefi)

- **Status:** Phase 0 Complete (20 April 2026) — data collection done, mapping pending
- **Bounty:** $50K Critical max / $21K floor / $10-20K High / KYC required / Immunefi-triaged / Primacy of Rules
- **Chain:** Solana/Anchor (Rust, Anchor 0.31.1, Solana 2.1.0)
- **Assets (both m_ext forks):**
  - USDK  = `extaykYu5AQcDm3qZAbiDN3yp6skqn6Nssj7veUUGZw`
  - USDKY = `extMahs9bUFMYcviKCvnSRaXgs5PcqmMzcnHRtTqE85`
- **Codebase:** m0-foundation/solana-m-extensions (~4,123 SLoC, 2 programs: m_ext 3,175 + ext_swap 948)
- **Feature flags:** no-yield / scaled-ui / crank / wm — only ONE compiled per deploy (detect via anchor idl fetch)
- **Audits:** 5 reports across 3 firms (Adevar v1+v2, Halborn v1+v2, OtterSec v1) — Jun 2025 to Sep 2025
- **Post-audit gap:** ~7 months (last audit Sep 19, 2025 → bounty launch Apr 20, 2026)
- **Known issues (auto-kill zone):** 5 acknowledged
  - Unsupported Mint Extensions
  - trunc/floor off-by-one (multiplier × INDEX_SCALE_F64)
  - Retroactive Fee Application (crank variant)
  - Earners Lose Pending Yield on removal
  - ext_mint CloseMintAuthority + PermanentDelegate
- **Caller constraint:** INCLUSIVE with privileged-caveat (admin/gov bugs default OOS unless intended-permissionless)
- **Master map:** bounty-notes/kast/mappings/kast-research-mapping.md ✅ (Tier 1 P1 = PROTO-835 Feb 2026 post-audit fix, 5 files not audit-covered)
- **Path:** `C:\Users\USER\bounty-notes\kast\`
- **Dup-check cmd:** `findstr /i /c:"phrase" bounty-notes\kast\audits\*.txt`
- **Full findstr against all 5 audits:** ~6,251 lines total (millisecond scan)

## KAST Session Archives (Apr 20 2026)
- `kast/sessions/session-1-proto835/session-1-archive.md` — H1 PROTO-835 kill rationale, Floor-Bounded Rounding Pattern validation, deployment intel (SwapGlobal PDA, ExtGlobalV2 addresses, variant map)
- `kast/sessions/session-2-migrate/bootstrap.md` — T1 P2 migrate.rs bootstrap prompt for fresh chat

---

# Bounty Notes Index Update — Apr 21, 2026

> Paste/merge section below into `xnotok-ops/security-intel/bounty-notes-index.md`
> under the `sherlock-xrpl/` section.

---

## sherlock-xrpl/ — Updates Apr 21, 2026

### New files

- `sherlock-xrpl/xrpl-session-apr21.md` — Day 1 Pharos C++ pattern sweep
  - 6 grep categories swept (assert, abort, visit, sigverify, ratelimit, bounds)
  - Macro resolution: `UNREACHABLE = assert((message) && false)` → no-op in NDEBUG
  - 1 GREEN candidate: ValidVault TBD gap on `ttLOAN_SET/MANAGE/PAY`
  - 2 YELLOW preserved: BookStep `remaining<0` pair (1059/1221)
  - All other categories RED

- `sherlock-xrpl/pharos-sweep-out/P2-tbd-vault-invariant.md` — Priority #1 mini-mapping
  - Status: CONDITIONAL (gap confirmed, weaponization pending Day 2)
  - Gate 5 dup-check: clean vs #1 (MPT DEX `lsfMPTCanTrade`), #2 (Batch×Sponsor `RequireSign`)
  - Gate 6: `featureLendingProtocol` in contest scope per README L1041-1042

- `sherlock-xrpl/pharos-sweep-out/cat*.txt` — grep artifacts (retained for reference)

### Key pending-patterns queue additions (not yet validated 3x)

- **Pattern T1:** "TBD comment in invariant switch returning unconditional true"
- **Pattern T2:** "UNREACHABLE no-op in release enables graceful fallback masking state corruption"

Neither ready for skill v3.3 release (mid-May target). Re-evaluate post-contest.

### Pipeline status delta

- XRPL Sherlock: 2 Medium submitted → still 2. Day 2 goal: 1 additional via VaultInvariant TBD weaponization or Option C dynamic testing pivot.
- Deadline: Apr 27 (6 days remaining)

### Active exhausted-surfaces list (for future dup-check)

Added to existing exhausted list:
- `std::visit + UNREACHABLE` in STAmount canAdd/canSubtract (release returns false — safe deny)
- Batch `checkSignatureFields` lambda sig-field existence checks (tight, no bypass)
- HTTPClient `abort()` on deadline error (CLI-only, not network-reachable)
- SponsorshipTransfer `getLedgerEntrySponsorField` UNREACHABLE (upstream owner check sufficient)
- LogicError / contract.cpp `std::abort()` (safe `[[noreturn]]` terminator convention)

### Key insights (reusable for other XRPL/C++ audits)

1. XRPL uses `LogicError()` (`[[noreturn]] noexcept`) when abort actually intended. Always check `contract.h` for real termination primitives.
2. `UNREACHABLE` is instrumentation-only in XRPL (stripped NDEBUG). Always resolve macro definition before claiming abort-based DoS.
3. `enforce = view.rules().enabled(featureX)` pattern common in invariants — breaks indicate feature gating rather than runtime abort.
4. Pharos Pattern 2 (error handling anti-pattern) match in XRPL manifests as "TBD" comments rather than wrong abort — search for incomplete invariant coverage, not wrong termination.
## Apr 22, 2026 — XRPL Sherlock Day 2

- `sherlock-xrpl/xrpl-session-apr22.md` — Day 2 loan transactor + BookStep revival, full clean kill, 4 new patterns (T3-T6) queued for v3.3
- `sherlock-xrpl/pharos-sweep-out/day3-coldstart-prompt.md` — Day 3 dynamic testing Round 2 kickoff template


## Apr 23, 2026 — XRPL Sherlock Day 3 COMPLETE

### Session overview
- Deep-dives: 6, invariant sites examined: 21, new findings: **0**
- Deadline: Apr 27 (4 days remaining)
- Pipeline: 2 Medium submitted (MPT DEX lsfMPTCanTrade, Batch×SponsoredFees RequireSign), Day 4-5 = report polish

### Kills (Day 3)
- **V2b/V2d** (PermDelegation persistence through disable-master) — Gate 2 KILL, by-design via Ripple's own test Delegate_test.cpp L1597 + zero mentions of `asfDisableMaster` in DelegateUtils.cpp
- **ASSERT path** (5 deep-dives, 18 asserts): PaymentSandbox L83/413/424, STTx L302/585, SponsorshipTransfer L428/457/461/505, OfferCreate L218/474/684/705/708/738, MPTokenIssuanceSet L391/409/419 — all KILL
- **UNREACHABLE triage** (3 sites): MPTokenHelpers L189 (authorizeMPToken) + L495 (enforceMPTokenAuthorization), View.cpp L65 (isVaultPseudoAccountFrozen) — all KILL

### Files
- Session log: `sherlock-xrpl/xrpl-session-apr23.md`
- Test file baseline: `~/xrpl-contest/src/test/contest/XRPLContest_test.cpp` (904 lines, Apr 19 last run, 12 test cases clean)

### Pattern queued for bounty-lessons v2.x (mid-May)
- **"XRPL C++ defensive-invariant paradigm"** — XRPL_ASSERT + UNREACHABLE + LCOV_EXCL behind preflight/preclaim guards. Triage method: grep caller preflight for same condition.

### ⚠️ Contradiction flag (requires Day 4 resolution)
Day 2 entry states: "UNREACHABLE is instrumentation-only in XRPL (stripped NDEBUG)."
Day 3 Gate 0 re-read of `cmake/XrplCompiler.cmake` L241 as stripping `-DNDEBUG` FROM flags (keeping asserts LIVE).
Both interpretations lead to same kill verdicts for Day 3 sites (preflight-guarded regardless), but thesis differs.
**Action Day 4:** verify via actual binary — run `strings xrpld | grep "PaymentSandbox::creditMPT"` on built binary. Presence = asserts compiled in. Absence = compiled out per NDEBUG stripping (Day 2 interpretation).

### Active exhausted-surfaces list update
Added Day 3:
- PaymentSandbox::DeferredCredits MPT assertions (internal helper, no tx caller)
- STTx::checkBatchSign / getBatchTransactionIDs (dispatcher-gated)
- SponsorshipTransfer getAccountID `!!` asserts (4, typed-extractor tautological)
- OfferCreate applyGuts all 6 asserts (preflight + early-return guarded)
- MPTokenIssuanceSet sle type asserts (keylet-typed read invariant)
- MPTokenHelpers UNREACHABLE L189/495 (preclaim-gated conds)
- View.cpp isVaultPseudoAccountFrozen UNREACHABLE L65 (AccountDelete ledger invariant)

### Correction (end of Day 3)
Re-reading Day 2 insight more carefully: "UNREACHABLE instrumentation-only (stripped NDEBUG)" means NDEBUG is ACTIVE in XRPL release builds, causing assert() to strip → UNREACHABLE becomes no-op. Day 2 interpretation likely correct; Day 3 Gate 0 misread L241 context without checking conditional wrapper. XrplCompiler.cmake L241 strips `-DNDEBUG` but likely only in debug/assert-enabled build paths, not production release.

**Actual verdict on Day 3 sites:** still all KILL, but for the REAL reason: UNREACHABLE no-op → fallthrough returns `tefINTERNAL`/`false`/`tecINTERNAL` gracefully. Not "abort blocked by preflight" as Day 3 framed it.

**Lesson:** always re-read prior session's primitive-level insights before starting new primitive analysis. Day 2 was explicit about this exact topic; I should've consulted it Day 3 Gate 0.

## Kamino prior-audits (sec3)

Location: `bounty-notes/kamino/prior-audits/sec3/`

- sec3_kamino_lend.pdf — Feb 2025, Kamino Lending Program (patterns relevan untuk kfarms)
- sec3_kamino_vault.pdf — Feb 2025, Kamino Lending Vault
- sec3_kamino_scope.pdf — Dec 2024, Kamino Scope oracle aggregator
- sec3_kamino_report.pdf — Sep 2022, Kamino yvaults (baseline historis)

Use case: Gate 5 invalidation cross-check saat T1P2 transfer_ownership session.
