# Tool Arsenal — Static Analyzers for Smart Contract Audits

Comparison + install + usage guide for static analysis tools across EVM and Solana. Part of the public security-intel catalog. For authoritative install status per user, see `bounty-notes/tools-to-setup.txt` (private).

---

## Tool Comparison Matrix

| Tool | Chains | Analysis | Custom Rules | License | Repo |
|---|---|---|---|---|---|
| **Slither** | EVM (Solidity) | AST + dataflow | Python detectors | AGPL-3.0 | [crytic/slither](https://github.com/crytic/slither) |
| **X-Ray** | Solana (Rust) | LLVM-IR deep | Rule config edit | AGPL-3.0 | [sec3-product/x-ray](https://github.com/sec3-product/x-ray) |
| **Radar** | Rust/Anchor/Stylus/Solidity | AST-based | Python templates | GPL-3.0 | [Auditware/radar](https://github.com/Auditware/radar) |
| **solana-fender** | Solana/Anchor | Cargo crate (dev-time) | Rust | GPL-3.0 | [honey-guard/solana-fender](https://github.com/honey-guard/solana-fender) |
| **l3x** | Solana/Rust | AI-driven | — | — | [VulnPlanet/l3x](https://github.com/VulnPlanet/l3x) |
| **Trident** | Solana fuzzing | Flow + property-based | Rust scenarios | — | [Ackee-Blockchain/trident](https://github.com/Ackee-Blockchain/trident) |

---

## Per-Chain Recommendations

### EVM (Solidity/Vyper)

**Primary:** Slither (widest coverage, well-maintained).
**Secondary:** Radar (SARIF output, multi-chain pivot for Stylus or Solidity CI).
**Fuzzing:** Echidna (property-based), Medusa (Geth-based).

**Install (WSL):**
```bash
pip3 install slither-analyzer
# or via Docker for clean env
docker pull trailofbits/eth-security-toolbox
```

### Solana (Anchor/Native Rust/Pinocchio)

**Recommended trio:** X-Ray + Radar + query-security-txt (pre-audit recon).
**Fuzzing:** Trident (only dedicated Solana fuzzer as of 2026).
**Dev-time:** solana-fender embedded in unit tests.
**AI-driven:** l3x as second-opinion.

**Install (WSL):**
```bash
# X-Ray (Docker)
docker pull ghcr.io/sec3-product/x-ray:latest

# Radar (install script)
curl -L https://raw.githubusercontent.com/auditware/radar/main/install-radar.sh | bash

# query-security-txt
cargo install query-security-txt

# Trident
cargo install trident-cli
```

---

## X-Ray Static Rules (Solana) — SEV Catalog

18 built-in rules targeting canonical Solana vulnerabilities. Each maps to a CWE class and often to a real-world exploit.

### SEV-10xx (Account & Arithmetic)

| Rule | Pattern | Canonical Source |
|---|---|---|
| SEV-1001 | Missing Signer Check | Sealevel Attacks #0 |
| SEV-1002 | Missing Owner Check | Sealevel Attacks #2 |
| SEV-1003 | Integer Add Overflow | Rust arithmetic |
| SEV-1004 | Integer Underflow | Rust arithmetic |
| SEV-1005 | Integer Mul Overflow | Rust arithmetic |
| SEV-1006 | Integer Div Overflow | Rust arithmetic |
| SEV-1007 | Unverified Parsed Account | Sealevel Attacks #1 |
| SEV-1010 | Type Full Cosplay | Sealevel Attacks #3 |
| SEV-1011 | Type Partial Cosplay | Sealevel Attacks #3 |
| SEV-1014 | Bump Seed Not Validated | Sealevel Attacks #7 |
| SEV-1015 | Insecure PDA Sharing | Sealevel Attacks #8 |
| SEV-1016 | Arbitrary CPI | Sealevel Attacks #5 |
| SEV-1017 | Malicious Simulation | Transaction simulation detection |
| SEV-1019 | Unvalidated Account | Wormhole-class vulnerability |

### SEV-20xx (Logic Exploits — Real-World Bug References)

| Rule | Pattern | Real-World Exploit |
|---|---|---|
| **SEV-2001** | Incorrect Loop Break Logic | **Jet Protocol** (break vs continue) |
| SEV-2002 | Incorrect Condition Check | Liquidation `>=` should be `>` |
| SEV-2003 | Exponential Calculation | Compute-budget DoS risk |
| **SEV-2004** | Incorrect Division Logic | **spl-token-swap stable curve** (PR #2942) |
| **SEV-2005** | Incorrect Token Calculation | **Sushi Trident invariant break** (reserves vs balances) |

Full rule config: `github.com/sec3-product/x-ray/blob/main/package/conf/xray.json`

---

## Radar — Custom Template Workflow

Radar supports Python templates for custom pattern detection without forking the tool. Workflow for codifying patterns from audits:

```
1. Pattern validated ≥3x across real audits → candidate for codification
2. Write Python template over AST (see Radar docs)
3. Place in radar/templates/my_pattern.yaml
4. Run: radar -p <target> -t ./templates/
5. Auto-detect across all future audits of matching chain
```

**Use case:** promotes pending-patterns.md queue entries into automated future detectors. Applicable for Rust/Anchor, Stylus, and Solidity.

**Canonical test:**
```bash
git clone https://github.com/coral-xyz/sealevel-attacks
radar -p sealevel-attacks  # fires on Sealevel Attack examples
```

---

## Usage Comparison — When to Use Which

| Scenario | Tool Choice |
|---|---|
| First-pass Solidity audit | Slither |
| Deep Solana Rust analysis (LLVM-IR) | X-Ray |
| Multi-chain project (Anchor + Solidity + Stylus) | Radar |
| Protocol repo wants CI security gate | Radar (SARIF → GitHub Security) |
| Embed continuous security checks in dev tests | solana-fender (Rust crate) |
| AI second opinion on Rust SC | l3x |
| Fuzzing new Solana program | Trident |
| Pre-audit recon — who audited this program on-chain? | query-security-txt |

---

## CI Integration (optional)

### GitHub Action for Radar

```yaml
name: Radar Static Analysis
on: [push]
jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      actions: read
      contents: read
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: 'recursive'
      - uses: auditware/radar-action@main
        with:
          path: "."
          ignore: "low"
      - uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: output.sarif
```

---

## Historical Context

- **sec3.dev** (Soteria team) = tier-1 Solana security firm. X-Ray is open-source arm of their commercial scanner.
- **Auditware** (audit_wizard) = introduced Radar at Breakpoint 2024. Open-source to attract community template contributions.
- **Neodyme** = built solana-security-txt standard (9.3k+ dependents incl. Jupiter, BitGo, Magicblock) + query-security-txt CLI.
- **Ackee Blockchain** = Trident fuzzer maintainer.

---

*Last updated: 2026-04-21 as part of v4.0 tri-split skill release.*
*Feeds: smart-contract-audit-common, smart-contract-audit-solana, smart-contract-audit-evm, tools-reminder skills.*
