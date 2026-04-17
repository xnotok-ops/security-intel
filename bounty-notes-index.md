# Bounty Notes Index

Complete catalog of `bounty-notes` (PRIVATE repo). Use this index to identify which files to upload to Claude chat during audit sessions.

**How to use:** Tell Claude "upload \[filename]" → Claude will ask you to upload from `C:\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Users\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\USER\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\bounty-notes\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\[path]`.

Last updated: April 12, 2026

\---

## References (cross-audit knowledge base)

|File|Path|Description|Use When|
|-|-|-|-|
|invalidation-library.md|references/|45 false-positive patterns from The Judge (heavyw8t)|Before submitting any finding — cross-check Gate 5|
|pashov-attack-vectors.md|references/|266 SC attack vectors with D (detection) + FP (false positive) markers|Any SC audit — primary cross-reference|
|pashov-judging.md|references/|4-gate finding validation framework (source material)|Calibrating finding severity|
|pashov-threat-profiles.md|references/|8 protocol-type threat models (lending, DEX, vault, bridge, governance, stablecoin, derivatives, liquid staking)|Phase 0 — classify protocol type and pick attack vectors|
|plamen-reference-bundle.md|references/|8 audit guides: EVM security rules, governance, lending, vault accounting, oracle, signature verification, flash loan, confidence scoring|Protocol-specific deep dive|
|solana-rust-audit-checklist.md|references/|Solana/Anchor checklist: account validation, CPI safety, Token-2022 extensions, arithmetic, Rust quality (CDSecurity)|Any Solana/Anchor audit|
|audit-reports/index.txt|references/audit-reports/|Index of downloaded audit reports|Cross-referencing past audits of same protocol|

### Exploit Postmortems

|File|Path|Description|Pattern|
|-|-|-|-|
|subquery-sqt-exploit-apr2026.md|references/exploit-postmortems/|SubQuery SQT staking drain on Base ($128-160K)|Access control on settings/config proxy contract|
|governance-self-delegation-lock.md|references/exploit-postmortems/|NounsDAO delegation lock (Hexens disclosure)|Governance: delegate(address(0)) locks voting power|

\---

## Claude Skills (uploaded to Claude.ai Settings)

|File|Path|Version|Description|
|-|-|-|-|
|bounty-workflow/SKILL.md|claude-skills/bounty-workflow/|v1.5|Phase 0 router: scope → triage → dispatch (SC/Web/Hybrid)|
|smart-contract-audit/SKILL.md|claude-skills/smart-contract-audit/|v3.2|Full SC audit: EVM/Solana/TON/Sui/Vyper, multi-expert 3-round, AI tools|
|bounty-lessons/SKILL.md|claude-skills/bounty-lessons/|v1.2|Report quality, rejection history, Gate 5 invalidation, pre-submit|
|security-research/SKILL.md|claude-skills/security-research/|latest|Web/API: recon, IDOR, SSRF, JWT, GraphQL, smuggling, cache poison|
|ffuf-web-fuzzing/SKILL.md|claude-skills/ffuf-web-fuzzing/|latest|ffuf usage: dir/file, subdomain, parameter, authenticated fuzzing|
|blockchain-forensics.md|claude-skills/|v1.0|On-chain investigation, exploit tracing, fund flow|
|tiny-auditor.md|claude-skills/|v1.0|Phase 0 quick gate: WORTH DEEP DIVE / SKIP / BORDERLINE|

\---

## Active / Submitted Programs

|Folder|Platform|Type|Status|Key Files|
|-|-|-|-|-|
|btse/|HackenProof|Web/API|PAUSED (2 reports submitted, waiting response)|BTSE-AUDIT-COMPLETE.md, BTSE-nonce-replay-report.md, btse-nonce-replay-test-v3.py|
|midas/|Cantina|SC|IN REVIEW|MIDAS-FINDINGS.md|
|cronos-zkevm/|HackenProof|SC|SUBMITTED|cronos-zkevm-FINDINGS.md|
|zest/|—|SC|SUBMITTED|zest-bounty-notes.md, zest-report-HIGH-final.md|

\---

## Completed / Parked Programs

|Folder|Platform|Type|Status|Key Files|Lesson|
|-|-|-|-|-|-|
|allbridge/|—|SC+Web|DONE|ALLBRIDGE-INTEL.md, FINDINGS.md, WEB-ATTACK-CHECKLIST.md, 3x PoC .t.sol|Has PoC exploits|
|bitmart/|—|Web|DONE|BITMART-AUDIT-SUMMARY.md|—|
|calyx/|—|SC|DONE|AUDIT-SUMMARY.md|—|
|cetus/|HackenProof|Web|PARKED (all 6 vectors exhausted)|CETUS-WEB-AUDIT-COMPLETE.md, CETUS-WEB-AUDIT.md|CETUSW-6 rejection: domain-restricted API key|
|coinstore/|—|Web|DONE (2x)|confirm\_replay.py, poc\_replay.txt|Replay PoC|
|cronos-sc/|HackenProof|SC|DONE|CRONOS-SC-AUDIT.md|—|
|dexalot/|—|SC|PARKED (2x deep dive, 0 findings)|AUDIT-SUMMARY.md, DEXALOT-REPORT.md, SimplifiedExploit.t.sol, SimplifiedOmniVault.sol|Skip future rounds|
|Dexalot-removeAuction/|—|SC|DONE|README.md, RESULT.md|—|
|ethereum-foundation/|HackenProof/EF|SC|DONE (0 findings)|AA-ERC4337-RESEARCH.md|—|
|flipcash/|—|—|DONE|SUMMARY.md|—|
|kite-ai/|—|SC|DONE|KITE-AI-BOUNTY-NOTES.md, 4x .json (contract ABIs)|—|
|layerzero-stellar-c4/|Code4rena|SC (Rust/Stellar)|DONE|SUMMARY.md|—|
|monday-trade/|—|—|DONE|SUMMARY.md|—|
|Moonwell/|—|SC|ARCHIVED|moonwell-archive.md|—|
|NEAR-Intents/|HackenProof|Web|PARKED|FINDINGS.md, NEAR-INTENTS-ATTACK-CHECKLIST.md, NEAR-INTENTS-AUDIT.md|—|
|NEAR-Intents-SC/|HackenProof|SC|PARKED|NEAR-INTENTS-SC-AUDIT.md, NEAR-INTENTS-SC-ATTACK-CHECKLIST.md, STATUS.md|—|
|pumb/|—|Web|PARKED (auth butuh local identity)|PUMB-INTEL-ARCHIVE.md|—|
|superfluid/|Sherlock|SC|PARKED (0 findings)|superfluid-clearmacro-notes.md|—|
|superfluid-clearmacro/|Sherlock|SC|PARKED (0 findings, 11 vectors dead)|SUPERFLUID-CLEARMACRO-AUDIT.md|Clean codebase, well-designed EIP-712 + nonce|
|clear-macro-by-superfluid/|Sherlock|SC|PARKED|CLEAR-MACRO-INTEL.md, FINDINGS-LEADS.md|—|
|symbiotic/|—|SC|DONE|AUDIT-CHECKLIST.md, FINDINGS.md, README.md|—|
|whitechain-bridge/|—|SC|DONE|SUMMARY.md|—|
|amlbot/|—|Intel only|DONE|AUDIT-SUMMARY.md|Intel-only, no bounty|

\---

## Research / Pattern Notes

|Folder|Type|Key Files|Patterns Covered|
|-|-|-|-|
|glow-finance/|SC research|GLOW-FINANCE-RESEARCH.md, PATTERNS-MARGIN-LENDING.md|Margin lending protocol patterns|
|gmtrade/|SC research|GMTRADE-RESEARCH.md, PERP-DEX-PATTERNS.md|Perp DEX patterns (GMX-style)|
|intuition/|SC research|INTUITION-RESEARCH.md, PATTERNS-BONDING-CURVE-EMISSIONS.md|Bonding curve + emissions patterns|
|legion/|SC research|LEGION-RESEARCH.md, PATTERNS-TOKEN-SALE-VESTING.md|Token sale + vesting patterns|
|renegade/|SC research|RENEGADE-RESEARCH.md|Dark pool / MPC protocols|
|synfutures/|SC research|synfutures-research.md|Perp DEX (order book style)|
|ton-foundation/|SC research|ton-foundation-audit.md|TON/FunC patterns|

\---

## Patterns \& Tools

|File/Folder|Description|
|-|-|
|patterns/VULNERABILITY\_CHECKLIST.md|Master vulnerability checklist|
|patterns/claude-code/|Claude Code security research (11 files): bash injection, MCP, path validation, webfetch, permissions|
|patterns-lending-strategy.md|Lending protocol attack strategy|
|wallet-telegram.md|Telegram wallet security notes|
|tools-to-setup.txt|Pending tools: jsmon, JS-Tap, DeadDrop, Osmedeus, H1 MCP Server|
|CHAT-HISTORY-SUMMARY-APR2026.md|Chat history summary for context continuity|

\---

## Quick Lookup by Protocol Type

Need to audit a specific protocol type? Upload these files:

|Protocol Type|Upload These|
|-|-|
|**EVM/Solidity (generic)**|pashov-attack-vectors.md|
|**Solana/Anchor**|solana-rust-audit-checklist.md|
|**Lending/Borrowing**|plamen-reference-bundle.md (Part 3), PATTERNS-MARGIN-LENDING.md|
|**Perp DEX**|PERP-DEX-PATTERNS.md, gmtrade/GMTRADE-RESEARCH.md|
|**Vault/ERC4626**|plamen-reference-bundle.md (Part 4)|
|**Governance/DAO**|plamen-reference-bundle.md (Part 2), governance-self-delegation-lock.md|
|**Oracle**|plamen-reference-bundle.md (Part 5)|
|**Bridge**|pashov-threat-profiles.md (Bridge section)|
|**Token sale/Vesting**|PATTERNS-TOKEN-SALE-VESTING.md|
|**Bonding curve**|PATTERNS-BONDING-CURVE-EMISSIONS.md|
|**TON/FunC**|ton-foundation-audit.md|
|**Before submit (any)**|invalidation-library.md|
|**Staking exploit ref**|subquery-sqt-exploit-apr2026.md|

web3-bug-classes.md - references/ - 10 DeFi bug classes with real paid examples (shuvonsec)
web3-grep-arsenal.md - references/ - 10 copy-paste grep blocks for SC audit (shuvonsec)
web3-bug-classes.md - references/ - 10 DeFi bug classes with real paid examples (shuvonsec)
web3-grep-arsenal.md - references/ - 10 copy-paste grep blocks for SC audit (shuvonsec)



\## usdfc/

\- \*\*Status:\*\* PARKED

\- \*\*Platform:\*\* Remedy (r.xyz)

\- \*\*Target:\*\* USDFC stablecoin — Liquity v1 fork on Filecoin (FVM)

\- \*\*Files:\*\* USDFC-AUDIT-NOTES.md

\- \*\*Date:\*\* 2026-04-13



\## xrpl-sherlock (Active — Waiting for contest publish)

\- Platform: Sherlock

\- Target: Ripple XRPL Feature Unlock ($550K)

\- Scope: Batch, PermissionDelegation, MPT DEX, Confidential Transfers, Sponsored Fees, Reserves

\- Files: xrpl-sherlock-rampup.md, xrpl-exploration-findings.md

\- Status: Pre-research done, waiting for contest page to go live

\- Key lead: Batch signer validation early return (same pattern as Feb 2026 critical)



## sherlock-clear-macro/

* FINDING-001-macro-not-in-digest.md - Medium: macro address not in EIP-712 digest (SUBMITTED, waiting judging)

# Append this to bounty-notes-index.md in security-intel repo

## autofinance/ — PARKED

* **Platform:** Remedy (r.xyz) | **Chain:** Ethereum | **Solidity 0.8.17**
* **Repo:** github.com/Tokemak/v2-core-pub
* **Rewards:** $1K-$250K | **AUM:** \~$130M
* **Status:** PARKED — Low ROI after deep dive (2026-04-13)
* **Files:**

  * `STATUS.md` — Status summary, reason for park, leads killed
  * `AUDIT-PHASE1-ANALYSIS.md` — Full structure analysis, architecture, attack leads, Phase 2 results
* **Notes:** Extensively audited (Sherlock/Hats/Omniscia/Quantstamp/Certora). OOS list massive. 86 participants, 5 payouts. All 7 leads investigated and killed. Revisit only for strategy verification (Critical-only) or web app scope.
xrpl-ledger/ - Sherlock Apr 2026 ($550K), 5 features, C++/C, research summary + 5 finding docs

  * sherlock-xrpl/xrpl-session-apr15.md - Apr 15 session: all static leads exhausted
* `sherlock-xrpl/xrpl-offercreate-deepread-apr15.md`  OfferCreate/applyHybrid deep read, 6 leads (all dead), architecture notes MPT-DEX + hybrid offers + invariant system



## sherlock-xrpl/ (COMPLETE)

* \- xrpl-final-summary-apr15.md — FINAL: all sessions compiled, 2 Med submitted, \~90% coverage
* \- xrpl-offercreate-deepread-apr15.md — OfferCreate applyHybrid 934 LOC deep read
* \- xrpl-session-apr15.md — Static analysis session summary
* 
* \## xrpl-ledger/ (reference)
* \- batch-fix-verification-guide.md
* \- mpt-crypto-audit-findings.md
* \- xrpl-diff-analysis.md
* \- xrpl-exploration-findings.md
* \- xrpl-sherlock-rampup.md
* \- xrpl-sherlock-research-summary.md



### tropykus/

* \- \*\*Platform:\*\* Immunefi
* \- \*\*Status:\*\* PARKED — 0 findings, all candidates dead
* \- \*\*Date:\*\* April 15, 2026
* \- \*\*Type:\*\* Smart Contract (Compound V2 fork, Solidity 0.5.16, Rootstock/RSK)
* \- \*\*Rewards:\*\* Critical $20K-$100K | High $3K-$20K | Med $3K | Low $1K
* \- \*\*TVL:\*\* \~$10.92M
* \- \*\*Files:\*\* STATUS.md
* \- \*\*Notes:\*\* Custom code (Hurricane model, subsidyFund) all deprecated + OOS. Active = vanilla Compound V2. 6 candidates evaluated, all failed gate check.

  * sherlock-xrpl/xrpl-session-apr16.md - Apr 16: OfferCreate+CT static clean, HybridxBatch dynamic tests pass
  * sherlock-xrpl/HybridBatch\_test.cpp - XRPL test skeleton for future dynamic investigations



### sherlock-xrpl/ — XRPL Sherlock Contest (Apr 13-27, 2026, $550K)

* \- \*\*Status:\*\* 2 Medium submitted \& critique-passed, monitoring mode (static+dynamic exhausted)
* \- \*\*Final summary:\*\* `sherlock-xrpl/xrpl-final-summary-apr16.md` (supersedes apr15)
* \- \*\*Dynamic tests:\*\* `sherlock-xrpl/XRPLContest\\\\\\\_test-v7.cpp` (MaxAmount enforcement, 6 test cases)
* \- \*\*Submissions:\*\* Med #1 MPT DEX `lsfMPTCanTrade` bypass, Med #2 Batch×SponsoredFees `RequireSign` bypass



## polymarket-cantina/ (ACTIVE)

* 
* \- \*\*Status\*\*: Phase 1 Intel — started 2026-04-16
* \- \*\*Platform\*\*: Cantina bug bounty (continuous, not time-boxed)
* \- \*\*Chain\*\*: Polygon PoS (137)
* \- \*\*Pool\*\*: $5M max Critical, $500K High, $50K Medium, $5K Low
* \- \*\*Deposit\*\*: $5/submit (anti-spam, refundable on valid)
* \- \*\*Competition\*\*: 157 findings in 3 days (crowded field)
* \- \*\*Start date (program)\*\*: 2026-04-13
* 
* \### Files
* \- `README.md` — program overview, reward pool, economics, competition snapshot
* \- `scope.md` — 22 in-scope contracts tiered A/B/C/D + OOS landmines + severity examples
* \- `attack-vectors.md` — P0-P5 priority with specific check items and $-anchors
* \- `TODO.md` — Phase 1 checklist (setup → source → audits → arch → solodit → cantina platform → onchain)
* \- `findings/` — finding drafts (empty initially)
* \- `prior-audits/` — downloaded PDFs from ctf-exchange-v2/audits (Phase 1.2)
* \- `repos/` — cloned GitHub repos: ctf-exchange-v2, ctf-exchange (V1), collateral, neg-risk
* \- `notes/` — session logs + architecture maps
* 
* \### Key intel
* \- Past exploit: Mar 25, 2025 UMA governance attack ($7M market) — \*\*OOS angle\*\*, not SC bug
* \- MEV/front-running strictly prohibited (rules section)
* \- Known issues: unfixed audits at github.com/Polymarket/ctf-exchange-v2/tree/main/audits — MUST READ
* \- Dupe filter: Immunefi also runs Polymarket program — dupes OOS
* 
* \### Next action
* \- User to clone repos + download audit PDFs → Phase 1.1-1.2


### polymarket-cantina/
* 
* Platform: Cantina (continuous bounty)
* Status: CLOSED — 0 findings, cut losses after 7 files reviewed
* Date: April 16, 2026
* Type: Smart Contract (Solidity 0.8.15/0.8.30/0.8.34, Polygon PoS)
* Rewards: Critical $5M | High $500K | Med $50K | Low $5K
* Competition: 118+ findings in 5 days
* Files: notes/polymarket-research-summary.md, poc/FeeModuleExploit.t.sol (not submitted)
* Audits reviewed: ChainSecurity Exchange (2022), Cantina/Quantstamp CTFExchangeV2 fix-review (2026-03-25)
* Contracts reviewed: FeeModule, CalculatorHelper, CollateralToken (pUSD), CollateralOnramp, CollateralOfframp, CtfCollateralAdapter, CTFExchange V1+V2, Hashing, Trading, NonceManager, Structs
* Key insight: Operator-centric trust model (documented in audit) = any operator-param-abuse finding is OOS. V2 removed NonceManager entirely. pUSD ecosystem uses Solady modern patterns, heavily hardened. Callback reentrancy dead (all callers hardcode address(0)).
* Lessons: Read audit reports BEFORE code deep-dive. Gate 3 (unprivileged trigger) is make-or-break for operator-centric protocols.

