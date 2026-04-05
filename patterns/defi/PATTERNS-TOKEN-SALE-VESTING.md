# Token Sale / Launchpad / Vesting — Vulnerability Patterns
# Source: Legion audit reports (Trail of Bits, C4, Pashov 2024-2025)

## Token Sale Patterns

### SALE-01: Position Transfer Breaks Proof Binding
**Source:** Pashov H-01, M-02, M-03
**Pattern:** Merkle proofs or signatures are bound to original investor address. When position is transferred (NFT or mapping), the new holder's investedCapital increases but their accepted/allocated amount remains unchanged in the proof.
**Attack:** Receiver calls withdrawExcess with inflated investedCapital, draining accepted capital.
**Check:** After position transfer, verify all proofs and signatures still bind correctly to new holder.
**Variants:**
- Transfer to refunded recipient → cache corruption
- Transfer to existing holder → additive merge breaks proof math

### SALE-02: Stale Cached Allocation After Term Change
**Source:** C4 H-6.3
**Pattern:** SAFT terms (allocationRate, investAmount) cached per-investor can become stale when project updates terms. Investor uses old (higher) allocation to claim tokens, then withdraws excess capital at new (lower) amount.
**Attack:** claim with old high allocation → withdraw excess at new low allocation → profit the delta.
**Check:** Verify claim and withdraw both re-validate against current terms, not cached values.

### SALE-03: Missing Re-execution Guard on Withdrawal
**Source:** C4 H-6.2
**Pattern:** State-changing withdrawal function (withdrawCapital, withdrawRaisedCapital) lacks a boolean flag or amount zeroing to prevent multiple calls.
**Attack:** Project calls withdraw multiple times, draining investor excess capital.
**Check:** Every withdrawal function must: (1) check flag/amount, (2) set flag/zero amount, (3) then transfer.

### SALE-04: Decimal Mismatch in Cross-Token Calculations
**Source:** C4 H-6.1
**Pattern:** When bidToken and askToken have different decimals (e.g., USDC 6 vs TOKEN 18), formula uses wrong token's decimals as divisor.
**Formula Bug:** `totalCapitalRaised = (tokensAllocated * price) / 10**bidDecimals` → should be `10**askDecimals`
**Check:** In any cross-token calculation, trace which token's decimals should be divisor. Unit analysis.

### SALE-05: Cancel Flow Incomplete State Exclusion
**Source:** C4 M-7.2
**Pattern:** After sale cancel, withdrawInvestedCapitalIfCanceled() doesn't check all exclusion states (hasSettled, hasRefunded). Settled investors can refund after cancel.
**Check:** Cancel withdrawal must verify: not settled, not already refunded, investedCapital > 0.

### SALE-06: Signature Lacks Nonce or Expiry
**Source:** Pashov L-06, C4 M-7.1
**Pattern:** Investment signature only contains (investor, contract, chainId) — no nonce, amount, or expiry. Same signature works for unlimited investments.
**Impact:** Varies — may be by design (known issue in Legion), but in other protocols could allow unbounded investment or replay.
**Check:** Investment signatures should include: amount, nonce/counter, expiry timestamp.

### SALE-07: Project Can Front-Run Sale Results
**Source:** TOB-LGN-7
**Pattern:** Project admin can front-run the publishSaleResults transaction and cancel the sale, after seeing unfavorable results.
**Mitigation:** Two-step process — initializePublish (locks cancel) → publishResults.
**Check:** Verify cancel is blocked during result publication window.

## Vesting Patterns

### VEST-01: Override Incompatible with Base Contract Semantics
**Source:** Pashov H-02
**Pattern:** Custom `_vestingSchedule()` returns delta (newly vested since last claim) instead of cumulative total. OZ VestingWalletUpgradeable.release() expects cumulative: `releasable = vestedAmount - released`.
**Result:** After first claim, `releasable = delta - released = 0` → tokens locked until final epoch.
**Check:** When overriding OZ vesting, verify return value is CUMULATIVE (total vested from start), not incremental.

### VEST-02: Epoch Boundary Off-by-One
**Source:** Pashov H-03
**Pattern:** `if (currentEpoch >= s_numberOfEpochs)` vs `>= s_numberOfEpochs + 1` — off-by-one in epoch counting causes either premature full allocation or funds locked permanently.
**Check:** Trace epoch numbering: epoch 1 = first epoch after start. Verify boundary condition at final epoch.

### VEST-03: Vesting Bypass via Direct Contract Call
**Source:** Pashov L-07
**Pattern:** Sale contract's `releaseVestedTokens()` is gated by `whenNotPaused`, but investor can call the vesting contract's `release()` directly, bypassing the pause.
**Check:** If pause should prevent all token release, the vesting contract itself must enforce it (not just the sale wrapper).

### VEST-04: Epoch Progression Allows Fund Lock
**Source:** Pashov H-03, H-04
**Pattern:** If epochs progress past numberOfEpochs without claiming, the vestingSchedule math can return amountVested > totalAllocation (no cap), causing underflow when OZ subtracts released.
**Check:** `_vestingSchedule` must cap return at `_totalAllocation` when past final epoch.

## Clone / Proxy Patterns

### CLONE-01: Atomic Deploy + Init Prevents Frontrunning
**Pattern:** Factory creates clone AND calls initialize() in same transaction → no window for frontrunning init.
**Anti-pattern:** Create clone → emit event → init in separate tx → attacker front-runs init with malicious params.

### CLONE-02: Implementation Disables Initializers
**Pattern:** Implementation contract constructor calls `_disableInitializers()` → prevents direct initialization of the implementation (only clones can be initialized).

## Sealed Bid / Encryption Patterns

### ECIES-01: XOR Encryption Brute-Forceable
**Source:** Pashov M-01
**Pattern:** ECIES with XOR encryption — if the plaintext space is small (e.g., bid amounts in reasonable range), encrypted value can be brute-forced by trying all possible amounts with the known public key.
**Impact:** Bid privacy broken before private key reveal.
**Check:** Verify plaintext space is large enough that brute-force is infeasible.

### ECIES-02: Salt/Nonce Prevents Bid Replay
**Source:** TOB-LGN-8
**Pattern:** Without per-investor salt, any investor can copy another's encrypted bid and submit it. Salt = hash(investor_address + fixed_salt) prevents this.
**Check:** Verify encryption salt is unique per investor.

---

*Extracted from: Legion Protocol 5-audit history (2024-2025)*
*Categories: SALE (7), VEST (4), CLONE (2), ECIES (2) = 15 patterns*
