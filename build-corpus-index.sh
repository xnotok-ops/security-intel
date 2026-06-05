#!/usr/bin/env bash
# build-corpus-index.sh — auto-generate the `audit-corpus-index` skill from security-intel/
# Re-run anytime the corpus changes; the index always stays in sync (zero hand-maintenance).
# Usage: bash build-corpus-index.sh [SECURITY_INTEL_DIR]
set -euo pipefail

SI="${1:-/mnt/c/Users/USER/security-intel}"
SKILL_DIR="${SKILL_DIR:-$HOME/.claude/skills/audit-corpus-index}"
SKILL="$SKILL_DIR/SKILL.md"

[ -d "$SI" ] || { echo "ERROR: corpus dir not found: $SI" >&2; exit 1; }
mkdir -p "$SKILL_DIR"

# folder path (relative) -> domain TAG
tag_for() {
  case "$1" in
    patterns/defi/*|defi-patterns/*|sc-patterns/*)            echo "SC-DEFI" ;;
    patterns/cross-chain/*)                                   echo "CROSS-CHAIN" ;;
    patterns/zk/*)                                            echo "ZK" ;;
    patterns/mobile/*)                                        echo "MOBILE" ;;
    patterns/secrets/*)                                       echo "SECRETS" ;;
    patterns/lessons/*)                                       echo "LESSON" ;;
    patterns/web/*|web-patterns/*|references/patterns/web/*)  echo "WEB" ;;
    checklists/*|references/checklists/*)                     echo "CHECKLIST" ;;
    bridge-exploits/*)                                        echo "BRIDGE-EXPLOIT" ;;
    prior-audit-corpus*|prior-audit-corpora*|prior-audits/*)                 echo "PRIOR-AUDIT" ;;
    references/patterns/recon/*)                              echo "RECON" ;;
    tools/*|tool-*|tools-*)                                   echo "TOOLS" ;;
    references/*)                                             echo "REFERENCE" ;;
    *)                                                        echo "MISC" ;;
  esac
}

# generate the index body (one entry per curated .md)
gen_index() {
  cd "$SI"
  find . -name '*.md' \
    -not -path './.git/*' \
    -not -path './external-references/*' \
    -not -name 'bounty-notes-index.md' \
    | sed 's|^\./||' | LC_ALL=C sort | while IFS= read -r rel; do
      tag="$(tag_for "$rel")"
      lines="$(wc -l < "$rel" | tr -d ' ')"
      title="$(grep -m1 '^# ' "$rel" 2>/dev/null | sed 's/^#\+ *//; s/[|]/ /g')"
      [ -z "$title" ] && title="$(grep -m1 '[^[:space:]]' "$rel" | cut -c1-70 | sed 's/[|]/ /g')"
      # keywords: prefer '## ' headers; fall back to '### ', then bold/pattern-IDs, so no file is keyword-less
      kw="$(grep '^## ' "$rel" 2>/dev/null | sed 's/^#\+ *//; s/[|]/ /g; s/[*`]//g' | head -14 | paste -sd '~' - | sed 's/~/ | /g')"
      if [ -z "$kw" ]; then
        kw="$(grep '^### ' "$rel" 2>/dev/null | sed 's/^#\+ *//; s/[|]/ /g; s/[*`]//g' | head -14 | paste -sd '~' - | sed 's/~/ | /g')"
      fi
      if [ -z "$kw" ]; then
        kw="$(grep -oE '\*\*[^*]{3,}\*\*|[A-Z][A-Z0-9]{2,}-[0-9]+' "$rel" 2>/dev/null | sed 's/[*]//g; s/[|]/ /g' | head -12 | paste -sd '~' - | sed 's/~/ | /g')"
      fi
      if [ -z "$kw" ]; then
        kw="$(grep -E '^[-*] ' "$rel" 2>/dev/null | sed 's/^[-*] *//; s/[|]/ /g; s/[*`]//g' | head -8 | cut -c1-45 | paste -sd '~' - | sed 's/~/ | /g')"
      fi
      [ -z "$kw" ] && kw="(title only — open file)"
      printf -- '- **[%s]** `%s` (%s ln) — %s\n  - kw: %s\n' "$tag" "$rel" "$lines" "$title" "$kw"
  done
}

BODY="$(gen_index)"
NFILES="$(printf '%s\n' "$BODY" | grep -c '^- \*\*\[')"
NLINES_CORPUS="$(cd "$SI" && find . -name '*.md' -not -path './.git/*' -not -path './external-references/*' -not -name 'bounty-notes-index.md' -exec cat {} + | wc -l | tr -d ' ')"
# per-tag counts
TAGCOUNTS="$(printf '%s\n' "$BODY" | grep -oE '^\- \*\*\[[A-Z-]+\]' | sed 's/^- \*\*\[//; s/\]//' | sort | uniq -c | awk '{printf "%s:%s  ", $2, $1}')"
GENDATE="$(date +%Y-%m-%d)"

# write the skill: static frontmatter+intro (stable), then auto-generated index between markers
{
cat <<'HDR'
---
name: audit-corpus-index
description: >
  Auto-generated navigation index (table-of-contents) over the security-intel knowledge corpus —
  ~70 curated pattern / checklist / prior-audit / exploit files across SC-DeFi, Web, cross-chain, zk,
  mobile, secrets, recon, and tools. Load + SCAN this FIRST whenever doing dedup, Pattern-AS /
  known-issue cross-check, variant analysis, or any "have we seen this pattern/case before?" lookup
  during research: match a candidate finding's shape against the keyword index, then open ONLY the
  one pointed-to source file (never load the whole corpus). Trigger on: dedup check, prior-audit
  lookup, is this known, Pattern AS, similar case, what pattern covers X, which checklist for Y,
  attack-vector catalog, pashov vectors, web pattern lookup, sec3 corpus, corpus index. Regenerated
  by build-corpus-index.sh from security-intel/ — NEVER hand-edit the INDEX block (it is overwritten).
  Companion to bounty-pre-submit Gate 2/4 + bounty-lessons Rejection History.
---

# Audit Corpus Index

Lightweight TOC over `security-intel/` (auto-generated). **Workflow:** scan the keyword index below →
match a candidate finding/topic → open ONLY the pointed-to file for full detail. Do NOT load the whole
corpus. Tags: `SC-DEFI` `WEB` `CROSS-CHAIN` `ZK` `MOBILE` `SECRETS` `LESSON` `CHECKLIST`
`BRIDGE-EXPLOIT` `PRIOR-AUDIT` `RECON` `TOOLS` `REFERENCE`. Paths are relative to `security-intel/`.
External clones (`external-references/`) are intentionally NOT indexed — pull them directly when needed.

HDR
echo "_Generated ${GENDATE} · ${NFILES} files · ${NLINES_CORPUS} corpus lines · ${TAGCOUNTS}_"
echo ""
echo "<!-- INDEX:START — auto-generated by build-corpus-index.sh; DO NOT hand-edit -->"
echo ""
printf '%s\n' "$BODY"
echo ""
echo "<!-- INDEX:END -->"
} > "$SKILL"

echo "OK: wrote $SKILL"
echo "    $NFILES files indexed, tags: $TAGCOUNTS"
