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
# Base Azul Research Master Map

> **Single source of truth** untuk riset Base Azul Immunefi Audit Competition.
> Fresh chat next session cukup paste handoff block (Section 9) → langsung dispatch tanpa re-discover.

**Last updated:** 2026-04-22 (v2 — data-driven revision post-recon)
**Owner:** xnotok-ops
**Phase:** 0 — Scope mapping COMPLETE → ready for Session 1 dispatch
**Related:** `bounty-notes/k2/` (prior contest), `bounty-notes/xrpl-sherlock/` (concurrent), `bounty-notes/claude-skills/pending-patterns.md` (Patterns K–R queued from this recon)

---

## 1. Program Overview

| Field | Value |
|---|---|
| Platform | **Immunefi Audit Competition** |
| URL | Immunefi bounty page: "Audit Comp \| Base Azul" |
| Live Since | 21 April 2026 20:00 UTC |
| Last Updated (scope) | 22 April 2026 (Day 2) |
| Deadline | **4 May 2026 20:00 UTC** (~12 days remaining) |
| Chain | Base (Ethereum L2) — testnet Sepolia in-scope, mainnet OOS for contest |
| Triage | Platform-managed (Immunefi + Base team, 48h weekday SLA) |
| KYC | Required before payout — status: ❌ pending |
| Stake | $0 (no stake) |
| PoC | **Required for ALL severities** (incl. Low + Medium) — Runnable |
| Responsible Publication | Category 3 (after fix/paid/invalid) |
| Caller Constraint | **INCLUSIVE** with specific exceptions (see §11 scope-official.md) |
| Lines of Code (nSLOC) | ~190,000 total → **target surface narrowed to ~300 LoC** via MFD recon |

### Reward Matrix

| Tier | Pool if top-severity = … |
|---|---|
| **Critical** | $250,000 (Primary $175K + All Stars $50K + Podium $25K) |
| **High** | $125,000 |
| **Medium** | $70,000 |
| **Low** | $30,000 |
| **Insights only** | $20,000 |

Token: **USDC on Base**.

### Special Rules

- **Duplicates valid for unfixed bugs**; fix publicly disclosed → new reports invalid.
- **Mid-contest fixes allowed**; changelog via Discord + program page.
- **Private known issue x1** — hash variant held by Immunefi; rediscovery = no credit.
- Base mainnet OOS for contest. Base Sepolia post-20 Apr 2026 is the target environment.
- Previous audit findings that remain unfixed = **NOT eligible** (known-issue exclusion).
- Downgrade rules active (see §6 and scope-official.md §6).

### 🔥 Post-Audit Addition Flagged

**`src/multiproof/zk/ZKVerifier.sol`** — 51 LoC, added via commit `01dad23` (subject: "Backport: add verifier contract (#256)") at **2026-04-21 16:40 UTC = 3h20m before contest start (20:00 UTC)**. Tag `v8.1.0` points at this exact commit. **Zero audit coverage** across all 4 Cantina audits. See Pattern K + L in pending-patterns for the methodology.

---

## 2. GitHub Repositories

**Org:** https://github.com/base

### 🎯 In-Scope Repos (target research)

| Repo | Path | Tag/Branch | Commit | Clone Status |
|---|---|---|---|---|
| [base/base](https://github.com/base/base) | `repos/base/` | **v0.8.0-rc.15** | `de349fc` | ✅ Cloned |
| [base/node](https://github.com/base/node) | `repos/node/` | main | latest | ✅ Cloned (43 objects; reth likely remote-loaded) |
| [base/contracts](https://github.com/base/contracts) | `repos/contracts/src/multiproof/` | **v8.1.0** | `01dad23` | ✅ Cloned + full history fetched |
| [base/contract-deployments](https://github.com/base/contract-deployments) | `repos/contract-deployments/` | main | latest | ✅ Cloned |

### 📋 Multiproof Source Tree (at v8.1.0, LoC verified)

```
src/multiproof/
├── AggregateVerifier.sol         (1032 LoC)  🟡 EXTREME audit coverage (151 mentions, 2 audits)
├── Verifier.sol                  (  48 LoC)  🟢 LIGHT — nullify logic
├── mocks/                                    (OOS — test mocks)
│   ├── MockDevTEEProverRegistry.sol
│   ├── MockSystemConfig.sol
│   └── MockVerifier.sol
├── tee/
│   ├── NitroEnclaveVerifier.sol  ( 706 LoC)  🟡 HEAVY (2 TEE audits, Nitro 45 mentions)
│   ├── TEEProverRegistry.sol     ( 260 LoC)  🟡 MODERATE (32 mentions)
│   └── TEEVerifier.sol           ( 106 LoC)  🟡 MODERATE (7 mentions)
└── zk/
    └── ZKVerifier.sol            (  51 LoC)  🟢🟢 FRESH — 0 audit coverage, backported Apr 21
```

**Total in-scope multiproof:** 2,203 LoC. **Core hunt surface:** ~300 LoC (ZKVerifier 51 + Verifier 48 + nullify path in AggregateVerifier ~60 + finding 3.1.1 resolve path ~100).

### 📚 Reference Repos (NOT in scope)

| Repo | Purpose |
|---|---|
| [ethereum-optimism/optimism](https://github.com/ethereum-optimism/optimism) | Security reviews sparse-cloned (44 PDFs). **0 upstream coverage** on any target contracts — confirmed pure Base-native scope. |
| [paradigmxyz/reth](https://github.com/paradigmxyz/reth) | Upstream Reth (EL). Base modifications in-scope but defer to Tier 2. |
| [succinctlabs/sp1](https://github.com/succinctlabs/sp1) | ZK prover (OOS itself). `ISP1Verifier` interface consumed by ZKVerifier.sol. |

---

## 3. Audit Coverage Map — VERIFIED DATA

Source: `bounty-notes/base-azul/audits-local/` (4 Cantina PDFs + 44 Optimism reviews = 48 PDFs/TXTs corpus).

### 📊 Per-Audit Manifest (verified via pdfinfo + wc + grep)

| Audit File | Pages | Words | Scope commit | Findings | Nature |
|---|---|---|---|---|---|
| `multiproof-1/cantina_coinbase_multiproof_mar2026.pdf` | 21 | 4,420 | `b6c4689b` (Mar 17–23) | 4 Info, 0 other, 4/4 Fixed | **Primary broad audit** (AggVerifier, Verifier, TEE stack) |
| `multiproof-2/cantina_coinbase_aggregateverifier_apr2026.pdf` | 5 | 923 | `ffe2af8c` (Apr 10–13) | 1 Info, 0 other, 1/1 Fixed | **Fix-verification pass** on AggregateVerifier.sol only |
| `tee-1/cantina_coinbase_nitro_enclave_mar2026.pdf` | 9 | 2,670 | TBD (Mar 23) | TBD (likely similar informational) | **Primary TEE audit** (Nitro enclave focus) |
| `tee-2/cantina_coinbase_nitro_enclave_apr2026.pdf` | 7 | 1,692 | TBD (Apr 10) | TBD | **Fix-verification pass** on TEE |

**Optimism upstream:** **0 files** mention any of our target contracts (AggregateVerifier, ZKVerifier, TEEVerifier, TEEProverRegistry, NitroEnclaveVerifier). Dup-check corpus reduces to 4 Cantina `.txt` files for target-specific grep.

### 📈 Term Frequency Signal (confirmed via grep -rh -c -i across 4 Cantina TXTs)

| Term | Mentions | Saturation | Implication |
|---|---|---|---|
| AggregateVerifier | **151** | 🔴 EXTREME | Primary target of 2 audits + appendix PoCs |
| Nitro | 45 | 🔴 HIGH | TEE audits deep-cover enclave attestation |
| PCR0 | 44 | 🔴 HIGH | Attestation measurements deep-covered |
| attestation | 33 | 🟡 HIGH | Nitro attestation path covered |
| TEEProverRegistry | 32 | 🟡 MODERATE | Registration flow touched |
| TEEVerifier | 7 | 🟡 LIGHT | Delegation wrapper, less surface |
| DelayedWETH | 3 | 🟢 LIGHT | **1d delay change barely probed** |
| AnchorStateRegistry | 3 | 🟢 LIGHT | **Integration points barely probed** |
| soundness | **1** | 🟢 FRESH | **Soundness alert auto-nullify flow barely covered** |
| **ZKVerifier** | **0** | 🟢🟢 PURE FRESH | **51 LoC brand new, never audited** |
| **OptimismPortal2** | **0** | 🟢🟢 PURE FRESH | **Delay-removal integration un-audited** |
| **"intermediate output"** | **0** | 🟢🟢 PURE FRESH | **New Azul sub-range dispute feature un-audited** |

### 📅 Post-Audit Git Diff Analysis (Pattern K applied)

Audit end commit (April) → v8.1.0 = 2 commits, 3 files touched in `src/multiproof/`:

| Commit | Date | Type | Files | Size | Risk Classification |
|---|---|---|---|---|---|
| `ddd5a09` | 2026-04-15 15:09 UTC | **Audit-2 fixes** | AggregateVerifier.sol (+13/-9), NitroEnclaveVerifier.sol (+13/-2) | Minor | Regression only; AggregateVerifier diff = comment updates (CWIA offsets); NitroEnclaveVerifier diff = cert expiration loop for non-trusted prefix (finding 1 fix) |
| `01dad23` | **2026-04-21 16:40 UTC** | **🔥 BACKPORT** | **zk/ZKVerifier.sol (+51/-0)** | **NEW FILE** | **🚨 Pattern L — 3h20m before contest start. Zero audit exposure.** |

### 📝 March Multiproof Audit Findings Summary

All 4 findings Informational, all Fixed:

| ID | Title | Context | Relevance |
|---|---|---|---|
| 3.1.1 | Unconditional Proof Threshold Check in resolve Blocks Normal Bond Recovery When Parent Game Is Invalid | AggregateVerifier.sol#L453 | **🎯 HIGH — Pattern M candidate: impact chain mentions ZK verifier nullification permanently stucks game** (see §6 full text) |
| 3.1.2 | Event Emissions Across Verification Functions Reflect Stale or Incomplete State | AggregateVerifier.sol | Low — event-only |
| 3.1.3 | Inaccurate NatSpec and Dead Code | Multi-file | Signal: auditor catches dead code patterns (Pattern P relevant for ZKVerifier which wasn't audited) |
| 3.1.4 | Duplicate code should be put in a helper function | Multi-file | Quality |

### 📝 April Multiproof Audit (AggregateVerifier focus)

1 finding Informational, Fixed:
- 3.1.1 Document offsets, size, and expected structs (CWIA layout documentation)

**Interpretation:** AggregateVerifier survived broad audit (March, 4 Info) → fix-verification pass (April, 1 Info) = **structurally well-reviewed**. March audit even includes Foundry PoC tests in appendix (`testClaimCredit_ParentBlacklisted_BondToCreator`, `_createAggregateVerifierGame`, `DELAYED_WETH_DELAY`) — **Pattern Q: bicamerally tested, saturation bumps up a tier for `resolve` + `claimCredit` + blacklist paths**.

---

## 4. Research Priority Queue — DATA-DRIVEN (v2)

> **Revised from v1** based on recon discoveries. v1 had AggregateVerifier at P1 — data shows this is over-saturated. Actual fresh ground found via Pattern K (git-diff) + Pattern L (temporal proximity).

### 🟢 Tier 1 — FRESH GROUND (Target HERE)

| Priority | Target | LoC | Audit mentions | Rationale |
|---|---|---|---|---|
| **P1** | **`zk/ZKVerifier.sol` full contract** | **51** | **0** | 🚨 Backported 3h20m pre-contest. Never audited. SP1 delegation pattern. Dead error `SP1VerificationFailed()`. `notNullified` modifier ties to Verifier.sol. Contest lists "Forging or bypassing ZK proof verification in AggregateVerifier" as Critical. |
| **P2** | **`Verifier.sol::nullify()` false-trigger surface** | **~20 (48 total)** | 0 direct (nullify term = 3 mentions in multiproof-1 only) | PERMANENT state flag, gated by `isGameProper && isGameRespected` via AnchorStateRegistry. No un-nullify. Successful false-trigger = permanent brick entire ZK (or TEE) verification path = **Critical** ("Permanent freezing of funds in bridge or dispute game bonds with no available recovery path" OR "Circumventing dispute/challenge mechanism"). |
| **P3** | **`AggregateVerifier.nullify()` soundness alert flow (L548-602)** | **~60 within 1032** | soundness=1, conflict not mentioned | Validates intermediate-root conflict before calling `IVerifier.nullify()`. Attack surface: (a) make soundness check pass with non-conflicting but crafted intermediate root → brick; (b) bypass soundness detection when legitimate conflict exists → scope explicit High "Bypass soundness alert — 2 conflicting valid same-type proofs fail to nullify". |
| **P4** | **Finding 3.1.1 variant extension** | `resolve` function + pathway | Fixed per recommendation | Pattern M application — fix narrow to proofCount-threshold move into else-branch. Variants to probe: (a) same permanent-stuck under different trigger combinations (TEE nullified + ZK-only parent), (b) chains of stuck games propagating via child dependencies, (c) bond-recipient reassignment edge cases. Impact chain maps to **Medium (Temp freeze ≥24h) or High (Dispute circumvention)** depending on framing. |
| **P5** | **Intermediate output roots + CWIA extradata layout** | ~50-100 within AggregateVerifier | 0 mentions of "intermediate output" | NEW Azul feature. Data layout per April audit comments: creator/rootClaim/l1Head/l2BlockNumber/parentGameAddress/intermediateRoots variable-length array. Attack surface: (a) index-out-of-bounds in `intermediateOutputRoot(idx)`, (b) length/offset mismatch vs CWIA bytes (the April fix only added documentation!), (c) malicious proof tricks `counteredByIntermediateRootIndexPlusOne` accounting. |

### 🟡 Tier 2 — MODERATE (if Tier 1 exhausted OR time short)

| Priority | Target | Rationale |
|---|---|---|
| **P6** | AggregateVerifier non-nullify state machine | 151 mentions + PoC tests in appendix = highly saturated. Defer unless new pattern emerges from T1 work. |
| **P7** | `DelayedWETH` 1-day withdrawal delay edge cases | 3 mentions only; delay-halving from 3.5d→1d barely probed. Lower impact ceiling (griefing/temp-freeze). |
| **P8** | `OptimismPortal2` + `AnchorStateRegistry` Azul-specific mods | 0-3 mentions; delay-removal integration. But OP Stack upstream carries high code saturation from Optimism audits (MCP, Interop, U18) — cross-reference those. |
| **P9** | `TEEProverRegistry` signer registration edge cases | 32 mentions (moderate) but PCR0 attestation flow is the main risk and Nitro/PCR0 combined = 89 mentions (high saturation). |
| **P10** | `post-audit NitroEnclaveVerifier diff` (+13/-2 lines) — cert expiration loop for non-trusted prefix | Regression-risk; 13 lines added by audit fix. Check off-by-one / index confusion in new loop. |

### 🔴 Tier 3 — SKIP (unless NEW pattern)

| Priority | Target | Rationale |
|---|---|---|
| P11 | `TEEVerifier.sol` internal logic | 7 mentions; slim wrapper. Primitives delegated. |
| P12 | Pure TEE attestation crypto internals | 45+44+33 mentions = 🔴 extreme saturation. |
| P13 | `base-reth-node` EIP implementations | 0 audit mentions but requires ~1 day Rust+EVM harness setup. Poor EV given T1 surface is accessible in Solidity Foundry immediately. |
| P14 | `base-consensus` CL↔EL boundary | Same as P13; setup-cost-prohibitive given 5-day budget + T1 yields. |
| P15 | RiscZero SP1 circuits / op-succinct core | Explicit OOS per scope. |

---

## 5. Research Status Matrix

Legend: 🔴 Unresearched • 🟡 In-progress • 🟢 Covered (cleared) • ⚫ Parked • ❌ Red (verified hardened) • 💎 Finding candidate

| Module | Tier | Status | LoC | Hours | Finding | Sub-Path Notes | Last Session |
|---|---|---|---|---|---|---|---|
| **ZKVerifier.sol** (full) | T1 P1 | 🔴 | 51 | 0 | — | Start: full-read + SP1 interface + Verifier base + call-site in AggregateVerifier | — |
| **Verifier.nullify() false-trigger** | T1 P2 | 🔴 | 48 (~20 core) | 0 | — | Map `isGameProper`/`isGameRespected` access model; check if external call in AnchorStateRegistry can be spoofed via forged game | — |
| **AggregateVerifier.nullify() flow** | T1 P3 | 🔴 | ~60 in 1032 | 0 | — | Read L548-602; check soundness condition ("same-type conflict"), intermediate-root validation, trigger conditions for false-pos/false-neg | — |
| **Finding 3.1.1 variants** | T1 P4 | 🔴 | resolve+blacklist path | 0 | — | Re-read fix commit dd587c9a; probe alternative trigger combos | — |
| **Intermediate output roots layout** | T1 P5 | 🔴 | ~100 | 0 | — | CWIA extradata packing; length/offset math; counteredByIntermediateRootIndexPlusOne accounting | — |
| AggregateVerifier other state | T2 P6 | ⚫ | 1032 total | 0 | — | Park unless new pattern | — |
| DelayedWETH 1d delay | T2 P7 | 🔴 | ~TBD | 0 | — | Locate DelayedWETH.sol, check WITHDRAWAL_DELAY constant | — |
| OptimismPortal2 Azul mods | T2 P8 | 🔴 | ~TBD | 0 | — | grep "Portal2" in repo + diff vs OP upstream | — |
| TEEProverRegistry | T2 P9 | 🔴 | 260 | 0 | — | Registration + orphan-removal flow | — |
| NitroEnclaveVerifier post-audit diff | T2 P10 | 🔴 | +13 | 0 | — | Line 618-625 cert expiration loop | — |
| TEEVerifier internal | T3 P11 | ❌ | 106 | 0 | — | Red — skip | — |
| base-reth-node | T3 P13 | ⚫ | huge | 0 | — | Parked, setup cost too high | — |

**Update rule:** Tiap sesi riset, update status + hours + sub-path notes. Red hypothesis tidak di-revisit tanpa NEW pattern (rule h).

---

## 6. Known Issues & Exclusions (CRITICAL — avoid dup)

### Dup-Check Workflow (MANDATORY sebelum submit)

```bash
# Cantina-only dup-check (Optimism confirmed 0 coverage, skip from main scan)
grep -rn -i "candidate_phrase" \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/multiproof-1/*.txt \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/multiproof-2/*.txt \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/tee-1/*.txt \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/tee-2/*.txt

# If finding-candidate overlaps Kona / Fault Proof / Interop paths, ALSO include these 10 upstream relevant PDFs:
#   2026_03-Kona-Spearbit.txt (Kona — private known issues exist)
#   2025_01-MT-Cannon-Base.txt (Base-specific Cannon)
#   2024_05-FaultProofs-Sherlock.txt (pre-Azul fault proof design)
#   2024_08_Fault-Proofs-{MIPS,No-MIPS}.txt (fault proof detail)
#   2025_0{3,4,5}-Interop-{Contracts,Portal}*.txt (bridge/portal patterns)
#   2026_01-U18-Cantina.txt (recent upgrade)
```

**Narrow-phrase discipline (V12 method):**
- 3–5 spesifik words dari hipotesis
- NO broad keywords (`reentrancy`, `overflow`, `access control`)
- Match = KILL (rule h)
- Pass 2 synonym expansion: `proof` → `attestation` → `witness` → `signature` → `claim`; `nullify` → `invalidate` → `disable` → `brick` → `retire`; `conflict` → `mismatch` → `discrepancy` → `divergence`

### Known Finding to Extend (Pattern M candidate) — **FULL TEXT**

**3.1.1 Unconditional Proof Threshold Check in resolve Blocks Normal Bond Recovery When Parent Game Is Invalid** (Informational, Fixed in `dd587c9a`)

> Context: AggregateVerifier.sol#L453
>
> The resolve function in AggregateVerifier enforces the proofCount threshold check unconditionally after the branch that sets status = CHALLENGER_WINS when the parent game is blacklisted, retired, or lost. With the planned upgrade to PROOF_THRESHOLD = 2, a game initialized with only one proof would have resolve revert with NotEnoughProofs, rolling back the status change and leaving the game stuck as IN_PROGRESS.
>
> Since PROOF_THRESHOLD = 2 requires both a TEE and ZK proof, a second proof can be submitted via verifyProposalProof before calling resolve to satisfy the threshold. The initialization proof already validates the state transition, so the second proof type can be produced and submitted within the 7-day SLOW_FINALIZATION_DELAY window.
>
> **The edge case arises if the second proof cannot be submitted within the 7-day window. For example, if a soundness issue is discovered in the ZK verifier through another game causing it to be nullified, no ZK proof can ever be submitted. If the parent game is then blacklisted, the child game needs to resolve as CHALLENGER_WINS but proofCount remains at 1. The game is permanently stuck as IN_PROGRESS, the bond is unrecoverable through normal operations and requires admin intervention via DelayedWETH, and child games built on top are also blocked from resolving.**
>
> Recommendation: Move the proofCount threshold check and the isChallenged bond recipient reassignment into the else branch so they only apply when the parent game is valid. When the parent is invalid, resolution should proceed directly to CHALLENGER_WINS and mark resolvedAt without requiring the proof threshold to be met.

**How to weaponize (Pattern M):**
- Auditor fix = proofCount check moved to else-branch. Check `git show dd587c9a -- src/multiproof/AggregateVerifier.sol` to understand exact fix scope.
- Variant vectors:
  1. Same permanent-stuck outcome under **different trigger combination** — e.g., TEE verifier nullified (not ZK) + parent blacklisted with only ZK proof on child
  2. **Cascading child games** — parent IN_PROGRESS blocks N children, map the DAG
  3. **Bond-recipient reassignment** — auditor noted "isChallenged bond recipient reassignment executes unconditionally after parent status branch" as secondary concern; fix moves this too, but does it correctly handle corner case where game was challenged AND parent was blacklisted?
- Impact chain mapping:
  - "stuck IN_PROGRESS >24h" → Immunefi Medium ("Temporary freezing of funds for at least 24 hours")
  - "child games cascading blocked" → potentially escalate to High — but stays Smart Contract tier, more likely Medium
  - "requires admin intervention via DelayedWETH" → if admin path has its own blocker (e.g., Security Council OOS under their mandate) → upgrade to Critical ("Permanent freezing of funds in the bridge or in dispute game bonds with no available recovery path")

### Program Exclusions (summary — full in scope-official.md §6)

**Hard OOS:** Mainnet testing, oracle manip, flash loans (basic econ), 51%/governance, Sybil, centralization risks, self-exploited, leaked keys, depegging, secrets in git, best-practice-only, test files, phishing.

**Downgrade triggers:**
- Attack requires compromising Base infra (not code-review-discoverable) → downgrade
- Assumes Base won't dispute/blacklist → downgrade
- Relies on invalid TEE/ZK proof → downgrade (TEE especially) unless key compromise proven unnecessary
- Assumes service won't be restarted → downgrade

**Privileged addresses:**
- OOS within privileges: TEE Proposer/Registrar signers, Security Council, Sequencer
- OOS even exceeding: L1 Ethereum validators, third-party bridge validators, Base corporate infra

---

## 7. Submission Gate Pre-Check (bounty-lessons v2.1)

Sebelum submit ANY finding, run:

1. **Gate 1 — Scope check:** Target dalam `src/multiproof/{root, zk, tee}` atau explicit OOS folders?
2. **Gate 2 — OOS pattern check:** Exploit require compromised Base infra / invalid proof / admin-exceeding authority? Cross-check scope-official.md §6 downgrades.
3. **Gate 3 — Validity check:** Real exploitable path w/ runnable Foundry PoC (MANDATORY all severities incl Info).
4. **Gate 4 — Severity math:** Match Impacts in Scope verbatim — `AggregateVerifier bypass` vs `Temp freeze ≥24h` vs `Soundness alert bypass`.
5. **Gate 5 — Audit dup check:** `grep -rn -i "narrow-phrase" multiproof-*/*.txt tee-*/*.txt`. Hit → bounty-lessons skill evaluation (rule h: KILL unless NEW pattern justifies variant).
6. **Gate 5.5 — Optimism upstream check (conditional):** Only if finding touches Kona / Cannon / Fault Proof / Interop / Portal. Otherwise skip (confirmed 0 coverage).
7. **Gate 6 — Deployment state:** N/A (testnet-only contest, no mainnet query needed). But check Sepolia addresses in `contract-deployments/` if finding is config-gated.
8. **(Pattern M addition) Gate 5.6 — Informational upgrade scan:** If hypothesis originated from an auditor Informational finding, is impact chain extension materially different from auditor's scenario? Framing must be "auditor noted X, this extension Y" NOT "auditor got severity wrong".

Bonus: cross-reference `smart-contract-audit-common` + `smart-contract-audit-evm` patterns before finalizing report.

---

## 8. Session Log

### Session 0 — 2026-04-22 (Phase 0 Scope Mapping, ~2h)

**Accomplishments:**
- Captured Immunefi scope: $250K pool, 12 days remaining, 190K nSLOC initial
- Classified caller-constraint: **INCLUSIVE** with downgrade rules
- Generated + ran `setup-base-azul.sh` — 4 repos cloned, optimism sparse-checkout (44 PDFs)
- Generated + ran `extract-audits.sh` — 48 PDFs → 48 TXTs
- **6 recon rounds executed (Pattern R case study):**

| Round | Action | Outcome |
|---|---|---|
| R1 | Repo clone + Optimism sparse | 50 PDFs inventoried |
| R2 | PDF → TXT extraction | Dup-check corpus operational (48 .txt) |
| R3 | Term frequency across Cantina | 3 fresh-ground terms identified: ZKVerifier (0), OptimismPortal2 (0), "intermediate output" (0) |
| R4 | PDF metadata analysis (pdfinfo + word counts) | April multiproof audit confirmed as 5-page fix-verification (1 Info finding) not full audit |
| R5 | Post-audit git diff (Pattern K applied) | **ZKVerifier.sol** identified: 51 LoC, backported commit `01dad23` at Apr 21 16:40 UTC = 3h20m pre-contest (Pattern L) |
| R6 | LoC inventory + nullify call-graph | Target surface narrowed to ~300 LoC (ZKVerifier 51 + Verifier 48 + AggregateVerifier.nullify 60 + intermediate-root layout 100 + finding 3.1.1 variants) |

- **Target space reduction: 190,000 nSLOC → ~300 LoC = 633× focus factor** in ~2h recon
- Drafted 8 patterns (K–R) to `claude-skills/pending-patterns.md` — 849 total lines in file now

**Key analytic decisions:**
- **v1 P1 (AggregateVerifier state machine) demoted to T2 P6** — data shows 151 mentions + Foundry PoC tests in appendix = over-saturated
- **v2 P1 = ZKVerifier.sol full contract** (0 coverage, 51 LoC, backported 3h20m pre-contest)
- **v2 P2 = Verifier.nullify() false-trigger surface** (permanent brick attack ceiling = Critical)
- **v2 P3 = AggregateVerifier.nullify() soundness alert flow** (explicit Impacts-in-Scope High target)
- **v2 P4 = Finding 3.1.1 variant extension** (Pattern M candidate, impact chain already documented by auditor)
- **v2 P5 = Intermediate output roots layout** (fresh Azul feature, 0 audit mentions)

**Status end-of-session:** Phase 0 COMPLETE. Ready Session 1 dispatch.

**Files produced in Phase 0:**
- `bounty-notes/base-azul/README.md`
- `bounty-notes/base-azul/scope-official.md`
- `bounty-notes/base-azul/audit-download-guide.md`
- `bounty-notes/base-azul/base-azul-research-mapping.md` (this file, v2)
- `bounty-notes/base-azul/scripts/setup-base-azul.sh`
- `bounty-notes/base-azul/scripts/extract-audits.sh`
- `bounty-notes/claude-skills/pending-patterns.md` (patterns K–R appended)

### Session 1 — PLANNED (TBD date)

**First Sprint (4-6h, P1 ZKVerifier focused):**

| Hour | Task | Deliverable |
|---|---|---|
| 0:00-0:30 | Full read `zk/ZKVerifier.sol` + `Verifier.sol` + `interfaces/multiproof/IVerifier.sol` + `interfaces/dispute/IAnchorStateRegistry.sol` + `src/dispute/zk/ISP1Verifier.sol` | Complete data-flow diagram |
| 0:30-1:00 | Locate `AggregateVerifier.sol` ZKVerifier call-sites — where imageId/journal/proofBytes originate; check ZK_IMAGE_HASH constant | Call-graph notes |
| 1:00-1:30 | SP1 gateway external dependency research: which gateway deployed on Sepolia? revert semantics? | SP1 integration notes |
| 1:30-2:30 | Attack hypothesis brainstorm (≤5 candidates): forge proof via imageId/journal manip, replay across games, dead-error significance, nullify-based bricking via ZK side, SP1 gateway version/soundness-fix (v6.0.2 req) | Hypothesis list w/ Gate-0 pre-check |
| 2:30-3:30 | For top hypothesis → Gate 1-5 pre-check (scope + OOS + validity + severity + narrow-phrase dup grep) | Keep list trimmed to 2-3 |
| 3:30-5:00 | Top hypothesis PoC sketch in Foundry (clone base/contracts, `forge init` local, write minimal repro) | Draft PoC |
| 5:00-6:00 | Session journal + decision: continue P1 / pivot to P2 (Verifier.nullify) / park and context-switch | Session 1 log entry |

**Second Sprint (4-6h, P2 Verifier.nullify OR P3 soundness alert):**

Continues from Session 1 First Sprint decision point. Same structure.

**Third Sprint (4-6h, P4 Finding 3.1.1 variants OR pivot to P5 intermediate roots):**

Pattern M application on finding 3.1.1. Re-read fix commit `dd587c9a`, generate 3 variant trigger scenarios, Gate-0 each.

---

## 9. Next Session Handoff Template

Copy-paste block untuk fresh chat:

```
Lanjut Base Azul research — resume dari mapping v2.

═══ CONTEXT ═══
- Platform: Immunefi Audit Comp ($250K pool if Critical)
- Stake: $0 | KYC: ❌ pending | PoC: required ALL severities
- Deadline: 4 May 2026 20:00 UTC (~N days remaining)
- Caller constraint: INCLUSIVE w/ downgrade rules active

═══ MASTER MAP ═══
File: C:\Users\USER\bounty-notes\base-azul\base-azul-research-mapping.md
Scope: 4 Cantina audits + 44 Optimism reviews (0 upstream coverage of target contracts)
Target surface: ~300 LoC narrow hunt (from 190K nSLOC initial)
Repos cloned: bounty-notes/base-azul/repos/{base@v0.8.0-rc.15, node, contracts@v8.1.0, contract-deployments}

═══ CURRENT TARGET ═══
Tier 1 P1: zk/ZKVerifier.sol full contract (51 LoC, 0 audit coverage, backported 3h20m pre-contest)
Backup: T1 P2 Verifier.nullify() false-trigger (permanent-brick surface, Critical ceiling)

═══ LAST SESSION ═══
[Paste: last Session Log entry from §8]

═══ TASK ═══
[Spesifik apa yang mau di-gas — e.g., "First Sprint Hour 0-2 per §8 Session 1 plan: read ZKVerifier + map call-sites + hypothesis brainstorm"]

═══ RULES ACTIVE ═══
- HARD LOCK: max 2 submits (high-competition contest), T1 only unless new pattern
- bounty-lessons v2.1 auto-trigger on finding candidate (+ Pattern M Gate 5.6 if Info-upgrade)
- Red hypothesis tidak revisit tanpa NEW pattern (rule h)
- Narrow-phrase dup-check SEBELUM PoC: grep di 4 Cantina .txt (Optimism upstream 0 coverage = skip)
- Soft cap total Base Azul: 5 hari. T1 first sprint: 4-6h max, then decision.

═══ DUP-CHECK COMMAND ═══
grep -rn -i "candidate_phrase" \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/multiproof-*/*.txt \
  /mnt/c/Users/USER/bounty-notes/base-azul/audits-local/tee-*/*.txt

═══ SKILLS TO LOAD ═══
- smart-contract-audit-common (base)
- smart-contract-audit-evm (layer)
- bounty-lessons v2.1 (submit gate)
- Optional: tools-reminder v1.1 (if installing SP1 harness / foundry-based fuzzers)

═══ PATTERNS IN PENDING (validate during hunt if relevant) ═══
K (git-diff), L (temporal), M (Info upgrade), N (circuit-breaker), O (audit-PDF extract),
P (dead-error), Q (PoC appendix), R (case study)

Gas.
```

---

## 10. Quick Reference — Addresses & Key Paths

### Commits

| Item | Commit | Date | Note |
|---|---|---|---|
| Contract scope tag v8.1.0 (= HEAD) | `01dad23` | 2026-04-21 16:40 UTC | "Backport: add verifier contract (#256)" — 🚨 ZKVerifier added here |
| Audit-2 fixes | `ddd5a09` | 2026-04-15 15:09 UTC | Regression only (comment + cert expiration loop) |
| April audit scope | `ffe2af8c` | 2026-04-09 17:11 UTC | AggregateVerifier only |
| March audit fix commit | `dd587c9a` | 2026-03-~25 | Finding 3.1.1 fix (resolve + parent blacklist) |
| March audit scope | `b6c4689b` | 2026-03-~16 | Broad multiproof audit |
| base/base scope tag v0.8.0-rc.15 | `de349fc` | 2026-04-20 23:13 UTC | Offchain Rust scope |

### Sepolia Deployed Addresses

*To be populated from `repos/contract-deployments/` during Session 1. Check `deployments/sepolia/*.json` or similar.*

| Contract | Sepolia Address |
|---|---|
| AggregateVerifier (current impl) | TBD Session 1 |
| TEEVerifier | TBD |
| ZKVerifier | TBD |
| TEEProverRegistry | TBD |
| DelayedWETH | TBD |
| OptimismPortal2 | TBD |
| AnchorStateRegistry | TBD |
| SP1 Verifier Gateway | TBD (check ZKVerifier constructor args) |

### Key Paths

- Master map: `C:\Users\USER\bounty-notes\base-azul\base-azul-research-mapping.md`
- Scope official: `C:\Users\USER\bounty-notes\base-azul\scope-official.md`
- Audits: `C:\Users\USER\bounty-notes\base-azul\audits-local\{multiproof-1,multiproof-2,tee-1,tee-2}/` (4 PDFs + 4 TXTs)
- Optimism corpus: `audits-local\optimism-reviews\optimism\docs\security-reviews\` (44 PDFs + 44 TXTs)
- Source repos: `C:\Users\USER\bounty-notes\base-azul\repos\{base,node,contracts,contract-deployments}\`
- Target files (multiproof):
  - `repos\contracts\src\multiproof\zk\ZKVerifier.sol` (51 LoC) ⭐ P1
  - `repos\contracts\src\multiproof\Verifier.sol` (48 LoC) ⭐ P2
  - `repos\contracts\src\multiproof\AggregateVerifier.sol` (1032 LoC, focus L453/L548-602) ⭐ P3/P4
  - `repos\contracts\src\dispute\AnchorStateRegistry.sol` (gate contract — L162/L225/L269)
- Sessions: `C:\Users\USER\bounty-notes\base-azul\sessions\`
- Findings drafts: `C:\Users\USER\bounty-notes\base-azul\findings\`
- Scripts: `C:\Users\USER\bounty-notes\base-azul\scripts\{setup-base-azul.sh,extract-audits.sh}`

### Key Spec URLs

- https://specs.base.org/upgrades/azul/overview — Azul overview
- https://specs.base.org/upgrades/azul/proofs — Proof system (ALREADY READ, summary in scope-official.md §4)
- https://specs.base.org/upgrades/azul/exec-engine — EL changes (8 EIPs)
- https://docs.base.org/base-chain/node-operators/base-v1-upgrade — operator migration
- https://specs.base.org/llms-full.txt — full LLM context dump

---

## 11. Decision Framework (Timing Caps)

### Pipeline context (split decision TBD per user)

| Program | Status | Deadline | Estimated budget |
|---|---|---|---|
| XRPL Sherlock | ACTIVE (2 Med submitted) | 27 Apr 2026 | 3-4 days remaining |
| Kamino T1P2 | NEXT (post-XRPL) | Open (~4 days work) | 4 days |
| KAST S4 | Cherry-pick | Open (1 day cap) | 1 day |
| **Base Azul** | **Phase 0 COMPLETE** | **4 May 2026** | **4-5 days max** (split pending) |

### Base Azul time-box rules

1. **First Sprint (Session 1) = 4-6h on P1 ZKVerifier.** Decision gate at sprint-end:
   - Finding candidate identified → Gate 1-6 check → if passes → 1-2 day PoC + report → submit
   - No candidate, partial surface explored → continue P1 second sprint (4-6h)
   - No candidate, P1 exhausted → pivot to P2 (Verifier.nullify) same-day, 4-6h
2. **Tier 1 total = 3 days max** (ZKVerifier + nullify surface + soundness flow). No candidate → pivot Tier 2 (1 day) or close chapter.
3. **Tier 2 = 1 day max** (only if T1 exhausted AND time remains).
4. **Tier 3 only dengan NEW pattern** (default skip).
5. **Total soft cap: 5 days. Hard cap: 5.5 days** (reserve 6-12h for report polish + Gate 5.6 Pattern M check if Info-upgrade variant).

### Decision tree at Session 1 end

```
4-6h First Sprint on P1 ZKVerifier complete. Decision:
├── 💎 Candidate found → Gate 1-6 check → PoC → submit (1-2d work) → DONE
├── 🟡 Partial progress, surface still promising → Sprint 2 on P1 (4-6h)
├── 🔴 P1 exhausted, 0 candidate → pivot P2 Verifier.nullify (4-6h)
└── ❌ Both P1+P2 exhausted, 0 candidate → pivot P3 soundness OR P4 Finding 3.1.1 variants
```

---

## 12. Pivot Triggers (Kill Conditions)

Close Base Azul chapter kalau:

- [ ] 5 days research, 0 Medium candidate passes Gate 1–6
- [ ] 2 Medium submissions → rejected → no new hypothesis
- [ ] XRPL / Kamino / KAST S4 workload spillover exceeds allotted days
- [ ] Major mid-contest fix drop that kills active hypothesis (check Discord + program page daily)
- [ ] Public disclosure of private known issue that matches active hypothesis (implies we matched known issue, no credit)
- [ ] User decision: explicit pivot to higher-EV program

---

## 13. Key Lessons from Phase 0 (queued to pending-patterns.md)

**All 8 patterns (K–R) appended to `bounty-notes/claude-skills/pending-patterns.md` as of 2026-04-22.** File now 849 lines, 8 new patterns added via clean block append.

Summary of what Base Azul Phase 0 teaches:

| Pattern | Tier | Core insight |
|---|---|---|
| K | 🔴 HIGH | Post-audit git-diff reveals fresh ground. 190K LoC scope → 51 LoC target via one `git log audit..HEAD` call. |
| L | 🔴 HIGH | Commits landing within 24h of contest-start scope-freeze = almost always under-scrutinized. Especially "Backport"/"add verifier"-type commits. |
| M | 🔴 HIGH | Auditor Informational findings often contain Medium+ impact chains (admin-recovery mitigations may not qualify under platform severity matrix). Extend trigger scenarios, don't challenge severity. |
| N | 🟡 MED | Circuit-breaker patterns (permanent-state nullify with gate) = explicit attack surface. 5 sub-vectors enumerated. |
| O | 🟡 MED | Cantina audit PDF format is extractable via regex. LaTeX+LuaTeX fingerprint identifies template. |
| P | 🟡 MED | Dead error declarations in Solidity = intentional-check-dropped risk signal, especially in fresh (un-audited) files. |
| Q | 🟢 LOW | PoC test code in audit appendix = bicameral review, bumps saturation tier by 1. |
| R | 🟢 LOW | MFD Phase 0 recon efficacy case study. 633× target reduction in ~2h. Template for future programs. |

**Release trigger watch:**
- `bounty-lessons v2.2` = 1 more validated case on Pattern M → ready to ship
- `smart-contract-audit-evm v3.3` = 2 more cases each on Pattern N + P
- `bounty-workflow v2.3` = 2 more cases each on Pattern K + L
- `tools-reminder v1.2` = audit-pdf-meta-extract.sh script work + Spearbit/Zeppelin fingerprints (Optimism corpus has samples already)

**J retired → K-R supersede.** Pattern J ("saturation vs skill-match tradeoff") from v1 was hypothetical; v2 data shows actual method is git-diff + temporal (K+L), which is more actionable and objective than the subjective skill-match calculus J proposed.

---

## Changelog

| Date | Version | Change |
|---|---|---|
| 2026-04-22 | v1 | Initial mapping created. Phase 0 scope gathering complete. 4 scope items captured, 4 prior audits inventoried, 13-priority queue constructed, 5-day soft cap set. Tier 1 P1 = AggregateVerifier (hypothesis-based). |
| 2026-04-22 | **v2** | **Data-driven revision post 6-round recon.** Patterns K+L applied: ZKVerifier.sol identified as Tier 1 P1 (51 LoC, 0 audit, backported 3h20m pre-contest). Section 3 rewritten with verified term frequencies + post-audit git diff + Finding 3.1.1 impact chain. Section 4 priority queue fully revised. Section 5 status matrix populated with actual LoC + target files. Section 6 includes Finding 3.1.1 full text for Pattern M weaponization. Section 8 Session 0 log extended with 6-round recon detail + Pattern R case study reference. Section 9 handoff template updated. Section 10 paths updated with commit table. Section 13 Key Lessons rewritten to reference 8 pending patterns (K–R). 633× target-space reduction achieved (190K → ~300 LoC). |
# ZKVerifier.sol declares `SP1VerificationFailed` error that is never raised, leaving the SP1 trust boundary without a defensive wrapper

**Severity:** Insights
**Target:** `src/multiproof/zk/ZKVerifier.sol:15`
**Commit:** `01dad23` (tag `v8.1.0`)
**Affected contract(s):** `ZkVerifier`

## Summary

`ZkVerifier` declares an `SP1VerificationFailed` error that is never raised anywhere in the contract or elsewhere in the codebase. The `verify()` function calls `SP1_VERIFIER.verifyProof()` directly and returns `true` unconditionally, with no `try`/`catch` wrapper to translate SP1 failures into the declared error. The dead declaration implies the presence of a defensive layer that does not exist, parallel to the unused `L2_CHAIN_ID` immutable variable flagged in audit finding 3.1.3 of the March 2026 Cantina multiproof audit.

## Location

`src/multiproof/zk/ZKVerifier.sol`:

```solidity
contract ZkVerifier is Verifier {
    ISP1Verifier public immutable SP1_VERIFIER;

    /// @notice Thrown when SP1 proof verification reverts.
    error SP1VerificationFailed();                                    // L15, declared

    // ...

    function verify(bytes calldata proofBytes, bytes32 imageId, bytes32 journal)
        external view override notNullified returns (bool)
    {
        SP1_VERIFIER.verifyProof(imageId, abi.encodePacked(journal), proofBytes);
        return true;                                                   // L42, no catch, no wrapper
    }
}
```

Repository-wide grep confirms `SP1VerificationFailed` is declared once and raised zero times:

```
$ grep -rn "SP1VerificationFailed" src/
src/multiproof/zk/ZKVerifier.sol:15:    error SP1VerificationFailed();
```

No `revert SP1VerificationFailed()` or `catch { revert SP1VerificationFailed(); }` exists in the repository.

## Description

The NatSpec on line 14 describes `SP1VerificationFailed` as "Thrown when SP1 proof verification reverts." The implementation does not honor this contract. The `verify()` function delegates to `SP1_VERIFIER.verifyProof()` and returns `true` unconditionally. Failures raised by the SP1 gateway propagate with whatever selector and signature the SP1 implementation raises, not `SP1VerificationFailed.selector`.

Two interpretations explain the divergence between declared error surface and runtime behavior:

1. An earlier revision of the contract wrapped the SP1 call in a `try`/`catch` block and used the error to normalize failure reasons across different SP1 versions. The wrapper was removed before the backport landed, but the error declaration remained.
2. The error was added proactively with intent to wrap, but the wrapper was never implemented.

In either case, the current state presents a contract to the reader that the implementation does not fulfill. Downstream consumers (off-chain indexers, error-selector-based monitoring, custom revert-reason decoders) looking for `SP1VerificationFailed.selector` will never match a revert from `ZkVerifier`.

The parallel to audit finding 3.1.3 (dead `L2_CHAIN_ID` immutable) is exact. The 3.1.3 description reads: *"the presence of an unused immutable variable is misleading, as it suggests proofs are explicitly bound to a specific L2 chain within this contract when they are not."* The same reasoning applies one layer up: the presence of an unused error declaration is misleading, because it suggests SP1 verification failures are handled as a distinct, named failure mode when they are not. Coinbase accepted 3.1.3 as Informational. The `SP1VerificationFailed` case was not reviewed because ZKVerifier.sol was added to the codebase via commit `01dad23` on 2026-04-21 16:40 UTC, 3 hours 20 minutes before contest start, and has no coverage in the four Cantina audits on record.

## Impact

**Code-quality impact:** moderate. Off-chain monitors built against the declared error surface receive no matches. For a contract that sits on the SP1 trust boundary and whose failure mode is the single most important event to alert on, an unreachable named error is a concrete observability gap.

**Security-adjacent impact:** low but non-trivial. Correct behavior of `verify()` depends entirely on SP1 reverting on failure. The deployed SP1 gateway is immutable, so an adversary cannot swap it. However, SP1 verifier gateways in production use selector-based routing (`bytes4` prefix of the proof bytes selects the verifier implementation), and the route table is typically governed by the gateway operator. If the operator routes to an implementation that returns without reverting on an invalid proof (a misconfigured route, a future verifier with different semantics, an emergency admin action during incident response), `ZkVerifier.verify()` returns `true` for arbitrary inputs. A `try`/`catch + revert SP1VerificationFailed()` wrapper would have bounded this risk by enforcing revert semantics at the ZKVerifier layer regardless of SP1 gateway state. As implemented, no such bound exists.

Under current SP1 standard semantics, the silent-acceptance scenario is hypothetical. The gap is narrow but real: the trust boundary at ZKVerifier is thinner than the error surface implies.

## Proof

### Static evidence (primary, conclusive)

Repository-wide grep from the `base/contracts` v8.1.0 checkout:

```
$ cd repos/contracts
$ grep -rn "SP1VerificationFailed" src/
src/multiproof/zk/ZKVerifier.sol:15:    error SP1VerificationFailed();
```

Single match on the declaration line. Zero usages of `revert SP1VerificationFailed()` or `catch { revert SP1VerificationFailed(); }` anywhere in the repository. The declared error has no reachable code path.

This grep is conclusive on its own. `SP1VerificationFailed` exists at the Solidity AST level, no symbol in any contract raises it, and no caller of `ZkVerifier.verify()` receives this selector as a revert reason under any input.

### Dynamic evidence (optional, source attached)

The file `PoC_ZKVerifier_DeadError.t.sol` contains Foundry tests that demonstrate two corollaries of the static proof:

1. `test_SP1VerificationFailed_isUnreachable`: when the SP1 gateway reverts, the revert propagates with the gateway's own error signature, not `SP1VerificationFailed.selector`.
2. `test_silentAcceptance_whenSP1DoesNotRevert`: when the SP1 gateway does not revert (hypothetical misrouted verifier), `verify()` returns `true` for a zero-byte proof with zero `imageId` and zero `journal`, confirming the absence of a defensive layer.
3. `test_staticGrep_noUsageOfDeclaredError`: documentation marker for the static grep step.

Setup and run (requires `base/contracts` Foundry dependencies to be installed):

```
cd repos/contracts
make deps                                    # installs forge-std, sp1-contracts, solady, etc.
mkdir -p test/poc
cp <attached>/PoC_ZKVerifier_DeadError.t.sol test/poc/
forge test --match-contract ZKVerifierDeadErrorTest -vvvv
```

Reproduction is optional. The static grep above is complete proof of the finding.

## Recommendation

Resolve the divergence between declared error surface and runtime behavior. Either option closes the gap.

**Option A: Remove the dead declaration** (aligns declaration with actual behavior):

```solidity
// Delete line 14-15:
// /// @notice Thrown when SP1 proof verification reverts.
// error SP1VerificationFailed();
```

**Option B: Restore the defensive wrapper** (aligns runtime with declared contract):

```solidity
function verify(bytes calldata proofBytes, bytes32 imageId, bytes32 journal)
    external view override notNullified returns (bool)
{
    try SP1_VERIFIER.verifyProof(imageId, abi.encodePacked(journal), proofBytes) {
        return true;
    } catch {
        revert SP1VerificationFailed();
    }
}
```

Option B adds defense in depth: the revert reason seen by `AggregateVerifier._verifyZkProof` and any off-chain observer becomes stable regardless of which SP1 verifier implementation is active on the gateway. This matches the pattern used by the parent `Verifier` abstract where error surfaces are explicitly normalized (`NotProperGame`, `Nullified`).

Option A is the minimal fix if the declared error is confirmed legacy residue.

## References

- `src/multiproof/zk/ZKVerifier.sol` (51 LoC, commit `01dad23`, 2026-04-21 16:40 UTC)
- Cantina Coinbase Multiproof Audit (March 2026), finding 3.1.3 "Inaccurate NatSpec and Dead Code" (parallel reasoning)
- ISP1Verifier interface contract at `src/dispute/zk/ISP1Verifier.sol`
- Parent `Verifier` abstract at `src/multiproof/Verifier.sol` (normalized error surface reference)

## Base Azul — Immunefi #74371 (CONFIRMED 2026-04-22)

- Pattern: P (dead error declaration, no defensive wrapper)
- File: src/multiproof/zk/ZKVerifier.sol:19
- Commit: 01dad23 (tag v8.1.0, backport 3h20m pre-contest)
- Finding: SP1VerificationFailed error declared but never raised
- Severity: Insight (Security Best practices)
- Status: Chief Finding, confirmed by project
- Artifacts: bounty-notes/base-azul/findings/base-azul-pattern-p-report.md
| SKILL-SPLIT-STRATEGY.md | claude-skills/ | Decision doc: kapan dan bagaimana split skill saat approach constraints | Consult saat YAML description > 900 chars OR SKILL.md > 1500 lines |


## 2026-04-24 — Skill Maintenance Session 1

- YAML trimmed 5 skills to ≤850 chars (batch1/solana/common/bounty-workflow/tools-reminder)
- pending-patterns.md: appended R-V (queue 12→17), target `smart-contract-audit-evm`, migrate Session 2 v4.1
- SKILL-SPLIT-STRATEGY.md: added section 4.6 symmetric backup rule + decision log row
- Commits: 7 atomic (5 per-skill + 1 pending + 1 strategy)
- Backup: `bounty-notes/claude-skills/backups/2026-04-24-trim/`
- Release snapshot: `bounty-notes/claude-skills/releases/2026-04-24-trim/`


## 2026-04-24 — Skill Maintenance Session 2 (v4.1 release)

- Migrated 17 patterns (A-V) from pending queue to 6 skill bodies
- smart-contract-audit-evm: +9 patterns (A,B,C,E,R,S,T,U,V)
- smart-contract-audit-common: +2 patterns (D,K)
- bounty-workflow: +4 patterns (G,L full promotion,O,Q)
- bounty-lessons: +1 pattern (Q Gate 3 extension)
- security-research: +1 pattern (F GraphQL)
- batch1-patterns-apr2026: +1 pattern (P as new xrpl-audit-patterns.md reference)
- Queue cleared 17→0, collecting for v4.2 mid-to-late May 2026
- Release snapshot: `bounty-notes/claude-skills/releases/2026-04-24-v4.1/`
- Backup: `bounty-notes/claude-skills/backups/2026-04-24-v4.1-premigration/`
- Commits: 8 atomic (6 per-skill + 1 pending + 1 release note)
