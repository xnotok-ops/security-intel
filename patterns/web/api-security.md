# API Security Patterns

## Version Manipulation
```
/api/v3/endpoint → /api/v1/endpoint
/api/v3/endpoint → /api/v2/endpoint
/api/mobile/login → /api/v3/login
/api/internal/endpoint
```

## Verb Tampering
```
GET /api/users/1 → POST /api/users/1
GET /api/users/1 → PUT /api/users/1
GET /api/users/1 → DELETE /api/users/1
GET /api/users/1 → PATCH /api/users/1
GET /api/users/1 → HEAD /api/users/1
GET /api/users/1 → OPTIONS /api/users/1
GET /api/users/1 → JEFF /api/users/1  # arbitrary verb
```

## Object ID Manipulation
```bash
# Numeric vs UUID
GET /api/users/6b95d962-df38 → GET /api/users/1

# Array wrapping
{"id":111} → {"id":[111]}

# Object wrapping  
{"id":111} → {"id":{"id":111}}

# Wildcards
/api/users/1 → /api/users/*
/api/users/1 → /api/users/%
/api/users/1 → /api/users/_
/api/users/1 → /api/users/.

# Negative/boundary values
/api/users/1 → /api/users/-1
/api/users/1 → /api/users/0
/api/users/1 → /api/users/99999999
```

## Parameter Pollution
```bash
# HTTP Parameter Pollution
/api/profile?user_id=legit&user_id=victim
/api/profile?user_id=victim&user_id=legit

# JSON Parameter Pollution
{"user_id":"legit","user_id":"victim"}
{"user_id":"victim","user_id":"legit"}

# Array injection
username[]=John
username[$neq]=lalala
```

## Content-Type Switching
```bash
# Standard conversions
x-www-form-urlencoded → user=test
application/json      → {"user": "test"}
application/xml       → <user>test</user>

# Type confusion
{"username": "John"}
{"username": true}
{"username": null}
{"username": 1}
{"username": [true]}
{"username": ["John", true]}
{"username": {"$neq": "lalala"}}  # NoSQL injection
```

## Headers to Test
```
X-HTTP-Method-Override: PUT
X-Method-Override: DELETE
X-Original-URL: /admin
X-Rewrite-URL: /admin
```

## Quick Checks
1. Try Object IDs in HTTP headers and bodies (URLs more protected)
2. Check non-production envs: staging/qa (less secure)
3. Test old APK versions (apkpure.com)
4. Look for "Convert to PDF" features → Export Injection
5. Mobile vs Web APIs may differ - test separately

## References
- https://github.com/inonshk/31-days-of-API-Security-Tips
- https://book.hacktricks.xyz/pentesting/pentesting-web/api-pentesting
