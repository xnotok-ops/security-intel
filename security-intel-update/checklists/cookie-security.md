# Cookie Security Testing Checklist

## Security Attributes

### Secure Flag
```http
Set-Cookie: session=abc123; Secure
```
- [ ] Session cookies have Secure flag
- [ ] Auth cookies have Secure flag
- [ ] Test: Cookies not sent over HTTP

### HttpOnly Flag
```http
Set-Cookie: session=abc123; HttpOnly
```
- [ ] Session cookies have HttpOnly flag
- [ ] Sensitive cookies have HttpOnly flag
- [ ] Test: `document.cookie` doesn't expose sensitive cookies

### SameSite Attribute
```http
Set-Cookie: session=abc123; SameSite=Strict
Set-Cookie: csrf=token; SameSite=Lax
```
- [ ] Session cookies: Strict or Lax
- [ ] CSRF tokens: Strict
- [ ] Test: Cross-origin requests don't send cookies

---

## Cookie Scope

### Domain Attribute
```http
Set-Cookie: session=abc; Domain=.target.com
```
- [ ] Domain not overly permissive
- [ ] No wildcard domain scope
- [ ] Test: Cookie not accessible by subdomains if not intended

### Path Attribute
```http
Set-Cookie: session=abc; Path=/app
```
- [ ] Path restricted appropriately
- [ ] Sensitive cookies limited to needed paths
- [ ] Test: Cookie not sent to other paths

---

## Session Cookie Security

### Randomness
- [ ] Session ID ≥ 128 bits entropy
- [ ] Cryptographically random generation
- [ ] Test: Generate multiple sessions, check randomness

### Lifetime
```http
Set-Cookie: session=abc; Max-Age=3600
Set-Cookie: session=abc; Expires=Thu, 01 Jan 2025 00:00:00 GMT
```
- [ ] Reasonable expiration time
- [ ] Session cookies vs persistent cookies
- [ ] Test: Expired cookies not accepted

### Invalidation
- [ ] Server-side session invalidation on logout
- [ ] Session ID regeneration after login
- [ ] Test: Old session ID rejected after logout

---

## Sensitive Data in Cookies

### Check for Exposure
- [ ] No passwords in cookies
- [ ] No API keys in cookies
- [ ] No PII in cookies
- [ ] No credit card data in cookies
- [ ] No unencrypted sensitive data

### Cookie Value Protection
- [ ] Values encrypted or hashed
- [ ] Signed cookies (HMAC)
- [ ] Test: Tamper with cookie, check server response

---

## Cookie-Based Attacks

### Session Fixation
- [ ] Session ID regenerated after login
- [ ] Test: Login with pre-set session ID
- [ ] Test: Session from URL parameter accepted?

### Session Hijacking
- [ ] HTTPS-only transmission
- [ ] Secure flag set
- [ ] Test: Cookie not exposed in Referer

### Cookie Overflow
- [ ] Maximum cookie size enforced
- [ ] Maximum cookies per domain enforced
- [ ] Test: Large cookie handling

### Cookie Tossing
- [ ] Subdomain can't overwrite parent domain cookies
- [ ] Test: Set cookie from subdomain, check main domain

---

## Testing Commands

### View Cookies
```bash
# Curl
curl -c cookies.txt -b cookies.txt https://target.com

# Browser DevTools
# Application > Cookies
```

### Check Attributes
```bash
# Curl verbose
curl -v https://target.com 2>&1 | grep -i "set-cookie"
```

### Test HTTPS-Only
```bash
# Try HTTP
curl -v http://target.com -H "Cookie: session=value"
```

### Test JavaScript Access
```javascript
// In browser console
console.log(document.cookie);
// HttpOnly cookies should not appear
```

---

## Common Misconfigurations

| Issue | Impact | Test |
|-------|--------|------|
| Missing Secure | MITM intercept | HTTP request |
| Missing HttpOnly | XSS cookie theft | `document.cookie` |
| Missing SameSite | CSRF | Cross-origin form |
| Domain=.target.com | Subdomain takeover | Subdomain enumeration |
| Long Max-Age | Session persistence | Check expiry |
| Predictable values | Session hijacking | Entropy analysis |

---

## Browser Cookie Limits

| Browser | Cookies/Domain | Size/Cookie |
|---------|----------------|-------------|
| Chrome | 180 | 4096 bytes |
| Firefox | 150 | 4097 bytes |
| Safari | 600 | 4096 bytes |
| Edge | 50 | 4096 bytes |

---

## Severity Ratings

| Issue | Severity |
|-------|----------|
| Sensitive data in cookies | Critical |
| Missing Secure + sensitive data | High |
| Missing HttpOnly + XSS present | High |
| Predictable session IDs | High |
| Session fixation | High |
| Missing SameSite | Medium |
| No session invalidation | Medium |
| Overly permissive domain | Medium |
| Long session lifetime | Low |

## References
- https://owasp.org/www-community/controls/SecureCookieAttribute
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
- https://book.hacktricks.xyz/pentesting-web/hacking-with-cookies
