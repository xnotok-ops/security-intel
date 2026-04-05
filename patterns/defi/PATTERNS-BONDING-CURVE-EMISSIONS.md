# Patterns: Bonding Curves, veCRV, Emissions & Knowledge Graphs

Extracted from Intuition V2 research (2x Diligence audit, POST-MORTEM, C4 contest). Applicable to any protocol using bonding curves, veCRV-style locking, or epoch-based emissions.

---

## CURVE-01: Progressive Bonding Curve — Deposit/Redeem Asymmetry

**Pattern:** Progressive curves where `price = slope * totalShares` have inherent asymmetry:
- Deposit: `shares = sqrt(s² + assets/halfSlope) - s` (round DOWN → fewer shares)
- Redeem: `assets = (s² - sNext²) * halfSlope` (round DOWN → fewer assets)

**Impact:** User always loses value on round-trip deposit→redeem due to double round-down. For dust amounts, loss can be 100%.

**Detection:** Look for `sqrt()` in deposit and `square()` in redeem with different rounding directions.

**Mitigation:** Protocols use `minDeposit` and `minShare` to prevent dust-level deposits. Check these minimums are set high enough.

**Seen in:** Intuition ProgressiveCurve (PR #136 fixed redeem underflow edge case).

---

## CURVE-02: Multi-Curve Architecture — Cross-Curve Fee Routing

**Pattern:** When a protocol supports multiple bonding curves per vault, fees (entry/exit) are often routed to a single "default" curve vault, not the curve the user is interacting with.

```
User redeems from vault[term][curveB]
  → exit fee goes to vault[term][defaultCurve]  // different vault!
  → vault[term][curveB].totalAssets -= rawAssets
```

**Impact:** Non-default curve vaults lose more assets than expected. Default curve vault gains free assets, inflating share price for default curve holders.

**Detection:** `grep -n "defaultCurveId" src/*.sol` — check if fee routing always uses default curve.

**Risk level:** Usually by design (default = pro-rata vault, others = bonding curves). But verify the protocol intends this.

**Seen in:** Intuition MultiVault `_increaseProRataVaultAssets()` always uses `bondingCurveConfig.defaultCurveId`.

---

## CURVE-03: Multi-Curve Counter-Stake Check — Per-Curve vs Global

**Pattern:** In triple/claim systems with "for" and "against" vaults, counter-stake checks may only prevent same-curve staking on both sides, not cross-curve.

```solidity
// Only checks same curveId
function _hasCounterStake(tripleId, curveId, receiver) {
    bytes32 oppositeId = _getInverseTripleId(tripleId);
    return _vaults[oppositeId][curveId].balanceOf[receiver] > 0;
}
```

**Impact:** User can hold positions on both sides using different curves. May allow utilization gaming or hedging.

**Detection:** `grep -n "counterStake\|hasCounter\|opposite" src/*.sol` — check if curveId is parameterized.

**Seen in:** Intuition MultiVault — considered design choice (each curve = separate market).

---

## VECURV-01: VotingEscrow Timestamp Underflow in Historical Queries

**Pattern:** veCRV forks using `_supply_at(point, t)` assume `t >= point.ts`. When a new checkpoint is created after an epoch boundary, historical queries for the epoch end timestamp can underflow:

```
t_i = epochEndTimestamp        // e.g., 1763478000
last_point.ts = checkpointTs   // e.g., 1763478091 (91s AFTER epoch end)
bias -= slope * (t_i - last_point.ts)  // UNDERFLOW!
```

**Impact:** Critical — ALL reward claims blocked. DoS on entire emissions system.

**Detection:** In any veCRV fork, check if `_totalSupply(t)` or `_balanceOf(addr, t)` can be called with `t < latest_checkpoint.ts`. Look for epoch-end queries that might precede the latest checkpoint.

**Fix pattern:** Binary search for the correct historical checkpoint where `point.ts <= t`:
```solidity
function _totalSupply(uint256 t) internal view returns (uint256) {
    uint256 target_epoch = _find_timestamp_epoch(t, epoch);
    Point memory point = point_history[target_epoch];
    return _supply_at(point, t);
}
```

**Seen in:** Intuition VotingEscrow POST-MORTEM (Nov 2025, PR #126). Also potentially applicable to: Stargate VotingEscrow, any Curve veCRV fork.

---

## VECURV-02: Binary Search Off-by-One in Checkpoint Lookup

**Pattern:** After fixing VECURV-01, the binary search itself can have off-by-one issues:
- `_find_timestamp_epoch(t, maxEpoch)` must find the LARGEST epoch where `point_history[epoch].ts <= t`
- Common bug: returning epoch where `ts > t` due to incorrect binary search bounds

**Detection:** Check binary search loop termination. Verify `min` and `max` bounds. Test with: t exactly at a checkpoint ts, t between two checkpoints, t before all checkpoints, t after all checkpoints.

**Seen in:** Intuition added extensive tests for this (regression + fuzz tests in PR #126).

---

## EMIT-01: Epoch-Based Utilization Rollover — System vs Personal Inconsistency

**Pattern:** When utilization data rolls over between epochs:
- **Personal rollover** uses `userLastEpoch` (user's actual last active epoch) — survives gaps
- **System rollover** uses `currentEpoch - 1` (immediately previous epoch) — breaks across 2+ epoch gaps

```solidity
// System: only looks at previous epoch
if (totalUtilization[currentEpoch] == 0) {
    totalUtilization[currentEpoch] = totalUtilization[currentEpoch - 1]; // gap = lost
}

// Personal: uses actual last active epoch
personalUtilization[user][currentEpoch] = personalUtilization[user][userLastEpoch]; // survives gap
```

**Impact:** If no transactions occur for 2+ epochs, system utilization resets. This could temporarily reduce rewards via lower system utilization ratio.

**Detection:** Compare rollover logic between system-wide and per-user utilization. Check if gap epochs are handled differently.

**Seen in:** Intuition MultiVault `_rollover()`. Diligence Report 1 finding 5.2 addressed related issue.

---

## EMIT-02: Unclaimed Rewards Reclaim — Epoch Delay Check

**Pattern:** Protocols that allow reclaiming unclaimed rewards must ensure the claim window has fully closed before reclaim is possible.

```
Epoch N: rewards earned
Epoch N+1: users can claim epoch N rewards
Epoch N+2: epoch N claim window closed, protocol can reclaim
```

**Detection:** Check the epoch delay in `getUnclaimedRewardsForEpoch`:
```solidity
if (epoch > currentEpoch - 2) return 0; // only allow reclaim for epochs 2+ old
```

Verify that `claimRewards` only works for `currentEpoch - 1` (not older).

**Seen in:** Intuition TrustBonding + SatelliteEmissionsController. Both have 2-epoch delay, no overlap possible.

---

## EMIT-03: Utilization Gaming via Deposit+Redeem Cycling

**Pattern:** If utilization tracks gross deposits (not net), a user can inflate utilization by:
1. Deposit X → utilization += X
2. Immediately redeem X → utilization -= X (but only rawAssets, not msg.value)
3. Net utilization change = fees lost (small positive delta)

**Impact:** Small utilization boost per cycle, but bounded by fee costs. Usually not profitable unless fees are very low or rewards are very high.

**Detection:** Check if utilization tracks `msg.value` (gross) vs `assetsAfterFees` (net). Compare deposit utilization tracking with redeem utilization tracking.

**Seen in:** Intuition tracks `msg.value` for deposits and `rawAssetsBeforeFees` for redeems. Cycling costs entry+exit+protocol fees each round.

---

## SCOPE-01: POST-MORTEM Files = Free Intel

**Pattern:** Some repos include `POST-MORTEM.md` files documenting past production incidents. These are goldmines:
- Exact vulnerable code location
- Root cause analysis
- Fix approach
- Timeline of incident

**Detection:** `find . -iname "*post*mortem*" -o -iname "*incident*"` in target repos.

**Value:** 
1. Understand what types of bugs exist in this codebase
2. Check if the fix introduced new issues
3. Identify related code areas that might have similar patterns

**Seen in:** Intuition `POST-MORTEM.md` — VotingEscrow underflow, full incident timeline.

---

## SCOPE-02: C4 Contest README — "Recommended Focus Areas" = OOS Signal

**Pattern:** C4 contest READMEs often list "recommended focus areas" with specific line ranges. These are the exact changes from audit fixes. Bugs in these areas are almost certainly found by 100+ contest wardens and are OOS for the bounty.

**Detection:** Check the C4 contest repo README for line ranges. Cross-reference with the bounty's OOS list.

**Value:** Negative signal — skip these areas. Focus on code that's NOT in the recommended focus areas.

**Seen in:** Intuition C4 contest listed TrustBonding L335-340, ProgressiveCurve L240, AtomWallet L285-361.

---

## SCOPE-03: Prior Bounty Payouts = Maturity Signal

**Pattern:** Check what severity of findings have been paid out:
- Only Low payouts → Medium+ likely exhausted
- Mixed payouts → still opportunity
- No payouts → either very secure or nobody looked

**Detection:** Search for `[protocol] bug bounty payout` or check C4 announcements.

**Seen in:** Intuition paid 3 Low findings ($250-$500 each). Strong signal that Medium+ was not findable after 2x Diligence + C4 contest.

---

## WALLET-01: ERC-4337 AtomWallet — Owner Delegation Edge Case

**Pattern:** In ERC-4337 smart wallets with "unclaimed" state, `owner()` may return a protocol warden (not the actual storage owner) until the wallet is claimed:

```solidity
function owner() returns (address) {
    return isClaimed ? $._owner : multiVault.getAtomWarden();
}
```

**Impact:** Pre-claim, the warden has full control (execute, transferOwnership). Post-claim, the actual owner takes over. Potential griefing if warden is compromised.

**Detection:** Check `owner()` override for conditional returns. Trace all functions using `onlyOwner` modifier.

**Seen in:** Intuition AtomWallet — design choice (warden manages unclaimed wallets).

---

*Extracted from Intuition V2 audit research — April 2026*
*Source protocols: Intuition, Curve Finance (veCRV reference)*
*Applicable to: bonding curve protocols, veCRV forks, epoch-based emissions, knowledge graph protocols*
