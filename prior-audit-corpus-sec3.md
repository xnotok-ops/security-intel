# Prior-Audit Corpus — Sec3 (sec3.dev / Soteria)

Catalog of Sec3's publicly-published audit reports. ~25 reports with PDF links across Solana, Solidity, Sei, and Scrypto chains. Used for dup-check cross-reference during Phase 1 Intel.

**Source:** `github.com/sec3-service/reports`
**Firm:** Sec3 (tier-1 Solana security, formerly Soteria)
**Download pattern:** `curl -LO https://github.com/sec3-service/reports/raw/master/reports/sec3_<name>.pdf`

---

## Usage in Audit Workflow

### Phase 1 Intel — per-protocol lookup

When target matches a protocol with a sec3 report, download the PDF and feed into bounty-notes/[program]/prior-audits/sec3/:

```bash
mkdir -p /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/sec3
cd /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/sec3
curl -LO https://github.com/sec3-service/reports/raw/master/reports/sec3_<name>.pdf

# Bulk convert for grep (one-time poppler-utils install)
pdftotext sec3_<name>.pdf
```

### Gate 5 / Gate 5.5 cross-check

Before submitting a finding:
1. `grep -i "keywords" bounty-notes/<program>/prior-audits/sec3/*.txt`
2. Any match → likely DUP → investigate before submit
3. For Solana: also run `query-security-txt <program-address>` and match `auditors` field against Sec3 reports here (see `smart-contract-audit-solana` skill Gate 5.5)

---

## Index — Published Sec3 Reports (PDF available)

### 2026

| Protocol | Date | Chain/Type | PDF |
|---|---|---|---|
| Huma Vault | Jan 2026 | Solana | `sec3_huma_vault.pdf` |

### 2025

| Protocol | Date | Chain/Type | PDF |
|---|---|---|---|
| Symphony Aggregator V1 | Dec 2025 | Solidity | `sec3_symphony_aggregator_v1_report_final.pdf` |
| **Kamino Lending Program** | Feb 2025 | Solana | `sec3_kamino_lend.pdf` |
| **Kamino Lending Vault** | Feb 2025 | Solana | `sec3_kamino_vault.pdf` |
| Kamino Limit Orders | Jan 2025 | Solana | `sec3_kamino_limo.pdf` |

### 2024

| Protocol | Date | Chain/Type | PDF |
|---|---|---|---|
| **Kamino Scope** | Dec 2024 | Solana (oracle) | `sec3_kamino_scope.pdf` |
| LFJ Token Mill | Nov 2024 | Solana | `sec3_lfj_token_mill_final.pdf` |
| Carrot Protocol | Aug 2024 | Solana | `sec3_carrot_final.pdf` |
| Lavarage | Jul 2024 | Solana (lending/margin) | `sec3_lavarage_final_report.pdf` |
| Defenders | Mar 2024 | Solana + Web2 | `sec3_defenders_report_final.pdf` |

### 2023

| Protocol | Date | Chain/Type | PDF |
|---|---|---|---|
| Monaco Protocol v0.13.0 | Dec 2023 | Solana (prediction market) | `sec3_monaco_0.13.0.pdf` |
| CaviarNine Order Book | Oct 2023 | Radix Scrypto | `sec3_caviar_orderbook_20231025.pdf` |
| Hyperlane Sealevel | Jul 2023 | Solana (bridge) | `sec3_hyperlane-sealevel.pdf` |
| CornerMarket V15 | May 2023 | Solidity | `sec3_cornerMarket_v15.pdf` |
| Monaco Protocol v0.9.0 | May 2023 | Solana | `sec3_monaco_0.9.0.pdf` |
| Monaco Protocol v0.8.0 | Apr 2023 | Solana | `sec3_monaco_0.8.0.pdf` |
| Helium Program Library | Mar 2023 | Solana | `sec3_helium_program_library_report.pdf` |
| Monaco Protocol v0.7.0 | Mar 2023 | Solana | `sec3_monaco_0.7.0.pdf` |
| Monaco Protocol v0.6.0 | Feb 2023 | Solana | `sec3_monaco_0.6.0.pdf` |
| Unique Delegation Manager | Feb 2023 | Solana | `sec3_udm_report.pdf` |

### 2022

| Protocol | Date | Chain/Type | PDF |
|---|---|---|---|
| Monaco Protocol v0.5.0 | Nov 2022 | Solana | `sec3_monaco_0.5.0.pdf` |
| **Kamino yvaults** | Sep 2022 | Solana (baseline) | `sec3_kamino_report.pdf` |
| UXD Program v3.1.0 | Jun 2022 | Solana | `sec3_uxd_3.1.0.pdf` |
| Hedge Vault | May 2022 | Solana | `sec3_hedge_report.pdf` |
| Invariant Protocol | May 2022 | Solana | `sec3_invariant_report.pdf` |
| UXD Program v3.0.1 | Mar 2022 | Solana | `sec3_uxd_3.0.1.pdf` |

---

## Bug Bounty Writeups (canonical exploit references)

| Target | Date | Chain | Bounty |
|---|---|---|---|
| **Jet Protocol** | Oct 2021 | Solana | Bounty awarded |
| TON compiler/VM (FunC) | Mar 2023 | TON | Bounty awarded |
| Firedancer | Feb 2023 | Solana | — |

**Jet Protocol note:** This is the canonical "loop break vs continue" exploit codified as X-Ray SEV-2001 rule. Reference for any Solana lending/farming audit — check loop-break logic patterns.

---

## Tiered Value Assessment

### TIER A — Direct relevance to active Kamino T1 (kfarms)

Already downloaded in `bounty-notes/kamino/prior-audits/sec3/`:
- `sec3_kamino_lend.pdf` — Lending Program patterns (Anchor, CPI, admin)
- `sec3_kamino_vault.pdf` — Lending Vault account model
- `sec3_kamino_scope.pdf` — Scope oracle aggregator
- `sec3_kamino_report.pdf` — yvaults baseline (Sep 2022 historical)

### TIER B — High-value Solana pattern references

Download on-demand when auditing matching protocol type:
- `sec3_lavarage_final_report.pdf` — lending/margin patterns
- `sec3_hyperlane-sealevel.pdf` — bridge patterns (dual-use: -solana + -common bridge section)
- `sec3_carrot_final.pdf` — yield vault patterns
- `sec3_monaco_0.13.0.pdf` — prediction market / orderbook
- `sec3_lfj_token_mill_final.pdf` — token launch patterns

### TIER C — EVM/cross-chain

- `sec3_symphony_aggregator_v1_report_final.pdf` — Solidity aggregator

### SKIP

- CaviarNine Radix Scrypto (chain not in hunting scope)
- Sei Chain reports (niche)
- Older Monaco/UXD versions (superseded by latest)
- Huma Vault (low alignment with current pipeline)

---

*Last updated: 2026-04-21 as part of v4.0 tri-split skill release.*
*Feeds: smart-contract-audit-solana skill Phase 1 Intel + bounty-workflow MFD Sub-step D'.*
