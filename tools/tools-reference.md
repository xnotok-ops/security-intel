# Security Tools Reference

> Quick reference untuk tools yang sering dipakai di bug bounty workflow

## Secrets & JS Analysis

### badsecrets
**Purpose**: Detect known/weak crypto secrets across frameworks

```bash
# Install
pip install badsecrets

# Basic usage
badsecrets "eyJhbGciOiJIUzI1NiJ9..."  # Check single token
badsecrets --url https://target.com/   # Scan URL (auto-carve)
badsecrets --url https://target.com/ --proxy http://127.0.0.1:8080
badsecrets --json "token"              # JSON output

# Frameworks supported
# Flask, Django, Rails, ASP.NET, Laravel, Express, Symfony
# JWT, Telerik, JSF, Apache Shiro, PeopleSoft, Rack, Yii2
```

### jsluice
**Purpose**: Extract URLs, paths, secrets from JavaScript (tree-sitter based)

```bash
# Install
go install github.com/BishopFox/jsluice/cmd/jsluice@latest

# Usage
cat app.js | jsluice urls      # Extract URLs
cat app.js | jsluice secrets   # Extract secrets
cat app.js | jsluice strings   # Extract all strings

# Batch process
find . -name "*.js" -exec cat {} \; | jsluice urls
curl -s https://target.com/app.js | jsluice secrets
```

### TruffleHog
**Purpose**: Find secrets in git repos, filesystems, S3, etc.

```bash
# Install
brew install trufflehog
# or
pip install trufflehog

# Usage
trufflehog git https://github.com/org/repo
trufflehog git https://github.com/org/repo --only-verified
trufflehog filesystem /path/to/code
trufflehog s3 --bucket=mybucket

# JSON output
trufflehog git https://github.com/org/repo --json
```

### Gitleaks
**Purpose**: Fast git secrets scanning

```bash
# Install
brew install gitleaks
# or
go install github.com/gitleaks/gitleaks/v8@latest

# Usage
gitleaks detect -s /path/to/repo
gitleaks detect -s /path/to/repo -v     # Verbose
gitleaks detect -s /path/to/repo --report-format json --report-path report.json
```

### git-dumper
**Purpose**: Dump exposed .git directories

```bash
# Install
pip install git-dumper

# Usage
git-dumper https://target.com/.git/ ./output
cd output && git checkout -- .
git log --oneline
git diff HEAD~10
```

---

## Web Fuzzing & Recon

### ffuf
**Purpose**: Fast web fuzzer

```bash
# Install
go install github.com/ffuf/ffuf/v2@latest

# Basic fuzzing
ffuf -u https://target.com/FUZZ -w wordlist.txt

# With filters
ffuf -u https://target.com/FUZZ -w wordlist.txt -fc 404,403
ffuf -u https://target.com/FUZZ -w wordlist.txt -fs 0
ffuf -u https://target.com/FUZZ -w wordlist.txt -mc 200,301,302

# POST data fuzzing
ffuf -u https://target.com/api -X POST -d '{"id":"FUZZ"}' -w ids.txt

# Header fuzzing
ffuf -u https://target.com/api -H "X-Custom: FUZZ" -w wordlist.txt

# Multiple positions
ffuf -u https://target.com/FUZZ1/FUZZ2 -w users.txt:FUZZ1 -w ids.txt:FUZZ2

# Auto-calibration
ffuf -u https://target.com/FUZZ -w wordlist.txt -ac
```

### nuclei
**Purpose**: Vulnerability scanner with templates

```bash
# Install
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Usage
nuclei -u https://target.com
nuclei -u https://target.com -t cves/
nuclei -u https://target.com -t exposures/
nuclei -l urls.txt -t technologies/

# Custom templates
nuclei -u https://target.com -t /path/to/custom-template.yaml
```

### httpx
**Purpose**: Fast HTTP toolkit

```bash
# Install
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Usage
cat urls.txt | httpx -silent
cat urls.txt | httpx -title -status-code -content-length
cat urls.txt | httpx -tech-detect
echo "target.com" | httpx -probe
```

### gau (GetAllUrls)
**Purpose**: Fetch known URLs from various sources

```bash
# Install
go install github.com/lc/gau/v2/cmd/gau@latest

# Usage
gau target.com
gau target.com --subs    # Include subdomains
gau target.com | grep "\.js$"
```

### katana
**Purpose**: Web crawling

```bash
# Install
go install github.com/projectdiscovery/katana/cmd/katana@latest

# Usage
katana -u https://target.com
katana -u https://target.com -jc    # JavaScript crawl
katana -u https://target.com -d 5   # Depth 5
```

---

## Subdomain Enumeration

### subfinder
```bash
# Install
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Usage
subfinder -d target.com
subfinder -d target.com -all
subfinder -d target.com -o subs.txt
```

### amass
```bash
# Install
go install -v github.com/owasp-amass/amass/v4/...@master

# Usage
amass enum -d target.com
amass enum -d target.com -passive
```

---

## Proxy & Interception

### Burp Suite
- Intercept requests/responses
- Modify parameters
- Intruder for fuzzing
- Extensions: 403 Bypasser, AuthMatrix, etc.

### mitmproxy
```bash
# Install
pip install mitmproxy

# Usage
mitmproxy           # Interactive
mitmdump            # CLI
mitmweb             # Web interface
```

---

## Quick Install Script (macOS/Linux)

```bash
#!/bin/bash

# Go tools
go install github.com/BishopFox/jsluice/cmd/jsluice@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/gitleaks/gitleaks/v8@latest

# Python tools
pip install badsecrets
pip install git-dumper
pip install trufflehog

# Brew (macOS)
brew install trufflehog gitleaks

echo "Done! Make sure ~/go/bin is in your PATH"
```

---

## Windows Installation Notes

```powershell
# Go tools - same commands, ensure GOPATH/bin in PATH

# Python tools
pip install badsecrets git-dumper

# Chocolatey alternatives
choco install golang
choco install python

# Manual downloads
# ffuf: https://github.com/ffuf/ffuf/releases
# nuclei: https://github.com/projectdiscovery/nuclei/releases
```
