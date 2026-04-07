# Finding Validation Gates — Pre-Submit Checklist

Source: Pashov Audit Group (https://github.com/pashov/skills)
Adapted for bug bounty submission workflow.

---

## 4-Gate Sequential Validation

Run every finding through all 4 gates IN ORDER before submitting. Fail any gate = drop or demote to informational.

### Gate 1 — Refutation (Self-Attack)

Construct the STRONGEST argument that your finding is wrong. Find the guard, check, or constraint that kills the attack. Quote the exact line.

- Concrete refutation found (specific guard blocks claimed step) → DROP or demote to informational
- Only speculative refutation ("probably wouldn't happen") → PASS, continue

### Gate 2 — Reachability

Prove the vulnerable state exists in a live/realistic deployment.

- Structurally impossible (enforced invariant prevents it) → DROP
- Requires privileged actions outside normal operation → DEMOTE to Low/Info
- Achievable through normal usage or common token behaviors → PASS

### Gate 3 — Trigger

Prove an unprivileged actor can execute the attack.

- Only trusted roles can trigger → DEMOTE (unless "admin can rug" with concrete mechanism)
- Attack cost exceeds extraction → DROP
- Unprivileged actor triggers profitably → PASS

### Gate 4 — Impact

Prove material harm to an identifiable victim.

- Self-harm only → DROP
- Dust-level, no compounding → DEMOTE to Low
- Material loss to identifiable victim → CONFIRMED

---

## Confidence Scoring

Start at 100, deduct:
- Partial attack path (not fully traced): -20
- Bounded non-compounding impact: -15
- Requires specific (but achievable) state: -10

Confidence >= 80: full report with PoC/fix
Confidence 60-79: report with description only, mark as Medium at best
Confidence < 60: do NOT submit, save as lead for later

---

## Do Not Report (Common Rejections)

- Admin-only functions doing admin things (no exploit path)
- Standard DeFi tradeoffs: MEV, rounding dust, first-depositor with MINIMUM_LIQUIDITY
- Self-harm-only bugs
- "Admin can rug" without concrete mechanism
- Linter/compiler issues, gas micro-optimizations
- Missing events, naming, NatSpec
- Centralization without exploit path
- Implausible preconditions

EXCEPTION: fee-on-transfer, rebasing, blacklisting ARE plausible for contracts accepting arbitrary tokens.

---

## Cross-Contract Escalation

When you find a bug in one contract, WEAPONIZE that pattern across every other in-scope contract. Search by function name AND by code pattern. Missing a repeat instance = missed bounty.

After finding: escalate to worst exploitable variant. DoS may hide fund theft.

---

## Lead Promotion Criteria

Promote lead → finding if:
- Complete exploit chain traced in source code
- Same root cause confirmed in another contract
- Multiple independent analysis passes flagged same area

---

## Pre-Submit Final Check

1. Does proof contain CONCRETE values/traces from actual code? (not hypothetical)
2. Did I pass all 4 gates without hedging?
3. Is this one vulnerability per report? (same root cause = one report)
4. Did I check if the pattern repeats elsewhere in scope?
5. Would I bet money this is a real bug?
