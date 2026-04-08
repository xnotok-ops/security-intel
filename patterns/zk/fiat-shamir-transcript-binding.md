# Fiat-Shamir Transcript Binding — Unbound Public Claims

**Source:** OtterSec research "Unfaithful Claims: Breaking 6 zkVMs" (March 2026)
**Impact:** Complete soundness break — prove false statements (e.g., forge $1M out of thin air)
**Category:** ZK Soundness, Fiat-Shamir, Transcript Ordering
**Affected:** Jolt (a16z), Nexus, Cairo-M (Kakarot), Ceno (Scroll), Expander (Polyhedra), Binius64

---

## Pattern

Prover-controlled values that affect verification equations are not absorbed into the Fiat-Shamir transcript before challenge derivation. This makes challenges independent of those values, giving the attacker a free variable to solve verification equations algebraically.

## Root Cause

In non-interactive ZK proofs, the Fiat-Shamir transform replaces the verifier's randomness with hash output. The transcript (running hash state) MUST include every value that affects verification BEFORE the challenges derived from it are used.

If value V affects a verification equation but V is not absorbed before the relevant challenge is squeezed, the prover can compute the challenge first, then choose V to satisfy the equation.

## Universal Attack Flow

```
1. Identify prover-supplied value V that affects verification equation
2. Confirm V is NOT absorbed into transcript before challenge derivation
3. Challenges are now independent of V (fixed from attacker perspective)
4. Verification equation becomes: f(V) = target
5. If f is linear: solve V = (target - b) / a
6. If f is bilinear/rational: solve via substitution, quadratic formula, or Groebner bases
7. Submit forged proof with crafted V — verifier accepts false statement
```

## Vulnerable Value Types (what to look for)

| Value | Found In | Equation Type |
|-------|----------|---------------|
| opening_claims / input_claim | Jolt | Linear (sumcheck compression) |
| claimed_sum (LogUp) | Nexus, Cairo-M | Linear (composition polynomial) |
| public_data (I/O, registers) | Cairo-M | Rational (lookup denominators) |
| r_out_evals, w_out_evals | Ceno | Linear + Bilinear (GKR + multiset product) |
| public_input | Expander | Linear (GKR constant gate eval) |
| public witness | Binius64 | Linear (MLE evaluation) |

## Why It Keeps Happening

**Academic papers describe interactive protocols.** Security proofs analyze interactive versions where binding is implicit (verifier sees everything). Papers rarely specify what goes into the Fiat-Shamir transcript. Implementors must figure it out themselves.

**Hot Potato Problem.** Modular zkVMs have multiple layers (constraint system, sumcheck, PCS, lookup). Each layer assumes the other handles transcript binding. Nobody does.

**Optimization pressure.** Every hash operation costs performance. Pressure to exclude values that seem "probably fine" to leave out. Determining what is safe requires full protocol understanding.

**Testing gap.** Unit tests and integration tests run honest provers. Fuzzing has near-zero probability of finding valid forged proofs. Only manual security analysis catches these bugs.

## Detection Methodology

```
1. MAP the full verification flow:
   - What values does the verifier receive from the proof?
   - What values are passed separately (public inputs, claims)?
   
2. TRACE the transcript:
   - When is each value absorbed?
   - When is each challenge squeezed?
   
3. CHECK ordering for every prover-controlled value:
   - Does value V affect verification equation E?
   - Is V absorbed BEFORE challenge C that gates equation E?
   - If NO: potential soundness break
   
4. CLASSIFY the equation:
   - Linear in V? Trivial solve.
   - Bilinear? Substitution + quadratic.
   - Rational? Groebner bases.
   - Multiple unbound values? System of equations, Gaussian elimination.

5. Key question at every step:
   "What if the prover chose this value AFTER seeing the challenges?"
```

## Specific Protocol Patterns

### Sumcheck (compression trick)
The prover omits one coefficient per round. Final verification equation traces back through rounds and becomes LINEAR in the input claim H. If H is not in transcript, solve directly.

### LogUp (claimed_sum)
Each component's claimed_sum summarizes its net lookup contribution. Global check: sum of all claimed_sums = 0. If claimed_sums are not in transcript before composition polynomial challenges, attacker solves linear system.

### GKR (constant gate evaluation)
Public inputs feed into eval_cst as a linear combination weighted by challenge-derived coefficients. If public inputs not in transcript, attacker solves for alternate inputs.

### MLE evaluation
MLE at fixed challenge point r is linear in table values: f(r) = sum(f(b) * eq(b,r)). If table values (public witness) not bound before r is derived, attacker finds alternate witness.

## Fix

One or two lines of code in each case: absorb the value into the transcript before deriving any challenge that gates an equation depending on it.

```
// VULNERABLE
let challenges = transcript.squeeze();
let result = verify_with(challenges, unbound_value); // unbound_value not in transcript

// FIXED
transcript.absorb(value);           // bind BEFORE squeeze
let challenges = transcript.squeeze();
let result = verify_with(challenges, value);
```

Design-level prevention: merge proof buffer and transcript so all prover-sent values are auto-absorbed.

## Bounty Context

- Expander (Polyhedra): $500K bounty claimed, award pending
- This bug class is high-value but requires deep ZK expertise
- Most zkVM bounty programs would classify this as Critical
- Detection requires manual protocol analysis, not automated tooling

## Disclosure Timeline

| System | Reported | Fixed | Bounty |
|--------|----------|-------|--------|
| Jolt (a16z) | Sep 2025 | Oct 2025 | - |
| Nexus | Oct 2025 | Oct 2025 | - |
| Cairo-M (Kakarot) | Oct 2025 | Oct 2025 | - |
| Ceno (Scroll) | Nov 2025 | OPEN | - |
| Binius64 | Dec 2025 | Dec 2025 | - |
| Expander (Polyhedra) | Nov 2025 | Jan 2026 | $500K claimed |

## References

- Blog: https://osec.io/blog/2026-03-03-zkvms-unfaithful-claims/
- Jolt fix: https://github.com/a16z/jolt/pull/981
- Nexus fix: https://github.com/nexus-xyz/nexus-zkvm/pull/503
- Cairo-M fix: https://github.com/kkrt-labs/cairo-m/pull/352
- Ceno issue: https://github.com/scroll-tech/ceno/issues/1125
- Expander fix: https://github.com/PolyhedraZK/Expander/commit/4a8c2be
- Binius64 fix: https://github.com/binius-zk/binius64/pull/1355
- Polyhedra bounty: https://blog.polyhedra.network/expander-bug-bounty/

---

*Pattern extracted April 2026 by @xnotok*
