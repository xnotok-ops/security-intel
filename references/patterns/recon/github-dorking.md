# GitHub Dorking — Exposed Secrets Recon

> Source: @hackinarticles (X/Twitter)
> Use during Phase 1 Intel before testing any target with public GitHub repos.

---

## Workflow

```bash
# 1. Identify target org repos
gh api "orgs/TARGET/repos" | jq '.[].name'

# 2. Auto-scan with TruffleHog (verified secrets only)
trufflehog github --org=TARGET --only-verified

# 3. Manual dorks via GitHub search UI or API
# github.com/search?q=org:TARGET+DORK&type=code
```

**If found + active credential = instant Critical. No long PoC needed.**
Screenshot + verify API call = sufficient.

---

## 1. Finding Passwords

```
org:target filename:.env password
org:target "DB_PASSWORD"
org:target picarto tracker tokens
org:target PT_TOKEN language:bash
org:target "FPT_TOKEN" language:bash
org:target Amazon RDS possible credentials
org:target r2s.amazonaws.com.password
org:target possible salesforce credentials
org:target "SF_USERNAME" salesforce
org:target Shodan API keys
org:target shodan_api_key language:python
org:target Slack bot and private tokens
org:target soap OR wsdl
org:target "[WPClient_Password]" exceptions
```

---

## 2. Finding API Keys & Tokens

```
JEKYLL_GITHUB_TOKEN
HOMEBREW_GITHUB_API_TOKEN language:shell
HEROKU_API_KEY language:json
HEROKU_API_KEY language:json.pem
HEROKU_API_KEY language:json
VLAB Needed MongoDB Credentials
riak.com password
"https://hooks.slack.com/services/"
Telegram API token
"api_hash" "api_id"
```

**Firebase extension config:**
```
firebase-extension.js.config.json
Github tokens used for jekyll
Github tokens usually set by homebrew users
Heroku api keys
```

---

## 3. AWS / S3 Recon

```
org:Target "S3_ACCESS_KEY_ID"
org:Target "S3_BUCKET"
org:Target "S3_ENDPOINT"
org:Target "S3_SECRET_ACCESS_KEY"
org:Target "aws_secret_key"
org:Target "aws_access_key"
org:Target "list_aws_accounts"
org:Target "AWS_ACCESS_KEY_ID"
```

---

## 4. Finding by Extension

```
extension:pem private
extension:ppk private
extension:json .npmrc_auth
extension:yaml mongolab.com
mysql dump look for: password
extension:json google-access-token.client_secret
extension:json googleusercontent.com
extension:sql mysqldump
extension:yaml mongolab.com
extension:json api.forecast.io
```

**Specific targets:**
```
# MongoDB
extension:yaml mongolab.com
mongodb credentials in .config files (try with yml)
extension:yaml mongodb.com

# AWS via extension
extension:json aws_access_key_id

# Redis
Redis credentials provided by Redis Labs found in a JSON file
extension:json cloud.redislabs.com
```

---

## 5. Finding Sensitive Files (filename dorks)

### Auth & Credentials
```
filename:.netrc password
filename:id_rsa
filename:id_rsa OR filename:id_dsa
filename:.env DB_USERNAME NOT homestead
filename:.env MAIL_HOST=smtp.gmail.com
filename:credentials aws_access_key_id
```

### Config Files
```
filename:wp-config.php
filename:WebServers.xml
filename:ventrilo_srv.ini
filename:sshd_config
filename:shadow path:etc
filename:sftp-config.json
filename:sftp.json path:.vscode
filename:settings.py SECRET_KEY
filename:server.cfg rcon password
filename:.ftpconfig
filename:.esmtprc password
filename:dockercfg auth
filename:.bashrc mailchimp
filename:.bashrc password
filename:.bash_profile aws
filename:.cshrc
filename:.dockercfg auth
```

### Database
```
filename:robomongo.json
filename:pgpass
filename:connections.xml
filename:beaver-data-sources.xml
filename:deployment-config.json
```

### Keys & Tokens
```
filename:github-recovery-codes.txt
filename:gitlab-recovery-codes.txt
filename:hub.oauth_token
filename:idea14.key
filename:master.key path:config
filename:logins.json
filename:git-credentials
filename:discord_backup_codes.txt
filename:tugboat NOT .tugboat
filename:CCCam.cfg
filename:config.irc_pass
filename:config.json auths
filename:config.php dbpassword
filename:configuration.php JConfig password
```

### Shell History (goldmine)
```
filename:bash_history
filename:sh_history
filename:.history
```

### Server & Infra
```
filename:recentservers.xml Pass
filename:proftpdpasswd
filename:prod.secret.exs
filename:prod.exs NOT prod.secret.exs
filename:passwd path:etc
filename:dhcpd.conf
filename:.s3cfg
filename:remote-sync.json
filename:filezilla.xml Pass
filename:recentservers.xml Pass
filename:express.conf path:.openshift
```

---

## Severity Mapping

| Finding | Severity | Notes |
|---------|----------|-------|
| Active AWS key with S3/EC2 access | Critical | Direct cloud compromise |
| Active API key (Stripe, Twilio, etc) | Critical | Financial impact |
| Private key (`.pem`, `.ppk`) | Critical | System access |
| DB credentials (prod) | Critical | Data breach |
| DB credentials (dev/staging) | High | Depends on data |
| Expired/revoked token | Informative | Verify before submit |
| `.env` with placeholders only | N/A | Not a real finding |

---

## Verification Before Submitting

```bash
# AWS key - check if active
aws sts get-caller-identity --access-key-id AKIA... --secret-access-key ...

# Generic API key - try a read-only endpoint
curl -H "Authorization: Bearer TOKEN" https://api.target.com/me

# GitHub token
curl -H "Authorization: token ghp_..." https://api.github.com/user
```

**Always verify the credential is active before submitting.**
An expired key = Informative or NA, not Critical.

---

## Tools

| Tool | Command | Notes |
|------|---------|-------|
| TruffleHog | `trufflehog github --org=TARGET --only-verified` | Best for verified secrets |
| Gitleaks | `gitleaks detect --source . -v` | Local repo scan |
| GitLeaks (remote) | `gitleaks detect --repo-url https://github.com/TARGET/REPO` | Remote scan |
| gh CLI | `gh api "orgs/TARGET/repos"` | Enum repos first |
