# Injective / Peggy — C4 Mar-2026 Known-Issue Bridge Patterns (Pattern-AS / dedup baseline)

**Source:** code-423n4 `2026-02-injective` contest README "known issues" (public).
**Use:** Pattern-AS / dedup baseline for ANY future Peggy / Cosmos-validator-bridge engagement. These are audit-acknowledged — NOT promotable on Peggy itself; use them to dedup and to seed analogous hunts on other validator-set bridges.

## Patterns

- **P1 — Rate-limit freeze (irreversible state advance on a rejected claim).** A bridge/deposit claim that FAILS a rate-limit check still permanently consumes the event nonce and marks the attestation `Observed`, yet never mints to the recipient → permanent fund freeze, no recovery. General class: *validation-failure paths must not burn the nonce/slot.*

- **P2 — Blacklist async-stage gap (guard at entry, not re-checked at a later async stage).** Blacklist is validated only at submission (`SendToEth`), NOT re-validated when batches are built later (`BuildOutgoingTXBatch`) → stale guard at the async batch stage; a batch can stall on fee-on-transfer / USDT-type assets. General class: *guard enforced at entry but not re-checked at a later async / batch / execute stage.*

- **P3 — Rate-limit config gaps (config/migration ignoring existing state).** Rate-limit creation ignores amounts of pre-existing token deposits; the price ID is not updated in the rate-limit config. General class: *config/migration not accounting for already-existing state.*

## Audit use (validator-set / Peggy-style bridge)

Check: (a) nonce/attestation lifecycle on validation-FAILURE (does a rejected claim still advance/burn state?); (b) blacklist/allowlist re-validation at EVERY async stage (submit vs batch-build vs execute); (c) rate-limit config vs existing balances/price-IDs at creation/migration.

**Tags:** Pattern-AS, Peggy, Cosmos validator bridge, cross-chain bridge, known-issue, dedup-baseline, rate-limit, blacklist async-stage, attestation nonce, C4 injective.
