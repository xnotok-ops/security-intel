\# LLM-for-Vulnerability-Detection Research Index



\*\*Source:\*\* https://github.com/huhusmang/Awesome-LLMs-for-Vulnerability-Detection

\*\*Curated:\*\* 2026-04-17

\*\*Review cadence:\*\* Quarterly. Pull actionable heuristic/pattern ke `smart-contract-audit` atau `bounty-lessons` skill kalau ada yang berimpact.



\## Context



Awesome-list akademik \~80+ paper (2018-2026) tentang LLM-based vulnerability detection. Auto-update via arxiv workflow. Mayoritas meta-research (cara BIKIN LLM detector), bukan actionable patterns — jadi \*\*bukan skill material langsung\*\*. Tapi ada 7 paper yang berhubungan operasi bounty hunting.



\## Priority: READ (2 papers, \~2 jam)



\### 1. Sifting the Noise: LLM Agents in Vulnerability False Positive Filtering (2026)

\*\*Link:\*\* https://arxiv.org/abs/2601.22952

\*\*Why:\*\* Langsung nyambung ke Gate 5 di `bounty-lessons` skill. FP filtering heuristic bisa extract langsung ke invalidation library.

\*\*Action:\*\* Baca section "Filtering Criteria" + "Heuristics", check overlap sama 45 pattern yang udah ada.



\### 2. LLM-SmartAudit: Advanced Smart Contract Vulnerability Detection (2024)

\*\*Link:\*\* https://arxiv.org/abs/2410.09381

\*\*Code:\*\* https://github.com/LLMAudit/LLMSmartAuditTool

\*\*Why:\*\* SC-specific, ada GitHub — bisa inspect prompt engineering + tool logic langsung.

\*\*Action:\*\* Skim paper dulu, lalu `git clone` repo, review prompt templates di-compare dengan `smart-contract-audit` v3.2 multi-expert flow.



\## Priority: PARK (5 papers, baca if use case muncul)



| # | Paper | Year | Link | Kapan baca |

|---|---|---|---|---|

| 3 | AgenticSCR: Autonomous Agentic Secure Code Review | 2026 | https://arxiv.org/abs/2601.19138 | Evolusi ke v3.3 multi-agent flow |

| 4 | MOS: SC Vuln Detection via Mixture-of-Experts | 2025 | https://arxiv.org/abs/2504.12234 | Validate/extend multi-expert framework |

| 5 | Combining Fine-Tuning + LLM Agents for SC Auditing (ICSE) | 2025 | https://arxiv.org/abs/2403.16073 | Improve finding justification quality |

| 6 | LLM-Based Vulnerability Detection at Project Scale | 2026 | https://arxiv.org/abs/2601.19239 | Repo-level audit prep |

| 7 | GPTScan: Detecting Logic Vulns by Combining GPT + Program Analysis (ICSE) | 2024 | https://doi.org/10.1145/3597503.3639117 | Reference for Slither+Claude flow validation |



\## Priority: SKIP (73+ remaining papers)



Tracked auto via arxiv workflow di source repo. No manual tracking needed. Re-visit `Awesome-LLMs-for-Vulnerability-Detection` repo quarterly, scan new entries yang match criteria:

\- SC-specific

\- False positive filtering

\- Agent orchestration gates



\## Extraction candidates (for skill updates)



Setelah baca Tier 1 papers, migrate pattern berikut kalau valid:

\- \[ ] FP filtering heuristics → `bounty-lessons` invalidation library

\- \[ ] Confidence gate criteria → `smart-contract-audit` module triggers

\- \[ ] Multi-agent orchestration pattern → `smart-contract-audit` v-next framework



\## Related references di bounty-notes



\- `references/invalidation-library.md` — 45 FP patterns (current source of truth for Gate 5)

\- `claude-skills/smart-contract-audit/SKILL.md` v3.2 — multi-expert 3-round current implementation

\- `claude-skills/bounty-lessons/SKILL.md` v1.2 — current pre-submit checklist

