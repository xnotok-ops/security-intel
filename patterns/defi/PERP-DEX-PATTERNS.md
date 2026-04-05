# GMX V2 / Perp DEX Patterns

## Architecture Pattern: Two-Step Execution
- User creates request on-chain → Keeper executes with oracle prices
- Attack surface: gap between creation and execution (price changes, front-running)
- Mitigation: acceptable_price, min_output, price staleness checks

## Vulnerability: No-Op Swap (GMTrade, Mar 2026)
- **Root cause:** Market where `long_token == short_token` allows swapping token for itself
- **Impact:** Price impact pool manipulation without actual value exchange; fee extraction
- **Detection:** Check all swap path markets for `long_token != short_token`
- **Solidity equivalent:** Would be caught by different type system, but same logic bug

## Vulnerability: Swap Path Length Mismatch
- **Root cause:** Declared `swap_path_length` param vs actual remaining_accounts array length
- **Impact:** Bypass no-op swap check by declaring length 0 but providing swap accounts
- **Detection:** Validate the parameter, not the array length

## Pattern: Decrease Position Swap Layers
GMX V2 / GMTrade has TWO swap layers in decrease position:
1. **Inner swap (model):** `DecreasePositionSwapType` — PnL token ↔ collateral token
2. **Outer swap (program):** Multi-hop swap path — collateral token → final output token
- Both are independent; inner swap failure is handled gracefully (logged, outer swap proceeds)
- Slippage is validated AFTER both swaps via total USD value check

## Pattern: GLV Shift Exploit Vector
- GLV vault holds market tokens across multiple markets
- Shift = withdraw from market A + deposit into market B
- Attack: temporarily inflate utilization in market A → shift moves value → deflate
- Mitigations: max_price_impact_factor, min_interval, min_value, per-market balance caps
- Key: all mitigations are CONFIG-DEPENDENT — misconfiguration = exploitable

## Pattern: First Depositor Protection (Solana)
- Solana equivalent of ERC4626 inflation attack
- Solution: send first deposit tokens to a dead PDA (`find_program_address(["first_deposit_receiver"])`)
- Additional: `min_tokens_for_first_deposit` config parameter
- Unlike EVM "virtual shares" approach, Solana uses PDA-locked tokens

## Pattern: Rust vs Solidity Translation Bugs
Key differences to check when auditing Rust ports of Solidity protocols:
- **Integer overflow:** Solidity unchecked wraps/reverts; Rust panics (debug) or wraps (release)
- **Checked arithmetic:** Rust `checked_*` returns `Option<T>` vs Solidity's revert
- **Signed arithmetic:** Rust `i128` vs Solidity `int256` — different ranges
- **Type casting:** Rust `as` keyword can silently truncate; `try_into()` is safer
- **Division:** Both floor by default, but Rust's type system catches more errors
- **`saturating_*`:** Returns MAX/MIN on overflow instead of reverting — can mask issues in validation paths

## Audit Checklist: Perp DEX
- [ ] Position increase: collateral validation, leverage limits
- [ ] Position decrease: PnL calculation, collateral deduction order, swap error handling
- [ ] Liquidation: threshold calculation, price impact exclusion, funding fee inclusion
- [ ] Price impact: same-side vs cross-over, capping mechanism, impact pool accounting
- [ ] Funding rate: adaptive rate calculation, direction changes, boundary clamping
- [ ] Market token pricing: pool value calculation, PnL factor capping, first depositor
- [ ] Swap: multi-hop accounting, path validation, no-op prevention
- [ ] GLV/vault: deposit/withdrawal asymmetry, shift exploitation, negative pool value
- [ ] Oracle: staleness, deviation, future timestamp, cross-oracle timestamp range
- [ ] ADL: trigger conditions, PnL factor validation before/after
