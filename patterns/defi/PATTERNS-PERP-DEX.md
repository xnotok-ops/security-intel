# Perp DEX Vulnerability Patterns

**Source:** GTE Perps & Launchpad + GTE Spot CLOB & Router — Code4rena (2025)
**Reports:** 
- Perps: https://code4rena.com/reports/2025-08-gte-perps-and-launchpad (10H, 25M)
- Spot: https://code4rena.com/reports/2025-07-gte-spot-clob-and-router (3H, 4M)
**Total Patterns:** 31
**Extracted:** April 2026

---

## Category 1: Margin & Leverage Logic

The most fertile area in perp DEX audits. Leverage changes, margin removal, and position closing must be mutually aware of each other's constraints.

### PERP-ML-01: Leverage Change Refunds Margin Backing Unrealized Loss
**Severity:** Medium | **Source:** GTE M-01

When changing leverage, `settleNewLeverage()` calculates new intended margin as `notional / newLeverage` but does not subtract unrealized loss from refundable amount. User with 20K margin, -10K uPnL, changing to higher leverage gets refunded margin that was covering the loss.

**Checklist:**
- [ ] Does `setLeverage` consider uPnL when calculating margin refund?
- [ ] Is `newMargin = max(intendedMargin, margin - |negativePnL|)`?

### PERP-ML-02: Leverage Increase Bypasses removeMargin Safety Checks
**Severity:** Medium | **Source:** GTE M-04

`removeMargin()` enforces `margin + upnl >= max(intendedMargin, totalNotional / 10)`. But `setPositionLeverage()` only checks `assertOpenMarginRequired()` which uses `maxOpenLeverage` instead of actual leverage. Increasing leverage effectively extracts margin that `removeMargin()` would block.

**Checklist:**
- [ ] Does leverage increase apply the same margin checks as `removeMargin`?
- [ ] Is there a unified margin validation path for both operations?

### PERP-ML-03: Margin Drain via Close After RemoveMargin
**Severity:** Medium | **Source:** GTE M-14

User removes margin while in profit (allowed if equity > intendedMargin). Then closes another position — the close flow returns `marginDelta` (proportional IM refund) as free collateral. User withdraws this refund, extracting more than deposited. Repeatable drain.

**Checklist:**
- [ ] On close, does `marginDelta` refund check if IM was already withdrawn?
- [ ] Is refund capped to actual reserved margin for that position?

### PERP-ML-04: Max Leverage Not Enforced for Legacy Positions
**Severity:** Medium | **Source:** GTE M-13

When admin reduces `maxOpenLeverage` (e.g., 50x → 25x), existing positions retain their old leverage and can open new positions at the old (now-exceeded) leverage. `getPositionLeverage()` returns stored value without validation.

**Checklist:**
- [ ] On new order fill, is position leverage validated against current `maxOpenLeverage`?
- [ ] Can legacy high-leverage positions increase size?

---

## Category 2: Pricing & Oracle

### PERP-PO-01: Expired Orders Included in Price Calculations
**Severity:** Medium | **Source:** GTE M-02

Mid price and impact price calculations use best bid/ask without checking order expiry. Attacker submits orders expiring next block, manipulating mark price, funding rate, and potentially triggering wrongful liquidations.

**Checklist:**
- [ ] Does `getMidPrice()` / `getImpactPrice()` filter expired orders?
- [ ] Can expired-but-not-removed orders affect mark price?

### PERP-PO-02: EMA Window Miscalculation (Snapshot Count vs Time)
**Severity:** Medium | **Source:** GTE M-03

`getBasisSpreadEMA(15 minutes)` passes 15*60=900 as snapshot count. With 10s intervals, that's 900*10=9000s=2.5 hours, not 15 minutes. Mark price lags actual market by 2+ hours.

**Checklist:**
- [ ] Does EMA use time-based or snapshot-count-based window?
- [ ] If snapshot-based, is the count correctly derived from interval frequency?

---

## Category 3: Liquidation

### PERP-LQ-01: Liquidation Stalls When Book Outside Divergence Band
**Severity:** Medium | **Source:** GTE M-06

Liquidation submits reduce-only IOC order. Matching is gated by divergence bands around mark price. If no in-band quotes exist (thin/volatile market), liquidation aborts with `ZeroOrder()`. Applies to BOTH standard AND backstop books — defeating backstop's purpose.

**Checklist:**
- [ ] Does backstop book share divergence constraints with standard book?
- [ ] Can liquidation proceed when no in-band quotes exist?
- [ ] Is there a fallback mechanism (system LP, boundary execution)?

### PERP-LQ-02: Backstop Liquidation Assumes Full Close on Partial Fill
**Severity:** Medium | **Source:** GTE M-15

`backstopLiquidate()` writes off entire margin balance (bad debt) assuming position fully closed. But IOC order may only partially fill. Remaining position exists with zero margin backing.

**Checklist:**
- [ ] After backstop liquidation, is `position.amount == 0` verified before writing off margin?
- [ ] Is FOK (fill-or-kill) used instead of IOC for backstop?

---

## Category 4: Orderbook DoS

### PERP-DOS-01: Gas DoS via Unbounded Queue Looping
**Severity:** High | **Source:** GTE H-01

`cancelWithdrawal` and `processWithdrawals` iterate over entire `_withdrawalQueue`. Attacker submits many tiny withdrawal requests → subsequent calls hit gas limit.

**Checklist:**
- [ ] Do queue operations iterate over unbounded arrays?
- [ ] Can users submit unlimited queue entries?
- [ ] Is there a mapping-based lookup for cancel operations?

### PERP-DOS-02: Backstop Bid Frozen by Tick-Size Constraint
**Severity:** High | **Source:** GTE H-02

Attacker places SELL backstop at price = `tickSize` (minimum). Any BUY backstop at the first legal price equals best ask → `PostOnlyOrderWouldBeFilled` revert. Bid side permanently frozen until attacker cancels.

**Checklist:**
- [ ] Can post-only orders on backstop book create deadlock conditions?
- [ ] Is there a minimum spread or one-tick buffer for post-only backstop?

### PERP-DOS-03: Reduce-Only Orders Inflate Open Interest
**Severity:** Medium | **Source:** GTE M-08

Reduce-only orders don't require collateral but still increment `quoteOI`. Attacker places reduce-only order with tiny amount + extreme price → massively inflates `metadata.quoteOI` → other users' orders revert on OI cap.

**Checklist:**
- [ ] Are reduce-only orders excluded from OI calculations?
- [ ] Is there a price cap relative to mark for reduce-only orders?

---

## Category 5: Funding Rate

### PERP-FR-01: Funding Mis-Accrual — Missing Time Normalization
**Severity:** Medium | **Source:** GTE M-11

`fundingIndex = fundingRate × indexTwap` without scaling by elapsed time. N settlements of Δt ≠ 1 settlement of N×Δt. Funding becomes path-dependent on settlement frequency.

**Checklist:**
- [ ] Is cumulative funding index scaled by `elapsed / baseInterval`?
- [ ] Is funding accrual path-independent (same result regardless of settlement frequency)?

---

## Category 6: Vault (ERC4626 / LP Vault)

### PERP-VT-01: ERC4626 Inflation Attack
**Severity:** Medium | **Source:** GTE M-09

GTL vault inherits ERC4626 without implementing inflation protection (decimal offset, virtual shares, or fixed initial rate). First depositor can inflate share price.

**Checklist:**
- [ ] Does vault implement ERC4626 inflation protection?
- [ ] Is there a minimum first deposit or dead shares mechanism?

### PERP-VT-02: Post-Only Orders Skew totalAssets
**Severity:** Medium | **Source:** GTE M-12

When GTL places post-only order on new subaccount, collateral moves to book but subaccount isn't added to GTL's tracking (only added on fill via `_processMakerFill`). `totalAssets()` under-reports → depositors get inflated shares.

**Checklist:**
- [ ] Are all collateral-moving operations reflected in vault accounting immediately?
- [ ] Is there a gap between collateral posting and subaccount registration?

---

## Category 7: Access Control / Emergency

### PERP-AC-01: Emergency Shutdown Bypass
**Severity:** Medium | **Source:** GTE M-05

`deactivateProtocol()` sets `active = false`. Trading functions have `onlyActiveProtocol` modifier, but margin/collateral management functions (addMargin, removeMargin, deposit, withdraw, setLeverage) don't. Users can extract funds during emergency.

**Checklist:**
- [ ] Do ALL state-changing functions check protocol active status?
- [ ] Can margin/collateral be withdrawn during emergency shutdown?

---

## Category 8: Race Conditions

### PERP-RC-01: Partial Fill Before AmendOrder
**Severity:** Medium | **Source:** GTE M-07

`amendLimitOrder` sets `order.amount = args.baseAmount` without checking if order was partially filled since submission. If 9/10 ETH filled before amend TX, amend resets to 10 ETH → user has 19 ETH exposure instead of 10.

**Checklist:**
- [ ] Does `amendOrder` validate current fill state before applying changes?
- [ ] Is there a nonce or fill-count check to detect stale amendments?

---

## Category 9: Array / Data Structure

### PERP-DS-01: Wrong Element Removed from Array
**Severity:** Medium | **Source:** GTE M-10

`_movePop(array, asset)` should swap target with last element then pop. Instead it does `array.set(index, asset)` (sets same value) then pops last element. Wrong asset removed from account tracking → active positions disappear, closed positions persist.

**Checklist:**
- [ ] Does `movePop` / `swapAndPop` correctly swap before popping?
- [ ] Unit test: remove middle element, verify array integrity

---

## Category 10: Launchpad / AMM Fee Accounting

Three Highs from one root cause: accrued launchpad fees create discrepancy between `balances` and `reserves`.

### PERP-LP-01: LP Burn Includes Accrued Fees (H-03)
Burn calculates distribution from `balanceOf` which includes unclaimed fees. Should use `balance - accruedFees`.

### PERP-LP-02: Swap Drain via Fee-Distorted Reserves (H-04)
Reserves = balance - fees. When fees accumulate, `k` invariant is satisfied with less actual liquidity, enabling profitable extraction.

### PERP-LP-03: Free LP Mint When Fees ≠ 0 (H-05)
Minting uses reserves (excluding fees), burning uses balances (including fees). Arbitrage: mint cheap (reserves-based) → burn expensive (balance-based).

### PERP-LP-04: 1 Wei Donation DoS on Graduation (H-09)
`addLiquidity` during graduation can be DoS'd with 1 wei donation that breaks expected ratio.

**Checklist for any AMM with fee accrual:**
- [ ] Do mint AND burn use the same basis (both reserves or both balances)?
- [ ] Are accrued-but-unclaimed fees excluded from LP share calculations?
- [ ] Can donations break liquidity ratio assumptions?

---

## Cross-Reference

| Pattern | Also seen in |
|---------|-------------|
| ERC4626 inflation | Midas, every vault protocol |
| LP self-play | DenariaFinance (lp-trader-self-play.md) |
| Margin logic bypass | GMX-style perps |
| Expired order pricing | Any CLOB-based DEX |
| Emergency shutdown bypass | Common in multi-module protocols |

---

## APPENDIX: Spot CLOB Patterns (from GTE Spot CLOB & Router)

**Source:** GTE Spot CLOB & Router — Code4rena (Jul-Aug 2025, $63K pool)
**Report:** https://code4rena.com/reports/2025-07-gte-spot-clob-and-router
**Results:** 3 High, 4 Medium

---

## Category 11: Linked List / Data Structure Integrity

### CLOB-DS-01: prevOrderId Not Persisted (Memory vs Storage)
**Severity:** High | **Source:** GTE Spot H-01

`addOrderToBook` passes order as `memory`. `_updateLimitPostOrder` sets `order.prevOrderId = tailOrder.id` — but this write is to memory, never persisted to storage. Entire double-linked list is broken: `prevOrderId` always null. Removing orders corrupts `limit.tailOrder`, leading to DoS when book is full.

**Checklist:**
- [ ] Are linked list updates writing to storage, not memory copies?
- [ ] After adding order, is `prevOrderId` readable from storage?
- [ ] Test: add 3 orders to same limit, remove middle one, verify list integrity

### CLOB-DS-02: Tree Size Doesn't Shrink on Tail-Only Removal
**Severity:** Medium | **Source:** GTE Spot M-03

When book is full and worst order is removed, only tail order of that limit is deleted. If limit has multiple orders, the limit (tree node) persists → `tree.size()` unchanged. Next order posting bypasses `maxNumLimitsPerSide` check (uses `==`). Book grows indefinitely.

**Checklist:**
- [ ] When removing for capacity, does code remove entire limit or just one order?
- [ ] Is tree size check `>=` instead of `==`?

---

## Category 12: Dust / Lot Size Edge Cases

### CLOB-DUST-01: Dust Orders Block Order Posting
**Severity:** High | **Source:** GTE Spot H-02

Partial fills can reduce maker order amount below `minLimitOrderAmountInBase` — no post-fill minimum check. Remaining dust order stays on book. Next incoming order matching this dust gets `quoteDelta = 0` (rounding) → reverts with `ZeroCostTrade`.

**Checklist:**
- [ ] After partial fill, is remaining order amount checked against minimum?
- [ ] Should orders below minimum be auto-removed after partial fill?

### CLOB-DUST-02: FOK Orders Revert on Sub-LotSize Residual
**Severity:** Medium | **Source:** GTE Spot M-02

FOK order checks `newOrder.amount > 0` for full-fill. But if residual amount < `lotSizeInBase`, it should be treated as filled (dust). Breaks multi-hop swaps via router where Uniswap output doesn't align with CLOB lot size.

**Checklist:**
- [ ] Does FOK check use `amount >= lotSize` instead of `amount > 0`?
- [ ] Can router output amounts always align with CLOB lot sizes?

---

## Category 13: Order Amendment Bypass

### CLOB-AMN-01: AmendOrder Bypasses maxLimitsPerTx DOS Protection
**Severity:** High | **Source:** GTE Spot H-03

`postLimitOrder` calls `incrementLimitsPlaced()` for DOS protection. `amend()` does NOT call it, even when amending to different price/side (which effectively creates a new book entry). Attacker can flood book with unlimited price level changes in single tx.

**Checklist:**
- [ ] Does `amendOrder` increment limit counter when price/side changes?
- [ ] Are all operations that create new book entries subject to same DOS protection?

### CLOB-AMN-02: Spam Expired/Cancelled Orders Wipe Legitimate Orders
**Severity:** Medium | **Source:** GTE Spot M-04

No minimum validity period for orders. User creates orders expiring next second at extreme prices. When book is full, these fill worst-limit slots. After expiry, legitimate orders at those limits were already displaced. Cost: only gas.

**Checklist:**
- [ ] Is there a minimum order validity period?
- [ ] Can expired orders displace legitimate orders from capacity-limited book?

---

## Category 14: Bitwise Logic Errors

### CLOB-BIT-01: Bitwise AND Used Instead of Logical Zero Check
**Severity:** Medium | **Source:** GTE Spot M-01

`if (a & b == 0)` used to detect zero-cost trades. But `1 & 2 == 0` is true even though neither value is zero. Should use `(a == 0 || b == 0)`.

**Checklist:**
- [ ] Are bitwise operations used for logical comparisons anywhere?
- [ ] Replace `a & b == 0` with `(a == 0 || b == 0)` for zero checks
