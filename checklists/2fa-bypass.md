# 2FA Bypass Techniques

## 1. Response Manipulation
```
1. Enter correct OTP → capture response
2. Enter wrong OTP → intercept response
3. Replace wrong response with correct response
```

## 2. Status Code Manipulation
```
If response is 4xx → change to 200 OK
```

## 3. Direct Endpoint Access
```
Skip 2FA page, access next endpoint directly:
site.com/login/otp_verification → site.com/login/dashboard
```

## 4. Referrer Header Bypass
```http
# Add referrer as if coming from 2FA page
Referer: https://site.com/2fa/verify
```

## 5. Client-Side Bypass
```javascript
// Check for JS functions in submit button
// Right-click → Inspect → look for checkOTP(event)
// Call function directly in console
```

## 6. IP Header Bypass
```http
X-Forwarded-For: 127.0.0.1
X-Originating-IP: 127.0.0.1
X-Remote-IP: 127.0.0.1
X-Remote-Addr: 127.0.0.1
X-Client-IP: 127.0.0.1
X-Host: 127.0.0.1
X-Forwared-Host: 127.0.0.1
```

## 7. Session Permission Mixing
```
1. Start login flow with YOUR account
2. Start login flow with VICTIM account (different browser)
3. Complete 2FA on YOUR account
4. Access victim's dashboard using victim's session
```

## 8. Token Reuse
```
Reuse previously used valid token
```

## 9. Token Sharing
```
Get token for your account, use it on another account
```

## 10. OTP Leak in Response
```
Check if OTP is returned in API response
```

## 11. Brute Force (No Rate Limit)
```
Use Burp Intruder with OTP range (000000-999999)
```

## 12. CSRF/Clickjacking to Disable 2FA
```
Check if disable 2FA endpoint has CSRF protection
```

## 13. Arbitrary Input
```
Try: null, 000000, 0, random strings, empty
```

## 14. Method Change
```
POST → GET
GET → POST
```

## References
- https://book.hacktricks.xyz/pentesting-web/2fa-bypass
