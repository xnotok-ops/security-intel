# C/C++ Blockchain Node Audit Patterns

## Origin Case Study

Pharos BlockChain Audit Report by ExVul Web3 Security (Dec 2025)
- 101 findings on pre-mainnet L1 C++ codebase
- Breakdown: 17 Critical, 15 High, 21 Medium, 35 Low, 13 Info
- Status: mostly "Fixed", some "Acknowledge"
- Archive: bounty-notes/references/chain-audits/pharos-exvulsec-2025-12.pdf

## Applicability

- XRPL (C++ ledger) — **DIRECTLY applicable, Sherlock Apr 27 deadline**
- Ethereum execution clients (geth, reth, erigon — similar patterns
  despite Go/Rust)
- Solana validator (Rust — conceptual transfer)
- Bitcoin Core (C++)
- Any L1/L2 node implementation in C/C++/Rust

---

## Pattern Categories

### 1. Release-Build Compilation Artifacts

Bug class: debug-only safety constructs silently disabled in
production builds (NDEBUG defined, optimizations applied).

Grep signals:
- `assert(.*)` used as validation (not documentation)
- `#ifdef DEBUG` / `#ifndef NDEBUG` guarding safety checks
- Custom assert macros (`ALDABA_ASSERT`, `DCHECK`, etc.)
- Buffer bounds checks that might be optimized away
- Debug logging containing secrets

Real example (Pharos 3.4):
```cpp
auto code = inner_tx_view.Unpack(schema_tx, 0);
assert(code == ssz::SSZError::OK);  // NO-OP in release
raw_tx.nonce_ = schema_tx.nonce;    // uses uninitialized data
```

Audit action: Compile-flag audit — what's stripped in release?

### 2. Error Handling Anti-Patterns

- `abort()` in catch blocks → node DoS on malformed input
  (Pharos 3.2: `ALDABA_ASSERT(false)` in catch = unhandled throw
  in release)
- Error logged but not propagated
  (Pharos 3.5: `LOGF_WARN(...); return true;` — silent fail)
- Uninitialized data used after failed deserialization
- `std::visit` with unreachable case → `abort()` should throw
  (Pharos 3.3: Transaction::GetType → attacker sends unknown tx
  type → node aborts)

### 3. Cryptographic Primitive Misuse

- Private keys not zeroed from memory — use secure allocator /
  `explicit_bzero` / `sodium_memzero`
- Weak PRNG output due to pointer bugs
  (Pharos 3.6: `reinterpret_cast<char*>(data)` dereferenced →
  gets single byte → 2^8 key space instead of 2^128 for AES)
- Signature recovery always returns true (Pharos 3.5)
- AES-GCM IV length mismatch (Pharos 3.51)
- RSA-OAEP encoding inconsistency between encrypt/decrypt
  (Pharos 3.53)
- BLS aggregation without proof-of-possession check
  (Pharos 3.26, 3.30)
- Inverted pubkey guards (Pharos 3.27)
- Empty keypair accepted → uninitialized signer (Pharos 3.7)

### 4. Serialization / Deserialization Safety

- `assert` on deserialize return code (compiled out in release)
- Data read from object before validation succeeds
- SSZ spec version misuse
- Missing length checks on decoded fields
- Unsafe `ReceiverFromRlp` deserialization (Pharos 3.11)
- SSZ views out-of-bounds read (Pharos 3.68)

### 5. Concurrency & State Bugs

- TOCTOU in connection tracking / DoS defender
  (Pharos 3.13: DDosDefender::ForwardInc)
- Use-after-free via auto-delete callbacks (Pharos 3.80)
- Use-after-free in SelServer race (Pharos 3.9)
- Inconsistent lock usage — some paths hold lock, others don't
  (Pharos 3.14: FetchingLock)
- Race in bloom filter update (Pharos 3.16)
- Race in rule state updates (Pharos 3.15)
- Iterator dereferenced after end check (Pharos 3.35)
- DOG Service data race in consensus node list (Pharos 3.12)

### 6. Resource Exhaustion / Rate Limit Bypass

- Rate limiter initialized but never invoked (Pharos 3.43)
- Expensive crypto op per unauth request
  (Pharos 3.8: MultiVerify — attacker sends many pubkeys, each
  hashed upfront → CPU exhaustion)
- Unbounded pending connections queue (Pharos 3.41)
- Rate Limiting Logic Flaw in RPC (Pharos 3.42)
- DOG Service unauthenticated node addition (Pharos 3.40)
- ETH Subscribe Logs DoS (Pharos 3.66)
- HealthChecker indefinite wait (Pharos 3.65)

### 7. RPC / API Exposure

- Debug APIs unauthenticated → remote config modification
  (Pharos 3.17)
- ETH Call pending state violates JSON-RPC spec (Pharos 3.44)
- Internal RPC call missing timeout (Pharos 3.67)
- ETH Subscribe Logs DoS (Pharos 3.66)

### 8. Daemon / Process Hygiene

- `umask(0)` in daemon mode → world-writable files (Pharos 3.45)
- Component shutdown failures silently ignored (Pharos 3.46)
- Incorrect shutdown status semantics (Pharos 3.76)
- Timer cancellation failure post-shutdown (Pharos 3.24)
- DNS hijacking leading to eclipse attack (Pharos 3.39)

---

## XRPL-Specific Hypothesis Generators (URGENT — Apr 27 deadline)

Pattern mapping for XRPL Sherlock dynamic testing mode:

| Pharos Pattern | XRPL Application |
|---|---|
| `assert()` compiled out | Grep XRPL for `assert(` on sig/deserial paths |
| `abort()` in exception | TX type dispatch, precompiles |
| TX type `std::visit` + abort | XRPL tx type handling |
| Signature recovery always true | Batch, MPT sig ops |
| SSZ deserialize assert-only | STObject/STVL deserialization |
| Race in consensus node list | XRPL consensus |
| Rate limiter init unused | RPC rate limiting |
| Buffer bounds check stripped | SerialIter / Slice ops |
| Use-after-failed-deserial | STParsedJSON / SerialIter errors |

**Caveat:** These are hypothesis generators, NOT guaranteed findings.
Each lead must pass full Gate 1-5 of bounty-workflow v2.1 before PoC
development. Zero Gate 3 bypass tolerance.

---

## Audit Lens Checklist (Quick Reference)

When auditing C/C++ node code:
1. Compile release binary, check stripped assertions
2. Grep all `catch` blocks for `abort()`, `assert(false)`, re-raise
3. Check all crypto primitive usage for key zeroing post-use
4. Trace every external input to deserialization boundary — is
   validation before or after first data use?
5. Enumerate all background workers / threads / schedulers — race
   analysis per shared state
6. Identify all rate limiters — are they actually called?
7. Debug/metrics APIs — authentication required?
