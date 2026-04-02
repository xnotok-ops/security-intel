# Secrets Detection Patterns

## Quick Reference - What to Look For

### API Keys & Tokens Regex
```regex
# AWS
AKIA[0-9A-Z]{16}
[A-Za-z0-9/+=]{40}  # AWS Secret Key (context needed)

# Google
AIza[0-9A-Za-z\-_]{35}
[0-9]+-[0-9A-Za-z_]{32}\.apps\.googleusercontent\.com

# GitHub
gh[pousr]_[A-Za-z0-9_]{36,}
github_pat_[A-Za-z0-9_]{22,}

# Slack
xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24}

# Stripe
sk_live_[0-9a-zA-Z]{24}
pk_live_[0-9a-zA-Z]{24}
rk_live_[0-9a-zA-Z]{24}

# Twilio
SK[0-9a-fA-F]{32}
AC[a-zA-Z0-9_\-]{32}

# SendGrid
SG\.[a-zA-Z0-9]{22}\.[a-zA-Z0-9-_]{43}

# Mailgun
key-[0-9a-zA-Z]{32}

# Firebase
AAAA[A-Za-z0-9_-]{7}:[A-Za-z0-9_-]{140}

# Heroku
[h|H][e|E][r|R][o|O][k|K][u|U].{0,30}[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}

# Generic API Key patterns
[aA][pP][iI]_?[kK][eE][yY].{0,30}['"][0-9a-zA-Z]{32,}['"]
[aA][pP][iI]_?[sS][eE][cC][rR][eE][tT].{0,30}['"][0-9a-zA-Z]{32,}['"]
```

### Private Keys
```regex
# RSA Private Key
-----BEGIN RSA PRIVATE KEY-----
-----BEGIN OPENSSH PRIVATE KEY-----
-----BEGIN DSA PRIVATE KEY-----
-----BEGIN EC PRIVATE KEY-----
-----BEGIN PGP PRIVATE KEY BLOCK-----

# Generic Private Key
-----BEGIN PRIVATE KEY-----
```

### JWT Patterns
```regex
eyJ[A-Za-z0-9_-]*\.eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*
```

### Database Connection Strings
```regex
# MongoDB
mongodb(\+srv)?://[^\s"']+

# PostgreSQL
postgres(ql)?://[^\s"']+

# MySQL
mysql://[^\s"']+

# Redis
redis://[^\s"']+
```

### Cloud Credentials
```regex
# Azure
[a-zA-Z0-9+/]{86}==  # Storage Account Key

# Cloudflare
[A-Za-z0-9_-]{37}  # API Token (context needed)
```

---

## Framework-Specific Secrets (via badsecrets)

### Frameworks Detected by badsecrets

| Framework | Secret Type | Product Example |
|-----------|-------------|-----------------|
| **Flask** | SECRET_KEY | Signed cookies `eyJ...XDtqeQ.1qsB...` |
| **Django** | SECRET_KEY | Session cookies `.eJxV...1ojOrE:bfOk...` |
| **Rails** | secret_key_base | Encrypted cookies `dUEv...--7efe...` |
| **ASP.NET** | MachineKey | ViewState `AgF5W...` |
| **Laravel** | APP_KEY | laravel_session cookies |
| **Express.js** | Session secret | `s%3A...` signed cookies |
| **Symfony** | APP_SECRET | `_fragment` URLs with hash |
| **JWT** | HMAC/RSA key | `eyJhbGci...` |
| **Telerik** | HashKey/EncryptionKey | DialogHandler params |
| **Apache Shiro** | rememberMe key | Base64 AES encrypted cookie |
| **JSF** | ViewState key | Mojarra/MyFaces viewstate |
| **PeopleSoft** | PS_TOKEN | Signed tokens |

### Known Weak Secrets Database
```
# Flask common weak keys
secret
secretkey
dev
development
change_me
super-secret

# Django common weak keys
django-insecure-*
changeme
secretkey

# Rails common weak keys
secret_key_base (from generators)

# JWT common weak keys
secret
1234
password
your-256-bit-secret
```

---

## JS Analysis Patterns (via jsluice)

### URL Extraction Points
```javascript
// Direct assignments
document.location = "/path"
window.location.href = "/path"
location.assign("/path")
location.replace("/path")

// Fetch/XHR
fetch("/api/endpoint")
$.ajax({url: "/api"})
XMLHttpRequest.open("GET", "/api")

// Dynamic URLs
"/api/" + userId + "/profile"
`/api/${userId}/profile`
```

### Secrets in JS
```javascript
// Config objects
const config = {
    apiKey: "...",
    secretKey: "...",
    token: "..."
}

// Direct assignments
var API_KEY = "...";
let secret = "...";
const token = "...";
```

---

## Detection Commands

### badsecrets
```bash
# Check single product
badsecrets "eyJhbGciOiJIUzI1NiJ9..."

# Scan URL (auto-carve)
badsecrets --url https://target.com/

# With proxy
badsecrets --url https://target.com/ --proxy http://127.0.0.1:8080

# JSON output
badsecrets --json "token_here"
```

### jsluice
```bash
# Extract URLs from JS
cat app.js | jsluice urls

# Extract secrets
cat app.js | jsluice secrets

# Batch process
find . -name "*.js" -exec cat {} \; | jsluice urls
```

### TruffleHog
```bash
# Scan git repo
trufflehog git https://github.com/org/repo

# Scan filesystem
trufflehog filesystem /path/to/code

# Scan with verified only
trufflehog git https://github.com/org/repo --only-verified
```

### Gitleaks
```bash
# Scan repo
gitleaks detect -s /path/to/repo

# Scan with custom config
gitleaks detect -s /path/to/repo -c gitleaks.toml
```

### git-dumper
```bash
# Dump exposed .git
git-dumper https://target.com/.git/ ./output

# Then extract
cd output && git checkout -- .
```

---

## Resources

- secrets-patterns-db: https://github.com/mazen160/secrets-patterns-db
- badsecrets: https://github.com/blacklanternsecurity/badsecrets
- jsluice: https://github.com/BishopFox/jsluice
- TruffleHog: https://github.com/trufflesecurity/trufflehog
- Gitleaks: https://github.com/gitleaks/gitleaks
- KeyHacks: https://github.com/streaak/keyhacks
