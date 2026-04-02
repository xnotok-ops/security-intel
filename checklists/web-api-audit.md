# Web/API Security Audit Checklist

> Consolidated checklist untuk Web/API bug bounty targets (exchanges, platforms, etc.)

## Phase 1: Reconnaissance

### Endpoint Discovery
- [ ] Crawl application with Burp Spider
- [ ] Check `/robots.txt`, `/sitemap.xml`
- [ ] Fuzz with wordlist: `/api/`, `/v1/`, `/v2/`, `/internal/`, `/admin/`
- [ ] Check JS files for hidden endpoints
- [ ] Monitor WebSocket connections

### Technology Fingerprinting
- [ ] Identify framework (response headers, error pages)
- [ ] Check for version disclosure
- [ ] Identify WAF (Cloudflare, Akamai, etc.)

---

## Phase 2: Authentication Testing

### Login
- [ ] Default credentials
- [ ] Username enumeration via error messages
- [ ] Username enumeration via response timing
- [ ] Brute force protection / rate limiting
- [ ] Account lockout bypass

### Password Reset
- [ ] Token not expiring after use
- [ ] Token not expiring after new request
- [ ] Token leak in Referer header
- [ ] Token leak in response body
- [ ] Host header poisoning
- [ ] Email parameter manipulation (HPP, CC injection)
- [ ] User enumeration
- [ ] Rate limiting bypass

### 2FA Bypass
- [ ] Response manipulation (change status to 200)
- [ ] Direct endpoint access (skip 2FA page)
- [ ] Referrer header bypass
- [ ] Brute force OTP (no rate limit)
- [ ] OTP reuse
- [ ] OTP leak in response
- [ ] Session permission mixing

### Session Management
- [ ] Session fixation
- [ ] Session token in URL
- [ ] Concurrent session handling
- [ ] Session timeout
- [ ] Logout invalidation

---

## Phase 3: Authorization Testing

### IDOR
- [ ] Horizontal: access other users' data
- [ ] Vertical: access admin functions
- [ ] Test all parameters: path, query, body, headers
- [ ] UUID vs numeric ID switching
- [ ] Array/object wrapping: `{"id":1}` → `{"id":[1]}`

### 403 Bypass
- [ ] Path manipulation: `/admin` → `/admin;` `/admin/` `/admin..;`
- [ ] URL encoding: `/%61dmin`
- [ ] Case variation: `/Admin` `/ADMIN`
- [ ] HTTP method override headers
- [ ] X-Forwarded-For: 127.0.0.1
- [ ] X-Original-URL / X-Rewrite-URL
- [ ] HTTP/1.0 downgrade

### Verb Tampering
- [ ] GET → POST → PUT → DELETE → PATCH
- [ ] HEAD, OPTIONS, TRACE
- [ ] Arbitrary verbs: JEFF, FAKE

---

## Phase 4: Input Validation

### Injection
- [ ] SQL Injection (error-based, blind, time-based)
- [ ] NoSQL Injection (`{"$ne":""}`, `{"$gt":""}`)
- [ ] Command Injection (`;`, `|`, `` ` ``)
- [ ] LDAP Injection
- [ ] XPath Injection

### XSS
- [ ] Reflected XSS
- [ ] Stored XSS
- [ ] DOM XSS
- [ ] SVG upload XSS
- [ ] PDF/DOCX XSS
- [ ] WAF bypass payloads

### SSRF
- [ ] URL parameters fetching external resources
- [ ] Webhook URLs
- [ ] PDF/image generators
- [ ] File import functions
- [ ] Cloud metadata access (169.254.169.254)

### File Upload
- [ ] Extension bypass (double ext, null byte, special chars)
- [ ] Content-Type bypass
- [ ] Magic bytes manipulation
- [ ] SVG with XSS/XXE/SSRF
- [ ] Zip slip
- [ ] Path traversal in filename

---

## Phase 5: API-Specific

### Version Testing
- [ ] `/api/v3/` → `/api/v1/` → `/api/v2/`
- [ ] `/api/mobile/` endpoints
- [ ] `/api/internal/` endpoints

### Content-Type Switching
- [ ] JSON → XML (check XXE)
- [ ] JSON → form-urlencoded
- [ ] Add `Content-Type: application/xml`

### Parameter Pollution
- [ ] `?param=a&param=b`
- [ ] JSON: `{"key":"a","key":"b"}`

### Rate Limiting
- [ ] Null payload brute force
- [ ] X-Forwarded-For rotation
- [ ] Parameter variation: `signup` → `Sign-up` → `SignUp`
- [ ] Add special chars: `email%00`, `email%20`
- [ ] Random query param: `?bypass`

### Mass Assignment
- [ ] Add admin/role parameters to requests
- [ ] Modify read-only fields

---

## Phase 6: Business Logic

### Payment/Transaction
- [ ] Price manipulation
- [ ] Currency confusion
- [ ] Negative values
- [ ] Race conditions (double spending)
- [ ] Order status manipulation

### Account
- [ ] Email change without verification
- [ ] Phone change without verification
- [ ] Merge account vulnerabilities
- [ ] Account deletion bypass

---

## Phase 7: Miscellaneous

### Information Disclosure
- [ ] Error messages with stack traces
- [ ] Debug endpoints
- [ ] .git exposure
- [ ] Backup files (.bak, .old, ~)
- [ ] Environment files (.env, config.php)
- [ ] API documentation exposure

### CORS
- [ ] `Origin: null` reflection
- [ ] `Origin: attacker.com` reflection
- [ ] Subdomain trust issues

### CSRF
- [ ] Missing CSRF token
- [ ] Token validation bypass
- [ ] Clickjacking

### WebSocket
- [ ] Authentication bypass
- [ ] Message manipulation
- [ ] Cross-site WebSocket hijacking

---

## Tools
- Burp Suite Pro
- ffuf (fuzzing)
- nuclei (templates)
- sqlmap (SQLi)
- Gopherus (SSRF)
- 403bypasser

## Wordlists
- `cyspadSniper.txt` (sensitive paths)
- SecLists
- PayloadsAllTheThings

## References
- https://book.hacktricks.xyz
- https://portswigger.net/web-security
- https://owasp.org/www-project-web-security-testing-guide/
