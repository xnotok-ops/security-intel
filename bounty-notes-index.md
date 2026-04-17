\# Bounty Notes Index



Complete catalog of `bounty-notes` (PRIVATE repo). Use this index to identify which files to upload to Claude chat during audit sessions.



\*\*How to use:\*\* Tell Claude "upload \[filename]" → Claude will ask you to upload from `C:\\\\\\\\Users\\\\\\\\USER\\\\\\\\bounty-notes\\\\\\\\\\\\\\\[path]`.



\*\*Last updated:\*\* April 17, 2026



\---



\## References (cross-audit knowledge base)



| File | Path | Description | Use When |

|-|-|-|-|

| invalidation-library.md | references/ | 45 false-positive patterns from The Judge (heavyw8t) | Before submitting any finding — cross-check Gate 5 |

| pashov-attack-vectors.md | references/ | 266 SC attack vectors with D (detection) + FP (false positive) markers | Any SC audit — primary cross-reference |

| pashov-judging.md | references/ | 4-gate finding validation framework (source material) | Calibrating finding severity |

| pashov-threat-profiles.md | references/ | 8 protocol-type threat models (lending, DEX, vault, bridge, governance, stablecoin, derivatives, liquid staking) | Phase 0 — classify protocol type and pick attack vectors |

| plamen-reference-bundle.md | references/ | 8 audit guides: EVM security rules, governance, lending, vault accounting, oracle, signature verification, flash loan, confidence scoring | Protocol-specific deep dive |

| solana-rust-audit-checklist.md | references/ | Solana/Anchor checklist: account validation, CPI safety, Token-2022 extensions, arithmetic, Rust quality (CDSecurity) | Any Solana/Anchor audit |

| web3-bug-classes.md | references/ | 10 DeFi bug classes with real paid examples (shuvonsec) | Pattern cross-reference |

| web3-grep-arsenal.md | references/ | 10 copy-paste grep blocks for SC audit (shuvonsec) | Quick vulnerability scanning |

| audit-reports/index.txt | references/audit-reports/ | Index of downloaded audit reports | Cross-referencing past audits of same protocol |



\### Audit Reports (Solana/Rust — Frank Castle)



| File | Path | Description | Use When |

|-|-|-|-|

| GMX\_Solana\_Zenith.pdf | references/audit-reports/solana/frankcastle/ | GMX Solana Zenith audit (9H/23M/24L) | Perp DEX audits — cross-validate GMX patterns |

| Perena\_Pashov.pdf | references/audit-reports/solana/frankcastle/ | Perena stablecoin+staking (4C/3H/4M/3L) | Stablecoin audits — Midas / SG Forge prep |

| ORO\_Cantina.pdf | references/audit-reports/solana/frankcastle/ | ORO liquid staking + gold trading (11C/1H/5M/3L) | Liquid staking / oracle-heavy audits |

| CoalesceFinance\_Pashov.pdf | references/audit-reports/solana/frankcastle/ | Coalesce Finance (Solend fork, 3H/14M/15L) | Lending patterns (fresh 2025 findings) |

| BTRFI\_Pashov.pdf | references/audit-reports/solana/frankcastle/ | BTRFI staking/voting/vault (5C/2H/5M/13L) | Multi-component staking audits |



\### Exploit Postmortems



| File | Path | Description | Pattern |

|-|-|-|-|

| subquery-sqt-exploit-apr2026.md | references/exploit-postmortems/ | SubQuery SQT staking drain on Base ($128-160K) | Access control on settings/config proxy contract |

| governance-self-delegation-lock.md | references/exploit-postmortems/ | NounsDAO delegation lock (Hexens disclosure) | Governance: delegate(address(0)) locks voting power |

| rhea-finance-near-apr2026.md | references/exploit-postmortems/ | Rhea Finance NEAR $7.6M fake-token oracle (Apr 16 2026) | Fresh pool oracle manipulation, asset registration bypass |

| lootbot-xloot-redeem-apr2026.md | references/exploit-postmortems/ | LootBot xLoot staking redeem $9.6K (Apr 15 2026) | Array loop double-counting via late state update |



\### Tools Tested (evaluation records)



| File | Path | Description | Status |

|-|-|-|-|

| txanalyzer-test-plan.md | references/tools-tested/ | TxAnalyzer evaluation: 3 test cases (LootBot, HB Token, XBIT), KEEP/ARCHIVE decision criteria | Pending test (post-Apr 27) |





\---



\## Claude Skills (uploaded to Claude.ai Settings)



| File | Path | Version | Description |

|-|-|-|-|

| bounty-workflow/SKILL.md | claude-skills/bounty-workflow/ | v1.5 | Phase 0 router: scope → triage → dispatch (SC/Web/Hybrid) |

| smart-contract-audit/SKILL.md | claude-skills/smart-contract-audit/ | v3.2 | Full SC audit: EVM/Solana/TON/Sui/Vyper, multi-expert 3-round, AI tools |

| bounty-lessons/SKILL.md | claude-skills/bounty-lessons/ | v1.2 | Report quality, rejection history, Gate 5 invalidation, pre-submit |

| security-research/SKILL.md | claude-skills/security-research/ | latest | Web/API: recon, IDOR, SSRF, JWT, GraphQL, smuggling, cache poison |

| ffuf-web-fuzzing/SKILL.md | claude-skills/ffuf-web-fuzzing/ | latest | ffuf usage: dir/file, subdomain, parameter, authenticated fuzzing |

| blockchain-forensics.md | claude-skills/ | v1.0 | On-chain investigation, exploit tracing, fund flow |

| tiny-auditor.md | claude-skills/ | v1.0 | Phase 0 quick gate: WORTH DEEP DIVE / SKIP / BORDERLINE |
| pending-patterns.md | claude-skills/ | — | Pattern queue for next skill update batch (release target: mid-May 2026) |





\---



\## Active / Submitted Programs



| Folder | Platform | Type | Status | Key Files |

|-|-|-|-|-|

| xrpl-sherlock/ | Sherlock | SC (C++) | ACTIVE — 2 Med submitted, deadline Apr 27 | xrpl-session-apr17.md, dynamic-tests/ |

| btse/ | HackenProof | Web/API | PAUSED (2 reports submitted, waiting response) | BTSE-AUDIT-COMPLETE.md, BTSE-nonce-replay-report.md |

| midas/ | Cantina | SC | IN REVIEW (Finding #115) | MIDAS-FINDINGS.md |

| cronos-zkevm/ | HackenProof | SC | SUBMITTED | cronos-zkevm-FINDINGS.md |

| zest/ | — | SC | SUBMITTED | zest-bounty-notes.md, zest-report-HIGH-final.md |

| sherlock-clear-macro/ | Sherlock | SC | SUBMITTED (1 Med, waiting judge) | FINDING-001-macro-not-in-digest.md |



\---



\## xrpl-sherlock/ — Ripple XRPL Audit Contest ($550K)



\*\*Status:\*\* ACTIVE — 2 Medium submitted, waiting for judging, deadline Apr 27 2026



\*\*Platform:\*\* Sherlock | \*\*Chain:\*\* XRP Ledger | \*\*Lang:\*\* C++, C | \*\*Repo:\*\* github.com/XRPLF/rippled (contest branch)



\*\*Scope:\*\* Batch, Permission Delegation, MPT DEX, Confidential Transfers, Sponsored Fees, Reserves



\### Submitted findings

\- #1 — MPT DEX `lsfMPTCanTrade` bypass (Medium)

\- #2 — Batch × SponsoredFees `RequireSign` bypass (Medium, PoC confirmed)



\### Research status

\*\*EXHAUSTIVE\*\* — static analysis (all 5 feature areas) + dynamic testing round 1 \& 2 + design-flaw angles evaluated.



\### Files

\- `xrpl-sherlock-rampup.md` — Pre-research, architecture notes

\- `xrpl-exploration-findings.md` — Early exploration leads

\- `xrpl-final-summary-apr15.md` — Static analysis final summary (superseded by apr16)

\- `xrpl-final-summary-apr16.md` — Post-static + dynamic summary (2 Med submitted)

\- `xrpl-session-apr15.md` — Static analysis session

\- `xrpl-session-apr16.md` — OfferCreate+CT static clean, HybridxBatch dynamic tests pass

\- `xrpl-session-apr17.md` — Round 2 dynamic testing — 9 test cases, 0 findings

\- `xrpl-offercreate-deepread-apr15.md` — OfferCreate applyHybrid 934 LOC deep read

\- `xrpl-diff-analysis.md` — Diff vs upstream rippled

\- `mpt-crypto-audit-findings.md` — mpt-crypto ZK library review

\- `batch-fix-verification-guide.md` — Batch patch verification

\- `dynamic-tests/XRPLContest\\\\\\\_test\\\\\\\_v5.cpp` — Final 9-case test file

\- `dynamic-tests/round2-final-results.log` — Full test run output, 0 failures

\- `wsl-backup/`, `wsl-backup-20260417/` — XRPL test code backups from WSL

\- `HybridBatch\\\\\\\_test.cpp` — Earlier test skeleton

\- `sherlock-report-sponsor-bypass.md`, `sherlock-xrpl-finding-checkcreate-cantrade.md` — Submission reports



\### Round 2 dynamic tests (Apr 17, all PASS)

\- R2-1: Batch × Sponsor × Delegation triple combo → correctly rejected (Batch notDelegable)

\- R2-2: Permission escalation via granular sandbox → 4 sub-attacks blocked (flag/limit/field)

\- R2-3: MPT DEX cross-domain offer isolation → enforced



\### Killed leads (for future reference)

\- Credential/Domain delegable griefing — contest README excludes (issuer = trusted)

\- Stale domain offer — OfferStream re-verifies at stream time

\- Account-in-domain credential expiry bypass — `accountInDomain` calls `checkExpired()`

\- sfAdditionalBooks atomic delete — OfferHelpers iterates all book dirs

\- AccountDelete cascade to PermissionedDomain — owner dir blocks



\---



\## Completed / Parked Programs



| Folder | Platform | Type | Status | Key Files | Lesson |

|-|-|-|-|-|-|

| allbridge/ | — | SC+Web | DONE | ALLBRIDGE-INTEL.md, FINDINGS.md, WEB-ATTACK-CHECKLIST.md, 3x PoC .t.sol | Has PoC exploits |

| autofinance/ | Remedy | SC | PARKED (2026-04-13) | STATUS.md, AUDIT-PHASE1-ANALYSIS.md | Extensively audited already — 7 leads killed |

| bitmart/ | — | Web | DONE | BITMART-AUDIT-SUMMARY.md | — |

| calyx/ | — | SC | DONE | AUDIT-SUMMARY.md | — |

| cetus/ | HackenProof | Web | PARKED (all 6 vectors exhausted) | CETUS-WEB-AUDIT-COMPLETE.md, CETUS-WEB-AUDIT.md | CETUSW-6 rejection: domain-restricted API key |

| coinstore/ | — | Web | DONE (2x) | confirm\_replay.py, poc\_replay.txt | Replay PoC |

| cronos-sc/ | HackenProof | SC | DONE | CRONOS-SC-AUDIT.md | — |

| dexalot/ | — | SC | PARKED (2x deep dive, 0 findings) | AUDIT-SUMMARY.md, DEXALOT-REPORT.md, SimplifiedExploit.t.sol, SimplifiedOmniVault.sol | Skip future rounds |

| Dexalot-removeAuction/ | — | SC | DONE | README.md, RESULT.md | — |

| ethereum-foundation/ | HackenProof/EF | SC | DONE (0 findings) | AA-ERC4337-RESEARCH.md | — |

| flipcash/ | — | — | DONE | SUMMARY.md | — |

| kite-ai/ | — | SC | DONE | KITE-AI-BOUNTY-NOTES.md, 4x .json (contract ABIs) | — |

| layerzero-stellar-c4/ | Code4rena | SC (Rust/Stellar) | DONE | SUMMARY.md | — |

| monday-trade/ | — | — | DONE | SUMMARY.md | — |

| Moonwell/ | — | SC | ARCHIVED | moonwell-archive.md | — |

| NEAR-Intents/ | HackenProof | Web | PARKED | FINDINGS.md, NEAR-INTENTS-ATTACK-CHECKLIST.md, NEAR-INTENTS-AUDIT.md | — |

| NEAR-Intents-SC/ | HackenProof | SC | PARKED | NEAR-INTENTS-SC-AUDIT.md, NEAR-INTENTS-SC-ATTACK-CHECKLIST.md, STATUS.md | — |

| polymarket-cantina/ | Cantina | SC | CLOSED (2026-04-16, 0 findings) | notes/polymarket-research-summary.md, poc/FeeModuleExploit.t.sol | Operator-centric trust model = OOS |

| pumb/ | — | Web | PARKED (auth butuh local identity) | PUMB-INTEL-ARCHIVE.md | — |

| superfluid/ | Sherlock | SC | PARKED (0 findings) | superfluid-clearmacro-notes.md | — |

| superfluid-clearmacro/ | Sherlock | SC | PARKED (0 findings, 11 vectors dead) | SUPERFLUID-CLEARMACRO-AUDIT.md | Clean codebase, well-designed EIP-712 + nonce |

| clear-macro-by-superfluid/ | Sherlock | SC | PARKED | CLEAR-MACRO-INTEL.md, FINDINGS-LEADS.md | — |

| symbiotic/ | — | SC | DONE | AUDIT-CHECKLIST.md, FINDINGS.md, README.md | — |

| tropykus/ | Immunefi | SC | PARKED (0 findings, 2026-04-15) | STATUS.md | Custom code deprecated, active = vanilla Compound V2 |

| usdfc/ | Remedy | SC | PARKED (2026-04-13) | USDFC-AUDIT-NOTES.md | Liquity v1 fork on Filecoin FVM |

| whitechain-bridge/ | — | SC | DONE | SUMMARY.md | — |

| amlbot/ | — | Intel only | DONE | AUDIT-SUMMARY.md | Intel-only, no bounty |



\---



\## Research / Pattern Notes



| Folder | Type | Key Files | Patterns Covered |

|-|-|-|-|

| glow-finance/ | SC research | GLOW-FINANCE-RESEARCH.md, PATTERNS-MARGIN-LENDING.md | Margin lending protocol patterns |

| gmtrade/ | SC research | GMTRADE-RESEARCH.md, PERP-DEX-PATTERNS.md | Perp DEX patterns (GMX-style) |

| intuition/ | SC research | INTUITION-RESEARCH.md, PATTERNS-BONDING-CURVE-EMISSIONS.md | Bonding curve + emissions patterns |

| legion/ | SC research | LEGION-RESEARCH.md, PATTERNS-TOKEN-SALE-VESTING.md | Token sale + vesting patterns |

| renegade/ | SC research | RENEGADE-RESEARCH.md | Dark pool / MPC protocols |

| synfutures/ | SC research | synfutures-research.md | Perp DEX (order book style) |

| ton-foundation/ | SC research | ton-foundation-audit.md | TON/FunC patterns |



\---



\## Patterns \& Tools



| File/Folder | Description |

|-|-|

| patterns/VULNERABILITY\_CHECKLIST.md | Master vulnerability checklist |

| patterns/claude-code/ | Claude Code security research (11 files): bash injection, MCP, path validation, webfetch, permissions |

| patterns-lending-strategy.md | Lending protocol attack strategy |

| wallet-telegram.md | Telegram wallet security notes |

| tools-to-setup.txt | \*\*Categorized tools catalog\*\* — Recon, JS/Secrets, GitHub, Web Fuzzing, GraphQL, SC Fuzzing, TX Analysis, MCP. Status markers: \[PENDING] / \[INSTALLED] / \[ONLINE] / \[CLONED] + install commands + use case triggers. Mirror summary: `security-intel/tools-catalog.md`. |

| CHAT-HISTORY-SUMMARY-APR2026.md | Chat history summary for context continuity |



\---



\## Quick Lookup by Protocol Type



Need to audit a specific protocol type? Upload these files:



| Protocol Type | Upload These |

|-|-|

| EVM/Solidity (generic) | pashov-attack-vectors.md |

| Solana/Anchor | solana-rust-audit-checklist.md |

| Solana/Rust (real audit reports) | frankcastle/\*.pdf (GMX/Perena/ORO/Coalesce/BTRFI) |

| Lending/Borrowing | plamen-reference-bundle.md (Part 3), PATTERNS-MARGIN-LENDING.md, frankcastle/CoalesceFinance\_Pashov.pdf |

| Perp DEX | PERP-DEX-PATTERNS.md, gmtrade/GMTRADE-RESEARCH.md, frankcastle/GMX\_Solana\_Zenith.pdf |

| Vault/ERC4626 | plamen-reference-bundle.md (Part 4) |

| Governance/DAO | plamen-reference-bundle.md (Part 2), governance-self-delegation-lock.md |

| Oracle | plamen-reference-bundle.md (Part 5), rhea-finance-near-apr2026.md |

| Bridge | pashov-threat-profiles.md (Bridge section) |

| Token sale/Vesting | PATTERNS-TOKEN-SALE-VESTING.md |

| Bonding curve | PATTERNS-BONDING-CURVE-EMISSIONS.md |

| Stablecoin | pashov-threat-profiles.md (Stablecoin), frankcastle/Perena\_Pashov.pdf |

| Liquid Staking | frankcastle/ORO\_Cantina.pdf |

| Staking (general) | frankcastle/BTRFI\_Pashov.pdf, subquery-sqt-exploit-apr2026.md, lootbot-xloot-redeem-apr2026.md |

| Batch operations / Array input | lootbot-xloot-redeem-apr2026.md |

| TON/FunC | ton-foundation-audit.md |

| XRPL (C++/Rippled) | xrpl-sherlock/ (rampup + final-summary-apr16 + session-apr17) |

| Before submit (any) | invalidation-library.md |
| Attack TX RCA test plan | txanalyzer-test-plan.md, plus local tool at C:\\Users\\USER\\TxAnalyzer |

