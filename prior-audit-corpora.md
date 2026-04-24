# Prior Audit Corpora — Solana + EVM + Multi-chain

Consolidated reference of PUBLIC audit report collections for cross-reference during audits. Use in Phase 0 MFD sub-step D' (Corpus Cross-Reference) when evaluating target protocol against known findings from similar programs.

**Update cadence:** Manual review every 2-3 months. Add new corpora as they emerge.

---

## Solana Corpora

### 1. sec3 (existing)

**Location:** `security-intel/prior-audit-corpus-sec3.md` (25 reports)
**Focus:** Solana/Anchor programs, Token-2022, DeFi primitives
**Integration:** Loaded by `smart-contract-audit-solana` skill v4.0 as primary cross-reference source.

### 2. OtterSec — Public Sampled Audits (NEW 2026-04-24)

**URL:** `https://ottersec.notion.site/Sampled-Public-Audit-Reports-a296e98838aa4fdb8f3b192663400772`
**Format:** Notion-hosted PDFs (download required, no git clone)
**Focus:** High-quality Solana audits (OtterSec = Solana-specialized firm)
**Discovery source:** Frank Castle Mar 22 2026 roadmap thread
**Cross-reference pattern:**
- Before Phase 2 deep dive on a Solana target, search OtterSec reports for similar protocol category (AMM / perp / staking / lending / oracle / governance)
- Look for: same invariant patterns, same vulnerability classes, same fix patterns
- If target has ackowledged OtterSec audit → check HIGH/CRITICAL findings and fixes already applied (potential dup source)

**Integration use case:**
- Kamino (lending) cross-ref against OtterSec lending protocol findings
- Kast (staking) cross-ref against OtterSec staking/vault findings
- Future audits: any Solana DeFi primitive

### 3. Accretion — Audit Reports (NEW 2026-04-24)

**URL:** `https://github.com/accretion-xyz/audit-reports`
**Format:** GitHub-hosted markdown reports (cloneable)
**Focus:** Solana DeFi + Rust programs
**Discovery source:** Frank Castle Mar 22 2026 roadmap thread
**Cross-reference pattern:**
- Professional finding structure templates (useful for own report formatting reference)
- Severity classifications can indicate industry consensus on similar issues

**Quick clone:**
```bash
git clone https://github.com/accretion-xyz/audit-reports ~/audit-corpora/accretion
```

### 4. Frank Castle — Public Audits (NEW 2026-04-24)

**URL:** `https://github.com/Frankcastleauditor/public-audits`
**Format:** GitHub-hosted (cloneable)
**Focus:** Solana + Rust, 50+ reports by Frank Castle (Pashov Audit Group senior, Cantina, Spearbit)
**Discovery source:** Frank Castle Mar 22 2026 roadmap thread
**Cross-reference pattern:**
- Same-author finding style reference (heuristic diversity)
- Rust-specific patterns from non-Solana chains (XCM, Substrate, etc.)

**Quick clone:**
```bash
git clone https://github.com/Frankcastleauditor/public-audits ~/audit-corpora/frankcastle
```

---

## EVM Corpora (existing)

`security-intel` already has:
- C4 findings archive (via `audit-workspace/hackerone-reports`)
- Immunefi patterns (via `bounty-lessons` Gate 5 "The Judge" 45 FP patterns)

**Future additions to consider (Pashov ecosystem wave Jan-Mar 2026):**
- Pashov Audit Group public reports (`github.com/pashov/audits`)
- Trail of Bits public reports
- Spearbit Cantina public reports (already accessible via Cantina platform)

---

## Usage Workflow

**Phase 0 MFD sub-step D' (Corpus Cross-Reference):**

1. Identify target protocol category (AMM/lending/staking/perp/bridge/oracle/governance)
2. Search relevant corpora for same-category reports (grep for category keywords)
3. Extract finding titles + severity tags
4. During Phase 2 hunt: use as V12-fingerprint dup check source (per `bounty-lessons` Gate 4)
5. If target protocol has its OWN prior audit by one of these firms → loaded into `bounty-notes/[program]/prior-audits/`

**Integration with existing skills:**
- `bounty-workflow` v2.6 → MFD sub-step D' references this file
- `bounty-lessons` v2.3 → Gate 4 dup check extends to these corpora
- `smart-contract-audit-solana` v4.0 → Phase 0 codebase category → corpus selection

---

## Maintenance Commands

**Refresh corpora (monthly):**
```bash
cd ~/audit-corpora
for dir in */; do
  echo "=== Updating $dir ==="
  cd "$dir" && git pull && cd ..
done
```

**Count reports per corpus:**
```bash
cd ~/audit-corpora
for dir in */; do
  count=$(find "$dir" -name "*.md" -o -name "*.pdf" | wc -l)
  echo "$dir: $count reports"
done
```

---

*Last updated: 2026-04-24*
*Sources: Frank Castle Mar 22 roadmap thread + existing security-intel archive*
