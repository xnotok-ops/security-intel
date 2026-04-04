# 2FA Bypass Checklist — Bug Bounty Edition

> Source: github.com/awais0x1/2fa-bypass + real bug bounty writeups
> Reference: github.com/reddelexc/hackerone-reports/tops_by_bug_type/TOPMFA.md
> Run this checklist on any target with 2FA/MFA implementation.

---

## Quick Priority Order

1. Password reset flow bypass (easiest, highest hit rate)
2. OAuth/SSO bypass (common in crypto platforms)
3. Response tampering (missing backend validation)
4. Brute force + rate limit bypass
5. Race conditions
6. Session persistence abuse
7. Advanced (ID swapping, token replay, trust device abuse)

---

## 1. Password Reset Flow Bypass

**Test:**
```
1. Enable 2FA on test account
2. Logout → go to "Forgot Password" flow
3. Reset password → check if auto-logged in WITHOUT 2FA prompt
4. Also test: deactivate account → reset password → login
```

**Variants:**
- Reset password → session grants access without 2FA
- Deactivate account → reset password → 2FA skipped on reactivation
- Click login link from email → auto-login without 2FA
- Remove `token` parameter from reset POST request → bypass 2FA

**Severity:** High — attacker needs email access only

---

## 2. OAuth / SSO Integration Bypass

**Test:**
```
1. Target supports "Login with Google/Apple/Facebook/GitHub"
2. Create OAuth account with same email as target account
3. Login via OAuth → check if 2FA prompt appears
4. Also: enable 2FA → use OAuth login → check if 2FA disabled/skipped
```

**Real cases:**
- Sign in with Apple → bypasses Cloudflare 2FA (same email)
- Sign in with Google → silently disables Shopify 2FA + can't re-enable
- GitHub OAuth → skips internal 2FA enforcement

**Severity:** High-Critical — breaks MFA entirely for OAuth users

---

## 3. Response Tampering (Missing Backend Validation)

**Test:**
```
1. Intercept OTP submission request in Burp
2. Try modifying:
   - OTP value → arbitrary/wrong code
   - Response body: "is2faVerified": false → true
   - HTTP status: 403 → 200
   - Remove 2FA parameter entirely
3. Forward and check if login succeeds
```

**Variants:**
- Submit blank/empty OTP code
- Submit null OTP
- Remove OTP parameter from request body
- Tamper response to indicate success

**Severity:** High — trivial to exploit if validation is client-side

---

## 4. Brute Force (Missing Rate Limiting)

**Test:**
```
1. Trigger OTP prompt
2. Intercept OTP verification request
3. Automate submissions:
   - 4-digit: 0000-9999 (10,000 attempts)
   - 6-digit: 000000-999999 (1,000,000 attempts)
4. Check for lockout after N attempts
5. Check OTP expiration after failed attempts
```

**Burp Intruder setup:**
```
POST /api/2fa/verify
{"otp": "§000000§"}

Attack type: Sniper
Payload: Numbers 000000-999999
```

**Severity:** High if no lockout, Medium if partial rate limiting

---

## 5. Rate Limit Bypass via HTTP Headers

**Test:**
```
1. Confirm rate limiting kicks in (429 / blocked)
2. Add/rotate these headers per request:
   X-Forwarded-For: {random_ip}
   X-Real-IP: {random_ip}
   CF-Connecting-IP: {random_ip}
   X-Originating-IP: {random_ip}
3. Retry brute force with rotated headers
4. Check if rate limit resets per IP value
```

**Burp Intruder — Pitchfork attack:**
```
Position 1: OTP code
Position 2: X-Forwarded-For header value
```

**Severity:** High — enables brute force even with rate limiting

---

## 6. Race Condition on 2FA Verification

**Test:**
```
1. Intercept OTP verification request
2. Duplicate request ×20 in Burp Repeater
3. Send group in parallel (single-packet attack)
4. Check if one succeeds while others fail
5. Also test: concurrent 2FA enroll/change flows
```

**Race on 2FA enrollment:**
```
Session A: Start 2FA enrollment
Session B: Start 2FA change simultaneously
→ Check if one completes without OTP from the other
```

**Severity:** High — can validate expired OTPs or replace secret without OTP

---

## 7. Session Persistence Abuse

**Test A — Old sessions survive 2FA enable:**
```
1. Login on Device A and Device B (same account)
2. Enable 2FA on Device A
3. On Device B: reload page
4. Check if Device B still has full access without 2FA
```

**Test B — 2FA persistence after password change:**
```
1. Enable 2FA, start login, stop at OTP prompt
2. In another session: change password or disable 2FA
3. Return to OTP prompt, submit valid code
4. Check if login completes despite security change
```

**Severity:** High — attacker retains access even after victim changes credentials

---

## 8. Disable 2FA Without Reauthentication

**Test:**
```
1. Enable 2FA
2. Go to disable 2FA flow
3. Try disabling without providing password or OTP:
   - Remove password field from request
   - Tamper response to indicate success
   - Try old/wrong password
4. Check if 2FA gets disabled
```

**Severity:** High — attacker with active session can silently disable MFA

---

## 9. Backup Code Issues

**Test:**
```
1. Enable 2FA, generate backup codes
2. Test: use backup code twice → should be single-use
3. Test: change recovery method → old codes still work?
4. Test: submit random code (same format) → accepted?
5. Test: check if codes are predictable/sequential
```

**Severity:** High if random codes accepted, Medium if reusable

---

## 10. Account Deactivation + Reactivation

**Test:**
```
1. Enable 2FA
2. Deactivate account (if feature exists)
3. Reactivate via old link or email
4. Check if 2FA is still enforced after reactivation
```

**Severity:** Medium-High

---

## 11. Trust Device Abuse → Email Change ATO

**Test:**
```
1. Create attacker account, complete 2FA
2. Select "Trust this device for X days"
3. Change account email to victim's email
4. Logout → login with victim email → no OTP prompt?
5. Change back to attacker email → re-trust → change to victim again
→ Persistent bypass cycling
```

**Severity:** Critical — full ATO without victim interaction

---

## 12. 2FA IDOR — Link via Another User's ID

**Test:**
```
1. Register User A (no 2FA) — record User A's account ID
2. Register User B — start 2FA enrollment
3. In enrollment request, replace User B's ID with User A's ID
4. Call /api/2fa/verify with valid OTP + User A's ID
5. Check if User A now has 2FA linked to attacker's flow
```

**Severity:** Critical — account takeover without victim interaction

---

## 13. OTP/Session Swap (Cross-Account)

**Test:**
```
1. Create Attacker + Victim accounts, both with 2FA
2. As Attacker: start login, reach OTP prompt, intercept request
3. Replace username/login parameter with Victim's username
4. Replace OTP with valid OTP from Victim's authenticator
5. Forward → check if logged in as Victim
```

**Severity:** Critical — complete ATO

---

## 14. sendCodeTo Parameter Swapping

**Test:**
```
1. Create Account A + Account B with different recovery phones
2. Trigger "send recovery code" for each, capture sendCodeTo value
3. For Account B's flow: replace sendCodeTo with Account A's phone ID
4. Check which phone receives the SMS code
```

**Severity:** High — redirects recovery codes to attacker

---

## 15. Non-Expiring Tokens

**Test:**
```
1. Trigger password reset → capture confirmation_token URL
2. Wait for token to "expire" (hours/days)
3. Visit URL → check if still valid
4. Also: replay authenticity_token from password form
```

**Severity:** High — enables delayed account takeover

---

## 16. Enable 2FA Without Email Verification

**Test:**
```
1. Register with victim's email (don't verify)
2. Login without verification (if allowed)
3. Enable 2FA on unverified account
4. Victim tries to register → "email already used"
5. Victim can't recover → denial of account ownership
```

**Severity:** High — blocks legitimate owner from account

---

## 17. Previously Created Sessions Valid After 2FA Activation

**Test:**
```
1. Login on Device A and Device B
2. Enable 2FA on Device A
3. On Device B: navigate without re-auth
4. Check if full access without MFA challenge
```

**Severity:** High — existing sessions bypass newly enabled MFA

---

## 18. Reusable/Long-Lived OTP

**Test:**
```
1. Enable 2FA, note current OTP
2. Wait 2-3 intervals (~60-90 seconds)
3. Submit old OTP to complete login
4. Try OTP from 1-3 cycles ago
```

**Severity:** Medium-High — increases brute force window

---

## 19. 2FA Disable via Wrong Password (Response Tamper)

**Test:**
```
1. Enable 2FA → go to disable flow
2. Submit valid OTP but wrong password
3. Intercept response → modify to success
4. Check if 2FA gets disabled
```

**Severity:** High

---

## 20. SMS Endpoint Brute Force

**Test:**
```
1. Trigger SMS verification (profile change, etc.)
2. Capture required session headers
3. Send sequential codes (1000-9999 for 4-digit)
4. Check for rate limiting / expiration
5. Look for 204/success response
```

**Burp script:**
```python
for code in range(1000, 10000):
    # send POST with code as string f"{code:04d}"
```

**Severity:** Critical if no rate limiting on SMS endpoint

---

## Platform-Specific Checks

### Crypto Exchanges
```
[ ] 2FA enforced on withdrawal endpoint?
[ ] 2FA enforced on API key creation?
[ ] 2FA bypass via API endpoints (mobile vs web)?
[ ] Old sessions valid after 2FA enable?
[ ] Withdrawal 2FA and login 2FA same or separate?
```

### OAuth-Heavy Platforms
```
[ ] All OAuth providers enforce 2FA?
[ ] Social login creates new session without 2FA?
[ ] OAuth can be linked to existing 2FA account?
```

---

## Quick Checklist

```
[ ] Password reset → auto login without 2FA?
[ ] OAuth/SSO → skips 2FA?
[ ] Submit blank/null OTP → succeeds?
[ ] Response tamper → mark 2FA as passed?
[ ] Brute force → no lockout?
[ ] X-Forwarded-For → bypasses rate limit?
[ ] Race condition → validate expired OTP?
[ ] Old sessions → survive 2FA activation?
[ ] Disable 2FA → no reauthentication needed?
[ ] Backup codes → random accepted? reusable?
[ ] Trust device + email change → persistent bypass?
[ ] /api/2fa/verify → accepts other user's ID?
[ ] sendCodeTo → swappable?
[ ] Confirmation tokens → non-expiring?
[ ] Enable 2FA on unverified email → blocks owner?
```
