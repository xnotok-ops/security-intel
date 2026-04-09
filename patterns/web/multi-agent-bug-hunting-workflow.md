# Multi-Agent Bug Hunting Workflow

> Source: Twitter/X thread (April 2026)
> Context: Framework for parallel AI-assisted vulnerability hunting using multiple Claude agents

## The Framework

### Step 1: Rank Files by Bug Likelihood

Ask Claude to rank every file in the project on a 1-5 scale:

```
1 — Nothing exploitable (constants, static config, types)
2 — Low risk (simple utilities, pure functions)
3 — Moderate (state management, internal logic)
4 — Notable risk (external integrations, data processing)
5 — High-risk surface (parses raw Internet data, handles auth, processes payments)
```

Sort descending. This is the processing queue.

### Step 2: Hunt Bugs (One Agent Per File)

Each agent independently:
1. Reads the code and hypothesizes potential vulnerabilities
2. Runs the project to confirm or reject each hypothesis
3. Adds debug logic or uses debuggers as needed
4. Repeats until confident
5. Outputs either "no bug" or a bug report with:
   - Description of the vulnerability
   - Proof-of-concept exploit
   - Reproduction steps

Key insight: one file per agent = more diverse findings, fewer duplicates.

### Step 3: Validate Reports

Pass each bug report to a final Claude agent with:

```
"I have received the following bug report. Can you please confirm 
if it's real and interesting?"
```

Filters out technically-valid-but-useless edge cases.

---

## Adaptation for Our Workflow

### What We Can Use Now (Single Claude Instance)

**File Risk Ranking (add to Phase 1 Intel):**

```
Prompt template:
"Rank all files in this repo by bug likelihood (1-5 scale).
5 = handles auth, parses external input, processes funds, manages permissions
1 = constants, types, static config
Output as sorted list, highest first. Include LOC and reason for each."
```

This replaces our current ad-hoc "which file to look at first" approach with a systematic triage.

**Validation Pass (add to Phase 2, before Phase 3 Report):**

```
Prompt template:
"I found this potential vulnerability: [finding description + code reference].
1. Is this actually exploitable in a real deployment?
2. Does it affect real users or only obscure edge cases?
3. What prerequisites does the attacker need?
4. Rate confidence: HIGH / MEDIUM / LOW with reasoning."
```

Maps to our Finding Candidate Gate (bounty-workflow v1.4) but adds explicit AI validation.

### What Needs Claude Code CLI / API (Future)

- Parallel agents (one per file) — needs multiple Claude instances
- Auto-run project + debug — needs Claude Code with bash access
- Full automation pipeline — needs orchestration script

### Comparison to Our Current Flow

| Their Step | Our Equivalent | Gap |
|-----------|---------------|-----|
| Rank files | Ad-hoc file selection in Phase 1 | Need systematic ranking prompt |
| One agent per file | Single Claude reviews all | Parallel not possible yet |
| Hypothesis + test | Phase 2 manual review + PoC | Same concept, manual execution |
| Validation agent | Finding Candidate Gate (v1.4) | Gate is scope-focused, validation is impact-focused |

### Combined Approach (Recommended)

```
Phase 1 Intel
  → File Risk Ranking (new, from this framework)
  → CVE cross-ref (bounty-workflow v1.4)

Phase 1.5 AI Pre-scan (existing)
  → Run AI auditors on top-ranked files first
  → Use Horizon3 prompt template for vuln class coverage

Phase 2 Audit
  → Finding Candidate Gate (scope + impact filter)
  → AI Validation Pass on each finding candidate (new, from this framework)

Phase 3 Report
  → bounty-lessons pre-submit check (existing)
```
