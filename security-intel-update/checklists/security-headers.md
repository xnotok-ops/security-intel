# Security Headers Checklist

## Critical Headers

### Strict-Transport-Security (HSTS)
```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```
- **Missing**: MITM attacks, SSL stripping
- **Test**: Check if HTTP redirects to HTTPS
- **Severity**: High

### Content-Security-Policy (CSP)
```http
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self'
```
- **Missing**: XSS attacks, content injection
- **Weak**: `unsafe-inline`, `unsafe-eval`, `*` wildcards
- **Test**: Check for violations with `Content-Security-Policy-Report-Only`
- **Severity**: High

### X-Frame-Options
```http
X-Frame-Options: DENY
X-Frame-Options: SAMEORIGIN
```
- **Missing**: Clickjacking
- **Note**: Superseded by CSP `frame-ancestors`
- **Severity**: Medium

### X-Content-Type-Options
```http
X-Content-Type-Options: nosniff
```
- **Missing**: MIME-type sniffing attacks
- **Severity**: Medium

---

## Important Headers

### X-XSS-Protection
```http
X-XSS-Protection: 1; mode=block
```
- **Note**: Deprecated in modern browsers, CSP preferred
- **Legacy browsers**: Still useful
- **Severity**: Low

### Referrer-Policy
```http
Referrer-Policy: strict-origin-when-cross-origin
Referrer-Policy: no-referrer
```
- **Missing**: Leaking URLs/parameters to third parties
- **Values**: no-referrer, no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin
- **Severity**: Low-Medium

### Permissions-Policy (Feature-Policy)
```http
Permissions-Policy: geolocation=(), camera=(), microphone=()
```
- **Missing**: Unauthorized feature access
- **Features**: accelerometer, camera, geolocation, gyroscope, magnetometer, microphone, payment, usb
- **Severity**: Low

---

## CORS Headers

### Access-Control-Allow-Origin
```http
Access-Control-Allow-Origin: https://trusted.com
```
- **Vulnerability**: `*` with credentials, origin reflection
- **Check**: `Access-Control-Allow-Credentials: true` with wildcard origin

### Misconfigured CORS Tests
```bash
# Test origin reflection
curl -H "Origin: https://evil.com" -I https://target.com/api/

# Test null origin
curl -H "Origin: null" -I https://target.com/api/

# Check reflected origin
```

---

## Cookie Security Attributes

### Secure Flag
```http
Set-Cookie: session=abc123; Secure
```
- **Missing**: Cookie sent over HTTP

### HttpOnly Flag
```http
Set-Cookie: session=abc123; HttpOnly
```
- **Missing**: Accessible via JavaScript (XSS)

### SameSite Attribute
```http
Set-Cookie: session=abc123; SameSite=Strict
Set-Cookie: session=abc123; SameSite=Lax
```
- **Missing**: CSRF vulnerability
- **Values**: Strict, Lax, None (requires Secure)

### Path/Domain Scope
```http
Set-Cookie: session=abc123; Path=/app; Domain=example.com
```
- **Overly permissive**: Accessible to subdomains/paths

---

## TLS/SSL Headers

### Expect-CT
```http
Expect-CT: max-age=86400, enforce, report-uri="https://report.example.com"
```
- **Missing**: Misissued certificates not detected

### Public-Key-Pins (HPKP) - Deprecated
```http
Public-Key-Pins: pin-sha256="..."; max-age=5184000
```
- **Note**: Deprecated, use Certificate Transparency instead

---

## Cache Control

### Cache-Control
```http
Cache-Control: no-store, no-cache, must-revalidate, private
```
- **Sensitive pages**: Should not be cached
- **Check**: Authenticated content caching

### Pragma
```http
Pragma: no-cache
```
- **Note**: HTTP/1.0 backwards compatibility

---

## Information Disclosure Headers

### Server
```http
Server: nginx
```
- **Risk**: Version disclosure
- **Mitigation**: Remove or obfuscate

### X-Powered-By
```http
X-Powered-By: PHP/7.4.3
```
- **Risk**: Technology/version disclosure
- **Mitigation**: Remove completely

### X-AspNet-Version
```http
X-AspNet-Version: 4.0.30319
```
- **Risk**: Framework version disclosure
- **Mitigation**: Remove in web.config

---

## Testing Tools

### Online
- https://securityheaders.com
- https://observatory.mozilla.org
- https://csp-evaluator.withgoogle.com

### CLI
```bash
# curl
curl -I https://target.com

# nmap
nmap -p443 --script http-security-headers target.com

# nikto
nikto -h https://target.com
```

---

## Quick Audit Checklist

| Header | Expected | Severity |
|--------|----------|----------|
| Strict-Transport-Security | Present, max-age ≥ 1 year | High |
| Content-Security-Policy | Present, no unsafe-* | High |
| X-Frame-Options | DENY or SAMEORIGIN | Medium |
| X-Content-Type-Options | nosniff | Medium |
| Referrer-Policy | strict-origin-when-cross-origin | Low |
| Permissions-Policy | Restrict unused features | Low |
| Set-Cookie | Secure; HttpOnly; SameSite | High |
| Server | Removed or no version | Low |
| X-Powered-By | Removed | Low |

## References
- https://owasp.org/www-project-secure-headers/
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
- https://book.hacktricks.xyz/pentesting-web/cors-bypass
