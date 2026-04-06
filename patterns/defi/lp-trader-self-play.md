# LP-Trader Self-Play Attack (Role-Play Attack)

**Category:** Economic Exploit / Perp DEX  
**Severity:** Critical  
**First Seen:** DenariaFinance on Linea — April 2026  
**Loss:** 165,617 USDC  
**Reference Paper:** https://arxiv.org/abs/2310.01081  

---

## Vulnerability

Perp DEX protocols that use LP-based settlement allow a single actor to play both sides (LP + Trader) within the same transaction. The protocol's PnL accounting interprets the trader's loss as the LP's profit, enabling the LP to withdraw more collateral than deposited.

## Preconditions

- Protocol allows **same-block** addLiquidity + trade + settlePnL + removeCollateral
- No validation of **relationship** between LP and Trader (same deployer, same tx, same EOA)
- No **cooldown** or timelock between PnL realization and collateral withdrawal
- `realizePnL` accepts **unverified or empty reports** (no oracle/keeper gating)
- Flash loans available on the chain (Aave on Linea)

## Attack Flow

```
1. Flash-loan USDC from Aave
2. Deploy Helper A (LP role) + Helper B (Trader role)
3. Helper A → approve → addCollateral → addLiquidity (become dominant LP)
4. Helper B → approve → addCollateral → trade(direction, size) against A's liquidity
5. Helper A → realizePnL("") → protocol credits "profit" to A
6. Helper A → removeCollateral(amount >> deposit)
7. Repay flash loan, keep profit
```

## Real Case: DenariaFinance (Linea, April 2026)

**Tx:** `0xcb0744a0d453e5556f162608fae8275dabd14292bffbfcd8394af4610c606447`

**Contracts observed in trace:**
- `0xe844...dba5` — Helper A (LP)
- `0xb9c7...6194` — Helper B (Trader)  
- `0x61ce...8d91` — Denaria collateral contract
- `0xb683...ae17` — Denaria perp/trade contract

**Round 1:** Deposit 45K → Withdraw 183K  
**Round 2:** Deposit 15K → Withdraw 42K  
**Net profit:** 165,617 USDC (after flash loan repayment)

### Round 2 Trace (confirmed from internal tx):

| Step | Actor | Call | Value |
|------|-------|------|-------|
| 1 | A | `addCollateral([10e9])` | 10,000 USDC |
| 2 | A | `addLiquidity(8e18, ...)` | Become dominant LP |
| 3 | B | `addCollateral([5e9])` | 5,000 USDC |
| 4 | B | `trade(true, 30e18, minReturn=0)` | Open position vs A |
| 5 | A | `realizePnL("")` | Returns 159e18 — "profit" |
| 6 | A | `removeCollateral(42e21, ...)` | Withdraw >> deposit |

### Key Red Flags in Protocol

- `realizePnL(unverifiedReport="")` — empty string accepted, no oracle/keeper validation
- `minTradeReturn=0` — no slippage protection enforced
- No cooldown between `addLiquidity` → `realizePnL` → `removeCollateral`
- No same-block or same-deployer relationship check between LP and Trader

## Audit Checklist

When auditing perp DEX / LP-based protocols, check:

- [ ] Can LP and Trader actions execute in the same transaction?
- [ ] Is there a cooldown/epoch between addLiquidity and PnL settlement?
- [ ] Does `realizePnL` require a valid oracle report or keeper signature?
- [ ] Is there a minimum lock period for LP collateral after settlement?
- [ ] Does the protocol check if LP and Trader share deployer/EOA/tx origin?
- [ ] Is `minTradeReturn` enforced to be non-zero?
- [ ] Are flash loan guards in place (e.g., `block.number` check, transfer delay)?
- [ ] Can `removeCollateral` exceed original deposit in a single block?

## Mitigation

1. **Epoch-based settlement** — LP cannot realize PnL in the same block as position was opened against their liquidity
2. **Keeper/oracle gating** — `realizePnL` must include a signed, timestamped report from an authorized keeper
3. **Withdrawal cooldown** — minimum N blocks between PnL realization and collateral withdrawal
4. **Flash loan guard** — detect and reject same-tx deposit+trade+settle+withdraw patterns
5. **Relationship validation** — flag or block when LP and Trader share `tx.origin` or are deployed by the same address

## Related Patterns

- Flash Loan Price Manipulation
- Oracle Manipulation (empty/stale reports)
- Atomic Arbitrage via Self-Trading
- GMX/GLP LP Manipulation patterns
