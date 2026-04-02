# Admin Key Compromise Patterns
## Category: Access Control | Severity: Critical | Updated: 2 April 2026

---

## Real-World Case: Drift Protocol ($285M - April 2026)

### Incident Summary
| Field | Value |
|-------|-------|
| Date | 1 April 2026 |
| Protocol | Drift Protocol (Solana Perp DEX) |
| Loss | $285M (~50% of TVL) |
| Root Cause | Admin private key compromise |
| Attack Duration | <1 hour |
| Chain | Solana |

### Attack Timeline
```
D-8:  Attacker creates wallet HkGz4KmoZ7Zmk7HN6ndJ31UJ1qZ2qgwQxgVqQwovpZES
D-7:  Test transaction (recon)
D-0:  
  11:06 UTC - First drain: 41.7M JLP ($155.6M)
  11:XX UTC - Drain SOL Super Staking vault
  11:XX UTC - Drain BTC Super Staking vault
  11:XX UTC - Change admin keys (lock out team)
  12:XX UTC - Swap via Jupiter → Bridge to ETH
  
Total: $285M drained, team locked out of contracts
```

### Stolen Assets
| Asset | Amount | Value |
|-------|--------|-------|
| JLP | 41.72M | $155.62M |
| USDC | 51.616M | $51.62M |
| cbBTC | 164,349 | $11.29M |
| WSOL | 125,000 | $10.45M |
| FARTCOIN | 23.366M | $4.11M |
| Others (MSOL, BSOL, JitoSOL, USDT) | - | ~$50M+ |

### Why Attack Succeeded
1. **Single admin key** - No multisig requirement
2. **No timelock** - Admin changes instant
3. **Over-privileged admin** - Could withdraw + change admin
4. **No audit** - Lacked Certik/formal audit
5. **No withdrawal limits** - Entire vault drained in 1 tx

### References
- GitHub: https://github.com/drift-labs (protocol-v2, drift-vaults)
- Attacker wallet: `HkGz4KmoZ7Zmk7HN6ndJ31UJ1qZ2qgwQxgVqQwovpZES`
- Detection: PeckShield, Lookonchain, Arkham
- 2022 Post-mortem (similar): https://driftprotocol.medium.com/drift-protocol-technical-incident-report-2022-05-11-eedea078b6d4

---

## Vulnerable Patterns

### Pattern 1: Single Admin EOA
```solidity
// VULNERABLE
address public admin;

modifier onlyAdmin() {
    require(msg.sender == admin, "Not admin");
    _;
}

function emergencyWithdraw(address token) external onlyAdmin {
    uint256 balance = IERC20(token).balanceOf(address(this));
    IERC20(token).transfer(admin, balance);
}
```

**Risk:** If admin key leaked, attacker has full control.

**Hunt for:**
- `address public owner/admin`
- `onlyOwner` / `onlyAdmin` without multisig
- Single signer controlling critical functions

### Pattern 2: Instant Admin Transfer
```solidity
// VULNERABLE - No delay
function transferAdmin(address newAdmin) external onlyAdmin {
    admin = newAdmin;
    emit AdminTransferred(newAdmin);
}

// SAFER - With timelock
uint256 public constant ADMIN_DELAY = 2 days;
address public pendingAdmin;
uint256 public adminTransferTime;

function queueAdminTransfer(address newAdmin) external onlyAdmin {
    pendingAdmin = newAdmin;
    adminTransferTime = block.timestamp + ADMIN_DELAY;
}

function executeAdminTransfer() external {
    require(block.timestamp >= adminTransferTime, "Timelock active");
    require(pendingAdmin != address(0), "No pending admin");
    admin = pendingAdmin;
    pendingAdmin = address(0);
}
```

**Hunt for:**
- `setOwner()`, `transferOwnership()`, `changeAdmin()` without delay
- Missing `Ownable2Step` pattern
- No pending owner mechanism

### Pattern 3: Admin Can Drain Vault
```solidity
// VULNERABLE - Admin can steal all funds
function adminWithdraw(
    address token,
    uint256 amount,
    address recipient
) external onlyAdmin {
    IERC20(token).transfer(recipient, amount);
}

// Also dangerous:
function setFeeRecipient(address newRecipient) external onlyAdmin {
    feeRecipient = newRecipient; // Can redirect all fees
}
```

**Hunt for:**
- `rescueTokens()`, `emergencyWithdraw()`, `adminWithdraw()`
- Arbitrary `recipient` parameter in admin functions
- `setFeeRecipient()` without validation

### Pattern 4: Upgrade Without Safeguards
```solidity
// VULNERABLE - Instant malicious upgrade
function upgradeTo(address newImplementation) external onlyAdmin {
    _upgradeTo(newImplementation);
}

// SAFER - With timelock
function queueUpgrade(address newImplementation) external onlyAdmin {
    pendingImplementation = newImplementation;
    upgradeTime = block.timestamp + UPGRADE_DELAY;
}
```

**Hunt for:**
- UUPS/Transparent proxy with single admin
- `upgradeTo()` without timelock
- `upgradeToAndCall()` can execute arbitrary code

### Pattern 5: Pause + Withdraw Combo
```solidity
// DANGEROUS COMBO
function pause() external onlyAdmin {
    _pause();
}

function emergencyWithdraw() external onlyAdmin whenPaused {
    // Admin pauses, then drains while users can't withdraw
}
```

**Hunt for:**
- `whenPaused` modifier on admin withdraw
- Pause doesn't affect admin functions
- No user withdrawal during emergency

### Pattern 6: Role-Based Without Separation
```solidity
// VULNERABLE - DEFAULT_ADMIN can grant any role
bytes32 public constant ADMIN_ROLE = DEFAULT_ADMIN_ROLE;
bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER");

// If ADMIN_ROLE compromised, attacker grants themselves WITHDRAWER
function grantRole(bytes32 role, address account) public override onlyRole(ADMIN_ROLE) {
    _grantRole(role, account);
}
```

**Hunt for:**
- `DEFAULT_ADMIN_ROLE` as single EOA
- No separation between role admin and role holder
- Missing role renouncement restrictions

---

## Audit Checklist

### Access Control
- [ ] Is admin/owner a multisig? (check on-chain)
- [ ] Is there timelock on admin changes? (min 24-48h)
- [ ] Can admin be changed to arbitrary address instantly?
- [ ] Is there `Ownable2Step` or pending owner pattern?
- [ ] What's the admin key storage? (HSM, hardware wallet, hot wallet?)

### Admin Privileges
- [ ] List ALL functions with admin modifier
- [ ] Can admin withdraw user funds directly?
- [ ] Can admin change critical addresses (oracle, fee recipient)?
- [ ] Can admin pause + withdraw combo?
- [ ] Can admin upgrade contract instantly?
- [ ] Can admin mint tokens?
- [ ] Can admin change fees to 100%?

### Vault-Specific
- [ ] Is there max withdrawal per tx?
- [ ] Is there daily withdrawal cap?
- [ ] Are large withdrawals delayed?
- [ ] Can admin bypass withdrawal queue?
- [ ] Is there withdrawal whitelist admin can modify?

### Upgrade Mechanism
- [ ] Is contract upgradeable?
- [ ] Who controls upgrade? (single key vs multisig)
- [ ] Is there upgrade delay?
- [ ] Can upgrade be cancelled?
- [ ] Is implementation validated before upgrade?

### Emergency Functions
- [ ] What can `emergencyWithdraw()` do?
- [ ] Who can call emergency functions?
- [ ] Is there cooldown after emergency?
- [ ] Can emergency be abused to drain funds?

---

## Application to Active Programs

### Midas Finance (Cantina)
**Relevant contracts:**
- `RedemptionVault.sol`, `DepositVault.sol`
- `MidasAccessControl.sol`
- `MidasLzVaultComposerSync.sol`

**Check:**
```solidity
// Look for these patterns:
- DEFAULT_ADMIN_ROLE holder (is it multisig?)
- withdrawToken() / rescueToken() functions
- setFeeReceiver() without timelock
- Vault pause + admin withdraw combo
- LayerZero endpoint change by admin
```

**Questions:**
1. Can DEFAULT_ADMIN withdraw user mTokens?
2. Is admin change timelocked?
3. Can admin redirect cross-chain messages?

### Dexalot (HackenProof)
**Relevant contracts:**
- `OmniVaultManager.sol`
- `OmniVaultShare.sol` (OFT - LayerZero)

**Check:**
```solidity
// Already found: totalSupply read during settlement
// Additional hunt:
- SETTLER_ROLE holder (multisig?)
- Can settler drain vault?
- Admin functions in OFT contract
```

### SG Forge (HackenProof - Opens May 2)
**Relevant:** Solana token with freeze/transfer authorities

**Check:**
- Freeze authority = single key?
- Can authority freeze + steal combo?
- Is there multisig on Solana authorities?

### Multipli (HackenProof - Need 150 rep)
**Relevant:** ERC-4626 vault on Avalanche

**Check:**
- Vault admin privileges
- UUPS upgrade mechanism
- FlashRedeem admin controls

---

## Detection Signals

### Pre-Attack Indicators
1. **New wallet creation** - Fresh wallet with no history
2. **Test transactions** - Small tx before main attack
3. **Contract interaction pattern** - Unusual admin calls
4. **Funding source** - Tornado/bridge from unknown source

### During Attack
1. **Large single withdrawals** - Unusual size
2. **Multiple vaults same block** - Coordinated drain
3. **Admin change tx** - Ownership transfer
4. **Bridge activity** - Moving to other chain quickly

### Monitoring Tools
- Arkham Intelligence - Wallet tracking
- PeckShield - Alert system
- Lookonchain - On-chain monitoring
- Forta - Real-time detection bots

---

## Remediation Patterns

### Must Have
1. **Multisig admin** - 3/5 or 4/7 minimum
2. **Timelock** - 24-48h for critical operations
3. **Withdrawal limits** - Max per tx, daily cap
4. **Separation of duties** - Different keys for different functions

### Nice to Have
1. **Hardware security** - HSM for admin keys
2. **Monitoring** - Real-time alerts for admin actions
3. **Insurance** - Coverage for key compromise
4. **Formal verification** - Prove admin can't drain

### Emergency Response
1. **Guardian system** - Can pause but not withdraw
2. **Recovery mechanism** - Time-delayed recovery
3. **User exit** - Users can always withdraw (even if paused)

---

## Historical Cases

| Date | Protocol | Loss | Cause |
|------|----------|------|-------|
| Apr 2026 | Drift | $285M | Admin key compromise |
| Feb 2025 | Bybit | $1.4B | Safe{Wallet} frontend injection |
| Mar 2022 | Ronin | $625M | Validator key compromise |
| Aug 2021 | Poly Network | $611M | Keeper key compromise |

**Pattern:** Biggest hacks aren't smart contract bugs — they're key management failures.

---

## Quick Reference Commands

### Check Admin on Etherscan
```
1. Go to contract → Read Contract
2. Find owner() / admin() / getRoleMember(DEFAULT_ADMIN_ROLE, 0)
3. Check if address is EOA or contract (multisig)
```

### Check Timelock
```solidity
// Search in code for:
- "delay"
- "timelock"
- "pending"
- "queue"
- "execute"
```

### Verify Multisig
```
1. Get admin address
2. Check on Etherscan if it's Safe/Gnosis
3. Verify threshold (e.g., 3/5)
```

---

*Last updated: 2 April 2026*
*Case source: Drift Protocol exploit*
