# Bounty Notes Index

Complete catalog of `bounty-notes` (PRIVATE repo). Use this index to identify which files to upload to Claude chat during audit sessions.

**How to use:** Tell Claude "upload \[filename]" → Claude will ask you to upload from `C:\\\\Users\\\\USER\\\\bounty-notes\\\\\\\[path]`.

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

