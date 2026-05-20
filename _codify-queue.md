
## [2026-05-20] — Aave Immunefi — Pattern-DD via Backward-Compat Source NatSpec

**Category:** Validity Layer / Pattern-DD (Disclaimer-Defeat) extension
**Source:** Aave Immunefi v3.6 — `Pool.sol` MOCK_STABLE_DEBT pattern (May 20 2026, Tier 2 v3.6 option (e))
**Trigger:** Source code contains explicit code-level comment documenting backward-compat design intent. Keywords include "temporary workaround", "broken integrations", "backward compatibility", "best-effort", "must be configured", "instead of reverting".
**Pattern:** When in-source code comment (not just NatSpec, but inline `//` comment block) self-documents 4 axes of design intent — (1) WHAT the construct is, (2) WHY it exists, (3) HOW it should be configured, (4) EXPECTED behavior under various inputs — the comment constitutes audit-equivalent design declaration. Functions as analog to Quantified-Probability-NatSpec Pattern-DD (Hyperbridge SAMPLE_SIZE canonical). Aave canonical: MOCK_STABLE_DEBT in Pool.sol assembles ReserveDataLegacy backward-compat field via `ADDRESSES_PROVIDER.getAddress(bytes32('MOCK_STABLE_DEBT'))`, with comment block stating "temporary workaround for integrations that are broken by Aave 3.2... mock must be configured... returning zero on all required view methods, instead of reverting." Covers all H1/H2/H3 angles (mock returns wrong values / mock not configured / integrator gets unexpected behavior) via single self-doc'd intent declaration.
**Decision rule:** For findings targeting backward-compat stubs, mock contracts, or deprecated-but-preserved interfaces, run source-level comment grep BEFORE Phase 1. Detection grep: `grep -rB5 -A10 "backward.compat\|temporary workaround\|broken integration\|must be configured" --include="*.sol" src/`. If self-doc'd intent covers the claimed mechanism, Pattern-DD binds regardless of audit corpus mention status. Even Pattern AS clean (0 audit hits) does NOT unlock submission when source-comment Pattern-DD applies.
**Cross-link:** `bounty-pre-submit` Gate 4 Quantified-Probability-NatSpec Pattern-DD extension (parent rule, Hyperbridge SAMPLE_SIZE source); `bounty-lessons` FP catalog (backward-compat stub anti-pattern); `sc-audit-evm` deprecation pattern recognition.

---

## [2026-05-20] — Methodology — Tier 2 Saturation Pattern Recognition

**Category:** Phase 0 / Density Assessment / Multi-Axis Saturation Detection
**Source:** Aave Immunefi Tier 2 v3.6 6-option full sweep (May 20 2026) — 6/6 surfaces bound via 5 distinct kill axes in ~45 min total drill time
**Trigger:** Heavily-hardened target where Tier 1 already exhausted, working Tier 2 deltas / refactor windows
**Pattern:** On hardened targets, Tier 2 sub-options typically exhibit comprehensive AS coverage spread across MULTIPLE kill axes simultaneously — no single axis dominates. Aave canonical distribution across 6 options:
- §8.3 Fix-Anywhere (option a — fix landed in tag, known issue)
- Pattern AS direct (option b — Pashov section + Savant Issue 22 ltvzero mitigation)
- §8.4 + Gate 4 Acknowledged-equivalent-Risk-Accepted (option c — Sherlock 2 Low both bound)
- Pattern AS comprehensive cross-version coverage (option d — Pashov 7-protection block)
- Pattern-DD via source NatSpec (option e — MOCK_STABLE_DEBT)
- Empty src grep / clean removal (option f — no dangling references)
**Decision rule:** If Tier 2 sub-target hits 4+ distinct kill axes across hypothesis classes in single session, mark "Tier 2 saturated" and pivot — continuing same-day produces 0 promote with near-certainty. Threshold derived from Aave 6/6 close. Companion to bounty-workflow v3.5 Phase 0.5 Audit-Saturation Signal (6+ kills) but operates at higher granularity — kill-axis-DIVERSITY rather than kill-count.
**Cross-link:** `bounty-workflow` Phase 0.5 Audit-Saturation Signal (6+ kills, sibling); `sc-audit-common` density assessment / Heavily-Hardened-Target v2 framework; `bounty-pre-submit` Gate 4 Pattern AS / Pattern-DD ladder.

---

## [2026-05-20] — Methodology — Internal Doc Terminology Imprecision Risk

**Category:** Phase 0 / Pre-Phase 0.5 / Doc Verification
**Source:** Aave audit-history.md v1.1 §4.5 "Sherlock v3.3 acknowledged-but-downgraded" label (May 20 2026, contest re-read in Tier 2 option (c))
**Trigger:** Pre-Phase 0.5 / pre-deep-dive consultation of self-authored documentation files (audit-history.md, mapping files, closure notes, prior research artifacts)
**Pattern:** Internal doc-level summaries written during prior sessions may use loose terms that don't match underlying audit/contest report reality. Words like "acknowledged-but-downgraded", "audit-lag confirmed", "ROI marginal", "heavily audited" carry connotations that can be over- or under-stated relative to the literal evidence. Aave canonical: audit-history.md note labeled Sherlock v3.3 contest as "acknowledged-but-downgraded" implying H/M severity disputes worth fix-correctness check. Actual contest content: ZERO H/M findings, only 2 Low severity issues (L-1 Not Fixed Not Acknowledged + L-2 Acknowledged). The "downgraded" label had no literal contest support.
**Decision rule:** Before committing time to a Tier N sub-target based on internal doc note, verify the literal claim against the underlying audit/contest report via single grep. Detection grep template: `grep -niE "acknowledged|downgrad|escalat|won.t.fix|wontfix|risk.accept" <audit-file>`. <30s confirmation or contradiction. If contradicts doc, update doc inline + re-assess Tier N viability.
**Cross-link:** `bounty-pre-submit` Gate 4 Pattern AS verification (verifies audit content for finding submission); `bounty-workflow` Phase 0 Audit Summary-Table-First (related: build summary tables from raw audit content, not from prior doc notes).

---

## [2026-05-20] — Tooling — Squashed-History Repo `--since` Filter Unreliable

**Category:** Phase 0.5 / Recon Tooling / Git Workflow
**Source:** Aave gho-origin + aave-v3-origin bounty-notes mirror analysis (May 20 2026 — GhoFlashMinter Phase 0 + Tier 2 v3.6 setup)
**Trigger:** Working with bounty-notes mirror repos cloned via shallow / squash from upstream. Common when upstream is large monorepo or when notes-keeper deliberately squashed for lighter clone.
**Pattern:** Mirror repos may contain single "Initial commit" representing the entire upstream history collapsed at clone time. `git log --since="YYYY-MM-DD" -- <file>` returns 0 commits regardless of actual upstream activity because all history is squashed into one commit dated at clone date. Misleading signal: appears file has zero recent changes when upstream may have had heavy activity. Aave canonical: gho-origin has single commit `731776b 2025-06-10 Initial commit` for GhoFlashMinter.sol — but underlying file has evolution upstream that's invisible here.
**Detection:** `git log --oneline -- <file> | wc -l` showing exactly 1 line with subject "Initial commit" = squashed mirror confirmed. Cross-check: compare commit date to repo's `.git/config` or `.git/HEAD` modification date — if matches, repo was cloned fresh that day with squash.
**Decision rule:** Before trusting `--since` git filter on bounty-notes mirror repos, verify history depth FIRST. If squashed-mirror confirmed, escalate to: (1) deployed bytecode via etherscan source viewer, (2) bounty page scope diff for asset re-list events, (3) cross-reference audit corpus dates against feature timeline. Don't rely on `--since` alone for audit-lag delta detection.
**Cross-link:** `bounty-workflow` v3.5 default-branch dynamic detection (sibling git workflow rule); `tools-reminder` recon hygiene Decision Rule 20.

---

## [2026-05-20] — Phase 0 — Bounty Re-Add ≠ Refactor (Scope-Table Reorganization Recognition)

**Category:** Phase 0 / Scope Density Assessment / Refactor-Signal Disambiguation
**Source:** Aave GhoFlashMinter 5 Sep 2025 bundle re-add (May 20 2026 GhoFlashMinter Phase 0 closure)
**Trigger:** Bounty page or audit-history.md notes show existing asset "Re-added" or "Re-added (likely refactor)" with date. Refactor signal claim needs verification before committing audit-lag hunt time.
**Pattern:** Bounty page re-add events often BUNDLE multiple existing assets alongside genuinely NEW assets in scope-table reorganization, NOT individual contract refactors. The bundling occurs because protocol launches ecosystem feature (e.g., new product family) requiring scope-table addition of new contracts — and bookkeeping pass re-lists adjacent existing assets for clarity. Aave canonical: 5 Sep 2025 bundle = GhoFlashMinter + GhoToken (both existing, ~2y deployed) + OwnableFacilitator + GhoReserve + GSM4626 + FixedPriceStrategy4626 (all new for sGho ecosystem launch). Two existing assets were re-added because they're adjacent to new RemoteGSM / 4626 family.
**Verification triad (run all 3 before committing to refactor-delta hunt):**
1. **Deployed bytecode:** Etherscan contract creation date. If pre-bundle-date, no redeploy → admin-only re-add.
2. **Upstream repo git log:** Any commits to the file since pre-bundle date? If 0, no code change → admin-only re-add.
3. **Audit corpus:** Any audit dated post-bundle covering this specific asset? If 0, no refactor occurred → admin-only re-add.
**Decision rule:** Pre-Phase 0.5, verify "refactor signal" via deployed + repo + audit triangulation. If 3/3 negative, treat as scope-table re-add (admin only), strip from audit-lag hunt list. Saves 3-4h Phase 0.5 commitment per non-refactor target. Aave GhoFlashMinter case: 0 audit on 5 Sep 2025+, gho-origin squashed (separate issue but consistent with no recent commits visible), etherscan source structure matches 2023-vintage `@aave/core-v3/contracts/...` imports → all 3 negative → H6 audit-lag hypothesis dead.
**Cross-link:** `bounty-pre-submit` Gate 0 Pre-Deployment TS Config Detection (sibling — bounty page lags reality); `bounty-workflow` Phase 0 Density Gate (parent); `bounty-lessons` Audit Decay Taxonomy.
