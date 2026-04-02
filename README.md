# 🛡️ Security Intel

Curated security knowledge base — vulnerability patterns, attack checklists, and lessons learned from bug bounty hunting and security research.

## Structure

```
security-intel/
├── patterns/           # Vulnerability patterns by category
│   ├── cross-chain/    # LayerZero, Wormhole, Axelar, etc.
│   ├── defi/           # ERC4626, AMM, lending, etc.
│   └── web/            # API auth, IDOR, SSRF, etc.
├── checklists/         # Attack checklists by target type
└── resources/          # Tools, references, links
```

## Usage

Reference these during audit workflow:
- **Phase 1 Intel** — Check relevant patterns before diving into code
- **Phase 2 Audit** — Use checklists as attack surface guide
- **Post-Audit** — Update patterns with new findings

## Patterns

| Category | File | Description |
|----------|------|-------------|
| Cross-chain | [layerzero.md](patterns/cross-chain/layerzero.md) | LayerZero V2 vulnerability patterns |

## Related Repos

- [bounty-radar](https://github.com/xnotok-ops/bounty-radar) — Live H1/Immunefi data search
- [bounty-notes](https://github.com/xnotok-ops/bounty-notes) — Audit artifacts & findings (private)
- [prompt-library](https://github.com/xnotok-ops/prompt-library) — Writing prompts

---

**Maintained by [@xnotok](https://x.com/xnotok)**
