# Subdomain Takeover Checklist

## Enumeration

### DNS Enumeration
```bash
# Subfinder
subfinder -d target.com -o subs.txt

# Amass
amass enum -d target.com -o subs.txt

# Sublist3r
sublist3r -d target.com -o subs.txt

# dnsrecon
dnsrecon -d target.com -t brt

# crt.sh (Certificate Transparency)
curl -s "https://crt.sh/?q=%25.target.com&output=json" | jq -r '.[].name_value' | sort -u
```

### DNS Records Check
```bash
# Check CNAME records
dig CNAME subdomain.target.com

# Check all records
dig ANY subdomain.target.com

# Mass DNS resolution
cat subs.txt | dnsx -a -cname -resp
```

---

## Vulnerable Services

### Cloud Providers

| Service | CNAME Pattern | Fingerprint |
|---------|---------------|-------------|
| AWS S3 | `*.s3.amazonaws.com` | NoSuchBucket |
| AWS CloudFront | `*.cloudfront.net` | Bad request, distribution not found |
| Azure Blob | `*.blob.core.windows.net` | ResourceNotFound |
| Azure Web | `*.azurewebsites.net` | 404 |
| Azure CDN | `*.azureedge.net` | 404 |
| Google Cloud | `*.storage.googleapis.com` | NoSuchBucket |

### Hosting/CDN

| Service | CNAME Pattern | Fingerprint |
|---------|---------------|-------------|
| GitHub Pages | `*.github.io` | 404, no such site |
| Heroku | `*.herokuapp.com` | No such app |
| Netlify | `*.netlify.app` | Not found |
| Vercel | `*.vercel.app` | 404 |
| Surge.sh | `*.surge.sh` | project not found |
| Pantheon | `*.pantheonsite.io` | 404 |
| Fastly | `*.fastly.net` | Fastly error |
| Ghost | `*.ghost.io` | 404 |

### SaaS Platforms

| Service | CNAME Pattern | Fingerprint |
|---------|---------------|-------------|
| Zendesk | `*.zendesk.com` | Help Center not found |
| HubSpot | `*.hs-sites.com` | 404 |
| Shopify | `*.myshopify.com` | Sorry, this shop is unavailable |
| Tumblr | `*.tumblr.com` | Not found |
| Unbounce | `*.unbouncepages.com` | The page you're looking for... |
| Desk | `*.desk.com` | Service not available |
| Freshdesk | `*.freshdesk.com` | Company not found |

---

## Detection Methods

### Check for Dangling CNAME
```bash
# CNAME exists but target doesn't resolve
dig CNAME sub.target.com
# Returns: sub.target.com CNAME something.service.com
# Then:
dig A something.service.com
# Returns: NXDOMAIN or service-specific error
```

### HTTP Response Analysis
```bash
# Check for error pages
curl -I https://sub.target.com 2>/dev/null | head -5

# Check body for fingerprints
curl -s https://sub.target.com | grep -i "not found\|doesn't exist\|no such"
```

### Automated Tools
```bash
# Subjack
subjack -w subs.txt -t 100 -timeout 30 -ssl -c fingerprints.json -v

# Nuclei
nuclei -l subs.txt -t takeovers/

# tko-subs
tko-subs -domains subs.txt -data providers-data.csv

# SubOver
SubOver -l subs.txt
```

---

## Takeover Process

### AWS S3
1. Identify CNAME pointing to S3 bucket
2. Bucket name from CNAME (e.g., `bucket.s3.amazonaws.com`)
3. Create bucket with same name in your AWS account
4. Upload `index.html` as proof

### GitHub Pages
1. Identify CNAME pointing to `*.github.io`
2. Create repo with matching name
3. Enable GitHub Pages
4. Create `CNAME` file with target subdomain

### Heroku
1. Identify CNAME pointing to `*.herokuapp.com`
2. Create Heroku app with matching name
3. Deploy proof of concept

### Azure (Web Apps)
1. Identify CNAME pointing to `*.azurewebsites.net`
2. Create App Service with matching name
3. Add custom domain

---

## Verification

### Safe PoC
```html
<!-- Create simple HTML page as proof -->
<html>
<head><title>Subdomain Takeover PoC</title></head>
<body>
<h1>Security Researcher</h1>
<p>This subdomain was vulnerable to takeover.</p>
<p>Contact: your@email.com</p>
</body>
</html>
```

### Document Evidence
- Screenshot of error page (before)
- CNAME record proof
- Screenshot of controlled page (after)
- Steps to reproduce

---

## Prevention

### For Asset Owners
- [ ] Regular subdomain auditing
- [ ] Remove unused DNS records
- [ ] Monitor for dangling CNAMEs
- [ ] Decommission resources properly
- [ ] Use DNS monitoring services

### Automated Monitoring
```bash
# Cron job to check weekly
0 0 * * 0 /path/to/subjack -w domains.txt -c fingerprints.json > /tmp/takeover-check.txt
```

---

## Wildcard DNS Risks

```bash
# Check for wildcard
dig A random-nonexistent.target.com

# If it resolves, wildcard is present
# Every non-existent subdomain points to same IP
```

---

## References
- https://github.com/EdOverflow/can-i-take-over-xyz
- https://book.hacktricks.xyz/pentesting-web/domain-subdomain-takeover
- https://0xpatrik.com/subdomain-takeover-basics/
