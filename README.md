# 🛡️ Security Intel

Curated security knowledge base — vulnerability patterns, attack checklists, and lessons learned from bug bounty hunting and security research.

## Structure

```
security-intel/
├── patterns/           # Vulnerability patterns by category
│   ├── cross-chain/    # LayerZero, Wormhole, Axelar, etc.
│   ├── defi/           # ERC4626, AMM, lending, etc.
│   ├── web/            # API auth, IDOR, SSRF, etc.
│   └── secrets/        # Secrets detection patterns
├── checklists/         # Attack checklists by target type
├── wordlists/          # Fuzzing wordlists
└── tools/              # Tool references & commands
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
| DeFi | [admin-key-compromise.md](patterns/defi/admin-key-compromise.md) | Admin key & access control patterns |
| Web | [api-security.md](patterns/web/api-security.md) | API version, verb tampering, parameter pollution |
| Web | [ssrf.md](patterns/web/ssrf.md) | SSRF payloads, cloud metadata, bypasses |
| Web | [access-control-bypass.md](patterns/web/access-control-bypass.md) | 403 bypass, header tricks, verb tampering |
| Web | [file-upload-bypass.md](patterns/web/file-upload-bypass.md) | Extension, content-type, magic bytes bypass |
| Web | [password-reset.md](patterns/web/password-reset.md) | Token leak, host header poisoning, ATO chains |
| Secrets | [secrets-detection.md](patterns/secrets/secrets-detection.md) | API keys, JWT, framework secrets, regex patterns |

## Checklists

| Target | File | Description |
|--------|------|-------------|
| Smart Contract | [smart-contract.md](checklists/smart-contract.md) | Solidity audit checklist |
| Web/API | [web-api-audit.md](checklists/web-api-audit.md) | Full Web/API security audit checklist |
| 2FA | [2fa-bypass.md](checklists/2fa-bypass.md) | 2FA bypass techniques |
| Rate Limit | [rate-limit-bypass.md](checklists/rate-limit-bypass.md) | Rate limiting bypass techniques |
| Secrets | [secrets-scanning.md](checklists/secrets-scanning.md) | Secrets hunting checklist |

## Tools

| File | Description |
|------|-------------|
| [tools-reference.md](tools/tools-reference.md) | Quick reference for badsecrets, jsluice, ffuf, nuclei, etc. |

## Wordlists

| File | Lines | Description |
|------|-------|-------------|
| [sensitive-paths.txt](wordlists/sensitive-paths.txt) | 6038 | Sensitive file/path discovery |

## Related Repos

- [bounty-radar](https://github.com/xnotok-ops/bounty-radar) — Live H1/Immunefi data search
- [bounty-notes](https://github.com/xnotok-ops/bounty-notes) — Audit artifacts & findings (private)
- [prompt-library](https://github.com/xnotok-ops/prompt-library) — Writing prompts

---

**Maintained by [@xnotok](https://x.com/xnotok)**
