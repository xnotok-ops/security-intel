# Solana Bonding Curve / Token Launch Patterns

Source: Code4rena Meteora Dynamic Bonding Curve (Aug-Sep 2025, $104.5K, 0H 2M 13L)
Protocol: Meteora DBC — permissionless token launch with bonding curves, fee rate limiters, AMM migration (Solana/Rust)

---

## MDBC-01: Instruction Discriminator Bypass in Rate Limiter Validation

**Category:** Access control / Anti-sniping bypass
**Severity:** Medium
**Applicable to:** Any Solana program with multiple instruction variants for the same operation

Anti-sniping check (`validate_single_swap_instruction`) only checked `swap` discriminator, not `swap2`. Attacker uses `swap2` to bundle 16 swaps in one TX, bypassing the 1-swap-per-TX rate limiter.

**Pattern:** When a protocol adds a new instruction variant (v2, swap2, etc.) that performs the same operation, existing validation/restriction logic may not cover the new discriminator.

**Check:**
- List ALL instruction discriminators that perform the target operation
- Verify every restriction/validation checks ALL variants, not just the original
- After adding a new instruction, grep all places that check discriminators

---

## MDBC-02: Validation Early Return Bypasses Minimum Fee Check

**Category:** Configuration validation bypass
**Severity:** Medium
**Applicable to:** Any protocol with configurable fee parameters and "zero/disabled" special cases

`validate()` early-returns `Ok(())` for "zero rate limiter" configs (3 fields are zero). But `cliff_fee_numerator` (the base fee) isn't checked in the zero-detection. Config with all-zero rate limiter params + zero cliff fee passes validation → zero-fee trades despite protocol requiring minimum 0.01% fee.

**Pattern:** Early return for "disabled/zero" config that checks some fields but not all, allowing invalid combinations to bypass validation.

**Check:**
- For every early return in validation functions, verify ALL relevant fields are checked
- "Is this feature disabled?" checks must account for all configurable parameters
- Test: set each field to zero individually and in combinations, verify validation catches all invalid states

---

## MDBC-03: Feature Flag Admin Bypass (Solana `#[cfg(feature)]`)

**Category:** Build configuration / Access control
**Severity:** Low
**Applicable to:** Any Solana program using cargo features for test/dev modes

`assert_eq_admin` returns `true` unconditionally under `#[cfg(feature = "local")]`. If feature accidentally included in release build, all admin checks bypassed.

**Pattern:** Feature flags that disable security checks for testing. CI must enforce features are not enabled in production builds.

**Check:**
- Grep for `#[cfg(feature = "local")]` or similar test features
- Verify CI pipeline rejects builds with test features enabled
- Prefer `#[cfg(test)]` over custom features for test-only code

---

## MDBC-04: Missing State Machine Guard Before State Transition

**Category:** State machine / Migration
**Severity:** Low
**Applicable to:** Any protocol with lifecycle states (active → migrating → migrated)

Migration metadata can be initialized without checking `is_migrated == 0`. Allows re-initialization after migration completed.

**Pattern:** State transitions that don't verify current state before proceeding.

**Check:** For every state-changing function, verify it checks the current state is valid for that transition.

---

## MDBC-05: Permissionless PDA Initialization (Front-run Timing Control)

**Category:** Centralization / Griefing
**Severity:** Low (Governance)
**Applicable to:** Any Solana program where PDA initialization is not gated to authorized caller

Anyone can initialize migration metadata PDA (pays rent, but controls timing). No creator/admin binding. Allows front-running initialization to control migration timing.

**Pattern:** Permissionless `init` on PDAs that should be creator/admin-controlled. Even if fields are deterministic, timing control can be a griefing vector.

**Check:** For every `#[account(init)]`, verify the payer/caller is appropriately restricted via constraints.

---

## MDBC-06: Missing Signer Check on UncheckedAccount Owner

**Category:** Access control (Solana-specific)
**Severity:** Low
**Applicable to:** Any Solana program using `UncheckedAccount` for owner fields

LP lock/claim functions accept `owner: UncheckedAccount` without requiring it to be a signer. Anyone can trigger lock/claim on behalf of the owner. Assets go to rightful owner, but unauthorized state changes (lock flags) = griefing.

**Pattern:** `UncheckedAccount` used for identity fields that should be `Signer`. Anchor won't enforce signing unless explicitly specified.

**Check:**
- Grep for `UncheckedAccount` in account structs
- For each, ask: "Should this account be required to sign?"
- If identity/ownership is implied, use `Signer<'info>` instead

---

## META: Scope Assessment Notes

- **Solana/Rust bonding curve** ($104.5K, 0H 2M): Very mature — prior audits, only minor findings. Pattern: well-audited Solana programs yield discriminator/config-validation edge cases, not fundamental logic flaws
- **Anti-sniping = high-value feature**: M-01 (discriminator bypass) directly undermines the protocol's core promise to token launchers. Business impact > technical severity
- **Rate limiter / fee config**: Both Mediums involve fee/rate-limiting bypass. Pattern: fee configuration validation is a common weak spot in DeFi
- **Solana-specific patterns**: discriminator checks, feature flags, UncheckedAccount, PDA init permissions — all Solana-specific footguns

---

*Extracted: April 2026*
*Source: code4rena.com/reports/2025-08-meteora-dynamic-bonding-curve*
