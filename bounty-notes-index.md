# Bounty Notes Index

Complete catalog of `bounty-notes` (PRIVATE repo at `C:\Users\USER\bounty-notes`). Use this index to identify which files to upload to Claude chat during audit sessions.

**How to use:** Tell Claude "upload [filename]" → Claude will ask you to upload from `C:\Users\USER\bounty-notes\[path]`.

**Last updated:** April 19, 2026

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
