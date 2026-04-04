# TruffleHog Cheatsheet

Secret scanner dengan auto-verification. Detect 800+ credential types.

Repo: https://github.com/trufflesecurity/trufflehog

---

## Install

```bash
# Mac
brew install trufflehog

# Linux
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin

# Docker
docker pull trufflesecurity/trufflehog:latest
```

---

## Basic Scans

### GitHub Repo
```bash
# Verified secrets only
trufflehog git https://github.com/target/repo --results=verified

# All results (verified + unknown + unverified)
trufflehog git https://github.com/target/repo

# JSON output
trufflehog git https://github.com/target/repo --results=verified --json
```

### GitHub Org
```bash
trufflehog github --org=targetorg --results=verified

# With token (bypass rate limit)
trufflehog github --org=targetorg --token=ghp_xxx --results=verified

# Include issues & PRs
trufflehog github --repo=https://github.com/target/repo --issue-comments --pr-comments
```

### GitLab
```bash
trufflehog gitlab --token=glpat_xxx --repo=https://gitlab.com/target/repo
```

### Local Filesystem
```bash
# Single file
trufflehog filesystem path/to/file.txt

# Directory
trufflehog filesystem path/to/dir

# Multiple paths
trufflehog filesystem file1.txt file2.txt dir/
```

### Local Git Repo
```bash
git clone https://github.com/target/repo
trufflehog git file://repo --results=verified
```

---

## Cloud Storage

### S3
```bash
# Specific bucket
trufflehog s3 --bucket=bucket-name --results=verified

# With IAM role
trufflehog s3 --bucket=bucket-name --role-arn=arn:aws:iam::123456789:role/scanner

# Multiple buckets via role
trufflehog s3 --role-arn=arn:aws:iam::123456789:role/scanner
```

### GCS (Google Cloud Storage)
```bash
trufflehog gcs --project-id=my-project --cloud-environment --results=verified
```

---

## Docker Images
```bash
# Remote registry
trufflehog docker --image trufflesecurity/secrets --results=verified

# Local Docker daemon
trufflehog docker --image docker://myimage:tag --results=verified

# From tarball
trufflehog docker --image file://path_to_image.tar --results=verified
```

---

## CI/CD & Other Sources

### Jenkins
```bash
trufflehog jenkins --url https://jenkins.example.com --username admin --password admin
```

### Elasticsearch
```bash
# Local cluster
trufflehog elasticsearch --nodes 192.168.1.10 --username user --password pass

# Elastic Cloud
trufflehog elasticsearch --cloud-id 'prod:xxx' --api-key 'xxx'
```

### Postman
```bash
trufflehog postman --token=PMAK_xxx --workspace-id=workspace-id
```

### Hugging Face
```bash
trufflehog huggingface --model model_id --dataset dataset_id --space space_id
```

### Stdin (pipe)
```bash
aws s3 cp s3://bucket/data.gz - | gunzip -c | trufflehog stdin
cat secrets.txt | trufflehog stdin
```

---

## Advanced Options

### Result Types
```bash
--results=verified          # Only confirmed active credentials
--results=verified,unknown  # Verified + verification failed (network error)
--results=all               # Everything including unverified
```

### Filtering
```bash
# Include specific detectors
--include-detectors=aws,github,slack

# Exclude detectors
--exclude-detectors=generic

# Exclude paths
--exclude-paths=exclude.txt

# Filter by entropy (reduce false positives)
--filter-entropy=3.0
```

### Performance
```bash
# Concurrency
--concurrency=20

# Skip verification (faster but no live check)
--no-verification
```

### CI Integration
```bash
# Fail if secrets found (exit code 183)
trufflehog git file://. --since-commit main --branch feature-1 --results=verified --fail

# Scan specific commit range
trufflehog git file://. --since-commit abc123 --branch HEAD
```

---

## GitHub Hidden Commits (Experimental)

Scan deleted/hidden commits via Cross Fork Object References:

```bash
trufflehog github-experimental --repo https://github.com/target/repo.git --object-discovery
```

---

## Output Examples

### Verified Result
```
Found verified result 🐷🔑
Detector Type: AWS
Raw result: AKIAYVP4CIPPERUVIFXG
File: config/secrets.yml
Commit: fbc14303ffbf8fb1c2c1914e8dda7d0121633aca
```

### JSON Output
```json
{
  "DetectorType": "AWS",
  "Verified": true,
  "Raw": "AKIAYVP4CIPPERUVIFXG",
  "ExtraData": {
    "account": "595918472158",
    "arn": "arn:aws:iam::595918472158:user/leaked-user"
  }
}
```

---

## Bug Bounty Workflow

```bash
# 1. Recon - scan target's public repos
trufflehog github --org=targetcompany --results=verified --json > secrets.json

# 2. Check specific repo with all history
trufflehog git https://github.com/target/app --results=verified,unknown

# 3. Scan S3 if accessible
trufflehog s3 --bucket=target-public-bucket --results=verified

# 4. Scan Docker images
trufflehog docker --image target/app:latest --results=verified

# 5. Check deleted commits (alpha)
trufflehog github-experimental --repo https://github.com/target/app.git --object-discovery
```

---

## Ignore Secrets

Add comment in code to ignore:
```
API_KEY=sk_test_xxx  # trufflehog:ignore
```

---

## Comparison

| Tool | Verification | Detectors | Speed |
|------|--------------|-----------|-------|
| TruffleHog | ✅ Yes | 800+ | Medium |
| Gitleaks | ❌ No | 150+ | Fast |
| git-secrets | ❌ No | Custom | Fast |

**Use TruffleHog when:** You need to know if credentials are still LIVE.

---

*Last updated: April 2026*
