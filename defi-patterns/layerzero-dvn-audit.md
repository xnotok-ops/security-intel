# LayerZero DVN Configuration Audit Pattern

## Bug Class
Cross-chain bridge via LayerZero OFT with inadequate DVN (Decentralized
Verifier Network) threshold — 1-of-1 or 1-of-N with single operator
creates single point of failure for cross-chain message validation.

## Canonical Real-World Case

**Kelp DAO Exploit — April 18, 2026**
- Loss: $292M (116,500 rsETH) — largest DeFi hack of 2026
- Attribution: Lazarus Group / TraderTraitor (per LayerZero post-mortem)
- Root cause: 1-of-1 DVN config on rsETH OFT bridge
- Attack vector: RPC poisoning (2 nodes) + DDoS failover forced
  verifier to rely on poisoned nodes → forged cross-chain message
  accepted → 116,500 rsETH minted on Ethereum without backing
- NOT a smart contract bug — 5+ prior audits passed

## On-Chain Verification (Bounty Recon)

DVN configurations are readable on-chain via LayerZero EndpointV2:
- Query `endpoint.getConfig(oapp, lib, eid, configType)` per chain
- Decode ULN302 config — check `requiredDVNCount`, `requiredDVNs[]`,
  `optionalDVNThreshold`, `optionalDVNs[]`
- 1-of-1 or 1-of-N with single operator = RED FLAG
- Multi-DVN (2-of-3+) with independent operators = baseline secure

## Grep Signals (In-Scope Code)

- `setConfig()` calls on LayerZero Endpoint
- `ULN302` / `UlnConfig` struct access and defaults
- DVN whitelist / threshold immutability — is it locked or mutable?
- Cross-ref bridge governance: apakah DVN config change butuh
  multisig+timelock atau admin-key only?

## Governance-Operational Gap Pattern

Real pattern observed across exploited protocols: core contracts
hardened (multisig + timelock) tapi **operational config** (bridge,
oracle, risk params) controlled by single admin key.

Audit lens:
- `onlyOwner` on DVN config setters vs `onlyTimelock`
- `setOracle()`, `setBridge()`, `setDVN()`, `setThreshold()` tanpa
  governance wrapper
- Bridge adapter contracts dengan EOA admin vs DAO-controlled

## Severity Calibration

- 1/1 DVN + admin-key controlled = High/Critical (config risk)
- 1/N with whitelisted operators = Medium
- 2-of-3 or higher multi-operator = Info / baseline secure

## Scope Consideration for Bounty Programs

Check program-specific: config-layer bugs often OOS under "not a code
bug" exclusion, BUT some programs explicitly include "bridge
misconfiguration" or governance architecture risks. For Immunefi
programs, this falls under "Impact" category even if the code is
"correct" — report as config risk with on-chain proof of deployed
config state.

## Sources

- LayerZero post-mortem (Apr 20, 2026):
  https://www.coindesk.com/tech/2026/04/20/layerzero-blames-kelp-s-setup-for-usd290-million-exploit
- Innora.ai forensic analysis:
  https://innora.ai/blog/kelp-dao-layerzero-292m-exploit-forensic-analysis
- Kelp security scan (pre-exploit April 6 flag):
  https://github.com/truenorth-lj/crypto-project-security-skill

## Related Historical Patterns
- Ronin Bridge ($625M, 2022) — 5 of 9 validators compromised
- Harmony Horizon ($100M, 2022) — 2 of 5 validators compromised
- Nomad ($190M, 2022) — config default value misstep
