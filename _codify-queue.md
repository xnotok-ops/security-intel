
## [2026-05-15] — Aave Immunefi — Certora Overview Section = Pattern AS Source
- **DEFINITION:** Audit "Protocol Overview" / "Project Overview" descriptive sections may explicitly describe DESIGN CAVEATS that constitute acknowledged-as-design behavior per §8.4 (or equivalent unfixed-vulnerability rule).
- **INSTANCE:** sGHO Certora 2025-09-09 line 86 — "The vault works on a first-come-first-served basis as the contract might not have enough GHO balance to support all withdrawals with their interest included." Kills auditor's "unfunded yield drain" T1A [85] finding.
- **DETECTION:** grep audit overview/intro sections for: `first.come.first.served`, `may not have enough`, `design limitation`, `intended behavior`, `by design`. Pattern AS scan must INCLUDE overview section, tidak hanya Findings section.
- **ROUTING:** bounty-pre-submit Gate 4 (Pattern AS) — must include OVERVIEW section grep, not just FINDINGS.
- **KILL ratio:** 1/1 this session (T1A [85]).
- **ACTION:** Codify to bounty-pre-submit v1.5 Gate 4 expansion.

## [2026-05-15] — Aave Immunefi — Auditor Strong-Signal Has Old Audit Precedent
- **DEFINITION:** Phase 0.7 auditor's high-confidence finding (≥80) can match a flagged issue from older audit (2+ years back) that team chose NOT to fix. Auditor's confidence doesn't bypass Pattern AS check.
- **INSTANCE:** solidity-auditor [80] "GhoReserve missing `_disableInitializers`" (5/8 agents, confidence 80) = SigmaPrime 2023-10-23 Gsm.sol section "Upgradeable Contracts Must Disable Initializers In The Implementation Contracts" (line 36/516/532/535). Still unfixed in Gsm.sol + GhoReserve + UpgradeableGhoToken + FixedFeeStrategyFactory.
- **DETECTION:** Pattern AS scan must include 3+ year-old audits. Don't filter audit corpus by recency for upgradeable-pattern hygiene findings.
- **ROUTING:** bounty-pre-submit Gate 4 mandatory for auditor strong-signal. No bypass even at high confidence.
- **KILL ratio:** 1/1 this session (T1C [80]).
- **ACTION:** Codify to bounty-pre-submit v1.5 + bounty-lessons v3.5 "Pre-Promote Discipline".

## [2026-05-15] — Aave Immunefi — Pre-Deployment Cluster via TS Config Detection
- **DEFINITION:** Bounty page can list "in-scope" contracts that aren't actually deployed yet. Address-book `.sol` files LAG behind TS configs (`scripts/configs/<protocol>/<chain>.ts`). TS configs = canonical deployment source of truth.
- **INSTANCE:** GHO sub-system 2025-09-05 bounty additions: sGho, GhoSwapFreezer, Gsm4626, FixedPriceStrategy4626, GhoFlashMinter rev2, GhoToken rev2 → NOT in `aave-address-book/scripts/configs/gho/ethereum.ts`. Only GhoReserve + GhoDirectFacilitator (2 instances) actually deployed. Bounty page = 6-month documentation lag.
- **DETECTION:** Phase 0 MANDATORY grep contract names di `scripts/configs/<protocol>/<chain>.ts` BEFORE Phase 0.5 manual mapping. §8.1 Code Discrepancy gate strict.
- **ROUTING:** bounty-workflow Phase 0 + bounty-pre-submit Gate 0.
- **KILL ratio:** 4/5 sGho-cluster targets this session (T1A + T1B + T1D + scope ambiguity rejected).
- **ACTION:** Codify to bounty-workflow v3.6 Phase 0 + bounty-pre-submit v1.5 Gate 0.

## [2026-05-15] — Aave Family — VersionedInitializable ≠ OZ Initializable
- **DEFINITION:** Aave's `VersionedInitializable` (`aave-v3-origin/src/contracts/misc/aave-upgradeability/`) does NOT have `_disableInitializers()` function. Equivalent constructor fix = set `lastInitializedRevision = type(uint256).max`. OpenZeppelin's `Initializable` HAS the auto-disable function; Aave's variant doesn't.
- **INSTANCE:** Confirmed via direct source read — only contains: `lastInitializedRevision uint256` + `initializer` modifier + `getRevision()` pure virtual + `______gap[50]`. Audit corpus check: SigmaPrime 2023 + audits since flagged this gap repeatedly; Aave team treats as "trusted-deployer + empty-impl" acceptance.
- **DETECTION:** When auditing Aave-family upgradeable contracts, distinguish VersionedInitializable vs OZ Initializable. Pattern AS check Aave audit corpus untuk acknowledged-status.
- **ROUTING:** smart-contract-audit-evm v4.6 "Aave upgradeable pattern" subsection.
- **KILL ratio:** N/A (informational pattern, contextual for audit-evm Aave subsection).
- **ACTION:** Codify to smart-contract-audit-evm.

## [2026-05-15] — Cross-Protocol — Scope Split Discipline (CCIP-GHO Example)
- **DEFINITION:** Some bounties demarcate "X protocol covered by their own bounty, only overrides eligible." For cross-protocol integrations, identify the BASE vs OVERRIDE split. Generic base-protocol bugs route to base bounty.
- **INSTANCE:** Aave bounty rule §4.6 — "Based on Chainlink CCIP v1.5.1 → covered by Chainlink Immunefi Bug Bounty. Only logic added/inherited specifically for GHO is within Aave program scope. Generic CCIP bugs → go to Chainlink bounty." Eligible = bridge limit feature + upgrade wrapper + GHO-RBAC overrides. NOT eligible = generic TokenPool / RateLimiter / Router logic.
- **DETECTION:** Phase 0 scope analysis MUST grep for "Based on X" / "Powered by X" / "Fork of X" footnotes. For each, identify the base-protocol bounty redirect.
- **ROUTING:** smart-contract-audit-common v5.2 Phase 0 Scope methodology.
- **KILL ratio:** N/A (scope methodology, prevents wasted Phase 0.5/0.7 cycles on out-of-scope base code).
- **ACTION:** Codify to smart-contract-audit-common.

