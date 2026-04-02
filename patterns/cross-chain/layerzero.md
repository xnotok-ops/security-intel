# LayerZero Security Patterns Reference

Collection of known vulnerability patterns from LayerZero audits — useful for auditing ANY LayerZero integration or cross-chain messaging protocol.

## Sources
- LayerZero Labs Audits Repo: https://github.com/LayerZero-Labs/Audits
- Zellic Publications: https://github.com/Zellic/publications
- C4 Reports: 2023-07-tapioca, 2025-09-layerzero (Sui), 2025-10-layerzero (Starknet)
- Dedaub DVN-AVS Audit (May 2025)
- ChainSecurity OFT/OApp Audit
- Paladin LayerZero Audits

---

## HIGH SEVERITY PATTERNS

### 1. Channel Blocking DoS
**Source**: Tapioca DAO C4 (H-16, H-17)
```
[H-16] Attacker can block LayerZero channel due to variable gas cost of saving payload
[H-17] Attacker can block LayerZero channel due to missing check of minimum gas passed
```
**Pattern**: If `lzReceive` fails due to out-of-gas, the message is stored in blocking mode. Attacker can intentionally trigger OOG to block channel.
**Check**: Ensure adequate gas is passed, validate minGas settings.

### 2. Cross-Chain Token Theft via OFT
**Source**: Tapioca DAO C4 (H-11, H-12, H-13, H-14)
```
[H-11] TOFT exerciseOption can be used to steal all underlying erc20 tokens
[H-12] TOFT removeCollateral can be used to steal all the balance
[H-13] TOFT triggerSendFrom can be used to steal all the balance
[H-14] All assets of (m)TapiocaOFT can be stolen by depositing to strategy
```
**Pattern**: Cross-chain calls that don't properly validate parameters allow attackers to specify arbitrary receivers.
**Check**: Validate all receiver addresses, amounts, and callback data in cross-chain flows.

### 3. DVN Admin Role Abuse
**Source**: Dedaub DVN-AVS Audit (High)
```
Admin can slash operators without proper checks
Security council can choose who gets slashed
```
**Pattern**: Centralized admin roles in DVN/AVS can abuse slashing mechanisms.
**Check**: Review admin permissions, multisig requirements, timelock delays.

### 4. Replay Attacks (TTL/Expiration Mismatch)
**Source**: LayerZero Stellar C4 2026 (notok finding)
```
UsedHash TTL (30 days) can expire before signature expiration (60+ days)
Allows replay of already-executed transactions
```
**Pattern**: Replay protection storage with TTL can expire before authorization validity.
**Check**: Ensure replay protection TTL >= max signature/authorization expiration.

---

## MEDIUM SEVERITY PATTERNS

### 5. Message Channel Blocking via Non-Reverting lzReceive
**Source**: Maia DAO C4 (M-09)
```
If exception occurs in lzReceiveNonBlocking, lzReceive will not revert
Native tokens sent remain stuck in contract
```
**Pattern**: Non-reverting receiver implementations can silently fail and trap funds.
**Check**: Ensure proper error handling in `_lzReceive` implementations.

### 6. Incorrect Address Encoding/Decoding
**Source**: Maia DAO C4 (M-11)
```
Incorrect source address decoding breaks LayerZero communication
Array slicing at wrong indexes
```
**Pattern**: Cross-chain address encoding differences cause communication failures.
**Check**: Verify encode/decode paths for different chain address formats (EVM 20 bytes vs Solana/Stellar 32 bytes).

### 7. Missing Integration Checklist Items
**Source**: Multiple audits
```
Most Low/QA issues come from not following LayerZero integration checklist
```
**Pattern**: Standard integration best practices not followed.
**Check**: Always review official LayerZero integration documentation.

### 8. Config Override Risks
**Source**: LayerZero Starknet C4 README
```
LayerZero should never have ability to override user-set configuration
Censorship resistance on native payment path
```
**Pattern**: Protocol admin shouldn't be able to censor or override OApp configs.
**Check**: Verify owner/admin can't override user-set message lib configs.

---

## LOW/QA PATTERNS

### 9. Storage Limits & DoS
**Source**: LayerZero Stellar C4 2026 (notok finding)
```
254 DVNs combined > 200 Soroban storage read limit
Permanent DoS on messaging path
```
**Pattern**: Chain-specific storage/compute limits not considered in validation.
**Check**: Validate combined limits, not just individual limits.

### 10. Fee Calculation Discrepancies
**Source**: LayerZero Sui C4 README
```
Is fee calculation in msglib sound? 
Differences between implementations may be unintended
```
**Pattern**: Fee calculation differences across implementations.
**Check**: Compare fee calculation logic across different chain implementations.

### 11. Nonce Ordering Bypass
**Source**: General LayerZero concerns
```
Message cannot execute until all messages before it delivered
Message can only execute once
```
**Pattern**: Nonce ordering can be bypassed via skip/nilify.
**Check**: Understand implications of skip, nilify, burn operations.

---

## LAYERZERO-SPECIFIC ATTACK SURFACES

### OApp (Omnichain Application)
- [ ] Validate `_origin.srcEid` and `_origin.sender`
- [ ] Check `_guid` uniqueness handling
- [ ] Review `_lzReceive` error handling
- [ ] Verify delegate permissions

### OFT (Omnichain Fungible Token)
- [ ] Check mint/burn balance accounting
- [ ] Validate shared decimals conversion
- [ ] Review credit/debit flow atomicity
- [ ] Check adapter vs native OFT differences

### DVN (Decentralized Verifier Network)
- [ ] Multisig threshold and signer validation
- [ ] Replay protection (hash storage TTL)
- [ ] Fee manipulation vectors
- [ ] Cross-chain signature format

### Executor
- [ ] Gas estimation accuracy
- [ ] Native drop amount validation
- [ ] Ordered execution enforcement

### ULN (Ultra Light Node)
- [ ] Config validation (required + optional DVNs)
- [ ] Confirmation threshold checks
- [ ] Library timeout handling

---

## USEFUL RESOURCES

### Official Docs
- LayerZero V2 Docs: https://docs.layerzero.network/
- Integration Checklist: https://docs.layerzero.network/v2/developers/evm/oft/quickstart

### Audit Reports
- LayerZero Audits Repo: https://github.com/LayerZero-Labs/Audits
- Zellic Reports: https://reports.zellic.io/
- ChainSecurity: https://www.chainsecurity.com/security-audit/layerzero-oft-oapp

### Past C4 Contests
- Tapioca DAO (LayerZero heavy): https://code4rena.com/reports/2023-07-tapioca
- Maia DAO Ulysses: https://code4rena.com/reports/2023-09-maia
- LayerZero Sui (2025-09)
- LayerZero Starknet (2025-10)
- LayerZero Stellar (2026-04) ← Current

---

## QUICK CHECKLIST FOR LAYERZERO AUDITS

```
[ ] Replay protection TTL vs authorization expiration
[ ] Channel blocking via OOG or failed lzReceive
[ ] Address encoding for non-EVM chains (32 bytes)
[ ] DVN count limits vs chain storage limits
[ ] Fee calculation consistency
[ ] Admin privilege escalation
[ ] Nonce gap handling (skip/nilify abuse)
[ ] Cross-chain receiver validation
[ ] Config override permissions
[ ] Token credit/debit atomicity
```

---

*Last updated: Apr 2, 2026*
*Maintainer: @xnotok*
