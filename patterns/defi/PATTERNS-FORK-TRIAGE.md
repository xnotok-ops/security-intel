# Patterns: Centralized Oracle Push Model

**Source:** Cronos SC audit (Tectonic), April 2026
**Pattern ID:** centralized-oracle-push

---

## Description

Protocol uses custom oracle contracts where authorized off-chain updaters push prices on-chain. No on-chain price reading from DEX/AMM pools.

## Detection

Check oracle contract for:
- `updatePrice()` or similar write function with access control
- `authorizedUpdaters` mapping or role-based access
- No `getReserves()`, `balanceOf(pool)`, `slot0()`, or TWAP reads
- Implements Chainlink `AggregatorV2V3Interface` for consumer compatibility

## Impact on Audit

- Flash loan oracle manipulation = NOT POSSIBLE
- DEX pool manipulation = NOT POSSIBLE (price not read on-chain)
- Remaining vectors: compromised updater key (usually OOS), staleness (check consumer)

## Consumer-Side Checks

Even with centralized push, check if consumer (lending protocol) validates:
1. Staleness — does it check `updatedAt` vs `block.timestamp`?
2. Zero/negative price — does it reject `answer <= 0`?
3. Round completeness — does it verify `answeredInRound >= roundId`?

## Real Example

Tectonic (Cronos) — CronosOracle contract:
```solidity
function updatePrice(uint256 _roundId, uint256 _timestamp, int256 _newPrice) 
    public onlyAuthorizedUpdaters {
    lastCompletedRoundId = _roundId;
    prices[_roundId] = _newPrice;
    updatedTimestamps[_roundId] = _timestamp;
}
```
- No price bounds, no deviation check
- `_timestamp` controlled by caller (not `block.timestamp`)
- All 17 Tectonic oracle feeds use same contract

## Skip Signal

If target protocol uses centralized push oracle AND bounty program has "oracle manipulation in scope":
- Oracle manipulation = in scope but not exploitable
- Don't waste time on flash loan attack chains
- Focus on consumer-side staleness/validation instead

---

# Patterns: GMX V1 Fork Audit Checklist

**Source:** Cronos SC audit (Fulcrom), April 2026 + GMX July 2025 exploit
**Pattern ID:** gmx-v1-fork-checklist

---

## Pre-Audit Triage

Before deep-diving any GMX V1 fork:

1. **Check ETH handling** — Does vault use `_transferOutETH` with `.call{value:}`? If ERC20-only (safeTransfer), July 2025 reentrancy = N/A.
2. **Check ShortsTracker** — Is there a separate ShortsTracker contract? If yes, check if global short average price update is split between Vault and ShortsTracker (the bug that caused $42M exploit).
3. **Check upgradeable** — Is vault behind proxy? If yes, check if implementation is initialized.
4. **Check custom code** — Diff against GMX V1 original. Focus ONLY on custom additions.

## Common Custom Additions in GMX V1 Forks

| Addition | Risk Level | Notes |
|----------|-----------|-------|
| Broker fee system | Low | Usually self-inflicted (user pays own collateral) |
| Referral/discount | Low | Fee accounting complexity but rarely exploitable |
| Partial liquidation | Low | Design choice, check penalty bypass |
| Circuit breaker | Low | Usually additive safety, not attack surface |
| Custom oracle (Pyth/Chainlink) | Medium | Check staleness, deviation, sequencer |
| Cross-chain bridge | High | New trust assumptions, message replay |
| Custom token (rebasing/fee-on-transfer) | High | Breaks internal accounting |

## Known GMX V1 Exploits (likely OOS in fork bounties)

1. **July 2025 $42M reentrancy** — `_transferOutETH` callback → bypass ShortsTracker → inflate AUM → drain GLP
2. **Sept 2022 AVAX/USD $565K** — zero-slippage + Chainlink spot price → open opposing positions → profit from oracle lag
3. **2022 $1M bounty** — non-atomic global short size / average price updates

## Skip Signals for GMX V1 Fork Bounties

- "Previously known vulnerabilities on Ethereum forks = OOS" → skip unless significant custom code
- Prior audit (SlowMist, CertiK, etc) + minimal custom additions → diminishing returns
- ERC20-only vault + ReentrancyGuard + Solidity 0.8 → most classic vectors eliminated

---

# Patterns: Fork Bounty Program Triage

**Source:** Cronos SC + Dexalot experience, April 2026
**Pattern ID:** fork-bounty-triage

---

## Red Flags — Skip Early

1. **Multiple mature forks in one program** — Each fork = battle-tested codebase, known bugs likely OOS
2. **"Known fork vulnerabilities = OOS" clause** — Eliminates most findings before you start
3. **Critical-only payouts** — Medium/Low = $0, high bar for actionable findings
4. **Prior professional audit** — SlowMist/CertiK/Trail of Bits already covered obvious bugs
5. **Centralized oracle** — Eliminates flash loan / oracle manipulation vectors

## Green Flags — Worth Investing Time

1. **Original codebase** (not a fork)
2. **Pays Medium severity** ($1K-$5K still worth it for rep)
3. **Complex cross-contract interactions** (bridges, cross-chain, novel DeFi primitives)
4. **No prior audit** or audit > 1 year old with significant code changes
5. **On-chain oracle reading** (AMM spot, TWAP with short window)
6. **New token standards** (ERC4626, Token-2022, rebasing tokens)

## Decision Framework

```
Time estimate > 8 hours AND all red flags present? → SKIP
Time estimate < 4 hours AND >= 2 green flags? → DO IT
Mixed signals? → Spend max 2 hours on Phase 1 recon, then decide
```
