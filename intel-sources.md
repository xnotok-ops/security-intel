\## BlockSec Weekly Web3 Security Incident Roundup



\- URL: https://blocksec.com/blog (filter: "Weekly Web3 Security Incident Roundup")

\- Cadence: Weekly (published Mon/Tue)

\- Format: 3-5 incidents/week, root cause + attack tx + patterns

\- Value: Pattern mining source for smart-contract-audit skill updates

\- Action: Review weekly, extract new patterns to skill candidate list

# Recurring Intel Sources



Daftar intel source yang worth di-check berkala untuk pattern mining, incident awareness, dan pipeline maintenance.



\## Primary sources (weekly skim)



\### BlockSec Weekly Web3 Security Incident Roundup



\- \*\*URL:\*\* https://blocksec.com/blog (filter: "Weekly Web3 Security Incident Roundup")

\- \*\*Cadence:\*\* Weekly (published Mon/Tue)

\- \*\*Format:\*\* 3-5 incidents per week, root cause + attack tx + pattern extractable

\- \*\*Value:\*\* Pattern mining source untuk skill updates. Setiap minggu potential 3-5 pattern baru.

\- \*\*Action:\*\* Skim Monday pagi. Kalau ada pattern baru, save postmortem ke `bounty-notes/references/exploit-postmortems/` + add ke skill candidate list.

\- \*\*Example patterns captured (Apr 6-12 2026 roundup):\*\*

&#x20; - Unsafe int256→uint256 cast in PnL (Denaria Linea)

&#x20; - Fail-open initialization-dependent ACL (XBIT BSC)

&#x20; - Permissionless arbitrary-call contract = approval sink (Squid Multicall)

&#x20; - Reward logic mutating AMM reserves (HB Token BSC)



\### CertiK Alert (Twitter/X)



\- \*\*URL:\*\* https://x.com/CertiKAlert

\- \*\*Cadence:\*\* Real-time (incident flagging)

\- \*\*Format:\*\* Short tweet with victim contract + loss estimate + preliminary analysis

\- \*\*Value:\*\* Earliest incident flagging, before detailed post-mortems exist

\- \*\*Action:\*\* Follow on X. Kalau incident relevan ke pipeline lu (Solana/EVM/NEAR/etc), create postmortem stub dengan info awal, update later saat detail emerge.



\## Secondary sources (on-demand)



\### SlowMist / PeckShield Twitter



\- Real-time incident flagging, similar to CertiK

\- Value: cross-reference to avoid missing reports



\### DeFiHackLabs



\- \*\*URL:\*\* https://github.com/SunWeb3Sec/DeFiHackLabs

\- \*\*Cadence:\*\* Ad-hoc, usually 1-3 weeks post-exploit

\- \*\*Format:\*\* Foundry PoC replay for major hacks

\- \*\*Value:\*\* Ideal for deep-dive learning via executable PoC. Use when pattern extraction needs deeper context than blog write-up.



\### Samczsun / Officer CIA (Twitter threads)



\- Operational awareness, researcher safety, web3 OpSec

\- Value: occasional gold-tier insight on novel attack surfaces



\## Historical archives (as needed)



\### Rekt News



\- \*\*URL:\*\* https://rekt.news

\- \*\*Format:\*\* Narrative post-mortem style

\- \*\*Value:\*\* Historical context for exploit pattern evolution



\### Code4rena / Sherlock / Cantina past contest findings



\- Already mined 876+ Code4rena repos (CLEARED)

\- Value: Re-reference for specific pattern variants



\## Workflow integration



\*\*When skimming an intel source:\*\*

1\. Check if incident pattern maps to active pipeline (Midas/SG Forge/idOS/Cronos zkEVM)

2\. If yes → deep-dive postmortem, save to `bounty-notes/references/exploit-postmortems/`

3\. Extract pattern → add to skill candidate batch (`bounty-notes/claude-skills/pending-patterns.md`)

4\. Cross-reference existing patterns to avoid duplicates

5\. Index sync → update `bounty-notes-index.md` di security-intel



\## Review cadence summary



| Source | Check frequency | Time budget |

|-|-|-|

| BlockSec blog | Weekly (Mon) | 10-15 min |

| CertiK Alert X | Daily skim | 2 min |

| SlowMist/PeckShield X | Daily skim | 2 min |

| DeFiHackLabs | Monthly sweep | 20 min |

| Rekt News | As needed | - |

| Samczsun/OfficerCIA | As encountered | - |

