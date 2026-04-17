\# Notok Bounty Tools — Catalog Summary



\*\*Full catalog (private):\*\* `bounty-notes/tools-to-setup.txt`

\*\*Purpose:\*\* Trigger reminder — saat riset butuh tool, cek catalog dulu sebelum install from scratch. Tools udah di-track dengan install command + use case trigger.



\## Categories (quick reference)



| Category | Tools tracked | Use when |

|---|---|---|

| \*\*Recon \& Enumeration\*\* | Osmedeus (+ Shodan/Censys/FOFA/grep.app online) | Heavy subdomain/port/tech sweep |

| \*\*JS / Secrets Analysis\*\* | jsmon, JS-Tap, badsecrets, jsluice, TruffleHog, Gitleaks, SecretFinder, Nosey Parker | JS file recon, secret hunting |

| \*\*Git / GitHub Recon\*\* | GitDorker, GitTools, github-search | Exposed .git, github dorking |

| \*\*Web Fuzzing \& Wordlists\*\* | ffuf, SecLists, DeadDrop (+ Interactsh online) | Dir/param brute, OOB testing |

| \*\*GraphQL Testing\*\* | graphw00f, clairvoyance, graphql-cop, InQL (+ Voyager online) | Target has /graphql endpoint |

| \*\*Smart Contract Fuzzing\*\* | Recon-Fuzz stack (chimera + 8 satellites) | Complex DeFi invariant audit |

| \*\*Attack TX Analysis\*\* | TxAnalyzer | Post-exploit single tx RCA |

| \*\*Platform / MCP\*\* | H1 MCP Server | Agentic HackerOne workflows |

| \*\*Claude Code Skills\*\* | ffuf, owasp, vibesec, trailofbits | System-wide (already installed) |



\## Status conventions



\- `\[INSTALLED]` — ready, jalankan langsung

\- `\[PENDING]` — install on-demand saat butuh (command available in catalog)

\- `\[CLONED]` — repo downloaded, needs config (e.g., TxAnalyzer)

\- `\[ONLINE]` — web-based, bookmark only



\## Trigger rule (for future Claude sessions)



Saat user minta tool untuk task riset, \*\*FIRST\*\* check kalau tool relevan udah tracked di catalog ini. Kalau ada `\[PENDING]`, suggest install command dari catalog (already validated). Kalau baru entirely, baru suggest dari scratch + propose add to catalog.



\## Last updated

2026-04-17 — restructured with categories + status markers (12 categories tracked)

