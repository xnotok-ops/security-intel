# Unprotected Multicall Arbitrary Call — Approval Drain

**Source:** Defimon whitehat rescue, SquidRouter incident (April 2026)
**Impact:** $800K at risk, $512K rescued across multiple chains
**Category:** Access Control, Approval Misuse, Cross-Chain

---

## Pattern

A multicall contract exposes a public `run()` or `execute()` function that takes an array of arbitrary `Call` structs (target, callData, value) with no access control. If a user mistakenly approves tokens to the multicall contract instead of the intended router contract, anyone can call `run()` with a crafted payload to `transferFrom()` the victim's tokens.

## Vulnerable Code Shape

```solidity
struct Call {
    address target;
    bytes callData;
    uint256 value;
}

// NO access control — anyone can call
function run(Call[] calldata calls) external payable {
    for (uint i = 0; i < calls.length; i++) {
        (bool success,) = calls[i].target.call{value: calls[i].value}(calls[i].callData);
        require(success);
    }
}
```

## Attack Flow

```
1. Victim approves token spending to multicall contract (operational mistake)
   - Should have approved to router contract instead
   - Approval often set to type(uint256).max (infinite)
   - May happen across multiple chains (amplified exposure)

2. Attacker (or MEV bot) detects approval via on-chain monitoring

3. Attacker calls run() with crafted Call struct:
   Call({
       target: WETH_ADDRESS,
       callData: abi.encodeWithSelector(
           IERC20.transferFrom.selector,
           victim,        // from
           attacker,      // to
           approvedAmount // amount
       ),
       value: 0
   })

4. Multicall executes transferFrom on behalf of attacker
   - Works because victim approved the multicall contract
   - No access control prevents arbitrary callers
```

## Why It Happens

Two-contract architecture (router + multicall) where:
- Router has access control and business logic validation
- Multicall is a raw execution proxy with no restrictions
- Users or integrators approve the wrong contract address
- UI or documentation does not clearly distinguish the two addresses

## Detection

```bash
# Find unprotected multicall/execute functions
grep -rn "function run\|function execute\|function multicall" src/*.sol

# Check for access control on those functions
# VULNERABLE if: external/public + no onlyOwner/onlyRouter/msg.sender check

# Find Call struct pattern
grep -rn "struct Call" src/*.sol

# Check if multicall address differs from router address
# If separate contracts exist, verify users should NEVER approve multicall
```

## Cross-Chain Amplification

When the same multicall contract is deployed at the same address across multiple chains (common with CREATE2), a single operational mistake (approving multicall instead of router) exposes the user on ALL chains simultaneously. The attacker only needs to monitor approvals on one chain, then replay the drain on every chain where the victim has balances.

## Fix

```solidity
// Option 1: Restrict caller to router only
modifier onlyRouter() {
    require(msg.sender == router, "only router");
    _;
}

function run(Call[] calldata calls) external payable onlyRouter {
    // ...
}

// Option 2: Block transferFrom calls entirely
function run(Call[] calldata calls) external payable {
    for (uint i = 0; i < calls.length; i++) {
        // Prevent token theft via approval abuse
        bytes4 selector = bytes4(calls[i].callData[:4]);
        require(selector != IERC20.transferFrom.selector, "transferFrom blocked");
        require(selector != IERC20.approve.selector, "approve blocked");
        // ...
    }
}

// Option 3: Whitelist allowed target contracts
mapping(address => bool) public allowedTargets;

function run(Call[] calldata calls) external payable {
    for (uint i = 0; i < calls.length; i++) {
        require(allowedTargets[calls[i].target], "target not allowed");
        // ...
    }
}
```

## Bounty Hunting Checklist

```
- [ ] Protocol has separate multicall and router contracts?
- [ ] multicall.run() or multicall.execute() is public/external?
- [ ] No access control (onlyOwner, onlyRouter, whitelist)?
- [ ] No selector blacklist (transferFrom, approve blocked)?
- [ ] UI or docs could lead users to approve multicall address?
- [ ] Same multicall deployed on multiple chains (cross-chain amplification)?
- [ ] Any existing approvals to multicall visible on-chain?
```

## Related Patterns

- Arbitrary external call (SWC-123)
- Approval front-running
- Cross-chain replay
- MEV bot token sniping

## References

- First attack tx: `https://bscscan.com/tx/0x81d0c429ee7eae19d8c4d9d797dbd3828279060096e703b11cca739c9b1301e9`
- Victim: `0xaCc0c1f672B03B9a5fED4535f840f09B85f40E98`
- SquidMulticall (BSC): `0xaD6Cea45f98444a922a2b4fE96b8C90F0862D2F4`
- Defimon rescue: $512K recovered, returned via Blockscan chat

---

*Pattern extracted April 2026 by @xnotok*
