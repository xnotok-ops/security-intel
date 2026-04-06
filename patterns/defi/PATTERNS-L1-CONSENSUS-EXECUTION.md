# L1 Blockchain / Consensus / Execution Patterns

Source: Code4rena Monad Audit (Sep-Oct 2025, $500K, 4H 7M 2L)
Protocol: Monad — high-performance EVM-compatible L1 with parallel execution (Rust/C++)

---

## MONAD-01: Consensus vs Execution Gas Calculation Mismatch (Legacy TX EIP-1559 Misapplication)

**Category:** Consensus/Execution divergence
**Severity:** High
**Applicable to:** Any L1/L2 with separate consensus and execution layers

Consensus layer applied EIP-1559 gas ceiling (`min(max_fee, base_fee + priority_fee)`) to legacy transactions. Execution layer correctly treated legacy TX gas as `gas_price * gas_limit` without ceiling. Result: consensus admits transactions that execution rejects as invalid → entire block invalidated.

**Pattern:** When consensus and execution have independent gas/fee calculation code paths, any divergence in how transaction types are handled creates block invalidation vectors.

**Check:**
- Are legacy, EIP-1559, EIP-4844, EIP-7702 transactions all handled identically in BOTH consensus and execution fee computation?
- Can an attacker craft transactions that pass consensus but fail execution validation?

---

## MONAD-02: Validation Check Ordering Mismatch Between Components

**Category:** Consensus/mempool divergence
**Severity:** High
**Applicable to:** Any system with multi-stage validation (mempool → block building → execution)

Mempool checked `chain_id` BEFORE `SYSTEM_SENDER` check for EIP-7702 authorizations. Block validator checked `SYSTEM_SENDER` FIRST, then `chain_id`. Attack: craft TX with `authority = SYSTEM_SENDER` + invalid `chain_id`. Mempool accepts (chain_id fails first, skips system check). Block validator rejects (system check fails first). Result: accepted-but-unexecutable TX causes every block containing it to be rejected → chain halt.

**Pattern:** When multiple components validate the same data but check conditions in different order, short-circuit evaluation creates acceptance/rejection divergence.

**Check:**
- For every validation that exists in >1 component (mempool, block builder, block validator, execution), are checks performed in identical order?
- Can a value that fails check A but passes check B route differently depending on evaluation order?

---

## MONAD-03: Mempool Admission vs Block Building Affordability Gap

**Category:** Economic / DoS
**Severity:** High
**Applicable to:** Any blockchain with separate mempool admission and block proposal validation

Mempool checked `balance >= base_fee * gas_limit`. Block builder checked full EIP-1559 bid `balance >= (base_fee + priority_fee) * gas_limit`. Attacker submits high-tip TXs that pass mempool gate but fail block building. TXs stay in mempool, get re-selected every proposal, produce empty blocks.

Cost: ~34 MON ($7) to stuff 16K addresses. No TXs ever execute, so attacker never pays gas.

**Pattern:** Weaker admission criteria at entry point vs stronger criteria at processing point = permanent DoS. If rejected items return to pool instead of being evicted, the DoS is self-sustaining.

**Check:**
- Is mempool admission check AT LEAST as strict as block building check?
- When a TX fails block building, is it evicted from pool or returned for re-selection?
- What's the cost to fill the mempool with never-executable transactions?

---

## MONAD-04: EIP-7702 Order-Dependent State Mismatch

**Category:** State consistency / DoS
**Severity:** High
**Applicable to:** Any system where state flags (delegation, authorization) are set at different times in different components

Txpool marks authority as "delegated" lazily AFTER including the EIP-7702 TX. Block validator pre-marks ALL 7702 authorities as delegated BEFORE per-TX checks. Two TXs from same authority: X (high-tip EIP-1559, passes emptying check) and Y (lower-tip EIP-7702, sets delegation). Txpool orders X before Y. Block validator globally applies delegation, reclassifies X as non-emptying, rejects with InsufficientReserveBalance.

**Pattern:** When a flag/state is applied "lazily per-item" in one component but "globally upfront" in another, ordering-sensitive items can pass one but fail the other.

**Check:**
- Are state transitions (delegation, authorization, permissions) applied at the same point in both mempool/proposal and validation?
- Can TX ordering create divergent state between components?

---

## MONAD-05: P2P Message Identity Impersonation (Missing pubkey-to-identity binding)

**Category:** P2P / Authentication
**Severity:** Medium
**Applicable to:** Any P2P network protocol with identity fields in messages

Cryptographic signature verified (Stage 1) but recovered pubkey never compared to identity fields in message payload like `validator_id` or `node_id` (Stage 2 missing). Attacker signs with own key but claims to be any validator/node.

Impact: group slot exhaustion DoS, reputation poisoning, peer table poisoning.

**Pattern:** Message authentication verifies "someone signed this" but not "the claimed identity signed this."

**Check:**
- After signature recovery, is recovered pubkey compared to EVERY identity claim in the message?
- Can an attacker impersonate a specific node/validator by crafting messages with forged identity fields?

---

## MONAD-06: Bounded Channel Panic via Message Flooding

**Category:** DoS / Crash
**Severity:** Medium
**Applicable to:** Any async system using bounded channels with `.expect()` or `.unwrap()` on send

Bounded channel (1024 slots) uses `.expect("executor is lagging")` on `try_send()`. Unauthenticated attacker floods with `ForwardedTx` messages → channel full → panic → node crash.

**Pattern:** `try_send().expect()` or `try_send().unwrap()` on bounded channels = remote crash vector if message source is external/unauthenticated.

**Check:**
- Grep for `.expect()` or `.unwrap()` after `try_send` / `send` on bounded channels
- Is the message source authenticated/rate-limited before reaching the channel?

---

## MONAD-07: Post-Serialization Size Check OOM

**Category:** DoS / Resource exhaustion
**Severity:** Medium
**Applicable to:** Any RPC/API server with response size limits

Server fully materializes + serializes response, THEN checks size limit. For batch RPC (5000 items default), entire batch is serialized into memory before limit check. Large `eth_getLogs` responses × batch size = multi-GB allocation → OOM.

**Pattern:** Size/resource limits checked AFTER allocation rather than BEFORE. Budget should be enforced during construction, not post-construction.

**Check:**
- Where is the response size limit checked? Before or after serialization?
- Is there a per-item size cap for batch requests?
- Are expensive endpoints (getLogs, feeHistory) concurrency-limited?

---

## MONAD-08: Block Device Trim Off-By-One Write Position

**Category:** Data corruption
**Severity:** Medium
**Applicable to:** Any storage layer with trim/discard operations

After advancing offset for trim operation (`range[0] += DISK_PAGE_SIZE`), code writes preserved partial page data back to the ADVANCED offset instead of original. Corrupts adjacent page data.

**Pattern:** When modifying a pointer/offset for one operation, ensure subsequent operations using the same variable account for the modification.

**Check:**
- After modifying an offset/pointer for operation A, is the original value preserved for operation B?
- Store original before modification: `let original = range[0]; range[0] += PAGE_SIZE; /* trim */ pwrite(fd, buf, PAGE_SIZE, original);`

---

## MONAD-09: RPC Encoding Spec Violation (encode vs encode_2718)

**Category:** Spec compliance
**Severity:** Medium
**Applicable to:** Any EVM implementation with RPC layer

`debug_getRawReceipts` used `r.encode()` (plain RLP) instead of `r.encode_2718()` (EIP-2718 typed encoding). Typed receipts missing TransactionType prefix byte. Same codebase correctly used `encode_2718` for transactions.

**Pattern:** Inconsistent use of encoding methods across related endpoints. When a library provides both `encode()` and `encode_2718()`, easy to use wrong one.

**Check:**
- For all RPC endpoints returning typed data, verify correct encoding method
- Search for `encode()` near typed transaction/receipt data — should be `encode_2718()`

---

## MONAD-10: Stale Timer Round Causing Vote Misrouting

**Category:** Consensus / Liveness
**Severity:** Medium
**Applicable to:** Any consensus protocol with timer-based vote scheduling

Vote timer fires for round R+1, but consensus already advanced to R+2. Timer callback uses timer's round (R+1) to determine vote recipients, not the actual vote's round (R+2). Vote sent to wrong leader.

**Pattern:** Asynchronous timers that carry stale round/epoch information when the main state has advanced.

**Check:**
- When a timer fires, does the callback use the timer's stored context or the current state?
- If state can advance between scheduling and firing, is the timer context still valid?

---

## MONAD-11: Base Fee Mismatch Between Consensus and Execution Headers

**Category:** Consensus/Execution divergence
**Severity:** Medium
**Applicable to:** Any blockchain with separate header construction for consensus vs execution

Consensus header and execution header constructed via independent data paths. Block validator didn't verify `consensus.base_fee == execution.base_fee_per_gas`. Malicious proposer could set low consensus base_fee, causing transactions to pass consensus fee checks but fail execution.

**Pattern:** When the same value is represented in multiple headers/structures built independently, validators must cross-check consistency.

**Check:**
- Are all shared fields between consensus and execution headers explicitly compared during validation?
- Can a field be set independently in one header without affecting the other?

---

## META: Scope Assessment Notes

- **L1 infra audit** (Rust/C++, 164K LOC): Very different from DeFi — findings are consensus bugs, P2P attacks, RPC DoS, storage corruption. No token/economic exploits.
- **$500K pool, 4H 7M**: All Highs are consensus/execution divergence or mempool DoS. Pattern: multi-component systems where same logic implemented independently create mismatch vectors.
- **EIP-7702 as attack surface**: 3 of 4 Highs involve EIP-7702 (account abstraction). New EIPs = new attack surface, especially at component boundaries.
- **Key attack persona**: unauthenticated external attacker (P2P port, RPC endpoint). No staking required for most attacks.
- **Free DoS**: Most attacks cost nothing because transactions are never executed (rejected at consensus/validation level). The economic barrier of gas is bypassed.

---

*Extracted: April 2026*
*Source: code4rena.com/reports/2025-09-monad*
