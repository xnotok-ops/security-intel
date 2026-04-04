# Admin Key Compromise Case Studies

Real-world exploits dari compromised privileged keys di DeFi protocols.

---

## Case Study 1: Drift Protocol (April 1, 2026)

### Summary
| Metric | Value |
|--------|-------|
| **Protocol** | Drift Protocol (Solana DEX) |
| **Chain** | Solana |
| **Drained** | $213M+ (possibly $240M) |
| **Time** | < 10 seconds |
| **Root Cause** | Admin signer key compromised |

### Attack Sequence

**Step 1: Market Creation**
```
InitializeSpotMarket → Create Spot Market #63 for CVT token
- initial_asset_weight = 1.0 (full collateral value)
- maintenance_asset_weight = 0.9 (minimal liquidation risk)
- No borrow limits
```

**Step 2: Disable Circuit Breakers (same tx)**
```
Withdrawal limits raised 20x on real assets:
USDC: 25T → 500T
wETH: 200B → 500T
dSOL: 5T → 500T
JLP: 5B → 500T
cbBTC: 10B → 500T
```

**Step 3: Oracle Manipulation**
- Set oracle_source to SwitchboardOnDemand feed attacker controlled
- Manipulated price: 500M CVT = $200M+ in SOL

**Step 4: Drain**
1. Mint 750M CVT (attacker held 80%)
2. Deposit 500M CVT as collateral
3. Borrow all real assets
4. Withdraw everything

**Result:**
- JLP vault: 41.7M → 133 JLP (99.9997% drained)
- Total extracted: $213M+

### Why It Worked

| Control | Status |
|---------|--------|
| Timelock | ❌ None |
| Multisig | ❌ None |
| Governance delay | ❌ None |
| Circuit breaker on admin ops | ❌ None |
| Parameter bounds | ❌ None |

Admin key could in single transaction:
- Create new collateral market with arbitrary params
- Set oracle to attacker-controlled account
- Disable withdrawal guards on all vaults

### Audit Flags

If auditing Drift-like protocols, check:
- [ ] Can admin create markets without timelock?
- [ ] Can admin set arbitrary oracle sources?
- [ ] Are there bounds on asset weights?
- [ ] Can circuit breakers be disabled by admin?
- [ ] Is there rate limiting on admin operations?

---

## Case Study 2: Resolv USR (March 22, 2026)

### Summary
| Metric | Value |
|--------|-------|
| **Protocol** | Resolv Protocol (USR stablecoin) |
| **Chain** | Ethereum |
| **Minted** | 80M unbacked USR |
| **Extracted** | ~$23-25M |
| **Time** | Minutes |
| **Root Cause** | SERVICE_ROLE key compromised via AWS KMS |

### How Minting Worked (Pre-Exploit)

Two-step off-chain approval process:
```
1. requestSwap: User deposits USDC → contract logs deposit, waits
2. completeSwap: Off-chain SERVICE_ROLE signs approval → contract mints USR
```

**Fatal flaw:** Contract had minimum check but NO maximum. Whatever SERVICE_ROLE signed, contract would mint.

### Attack Sequence

**Step 1: AWS KMS Breach**
- Attacker compromised Resolv's AWS cloud infrastructure
- Gained access to AWS Key Management Service (KMS)
- Extracted SERVICE_ROLE signing key

**Step 2: Deposit**
```
Deposited ~$100-200K USDC
Called requestSwap
```

**Step 3: Malicious Mint**
```
Using compromised SERVICE_ROLE key:
Tx1: completeSwap → mint 50M USR
Tx2: completeSwap → mint 30M USR
Total: 80M USR from ~$150K collateral
```

**Step 4: Cash Out**
```
USR → wstUSR (staked version)
wstUSR → USDC/USDT (via Curve, KyberSwap, Velodrome)
USDC/USDT → ETH
Total extracted: ~$23-25M (~11,400 ETH)
```

**Result:**
- USR price: $1.00 → $0.025 (97.5% crash)
- Multiple Morpho vaults with USR exposure also damaged
- Cascading depeg across DeFi ecosystem

### Why It Worked

| Control | Status |
|---------|--------|
| Max mint limit | ❌ None on-chain |
| Oracle/price check | ❌ None |
| Collateral ratio verification | ❌ None |
| SERVICE_ROLE security | ❌ Single EOA, not multisig |
| Rate limiting on mints | ❌ None |

The entire trust model sat on a single signing key stored in AWS.

### Audit Flags

If auditing stablecoin minting systems, check:
- [ ] Is there a max mint limit enforced on-chain?
- [ ] Is collateral ratio verified by oracle?
- [ ] Is the signing key a multisig or single EOA?
- [ ] Where is the key stored? (HSM vs cloud vs hot wallet)
- [ ] Is there rate limiting on mint operations?
- [ ] Can anomalous mint ratios be detected and blocked?

---

## Common Patterns

### Both exploits shared:

1. **Single point of failure** — One key controlled critical operations
2. **No on-chain validation** — Trusted off-chain components blindly
3. **No timelocks** — Instant execution of privileged operations
4. **No rate limits** — Unlimited operations in single transaction
5. **No monitoring/circuit breakers** — No anomaly detection

### Attack Surface Checklist

When auditing privileged key setups:

```
[ ] KEY SECURITY
    [ ] Multisig required?
    [ ] Timelock on sensitive operations?
    [ ] Hardware security module (HSM)?
    [ ] Key rotation policy?

[ ] ON-CHAIN VALIDATION
    [ ] Parameter bounds enforced?
    [ ] Oracle price checks?
    [ ] Max limits on critical operations?
    [ ] Sanity checks on inputs?

[ ] OPERATIONAL CONTROLS
    [ ] Rate limiting?
    [ ] Circuit breakers?
    [ ] Real-time monitoring?
    [ ] Anomaly detection?
    [ ] Pause functionality?

[ ] BLAST RADIUS LIMITATION
    [ ] Can single key drain entire protocol?
    [ ] Are there withdrawal limits?
    [ ] Delayed withdrawals for large amounts?
```

---

## Impact on Bug Bounty

### What to look for:

1. **Map admin powers** — List every function admin can call
2. **Check for timelocks** — Are sensitive operations delayed?
3. **Verify multisig** — Is admin a single EOA or multisig?
4. **Look for unbounded operations** — No max limits = red flag
5. **Oracle trust** — Can admin set arbitrary oracle sources?
6. **Circuit breakers** — Can admin disable safety mechanisms?

### Severity Considerations

| Finding | Typical Severity |
|---------|------------------|
| Admin can drain funds with single tx | Critical (but often OOS) |
| No timelock on market creation | Medium-High |
| Unbounded mint with privileged key | High |
| Admin can disable circuit breakers | Medium-High |
| No multisig on critical operations | Medium |

**Note:** Many programs exclude "admin can rug" as accepted risk. Check scope before reporting.

---

## References

- Drift: https://twitter.com/omeragoldberg/status/2039455314089746747
- Resolv: https://www.chainalysis.com/blog/lessons-from-the-resolv-hack/
- Resolv (DeFiPrime): https://defiprime.com/resolv-usr-exploit

---

*Last updated: April 2026*
