# FAsset / Collateral Bridge Patterns

Source: Code4rena Flare FAsset Audit (Aug-Sep 2025, $190K, 0H 4M 6L)
Protocol: FAssets — non-smart-contract assets (XRP) bridged to EVM via collateralized agents

---

## FASSET-01: Collateral Token Deprecation Incentive Misalignment

**Category:** Economic / Governance
**Severity:** Medium
**Applicable to:** Any protocol with swappable collateral tokens + liquidation

When collateral token becomes invalid (governance deprecation), agents are supposed to switch. But during liquidation with invalid token, pool covers entire payment instead of vault. This creates incentive for agent to NOT switch — effective liability drops from ~115% to ~65%.

**Pattern:** Governance-triggered state change creates economic advantage for actors who delay compliance.

**Check:** When collateral/token type can change via governance, verify incentives remain aligned during liquidation and other penalty flows.

---

## FASSET-02: Payment Reference Replay via Predictable IDs

**Category:** Cross-chain / Payment verification
**Severity:** Medium
**Applicable to:** Any protocol using payment references for cross-chain verification

Agent can predict future `newRedemptionRequestId` (on-chain slot 14, 8 bytes) and `randomizedIdSkip()` (guessable from block number). Attack flow:
1. Agent pays own address using valid payment reference (pre-computed)
2. Creates `transferToCoreVault` request that returns same payment ID
3. Payment was made before `request.firstUnderlyingBlock` → can't confirm via `confirmRedemptionPayment`
4. Can't challenge via `illegalPaymentChallenge` (matching redemption active) or `freeBalanceNegativeChallenge` (redemption value offsets spent amount)
5. Result: Agent inflates underlying balance, can mint more FAssets without backing

**Pattern:** Predictable payment/request IDs + temporal ordering assumptions = replay/inflation vector.

**Check:**
- Are request IDs predictable? Can external observer compute next ID?
- Does verification rely on temporal ordering (payment must come AFTER request)?
- Can challenge mechanisms be bypassed by crafting payments that match legitimate redemption references?

---

## FASSET-03: Token Address Upgrade Race Condition in Reward Claiming

**Category:** Token migration / Upgrade
**Severity:** Medium
**Applicable to:** Any protocol with upgradeable token addresses + reward claiming

When WNAT address changes via governance (`updateSystemContracts`), if agent claims rewards BEFORE calling `upgradeWNatContract`:
1. Rewards in new WNAT arrive at pool
2. `claimDelegationRewards` checks `wNat.balanceOf` — but wNat still points to OLD token
3. `totalCollateral` doesn't increase (wrong token tracked)
4. Agent then calls `upgradeWNatContract` (swaps old→new)
5. Uncounted new WNAT can be swept by agent

**Pattern:** Token address upgrade + reward claiming creates window where balances tracked in old token miss rewards in new token.

**Check:**
- When token address can be upgraded, are all balance-tracking functions aware of the transition?
- Can reward claiming happen between token address update and contract migration?
- Who controls the ordering of upgrade steps?

---

## FASSET-04: Liquidation Price Slippage (No Min-Out Protection)

**Category:** Liquidation / Oracle
**Severity:** Medium
**Applicable to:** Any protocol where liquidators receive collateral at oracle price

Between liquidation TX submission and execution, asset price can drop. Liquidator expected 10K USDC + 500 NAT but received 9K USDC + 450 NAT due to price movement. No slippage protection parameter.

**Pattern:** Liquidation functions that pay out collateral based on current oracle price without minimum output parameter.

**Check:** Does `liquidate()` have a `minCollateralOut` parameter? If oracle updates between submit and execute, who bears the price risk?

---

## FASSET-05: Self-Close Exit Off-By-One (Strict > vs >=)

**Category:** Logic / DoS
**Severity:** Low
**Applicable to:** Any protocol with capacity-gated exit mechanisms

`maxAgentRedemption > requiredFAssets` uses strict inequality. When no redemption needed (requiredFAssets=0) but agent capacity is also 0, exit reverts. When exact match (capacity == required), also reverts unnecessarily.

**Pattern:** Strict inequality in capacity checks blocks legitimate operations at boundary conditions.

**Check:** Look for `>` where `>=` is correct, especially in exit/withdrawal flows with computed capacity values.

---

## FASSET-06: Zero-Input Silent No-Op Traps msg.value

**Category:** Input validation / Fund lock
**Severity:** Low
**Applicable to:** Payable functions with loop-based processing

`redeem(0 lots)` with msg.value > 0: loop doesn't execute, no redemptions created, executor fee distribution loop also skipped, no refund path. msg.value permanently locked.

**Pattern:** Payable function with zero-input path that skips all processing but doesn't refund.

**Check:** For every payable function, trace the zero/empty input path. Is msg.value refunded or does it get trapped?

---

## FASSET-07: Oracle Zero-Price Divide-by-Zero DoS

**Category:** Oracle / DoS
**Severity:** Low
**Applicable to:** Any protocol doing price conversions with division

FTSO can theoretically return price=0. Multiple conversion functions divide by token price without zero guard → revert. Affects liquidation health checks, core vault calculations.

**Pattern:** Price conversion functions that divide by oracle price without checking for zero.

**Check:** Grep for division by price variables. Verify zero-price handling in all conversion paths, especially liquidation-critical ones.

---

## FASSET-08: Gwei Rounding Dust Accumulation

**Category:** Precision / Fund lock
**Severity:** Low
**Applicable to:** Any protocol storing values in reduced precision (gwei instead of wei)

Executor fee stored as `uint64` in gwei. Sub-gwei remainder (<1 gwei per call) is never refunded when executor is set. Dust accumulates in contract.

**Pattern:** Precision reduction (wei→gwei, token→lot) without handling remainder.

**Check:** When values are stored in lower precision, is the remainder refunded or tracked?

---

## META: Scope Assessment Notes

- **FAsset = non-SC asset bridge**: Novel attack surface — payment reference manipulation, cross-chain verification timing, underlying chain assumptions
- **$190K pool, 0 Highs, 4 Mediums**: Mature codebase (105 contracts, 8760 LOC, multiple prior audits by Zellic/Coinspect). Pattern: heavily-audited protocols yield mostly economic/logic findings, not classic vulnerabilities
- **Agent-centric model**: Most findings involve agent misbehavior (incentive misalignment, balance inflation, reward theft). Key attack persona = malicious agent
- **Flare-specific**: FTSO oracle integration, WNAT upgrade mechanism, FDC verification — Flare ecosystem primitives create unique attack surfaces

---

*Extracted: April 2026*
*Source: code4rena.com/reports/2025-08-flare-fasset*
