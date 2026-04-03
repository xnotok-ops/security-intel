# TLS/SSL Audit Checklist

## Protocol Version

### Required
- [ ] TLS 1.2 - Enabled
- [ ] TLS 1.3 - Enabled (preferred)

### Must Disable
- [ ] SSL 2.0 - Disabled
- [ ] SSL 3.0 - Disabled (POODLE)
- [ ] TLS 1.0 - Disabled
- [ ] TLS 1.1 - Disabled

---

## Cipher Suites

### Recommended (TLS 1.3)
```
TLS_AES_256_GCM_SHA384
TLS_CHACHA20_POLY1305_SHA256
TLS_AES_128_GCM_SHA256
```

### Recommended (TLS 1.2)
```
ECDHE-ECDSA-AES256-GCM-SHA384
ECDHE-RSA-AES256-GCM-SHA384
ECDHE-ECDSA-CHACHA20-POLY1305
ECDHE-RSA-CHACHA20-POLY1305
ECDHE-ECDSA-AES128-GCM-SHA256
ECDHE-RSA-AES128-GCM-SHA256
```

### Must Avoid
- [ ] NULL ciphers
- [ ] Export ciphers (EXPORT, EXP)
- [ ] DES / 3DES
- [ ] RC4
- [ ] MD5 signatures
- [ ] Anonymous Diffie-Hellman (ADH)
- [ ] Ciphers < 128 bits

---

## Certificate Validation

### Basic Checks
- [ ] Valid certificate (not expired)
- [ ] Certificate matches hostname
- [ ] Trusted CA in chain
- [ ] Complete certificate chain
- [ ] SHA-256 or higher signature
- [ ] Key size ≥ 2048 (RSA) or ≥ 256 (ECDSA)

### Advanced
- [ ] Certificate Transparency (CT) logs
- [ ] OCSP stapling enabled
- [ ] Valid revocation status (OCSP/CRL)
- [ ] No self-signed certificates

---

## Known Vulnerabilities

### Protocol Attacks
- [ ] **POODLE** - SSLv3 disabled
- [ ] **BEAST** - TLS 1.0 disabled or mitigated
- [ ] **CRIME** - Compression disabled
- [ ] **BREACH** - HTTP compression on sensitive responses
- [ ] **Heartbleed** - OpenSSL patched (CVE-2014-0160)
- [ ] **DROWN** - SSLv2 disabled everywhere
- [ ] **FREAK** - Export ciphers disabled
- [ ] **Logjam** - DH ≥ 2048 bits

### Implementation
- [ ] Secure renegotiation enabled
- [ ] Client-initiated renegotiation disabled
- [ ] Session resumption secure

---

## Forward Secrecy

- [ ] ECDHE cipher suites preferred
- [ ] DHE cipher suites with ≥ 2048 bit DH
- [ ] No static RSA key exchange

---

## Configuration

### HSTS
```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```
- [ ] HSTS header present
- [ ] max-age ≥ 1 year
- [ ] includeSubDomains (if applicable)

### Redirects
- [ ] HTTP → HTTPS redirect (301)
- [ ] No mixed content warnings
- [ ] No HTTP resources on HTTPS pages

---

## Testing Tools

### Online
```
https://www.ssllabs.com/ssltest/
https://observatory.mozilla.org
https://www.hardenize.com/
```

### CLI
```bash
# OpenSSL
openssl s_client -connect target.com:443 -tls1_2
openssl s_client -connect target.com:443 -tls1_3

# Nmap
nmap --script ssl-enum-ciphers -p 443 target.com
nmap --script ssl-cert -p 443 target.com

# testssl.sh
./testssl.sh target.com

# sslscan
sslscan target.com
```

---

## Quick Commands

### Check Certificate
```bash
echo | openssl s_client -connect target.com:443 2>/dev/null | openssl x509 -noout -dates
```

### Check Supported Protocols
```bash
for proto in ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3; do
  echo -n "$proto: "
  openssl s_client -connect target.com:443 -$proto < /dev/null 2>&1 | grep -q "Cipher is" && echo "YES" || echo "NO"
done
```

### Check Cipher Suites
```bash
nmap --script ssl-enum-ciphers -p 443 target.com | grep -A 20 "TLS"
```

### Check Heartbleed
```bash
nmap -p 443 --script ssl-heartbleed target.com
```

---

## Severity Ratings

| Issue | Severity |
|-------|----------|
| SSLv2/v3 enabled | Critical |
| TLS 1.0/1.1 enabled | High |
| Expired certificate | High |
| Self-signed certificate | Medium-High |
| Weak cipher suites | Medium |
| Missing HSTS | Medium |
| No forward secrecy | Medium |
| Certificate chain issues | Medium |
| Weak DH parameters | Medium |
| Missing OCSP stapling | Low |

## References
- https://ssl-config.mozilla.org/
- https://wiki.mozilla.org/Security/Server_Side_TLS
- https://book.hacktricks.xyz/pentesting-web/ssl-tls-vulnerabilities
