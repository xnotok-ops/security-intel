# Arjun — HTTP Parameter Discovery

> Source: github.com/s0md3v/Arjun
> Use during Phase 2 before manual testing. Run on all API endpoints to find hidden/undocumented parameters.

---

## What It Does

Brute-forces 25,890 parameter names against a target endpoint in ~50-60 requests (<10 seconds). Detects valid parameters by analyzing response differences.

**Why it matters for bug bounty:**
- Hidden params = undocumented attack surface
- `?admin=true`, `?debug=1`, `?role=superuser` → privilege escalation
- `?user_id=X` → IDOR
- `?verbose=1` → info disclosure
- Undocumented params often skip validation → business logic bypass

---

## Install

```bash
pipx install arjun
# or
pip install arjun --break-system-packages
```

---

## Core Commands

### Basic Scan
```bash
# GET request (default)
arjun -u https://api.target.com/v1/users

# POST request
arjun -u https://api.target.com/v1/users -m POST

# POST JSON
arjun -u https://api.target.com/v1/users -m JSON

# POST XML
arjun -u https://api.target.com/v1/users -m XML
```

### With Authentication
```bash
# Bearer token
arjun -u https://api.target.com/v1/users \
  --headers "Authorization: Bearer YOUR_TOKEN"

# Multiple headers
arjun -u https://api.target.com/v1/users \
  --headers "Authorization: Bearer TOKEN
Cookie: session=ABC123"

# Include fixed body params (for POST)
arjun -u https://api.target.com/v1/users -m JSON \
  --include '{"user_id": "123"}'
```

### Output Options
```bash
# JSON output
arjun -u https://api.target.com/v1/users -o results.json

# Text output
arjun -u https://api.target.com/v1/users -oT results.txt

# Send to Burp (then test manually)
arjun -u https://api.target.com/v1/users -oB
arjun -u https://api.target.com/v1/users -oB 127.0.0.1:8080
```

### Multiple Targets
```bash
# From file (one URL per line)
arjun -i targets.txt

# Import from Burp export
arjun -i burp_export.xml
```

### Performance Tuning
```bash
# Slow down for rate-limited targets
arjun -u https://api.target.com/v1/users -d 1 --rate-limit 10

# More stable (slower but fewer false positives)
arjun -u https://api.target.com/v1/users --stable

# Custom chunk size (params per request)
arjun -u https://api.target.com/v1/users -c 100
```

### Passive Mode (No Active Requests)
```bash
# Collect params from Wayback Machine, CommonCrawl, OTX
arjun -u https://target.com --passive
```

---

## Bug Bounty Workflow Integration

### Phase 2 — Before Manual Testing
```bash
# 1. List all API endpoints from JS analysis or Burp
cat endpoints.txt

# 2. Run Arjun on each endpoint with auth
arjun -i endpoints.txt \
  --headers "Authorization: Bearer TOKEN" \
  -o arjun-results.json \
  --stable

# 3. Review found params, test manually in Burp
```

### High-Value Param Patterns to Test After Discovery
```
admin, is_admin, role, privilege, level     → privilege escalation
user_id, account_id, uid, owner_id          → IDOR
debug, verbose, test, dev, internal         → info disclosure
callback, redirect, url, next, return       → open redirect / SSRF
format, output, type, response_type         → content type manipulation
token, key, secret, api_key                 → credential exposure
limit, offset, page, per_page               → business logic (negative values)
```

### Crypto Exchange Specific
```
# Order/trade endpoints
arjun -u https://api.exchange.com/v1/order -m JSON \
  --headers "Authorization: Bearer TOKEN" \
  --include '{"symbol": "BTC-USDT"}'

# User/account endpoints  
arjun -u https://api.exchange.com/v1/account \
  --headers "Authorization: Bearer TOKEN"

# Withdrawal endpoints (high value)
arjun -u https://api.exchange.com/v1/withdraw -m JSON \
  --headers "Authorization: Bearer TOKEN"
```

---

## Tips

**Combine with passive first:**
```bash
# Get params from historical data without touching target
arjun -u https://target.com --passive -o passive-params.json

# Then active scan with discovered params as starting point
```

**After finding hidden param — test for:**
1. IDOR — change param value to another user's ID
2. Privilege escalation — set `admin=true`, `role=admin`
3. Info disclosure — set `debug=true`, `verbose=1`
4. Business logic — set `price=0`, `quantity=-1`

**Rate limit aware:**
```bash
# Conservative for sensitive targets
arjun -u https://api.target.com/endpoint \
  -d 2 \
  --rate-limit 5 \
  --stable \
  --headers "Authorization: Bearer TOKEN"
```
