# Security Research Blog Corpus — 2026

Curated index of high-signal smart-contract / chain security research blogs, organized by bug-class theme (so the corpus-index keyword extraction surfaces them on dedup / Pattern-AS lookup). Each entry = firm — post topic — one-line takeaway — URL. Use as a dedup + variant-analysis cross-reference during Phase 1 Intel / Fase 3; open the linked post for full detail (do NOT treat takeaways as complete).

**Source:** @0xaudron thread (Jun 6 2026) + per-blog review. **Tiering:** TIER 1 = niche (Solana/Move/Cosmos/node) — highest relevance; TIER 2 = EVM/DeFi + tooling; TIER 3 (OpenZeppelin research) low novelty, skipped.

**Update cadence:** review quarterly; add new posts as they land. Companion to `prior-audit-corpus-*` (firm audit reports) and `audit-corpus-index` Pattern-AS lookup.

---

## Solana — SVM / sBPF / runtime internals
- **OtterSec** — SVM low-level: escalate a memory-corruption primitive to full program control (runtime-level RCE-equivalent). `osec.io/blog`
- **OtterSec** — Solana lamport-transfer edge cases: rent-exemption quirks, write-demotion traps, transfers to arbitrary accounts that silently fail (dissected via a simple on-chain game). `osec.io/blog`
- **Zellic** — Inside the SVM: sBPF JIT security pitfalls + memory leaks — interpreter vs JIT execution paths, controllable-input/verification boundaries, two real vulns (heap leak). `zellic.io/blog/solana-sbpf`
- **OtterSec** — Formally verifying Solana programs (bounded model checking; loop bounds / path explosion). `osec.io/blog/2023-01-26-formally-verifying-solana-programs`

## Solana — program logic (CPI / Anchor / accounts / events)
- **Asymmetric** — Invocation Security: vulnerabilities in Solana CPIs (invoke = core surface for SPL transfer / custom program / event emission). `blog.asymmetric.re`
- **Asymmetric** — Across event-spoof on Solana: events reconstructed from tx traces + failed txns still emit data → attacker spoofs deposit events, tricks relayers into filling orders with no real deposit. `blog.asymmetric.re`
- **Asymmetric** — p-token CU-optimization critical bug found pre-mainnet — subtle enough to survive a heavily-scrutinized codebase (compute-unit optimizations carry risk). `blog.asymmetric.re`
- **Zellic** — "The Vulnerabilities You'll Write With Anchor" — Anchor is no silver bullet (Solana primer; account/constraint pitfalls). `zellic.io/blog/tags/solana`
- **Asymmetric** — "Solana vulnerabilities that aren't" — anti-FP: false vuln-classes propagated by official docs / learning resources / LLMs. `blog.asymmetric.re`

## Cosmos / IBC / app-chain
- **Asymmetric** — Cosmos IBC reentrancy infinite-mint: reentrancy during ibc-go timeout-message handling → mint infinite IBC tokens on affected chains. `blog.asymmetric.re`
- **Asymmetric** — Evmos precompile state-commit infinite-mint (EVM-Cosmos precompile state-commit flaw). `blog.asymmetric.re`
- **Asymmetric** — Circle CCTP Noble mint bug: bypass CCTP message-sender verification → mint fake USDC on Noble (noble-cctp built as an SDK module, not contracts). `asymmetric.re/blog-archived/circles-cctp-noble-mint-bug`
- **OtterSec** — Building safer Cosmos: infinite loops, map non-determinism, AnteHandler missteps, storage-key collisions. `osec.io/blog`

## Move (Sui / Aptos) — verifier + linear types
- **Zellic** — Move Fast & Break Things (Aptos): bytecode verifier (memory + type safety), linear-type resources (no copy/drop, only move), account auth-key rotation. `zellic.io/blog/move-fast-and-break-things-pt-1`
- **Zellic** — Sui Move bytecode verifier (shared across ALL Move chains incl Aptos) — the high-impact verifier bug class (Mysten Labs engagement). `zellic.io/our-work`

## Cross-chain / bridge / signature verification
- **Asymmetric** — Relay Protocol Ed25519 verification without offset validation → forged allocator signatures / potential double-spend. `blog.asymmetric.re`
- **Asymmetric** — Titan Helix MEV relay equivocation: trusted proposers prematurely reveal private tx info → reordering. `blog.asymmetric.re`

## Node / consensus / client-split (determinism)
- **Asymmetric** — Prysm vs Lighthouse SSZ deserialization difference → could severely degrade Ethereum consensus (cross-client non-determinism = chain-split risk). `blog.asymmetric.re`
- **Asymmetric** — Polygon Heimdall validator takeover: rogue/compromised validator takes over Heimdall consensus + injects fraudulent events into StakeSync. `blog.asymmetric.re`

## EVM DeFi patterns
- **MixBytes** — ERC-4626 inflation attack: donation manipulates share value (first-depositor / share-price rounding), mitigations + their flaws. `mixbytes.io/blog/overview-of-the-inflation-attack`
- **MixBytes** — yield-aggregator / bridge / Curve-math bug writeups (EVM + Substrate focus). `mixbytes.io/blog`
- **Trust Security** — practical competitive-hunter EVM bug-class writeups (bounty-oriented). `trustsec.xyz/blog`

## Fuzzing / invariant / formal-verification tooling
- **Trail of Bits** — crytic/properties: reusable Echidna properties for ERC-20 / ERC-721 / ERC-4626 / ABDKMath64x64; differential props (e.g. `redeem()`/`previewDeposit()` must match). `github.com/crytic/properties`
- **Trail of Bits** — The call for invariant-driven development: function-level vs system-level invariants (ERC20 balance≤supply, AMM x*y=k, lending interest monotonic-increasing); Echidna/Medusa continuous fuzzing + Hexagate/Tenderly monitoring. `blog.trailofbits.com/2025/02/12/the-call-for-invariant-driven-development`
- **Trail of Bits** — Echidna smart-contract-library testing: empty-array `length-1` underflow → infinite loop → permanent DoS of a whitelist invariant. `blog.trailofbits.com/2020/08/17/using-echidna-to-test-a-smart-contract-library`
- **OtterSec** — Rounding-related hacks: corrects popular misunderstandings + mitigations. `osec.io/blog`
- **Asymmetric** — `crucible` fuzzer (LibAFL + LiteSVM) for Solana program fuzzing. `blog.asymmetric.re`

## Web2-in-Web3 / supply-chain / wallet / key-management
- **OtterSec** — Web3 auth via Web2 integrations: OAuth logic exploits, Supabase misconfig, localhost OAuth abuse. `osec.io/blog`
- **OtterSec** — Solana multisig: safe transaction-signing procedure when signers are compromised/malicious. `osec.io/blog`
- **OtterSec** — Lavamoat supply-chain defense + sneaky bypasses (JS ecosystem lockdown). `osec.io/blog`
- **Zellic** — TON (The Open Network): design choices + security considerations for building on TON. `zellic.io/blog`

---

## Notes / cross-references
- **Zellic V12** (AI auditor, AI+static, Solidity→Rust/Solana planned) — already tracked as `V12-FINGERPRINT` in `bounty-workflow`; not a corpus pattern. `zellic.io/blog/introducing-v12`
- **OtterSec / Neodyme / Asymmetric** = SIRN (Solana Incident Response Network) members; their disclosures feed Solana Pattern-AS dedup.
- **TIER 3 — OpenZeppelin research** (`openzeppelin.com/research`): EVM standards/findings, low novelty vs above — ingest last or skip.
- Tooling cross-ref: ToB Echidna/Medusa + crytic/properties → `tools-reminder`; Asymmetric crucible (LibAFL/LiteSVM) → Solana fuzzing.

---

*Last updated: 2026-06-15. Source: @0xaudron thread (Jun 6 2026) + per-blog review.*
*Feeds: `audit-corpus-index` Pattern-AS lookup + `bounty-pre-submit` Gate 4 dup-check + `smart-contract-audit-solana`/`-move-stack`/`-common` Phase 1 Intel.*
