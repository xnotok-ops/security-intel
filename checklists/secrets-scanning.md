# Secrets Scanning Checklist

> Checklist untuk hunting exposed secrets di Web/API targets

## Phase 1: Passive Recon

### JS File Analysis
- [ ] Collect all JS files from target
  ```bash
  # Using gau/waybackurls
  gau target.com | grep "\.js$" | sort -u > js_files.txt
  
  # Using katana
  katana -u https://target.com -jc -d 3 | grep "\.js$"
  ```

- [ ] Download and analyze with jsluice
  ```bash
  # Extract URLs
  cat js_files.txt | while read url; do
    curl -s "$url" | jsluice urls
  done
  
  # Extract secrets
  cat js_files.txt | while read url; do
    curl -s "$url" | jsluice secrets
  done
  ```

- [ ] Manual grep for common patterns
  ```bash
  grep -rE "(api[_-]?key|api[_-]?secret|password|token|secret)" *.js
  grep -rE "AKIA[0-9A-Z]{16}" *.js  # AWS
  grep -rE "eyJ[A-Za-z0-9_-]*\\.eyJ" *.js  # JWT
  ```

### Source Maps
- [ ] Check for exposed source maps
  ```
  /app.js.map
  /main.js.map
  /bundle.js.map
  /webpack.js.map
  ```

- [ ] Extract original source from maps
  ```bash
  # Using sourcemapper
  sourcemapper -url https://target.com/app.js.map -output ./extracted
  ```

### .git Exposure
- [ ] Check for exposed .git
  ```
  /.git/
  /.git/HEAD
  /.git/config
  /.git/index
  ```

- [ ] Dump if exposed
  ```bash
  git-dumper https://target.com/.git/ ./git-dump
  cd git-dump && git log --oneline
  git diff HEAD~10  # Check recent changes
  ```

### Config Files
- [ ] Check common config paths
  ```
  /.env
  /.env.local
  /.env.production
  /config.json
  /config.yml
  /settings.py
  /application.properties
  /appsettings.json
  /web.config
  ```

---

## Phase 2: Framework-Specific Checks

### Run badsecrets
- [ ] Scan target URL
  ```bash
  badsecrets --url https://target.com/
  ```

- [ ] Check specific cookies/tokens manually
  ```bash
  # Flask cookie
  badsecrets "eyJoZWxsbyI6IndvcmxkIn0.XDtqeQ.1qsBdjyRJLokwRzJdzXMVCSyRTA"
  
  # JWT
  badsecrets "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0In0.xxx"
  
  # ASP.NET ViewState
  badsecrets "AgF5WuyVO11CsYJ1K5rjyuLXqUGCITSOapG1cYNiriYQ6VTKochMpn8ws4eJRvft81nQIA==" "EDD8C9AE"
  ```

### Framework Detection Hints

| Framework | Indicators |
|-----------|------------|
| Flask | `session=eyJ...` cookie, Werkzeug errors |
| Django | `csrftoken`, `sessionid` cookies |
| Rails | `_session_id`, `_app_session` cookies |
| ASP.NET | `__VIEWSTATE`, `.aspx` extensions |
| Laravel | `laravel_session`, `XSRF-TOKEN` cookies |
| Express | `connect.sid`, `s%3A...` cookies |
| Symfony | `_fragment` URLs, `PHPSESSID` |
| Spring | `JSESSIONID`, `/actuator` endpoints |

---

## Phase 3: GitHub/Git Intelligence

### GitHub Dorking
- [ ] Search org repos
  ```
  org:targetcompany password
  org:targetcompany secret
  org:targetcompany api_key
  org:targetcompany AWS_ACCESS_KEY
  org:targetcompany PRIVATE KEY
  ```

- [ ] Search by domain
  ```
  "target.com" password
  "target.com" api_key
  "target.com" secret
  ```

- [ ] Search commits
  ```
  org:targetcompany "removed password"
  org:targetcompany "deleted secret"
  org:targetcompany "oops"
  ```

### TruffleHog Scan
- [ ] Scan public repos
  ```bash
  trufflehog git https://github.com/targetcompany/repo --only-verified
  ```

### Gitleaks Scan
- [ ] Scan cloned repos
  ```bash
  git clone https://github.com/targetcompany/repo
  gitleaks detect -s ./repo -v
  ```

---

## Phase 4: Cloud Metadata & Misconfigs

### AWS
- [ ] S3 bucket enumeration
  ```bash
  # Check for public buckets
  aws s3 ls s3://targetcompany --no-sign-request
  aws s3 ls s3://targetcompany-prod --no-sign-request
  aws s3 ls s3://targetcompany-backup --no-sign-request
  ```

- [ ] Check for exposed credentials in buckets

### Firebase
- [ ] Check for open Firebase
  ```
  https://targetcompany.firebaseio.com/.json
  https://targetcompany-prod.firebaseio.com/.json
  ```

---

## Phase 5: Validation

### KeyHacks Validation
- [ ] Validate discovered keys
  ```bash
  # AWS - check if valid
  aws sts get-caller-identity --access-key-id AKIAXXXXXXXX --secret-access-key xxxxx
  
  # GitHub token
  curl -H "Authorization: token ghp_xxxxx" https://api.github.com/user
  
  # Slack token
  curl -X POST https://slack.com/api/auth.test -H "Authorization: Bearer xoxb-xxxxx"
  
  # Stripe
  curl https://api.stripe.com/v1/charges -u sk_live_xxxxx:
  ```

- [ ] Reference: https://github.com/streaak/keyhacks

---

## Quick Commands Reference

```bash
# One-liner: Collect JS and scan for secrets
gau target.com | grep "\.js$" | httpx -silent | while read url; do curl -s "$url" | jsluice secrets; done

# Scan with badsecrets
badsecrets --url https://target.com/ --proxy http://127.0.0.1:8080

# Git dump + scan
git-dumper https://target.com/.git/ ./dump && gitleaks detect -s ./dump

# TruffleHog quick scan
trufflehog git https://github.com/target/repo --json | jq '.Raw'
```

---

## Tools Required

| Tool | Install | Purpose |
|------|---------|---------|
| badsecrets | `pip install badsecrets` | Framework secrets |
| jsluice | `go install github.com/BishopFox/jsluice/cmd/jsluice@latest` | JS analysis |
| git-dumper | `pip install git-dumper` | .git dump |
| trufflehog | `brew install trufflehog` | Git secrets scan |
| gitleaks | `brew install gitleaks` | Git secrets scan |
| gau | `go install github.com/lc/gau/v2/cmd/gau@latest` | URL collection |

---

## Impact Examples

| Secret Type | Potential Impact |
|-------------|------------------|
| AWS Keys | Full AWS account access, data breach |
| Database creds | Data breach, data manipulation |
| API Keys | Account takeover, billing abuse |
| JWT Secret | Auth bypass, privilege escalation |
| Framework Secret | Session forgery, RCE (deserialize) |
| Private Keys | Impersonation, decrypt traffic |
