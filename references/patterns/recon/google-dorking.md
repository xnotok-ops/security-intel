# Google Dorking — Recon Dork Checklist (95 dorks)

> Source: claude.ai/public/artifacts/854f3634-3edd-48bb-9f30-53edee35f705
> Use during Phase 1 Intel. Replace {target} with target domain (e.g. backpack.exchange).

---

## 1. Exposed Files & Docs (18 dorks)

> HackerOne hunters found confidential docs (NDAs, reports, contracts) on S3 via these. DoD disclosures confirmed.

```
# Config/Env files
site:{target} ext:log | ext:txt | ext:conf | ext:cnf | ext:ini | ext:env | ext:sh | ext:bak | ext:backup | ext:swp | ext:old | ext:git | ext:svn | ext:htpasswd | ext:htaccess | ext:json

# Office docs (Word/PPT/XLS/PDF)
site:{target} ext:doc | ext:docx | ext:pdf | ext:odt | ext:rtf | ext:ppt | ext:pptx | ext:pps | ext:csv | ext:xls | ext:xlsx

# Confidential / internal labels
site:{target} intitle:"confidential" | intitle:"internal use only" | intitle:"do not share" | intitle:"restricted"

# S3 buckets - confidential/top secret
site:s3.amazonaws.com "{target}" confidential | "top secret" | classified | undisclosed

# NDA & contract docs
site:{target} filetype:pdf intitle:"nda" | intitle:"non-disclosure" | intitle:"agreement" | intitle:"contract"

# Exposed Excel spreadsheets
site:{target} filetype:xls | filetype:xlsx intext:"password" | intext:"username" | intext:"confidential"

# Open directory listings
site:{target} intitle:"index of" inurl:/ "parent directory"

# XML / WSDL service files
site:{target} ext:xml | ext:wsdl | ext:wadl

# Private keys / certs
site:{target} ext:pem | ext:key | ext:crt | ext:cer | ext:p12 | ext:pfx

# SQL dumps
site:{target} ext:sql | ext:sql.gz | ext:dump intext:"INSERT INTO"
```

---

## 2. Credentials & Secrets (10 dorks)

> Bug hunters frequently find hardcoded API keys in GitHub repos and .env files indexed by Google. Highest-value category.

```
# Password files
site:{target} intext:"password" filetype:txt | filetype:log | filetype:env

# .env files with DB creds
site:{target} filetype:env intext:"DB_PASSWORD" | intext:"DB_USER" | intext:"APP_SECRET"

# API keys / tokens in JSON
site:{target} filetype:json intext:"api_key" | intext:"access_token" | intext:"secret_key" | intext:"client_secret"

# GitHub: API keys for target
"{target}" "api_key" | "apikey" | "api_secret" | "access_token" | "secret_key"

# GitHub: .env committed
"{target}" filename:.env "DB_PASSWORD" | "SECRET" | "API_KEY"

# GitHub: AWS keys
"{target}" "AKIA" "aws_access_key_id"

# Exposed htpasswd
site:{target} inurl:".htpasswd" | intext:"htpasswd"

# Connection strings
site:{target} intext:"connectionString" | intext:"jdbc:mysql" | intext:"mongodb://" | intext:"postgres://"

# FTP credentials
site:{target} intext:"ftp://" intext:"password"

# SSH private keys
"{target}" "BEGIN RSA PRIVATE KEY" | "BEGIN OPENSSH PRIVATE KEY"
```

---

## 3. Admin Panels & Login Pages (10 dorks)

> Hunters on HackerOne use these to find staging/UAT admin panels that are misconfigured or unprotected.

```
# Admin login panels
site:{target} inurl:admin | inurl:login | inurl:portal | inurl:dashboard inurl:admin

# Staging / dev environments
site:{target} inurl:staging | inurl:uat | inurl:test | inurl:dev | inurl:preprod | inurl:sandbox

# phpMyAdmin
site:{target} inurl:phpmyadmin | intitle:"phpMyAdmin" "Welcome to phpMyAdmin"

# Joomla / WordPress admin
site:{target} inurl:/wp-admin | inurl:/wp-login.php | inurl:/joomla/login | inurl:/administrator/index.php

# Jenkins / CI panels
site:{target} inurl:jenkins | intitle:"Dashboard [Jenkins]"

# Kibana / Grafana panels
site:{target} inurl:kibana | inurl:grafana | intitle:"Grafana" | intitle:"Kibana"

# Webmin / cPanel
site:{target} inurl:2082 | inurl:2083 | inurl:10000 intitle:"webmin"

# Exposed Swagger/API docs
site:{target} inurl:swagger | inurl:api-docs | intitle:"Swagger UI" | inurl:/api/v1

# Laravel debug mode
site:{target} intext:"Laravel" intitle:"Whoops!" | intitle:"ErrorException"

# Django admin exposed
site:{target} inurl:/admin/ intitle:"Django"
```

---

## 4. Error Messages & Stack Traces (6 dorks)

> Stack traces reveal tech stack, DB type, file paths and internal IPs — pivot into deeper recon.

```
# SQL errors
site:{target} inurl:"error" | intext:"database error" | intext:"SQL syntax" | intext:"mysql_fetch" | intext:"ORA-"

# Stack traces / exceptions
site:{target} intitle:"exception" | intitle:"failure" | intitle:"server at" | inurl:exception | intext:"unhandled exception" | intext:"stack trace"

# PHP warnings / errors
site:{target} intext:"undefined index" | intext:"Warning: include" | intext:"Parse error" | intext:"Notice: Undefined"

# IIS / ASP.NET errors
site:{target} intitle:"Server Error in" intext:"Application" intitle:"Runtime Error"

# 404/debug pages with paths
site:{target} intext:"Application root:" | intext:"Physical path:" | intitle:"404" intext:"/var/www"

# Java / Tomcat exceptions
site:{target} intitle:"Apache Tomcat" | intext:"java.lang.NullPointerException" | intext:"at org.apache"
```

---

## 5. Subdomain & Asset Discovery (8 dorks)

> HackerOne $1,500 bounty: hunter used multi-asterisk Google dorks to find staging subdomains not in any enumeration tool. Yandex indexes CIS infrastructure not found on Google.

```
# All subdomains
site:*.{target}

# Nested subdomains (multi-level)
site:*.*.{target}

# Dev/staging subdomains
site:*.{target} inurl:staging | inurl:dev | inurl:test | inurl:uat | inurl:preprod

# API subdomains
site:api.{target} | site:api2.{target} | site:v2.{target} | site:gateway.{target}

# Subdomains with admin paths
site:*.{target} inurl:admin | inurl:portal | inurl:dashboard | inurl:manage

# Yandex: CIS-indexed subdomains
site:{target} | site:*.{target}

# Cloud assets (S3, Azure, GCP)
site:*.s3.amazonaws.com "{target}" | site:*.blob.core.windows.net "{target}" | site:storage.googleapis.com "{target}"

# Old / archived subdomains
site:{target} inurl:old | inurl:legacy | inurl:backup | inurl:archive | inurl:deprecated
```

---

## 6. Open Redirects & SSRF Params (4 dorks)

> Hunters target redirect parameters to chain with OAuth flows or find SSRF vectors.

```
# Common redirect params
site:{target} inurl:redirect= | inurl:url= | inurl:next= | inurl:return= | inurl:redir=

# OAuth callback abuse
site:{target} inurl:callback= | inurl:redirect_uri= | inurl:return_url=

# SSRF-prone params
site:{target} inurl:fetch= | inurl:load= | inurl:path= | inurl:file= | inurl:uri=

# Proxy/forward params
site:{target} inurl:proxy= | inurl:forward= | inurl:dest= | inurl:target=
```

---

## 7. GitHub Code Leaks (19 dorks)

> GitHub dorking is one of the most high-yield techniques. AWS keys, internal API endpoints, and DB passwords found in committed code.

```
# API keys for target
"{target}.com" "api_key" | "apikey" | "api_secret" | "access_token"

# .env files committed
"{target}" filename:.env "SECRET" | "PASSWORD" | "KEY"

# Internal endpoints exposed
"{target}" "internal" | "staging" | "localhost" | "127.0.0.1" filename:*.js | filename:*.ts

# AWS credentials
"{target}" "AKIA" "aws_access_key_id" | "aws_secret_access_key"

# Firebase / GCP configs
"{target}" "firebase" "apiKey" | "databaseURL" | "storageBucket"

# Private Slack tokens
"{target}" "xoxp-" | "xoxb-" | "xoxa-"

# Stripe / payment keys
"{target}" "sk_live_" | "pk_live_" | "rk_live_"

# JWT secrets
"{target}" "jwt_secret" | "JWT_SECRET" | "jwt_key"

# Internal config / YAML
"{target}" filename:config.yml | filename:settings.py "password" | "secret"

# Private repo clues
org:{target} "internal" | "private" | "confidential" is:public
```

---

## 8. Yandex OSINT (CIS / Unique Indexed)

> Yandex indexes CIS infrastructure that Google misses — useful for targets with Russian/Eastern European infrastructure.

```
# CIS-specific subdomains
site:{target}

# Internal docs indexed by Yandex
site:{target} filetype:pdf | filetype:doc

# Staging environments
site:{target} inurl:test | inurl:dev | inurl:staging
```

---

## Quick Usage

**Google:**
```
site:backpack.exchange inurl:admin | inurl:dashboard
site:*.backpack.exchange inurl:staging | inurl:dev
site:backpack.exchange filetype:env intext:"DB_PASSWORD"
```

**GitHub:**
```
"backpack.exchange" "api_key" | "apikey" | "access_token"
"backpack.exchange" filename:.env "SECRET"
org:backpack-exchange "internal" | "private" is:public
```

**Tip:** Run Subdomain Discovery dorks first to expand attack surface, then run Credentials & Admin Panel dorks on each discovered subdomain.
