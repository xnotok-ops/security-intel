# Prior-Audit Corpus — Accretion (accretion-xyz)

Catalog of Accretion's publicly-published audit reports. 21 reports (2024–2026), Solana / Rust-heavy, many on protocols `smart-contract-audit-solana` already references (MarginFi, Kamino, Sanctum, Light Protocol/ZK, MetaDAO, Realms, Privacy Cash, Solana Foundation). Used for dup-check + Pattern-AS cross-reference during Phase 1 Intel.

**Source:** `github.com/accretion-xyz/audit-reports` (branch `main`, PDFs at repo root)
**Firm:** Accretion (Solana DeFi + Rust specialist)
**Download pattern:** `curl -LO https://github.com/accretion-xyz/audit-reports/raw/main/<file>.pdf`
**Bulk clone:** `git clone https://github.com/accretion-xyz/audit-reports ~/audit-corpora/accretion`

---

## Usage in Audit Workflow

### Phase 1 Intel — per-protocol lookup
When a Solana target matches one of these protocol categories (lending / LST / launchpad / governance / ZK-compression / privacy / smart-wallet), pull the matching report into `bounty-notes/<program>/prior-audits/accretion/` and `pdftotext` it for grep:
```bash
mkdir -p /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/accretion
cd /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/accretion
curl -LO https://github.com/accretion-xyz/audit-reports/raw/main/<file>.pdf
pdftotext <file>.pdf
```

### Gate 4 / Gate 5 cross-check
Before submitting: `grep -i "<keywords>" bounty-notes/<program>/prior-audits/accretion/*.txt` → any match = likely DUP → investigate before submit. For Solana also run `query-security-txt <program>` and match the `auditors` field against this list (see `smart-contract-audit-solana` Gate 5.5).

---

## Index — Published Accretion Reports

### 2026
| Protocol | Chain / Type | File |
|---|---|---|
| MetaDAO (full audit) | Solana (governance/futarchy) | `2026-accretion-metadao-metadao-full-audit-audit-A26MET1.pdf` |
| Solana Foundation — Lazorkit | Solana (passkey/smart wallet) | `2026-accretion-solana-foundation-lazorkit-audit-A26SFR1.pdf` |
| Solana Foundation — Keychain | Solana (key/identity) | `2026-accretion-solana-foundation-solana-keychain-audit-A26SFR2.pdf` |
| H2O Nodes / Revtec | Solana (infra) | `2026-accretion-h2o-nodes-gmbh-revtec-audit-A26HTO1.pdf` |

### 2025
| Protocol | Chain / Type | File |
|---|---|---|
| **MarginFi × Kamino** | Solana (lending integration) | `2025-accretion-mrgn-kamino-audit-A25MRG2.pdf` |
| **MarginFi** | Solana (lending) | `2025-accretion-mrgn-audit-A25MRG1.pdf` |
| **MarginFi × Drift × Solend** | Solana (lending/perp integration) | `2025-accretion-marginfi-drift-solend-integration-audit-A25MRG3.pdf` |
| **Sanctum** (flat-slab / token-ratio) | Solana (LST) | `2025-accretion-sanctum-flat-slab-jiminy-token-ratio-audit-A25SAN1.pdf` |
| Ellipsis / Plasma | Solana (AMM) | `2025-accretion-ellipsis-plasma-audit-A25ELL1.pdf` |
| MetaDAO — Launchpad | Solana (launchpad) | `2025-accretion-metadao-launchpad-audit-A25MET1.pdf` |
| MetaDAO — Squads Treasury | Solana (multisig/treasury) | `2025-accretion-metadao-squads-treasury-audit-A25MET2.pdf` |
| MetaDAO — Price-Based Token Lock | Solana (vesting/lock) | `2025-accretion-metadao-price-based-token-lock-audit-A25MET3.pdf` |
| Realms — Versioned Transactions | Solana (governance) | `2025-accretion-realms-versioned-transactions-audit-A25REA1.pdf` |
| Privacy Cash | Solana (privacy/ZK) | `2025-accretion-privacy-cash-audit-A25PRC1.pdf` |
| Light Protocol — Batched Merkle Tree | Solana (ZK compression) | `2025-accretion-light-batched-mt-audit-A25LIG2.pdf` |
| Light Protocol — Pinocchio | Solana (ZK / Pinocchio runtime) | `2025-accretion-light-pinocchio-audit-A25LIG3.pdf` |
| Light Protocol — Update | Solana (ZK compression) | `2025-accretion-light-update-audit-A25LIG1.pdf` |
| Anagram — Swig | Solana (smart wallet) | `2025-accretion-anagram-swig-audit-A25ANA2.pdf` |
| Beans | Solana | `2025-accretion-beans-audit-A25BEA1.pdf` |

### 2024
| Protocol | Chain / Type | File |
|---|---|---|
| Light Protocol — Updates | Solana (ZK compression) | `2024-accretion-light-updates-A24LIG1.pdf` |
| Vault | Solana (vault) | `2024-accretion-vault-audit-A24VAU1.pdf` |

---

## Tiered Value Assessment

### TIER A — Direct relevance to active Solana hunting (lending / perp / LST)
- `2025-accretion-mrgn-kamino-audit-A25MRG2.pdf` — MarginFi×Kamino lending integration (cross-protocol invariant patterns)
- `2025-accretion-mrgn-audit-A25MRG1.pdf` — MarginFi lending core
- `2025-accretion-marginfi-drift-solend-integration-audit-A25MRG3.pdf` — multi-lending/perp integration (composability bugs)
- `2025-accretion-sanctum-flat-slab-jiminy-token-ratio-audit-A25SAN1.pdf` — LST token-ratio (depeg / rounding patterns)
- `2025-accretion-ellipsis-plasma-audit-A25ELL1.pdf` — AMM invariants

### TIER B — High-value Solana pattern references (on-demand)
- MetaDAO ×4 (launchpad / squads-treasury / price-lock / full) — launchpad, multisig, vesting patterns
- `2025-accretion-realms-versioned-transactions-audit-A25REA1.pdf` — governance / tx-versioning
- `2025-accretion-privacy-cash-audit-A25PRC1.pdf` — privacy / ZK
- Light Protocol ×4 (batched-mt / pinocchio / update / 2024) — ZK compression + Pinocchio runtime (pull if ZK or Pinocchio target)
- `2025-accretion-anagram-swig-audit-A25ANA2.pdf` — smart-wallet patterns

### TIER C — Niche / infra (skip unless matching target)
- Solana Foundation Lazorkit / Keychain (passkey, identity)
- H2O Nodes / Revtec (infra)
- Beans, Vault (low alignment)

### SKIP
- None — all Solana, all in-scope. Tier by target match.

---

*Last updated: 2026-06-15. Source: accretion-xyz/audit-reports (Frank Castle Mar 22 roadmap thread).*
*Feeds: `smart-contract-audit-solana` Phase 1 Intel + `bounty-workflow` MFD Sub-step D' + `bounty-pre-submit` Gate 4 dup-check.*
