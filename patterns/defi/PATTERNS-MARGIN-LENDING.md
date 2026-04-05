# Patterns: Solana Margin/Lending Architecture

**Source:** Glow Finance (Blueprint Finance) — Code4rena Bug Bounty, April 2026
**Protocol Type:** Margin trading + lending (Solana/Rust)

---

## Pattern 1: Adapter CPI Trust Model

**Context:** Margin programs that allow users to interact with external programs (DEX, lending) via CPI.

**Architecture:**
```
User → adapter_invoke(margin_account, adapter_program, data)
  → margin_program validates adapter is registered
  → margin_program invokes adapter via CPI (signed or unsigned)
  → adapter sets return data (AdapterResult)
  → margin_program parses return data ONLY from SAFE_RETURN_DATA_PROGRAMS
  → margin_program applies position changes
  → margin_program verifies account health
```

**Security considerations:**
- Whitelist which programs' return data is trusted (`SAFE_RETURN_DATA_PROGRAMS`)
- External programs (e.g., Jupiter) should NEVER have their return data parsed
- Return data can come from any program in the CPI chain — the "safe" program must set its own return data before ending
- Separate signed (adapter_invoke) vs unsigned (accounting_invoke) paths
- Health check MUST happen after signed invocations

**Audit checklist:**
- [ ] Is the adapter registration permissioned (admin only)?
- [ ] Is return data only parsed from explicitly whitelisted programs?
- [ ] Are external programs (DEX, oracle) excluded from return data parsing?
- [ ] Is health check enforced after every user-initiated action?
- [ ] Can unsigned invocations modify critical state?

---

## Pattern 2: Stack Height Reentrancy Guard (Solana)

**Context:** Solana CPI reentrancy prevention using stack height instead of boolean flag.

**How it works:**
```rust
struct Invocation {
    caller_heights: BitSet, // u8 bitfield tracking stack heights
}

fn start(&mut self) {
    self.caller_heights.insert(get_stack_height() as u8);
}

fn end(&mut self) {
    self.caller_heights.remove(get_stack_height() as u8);
}

fn directly_invoked(&self) -> bool {
    let height = get_stack_height();
    height != 0 && self.caller_heights.contains(height - 1)
}
```

**Why better than boolean:**
- Boolean flag can't distinguish between direct CPI and nested CPI
- Stack height tracking ensures the invoker is the immediate parent
- Prevents indirect invocation attacks where a malicious adapter re-enters through another program

**Audit checklist:**
- [ ] Is stack height tracked per-invocation (not just boolean)?
- [ ] Is `start()` called BEFORE CPI and `end()` called AFTER?
- [ ] Does `directly_invoked()` verify parent height, not just any height?

---

## Pattern 3: Stale Position Asymmetry in Valuation

**Context:** Lending protocols must handle stale oracle data for both collateral and debt positions.

**Glow's approach:**
- **Claims (debt)** with stale data → **hard error** (transaction fails)
- **Collateral** with stale data → **silently excluded** (not counted in equity/collateral)
- **Liquidation** with stale positions → **blocked** (StalePositions error in verify_unhealthy)

**Why this matters:**
- Excluding stale collateral makes account appear LESS healthy (conservative)
- But blocking liquidation prevents exploitation of stale data
- Both sides are protected: can't manipulate health OR liquidation via staleness

**Common vulnerability pattern (NOT present in Glow):**
- If stale collateral is excluded from valuation BUT liquidation is allowed → attacker could block oracle updates to force liquidation
- If stale debt is silently ignored → account appears healthier than reality → under-collateralized borrowing

---

## Pattern 4: Liquidation Fee Anti-Extraction

**Context:** Preventing liquidators from extracting excessive value during liquidation.

**Glow's formula:** `fee = x/(100+x) * min(increases, repayments)`

**Guards:**
1. `equity_loss` tracked across all liquidator invocations — capped at `M * liabilities + B`
2. `collateral_change` must be >= 0 — can't reduce available collateral
3. `available_collateral` post-liquidation capped at `K * required_collateral` — prevents over-liquidation
4. Net borrows (repayments < 0) → instant revert
5. `is_collecting_fees` flag enforces ordering: can't invoke more actions after starting fee collection
6. Fee collection requires `verify_healthy()` — account must be healthy after fee extraction
7. Fee offset against equity loss — if liquidation caused value loss, fee is reduced

**Audit checklist:**
- [ ] Is equity loss tracked cumulatively across multiple invocations?
- [ ] Is there a cap on equity loss relative to liabilities?
- [ ] Can the liquidator reduce available collateral?
- [ ] Is over-liquidation prevented (collateral cap)?
- [ ] Is fee collection blocked until account is healthy?
- [ ] Does fee formula prevent fee > traded amount?

---

## Pattern 5: First Depositor Protection (Lending Pool)

**Context:** Preventing share price manipulation in deposit-note based lending pools.

**Glow's approach:**
```rust
fn deposit_note_exchange_rate(&self) -> Number {
    let deposit_notes = max(1, self.deposit_notes);
    let total_value = max(Number::ONE, self.total_value() - self.total_uncollected_fees());
    total_value / Number::from(deposit_notes)
}
```

**Plus zero-value conversion guard:**
```rust
if (notes == 0 && tokens > 0) || (tokens == 0 && notes > 0) {
    return err!(InvalidAmount);
}
```

**Why this works:**
- `max(1, deposit_notes)` prevents division by zero AND prevents inflating share price when notes = 0
- `max(ONE, total_value)` prevents exchange rate from going to zero
- Zero-value guard prevents "deposit 1 token, mint 0 notes" or "mint 1 note, deposit 0 tokens"
- Combined with U192 precision (192-bit), rounding attacks are impractical

**Compare with EVM (ERC4626):**
- EVM: virtual shares/assets offset (e.g., OpenZeppelin)
- Solana: dead PDA for initial deposit (alternative pattern from GMTrade)
- Glow: max(1, notes) + zero-value guard (simpler but effective)
