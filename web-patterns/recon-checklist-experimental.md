# Web Recon Checklist — Experimental Intel Queue

> Entries belum divalidasi via real bounty hunt. Review quarterly —
> promote to skill if ≥3 real cases validated, demote to skip if dead.

## 2026-04

- [ ] **Frontend lifecycle async race** — flag `useEffect(() => fetch(...))`
  / `onMounted(async ...)` tanpa cleanup return atau AbortController.
  Test: rapid state swap (userId change, route nav, logout) saat request
  in-flight. Signal: stale response renders di new context (cross-user
  leak, post-logout data, privilege bleed). Also flag Next.js SSR
  module-level state bleed as higher-impact variant.
  Origin: iOS SwiftUI .onAppear vs .task pattern (X, Apr 2026).
  Status: unvalidated.

---

## Validation Protocol

Saat pakai item dari list ini di real hunt:
1. Mark checkbox kalau grep pattern match di target
2. Document outcome di bounty-notes/programs/{program}/lessons.md
3. Setelah 3 confirmed real-world cases → promote ke security-research
   skill patterns via bounty-workflow bounty-lessons flow
4. Setelah 90 hari tanpa validation hit → demote ke archived-patterns.md
