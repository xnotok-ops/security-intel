# Prior-Audit Corpus — Frank Castle (Frankcastleauditor)

Catalog of Frank Castle's publicly-published audit reports. 29 reports, mix Solana + cross-chain + EVM (Frank Castle = Pashov Audit Group senior, Cantina/Spearbit). Strong on Solana DeFi (GMX-Solana, Meteora, Pump, Perena, Reserve DTF) + LayerZero/ONFT + Synthetix/Lido. Used for dup-check + Pattern-AS cross-reference during Phase 1 Intel; complements Solodit (which is thin on Solana).

**Source:** `github.com/Frankcastleauditor/public-audits` (branch `main`, reports under `reports/`)
**Firm:** Frank Castle (independent; Pashov Audit Group / Cantina / Spearbit)
**Download pattern:** `curl -L -o out.pdf "https://github.com/Frankcastleauditor/public-audits/raw/main/reports/<file>"` *(quote — some filenames contain spaces; URL-encode space as `%20`)*
**Bulk clone:** `git clone https://github.com/Frankcastleauditor/public-audits ~/audit-corpora/frankcastle`

---

## Usage in Audit Workflow

### Phase 1 Intel — per-protocol lookup
When a target matches one of these (Solana DeFi / LayerZero OFT-ONFT / perp / LST / launchpad / cross-chain), pull the matching report into `bounty-notes/<program>/prior-audits/frankcastle/` + `pdftotext` for grep:
```bash
mkdir -p /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/frankcastle
cd /mnt/c/Users/USER/bounty-notes/<program>/prior-audits/frankcastle
curl -L -o report.pdf "https://github.com/Frankcastleauditor/public-audits/raw/main/reports/<file>"
pdftotext report.pdf
```

### Gate 4 / Gate 5 cross-check
Before submitting: grep the converted text for finding keywords → match = likely DUP. For LayerZero targets, cross-link `smart-contract-audit-layerzero` (LayerZero + ONFT reports below). For Solana, also match `query-security-txt` auditors field.

---

## Index — Published Frank Castle Reports

### Solana — DeFi / AMM / perp / LST
| Protocol | Type | File |
|---|---|---|
| **GMX Solana** (Zenith) | perp DEX | `reports/GMX Solana Protocol - Zenith Audit Report.pdf` |
| **Meteora** | DLMM / AMM | `reports/Meteora-security-review_2025-09-01.pdf` |
| **Pump.fun AMM** | AMM | `reports/pump-fun-AMM_audit.pdf` |
| Pump (security review) | launchpad/AMM | `reports/pump-security-review.pdf` |
| Pump 2025-02-04 | launchpad/AMM | `reports/Pump-security-review_2025-02-04.pdf` |
| **Perena** | stablecoin (Solana) | `reports/Perena_Audit_Final_report.pdf` |
| **Reserve — Solana DTF** | index/DTF | `reports/Reserve_SolanaDTF_Audit.pdf` |
| Stix Swap Solana | swap | `reports/StixSwapSolana-security-review_2025-01-07.pdf` |
| Boop | Solana | `reports/Boop_Audit_Final_Report.pdf` |
| Bruv | Solana | `reports/Bruv_Audit_Final.pdf` |
| Oro (Cantina) | Solana | `reports/cantina_oro_february2025.pdf` |
| TailWind (zone) | Solana | `reports/TailWind-zoneReport.pdf` |

### Cross-chain / LayerZero / EVM
| Protocol | Type | File |
|---|---|---|
| **LayerZero** (Sep) | OFT / messaging | `reports/LayerZero-security-review-September.pdf` |
| **LzAPP / ONFT** | LayerZero ONFT | `reports/LzAPP_ONFT_Security_Review.pdf` |
| **Synthetix** 2024-11-05 | perp / staking (EVM) | `reports/Synthetix-security-review_2024-11-05.pdf` |
| **Lido** | LST (EVM) | `reports/Lido_final_report.pdf` |
| Cantina — Polymer | cross-chain / IBC | `reports/Cantina-Polymer-FrankCastle.pdf` |
| Plasma × Accretion | Plasma / L2 | `reports/Plasma_Accretion_Audit.pdf` |
| Layer N | L2 | `reports/Layer_N_report.pdf` |
| Hydration (Oct) | Substrate / Polkadot DEX | `reports/Hydration-security-review-October.pdf` |
| BTR 2025-06-29 | — | `reports/BTR-security-review_2025-06-29.pdf` |

### Other / niche
| Protocol | Type | File |
|---|---|---|
| Bio | — | `reports/Bio_final_report.pdf` |
| DUB | — | `reports/DUB_Audit_frank_castle.pdf` |
| Desci Launchpad 2025-02-07 | launchpad | `reports/DesciLaunchpad-security-review_2025-02-07.pdf` |
| Coalesce Finance 2025-10-13 | DeFi | `reports/CoalesceFinance-security-review_2025-10-13.pdf` |
| Adrastea | — | `reports/Adrastea-Security-Review.pdf` |
| Wick | — | `reports/Wick_Final_report.pdf` |
| Wick v2 | — | `reports/wick-v2_final_report.pdf` |
| SomethingCool | — | `reports/SomethingCool_security_Audit_report.pdf` |
| Sparkn (findings) | — (markdown) | `reports/sparkn-findings.md` |

---

## Tiered Value Assessment

### TIER A — Direct relevance (Solana DeFi + LayerZero, active hunting)
- `GMX Solana Protocol - Zenith Audit Report.pdf` — perp DEX (funding, liquidation, GLV — feeds `sc-audit-solana` perp section)
- `Meteora-security-review_2025-09-01.pdf` — DLMM/AMM Solana
- `pump-fun-AMM_audit.pdf` + `pump-security-review.pdf` — AMM / bonding-curve
- `LayerZero-security-review-September.pdf` + `LzAPP_ONFT_Security_Review.pdf` — OFT/ONFT (cross-link `smart-contract-audit-layerzero`)
- `Reserve_SolanaDTF_Audit.pdf` — Solana index/DTF
- `Perena_Audit_Final_report.pdf` — Solana stablecoin

### TIER B — High-value pattern references (on-demand)
- `Synthetix-security-review_2024-11-05.pdf` — Synthetix-family reward/staking (cross-ref the multi-reward checkpoint patterns)
- `Lido_final_report.pdf` — LST accounting
- `Cantina-Polymer-FrankCastle.pdf` — cross-chain / IBC proof
- `Plasma_Accretion_Audit.pdf` — Plasma/L2
- `StixSwapSolana-security-review_2025-01-07.pdf`, `cantina_oro_february2025.pdf` — Solana swap/DeFi

### TIER C — Niche / lower-alignment (pull only on protocol match)
- Hydration (Substrate), Layer N, BTR, Bio, DUB, DesciLaunchpad, Coalesce, Adrastea, Wick/Wick-v2, SomethingCool, Boop, Bruv, TailWind, Sparkn

### SKIP
- None outright — tier by target match. Hydration (Substrate) only if Polkadot-stack target.

---

*Last updated: 2026-06-15. Source: Frankcastleauditor/public-audits (Frank Castle Mar 22 roadmap thread).*
*Feeds: `smart-contract-audit-solana` + `smart-contract-audit-layerzero` Phase 1 Intel + `bounty-workflow` MFD Sub-step D' + `bounty-pre-submit` Gate 4 dup-check.*
