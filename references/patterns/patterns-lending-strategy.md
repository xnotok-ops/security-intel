# Patterns: Lending Protocol & Strategy Vaults

Extracted from Moonwell audit session (April 2026).
Use as reference for auditing similar protocols.

---

## Oracle Attack Patterns

### 1. Composite Oracle Staleness Bypass
**Pattern:** Composite oracle returns `block.timestamp` as `updatedAt`
**Impact:** Downstream staleness checks always pass, even with stale underlying feeds
**Detection:**
```
grep -n "block.timestamp" src/oracles/*.sol
# Look for latestRoundData() returning block.timestamp in updatedAt field
```
**Seen in:** Moonwell ChainlinkCompositeOracle, Midas ChainlinkAdapterBase

### 2. LST Exchange Rate Confusion
**Pattern:** LST/ETH exchange rate treated as USD price (missing ETH/USD multiplication)
**Impact:** Collateral mispriced by orders of magnitude
**Detection:** Check composite oracle constructor — does it combine base (ETH/USD) with multiplier (LST/ETH)?
**Seen in:** Moonwell cbETH exploit (Feb 2026), wrstETH exploit (Nov 2025)

### 3. On-Chain Quoter for Slippage = Sandwich Target
**Pattern:** Using DEX quoter.quoteExactInputSingle() for amountOutMinimum
**Impact:** Attacker manipulates pool in same block, quoter returns manipulated price
**Fix:** Use Chainlink oracle for minimum output calculation
**Detection:**
```
grep -n "quoter\|quoteExact" src/*.sol
# If used for slippage protection, it's vulnerable
```
**Seen in:** Moonwell MamoStakingStrategy.compound()

### 4. OEV Price Delay Window
**Pattern:** Oracle wrapper delays price updates to capture MEV
**Impact:** During delay, borrowers see old (higher) collateral price, can over-borrow
**Detection:** Look for `cachedRoundId` pattern in oracle wrappers
**Seen in:** Moonwell ChainlinkOEVWrapper

---

## Strategy/Vault Patterns

### 5. Split-Based Withdrawal Rounding
**Pattern:** `withdrawA = (needed * splitA) / total; withdrawB = (needed * splitB) / total;`
**Impact:** withdrawA + withdrawB < needed due to rounding, withdrawal reverts
**Fix:** Calculate one side as `needed - withdrawA`
**Detection:**
```
grep -n "SPLIT_TOTAL\|splitMToken\|splitVault" src/*.sol
# Check if both sides calculated independently with division
```

### 6. Permissionless Deposit + Restricted Withdraw
**Pattern:** deposit() has no access control but withdraw() is onlyOwner
**Impact:** Anyone can deposit tokens that only owner can withdraw (fund lock on user error)
**Detection:** Compare access modifiers on deposit vs withdraw functions

### 7. removeReward Without Claiming
**Pattern:** Synthetix MultiRewards fork with custom removeReward()
**Impact:** Unclaimed rewards stuck in per-user mapping after token removed from array
**Detection:** Check if removeReward clears user reward mappings or just the array/struct

### 8. CowSwap EIP-1271 Validation Checklist
When auditing isValidSignature for CowSwap integration, verify:
- [ ] Order hash matches digest
- [ ] Only sell orders allowed (KIND_SELL)
- [ ] validTo within acceptable range (not too soon, not too far)
- [ ] Not partially fillable (fill-or-kill)
- [ ] sellToken != strategy token (can't sell principal)
- [ ] buyToken == strategy token
- [ ] receiver == contract address
- [ ] feeAmount == 0
- [ ] appData matches expected pre-hook
- [ ] Price check uses off-chain oracle (not on-chain quoter)

---

## Scope Assessment Checklist

Before committing time to a bounty:

1. [ ] Check total rewards paid ($0 with many submissions = red flag)
2. [ ] Count previous audits (3+ audits = diminishing returns)
3. [ ] Identify NEW contracts vs battle-tested forks
4. [ ] Verify interesting contracts are ACTUALLY in scope table
5. [ ] Check known issues list for overlap with your findings
6. [ ] Read audit reports BEFORE deep diving
7. [ ] Estimate effort vs reward (Critical-only programs need higher bar)
