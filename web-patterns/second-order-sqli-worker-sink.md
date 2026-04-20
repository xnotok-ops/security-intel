# Second-Order SQL Injection via Background Worker Sink

## Bug Class

Delayed SQL injection where malicious payload is:
1. Submitted via API endpoint (seemingly "safe" field — category,
   enum, tag, status)
2. Stored in DB without validation (dev assumption: "it's just a
   category, only enum values come through")
3. Later read by background worker / cron / notification job
4. Constructed into SQL query via unsafe string formatting
5. Executes in elevated worker context (often DB admin-level)

Time gap between submit and execute breaks standard SAST input→sink
pattern matching. Classical signature-based WAFs also miss it — input
at submit time is benign ("looks like a category string").

## Canonical Case

**CVE-2026-40871** — Mailcow Second-Order SQLi via `quarantine_category`
- Vector: `/api/v1/add/mailbox` accepts arbitrary `quarantine_category`
- Storage: DB stores value unchanged (no validation)
- Sink: `quarantine_notify.py` line ~79 uses Python `%` formatting
- Trigger: Quarantine event fires notification job
- Impact: UNION SELECT exfils admin credentials via email
- Severity: High

Stored payload example:
`reject\") UNION SELECT username,1,password,1.0,username,NOW(),\"pwned\" FROM admin-- -`

## Universal Grep Signals

### Python (Mailcow anti-pattern)
```python
# VULN — % formatting
cursor.execute("SELECT ... WHERE field = '%s'" % db_value)
# VULN — f-string
cursor.execute(f"SELECT ... WHERE field = '{db_value}'")
# SAFE — parameterized
cursor.execute("SELECT ... WHERE field = %s", (db_value,))
```

### PHP
```php
// VULN — concat from prior SELECT result
$query = "SELECT ... WHERE x = '" . $row['user_field'] . "'";
```

### Node.js
```js
// VULN — template literal
db.query(`SELECT ... WHERE x = '${dbResult.field}'`)
```

## Recon Methodology

1. List all background workers / cron jobs / scheduled tasks in repo
   - Python: `*notify*.py`, `*cron*`, `*worker*`, `*scheduled*`,
     `*job*`, `*queue*`
   - Node: check `bullmq`, `agenda`, `node-cron` handlers
   - PHP: check `artisan schedule`, custom cron scripts
   - Language-agnostic: systemd timers, supervisor configs
2. For each worker: identify DB fields it reads
3. Trace upstream: which API endpoints write those fields?
4. Check validation on API input for those fields (often missing
   for "safe"/category-looking fields)
5. Verify query construction in worker — parameterized vs string
   format
6. PoC: inject benign marker (e.g., `'-- test_{uuid}`) into field
   via API, wait for job execution window, confirm exec via:
   - DB-level log analysis (if accessible)
   - Timing-based blind injection (`SLEEP()` / `pg_sleep()`)
   - Output side channel (email, webhook, log file)

## Severity Calibration

- Admin cred exfil via email / output channel → High/Critical
- Read-only data exposure → High
- Blind exec only (no readback) → Medium (if verified via timing
  or side channel)
- Theoretical only (no confirmed exec path) → Low/Info

## High-Value Target Classes

- Mail servers (Mailcow, iRedMail, Mailu, Zimbra)
- Admin panels with notification systems
- Ticketing / CRM (stored workflow fields, SLA rules)
- Monitoring dashboards (alert rules, webhook configs)
- Queue processors (Celery, Sidekiq, BullMQ workers)
- Audit log processors (stored log entries read later)
- Reporting schedulers (stored report configs)

## Bypass Value

- SAST tools miss due to temporal separation
- WAFs miss at input time (payload looks benign)
- First-order injection tests alone miss this class
- Often OOS-exclusion claim ("not user-controlled in SQL context")
  can be countered by showing full attack chain

## Source

CVE-2026-40871 disclosure:
https://github.com/lukehebe/Vulnerability-Disclosures/blob/main/CVE-2026-40871.md
