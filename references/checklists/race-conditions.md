# Race Conditions — Bug Bounty Patterns

> Source: PortSwigger Web Security Academy + real-world bug bounty context
> High value for crypto exchanges, DeFi platforms, payment flows.

---

## What Is It

Race conditions happen when an app processes concurrent requests without proper locking. Two threads interact with the same data simultaneously, causing unintended state transitions — the "race window."

Core concept: **TOCTOU (Time-of-Check to Time-of-Use)**
- App checks a condition (e.g. "has user used this coupon?")
- Between check and state update, another request slips through
- Both requests pass the check before either updates the state

---

## Attack Types

### 1. Limit Overrun (Most Common)

Bypass single-use or rate-limited controls by sending parallel requests during the race window.

**Classic targets:**
```
- Redeem promo/voucher code multiple times
- Withdraw funds exceeding balance
- Apply discount multiple times
- Bypass rate limiting on brute force
- Reuse single-use tokens (password reset, 2FA backup)
- Like/rate a post multiple times
- Claim referral bonus multiple times
```

**Crypto exchange specific:**
```
- Double withdrawal (request withdrawal twice simultaneously)
- Order placement race (place conflicting orders)
- Fee bypass via concurrent trades
- Balance check bypass on transfer
- Coupon/airdrop double-claim
```

### 2. Multi-Endpoint Race Conditions

Two different endpoints interact with shared state. Less obvious, harder to detect, higher severity.

**Example pattern:**
```
Thread A: POST /checkout (reads cart)
Thread B: POST /cart/add-item (modifies cart)
→ Checkout processes stale cart state
```

**Exchange example:**
```
Thread A: POST /order/place (reads balance)
Thread B: POST /withdraw (reduces balance)
→ Order placed with already-withdrawn funds
```

### 3. Single-Endpoint Race (Email/Token Collision)

Send two requests to same endpoint with different parameters — app processes both against shared state.

**Example:**
```
POST /account/update-email
→ Send request A (email_a@attacker.com)
→ Send request B (email_b@victim.com)
→ Token for email_a sent to email_b's session (or vice versa)
→ Account takeover
```

### 4. Partial Construction Race

Object created in multiple steps — attack during initialization window.

**Example:**
```
1. POST /api/token/create → token inserted with NULL permissions
2. Race window: token exists but permissions not yet set
3. Attacker uses token during this window → elevated access
```

### 5. Time-Sensitive Attacks

Predictable tokens generated using timestamp — race to enumerate within same second.

```
- Password reset tokens based on timestamp
- CAPTCHA tokens with short window
- Session tokens with low entropy + timestamp seed
```

---

## Methodology (3 Steps)

### Step 1 — Predict Potential Collisions

Look for endpoints that:
- Read → then write shared state (TOCTOU pattern)
- Enforce limits (rate limits, single-use, balance checks)
- Handle financial transactions
- Generate tokens/codes used elsewhere
- Update shared resources (cart, profile, order)

Ask: "What happens if this request runs twice simultaneously?"

### Step 2 — Probe for Clues

Send 20-30 parallel requests, look for:
```
- Inconsistent responses (some 200, some 400 for same request)
- Unexpected state changes
- Different response times on identical requests
- Error messages leaking internal state
- Duplicate entries in DB (if visible)
```

### Step 3 — Prove the Concept

Reproduce with minimum requests needed:
```
- 2 requests for limit overrun
- Timed carefully to hit race window
- Document response differences
- Show concrete impact (funds, access, etc.)
```

---

## Tools & Techniques

### Burp Suite — Single-Packet Attack (HTTP/2)

Best method — sends 20-30 requests in one TCP packet, neutralizes network jitter.

```
1. Capture request in Burp Proxy
2. Send to Repeater
3. Duplicate tab (Ctrl+R) × 20
4. Group tabs: right-click → "Add to group"
5. Send group → "Send group in parallel (single-packet attack)"
6. Analyze responses
```

**HTTP/1 fallback:** last-byte synchronization (Burp handles automatically)

### Turbo Intruder (Burp Extension)

For more control over timing and number of requests:

```python
def queueRequests(target, wordlists):
    engine = RequestEngine(endpoint=target.endpoint,
                           concurrentConnections=30,
                           requestsPerConnection=100,
                           pipeline=False)
    for i in range(30):
        engine.queue(target.req)

def handleResponse(req, interesting):
    table.add(req)
```

### Python Script (no Burp)

```python
import requests
import threading

TARGET = "https://target.com/api/redeem"
HEADERS = {"Authorization": "Bearer YOUR_TOKEN"}
PAYLOAD = {"code": "PROMO2026"}

def send_request():
    r = requests.post(TARGET, json=PAYLOAD, headers=HEADERS)
    print(r.status_code, r.text[:100])

threads = []
for _ in range(20):
    t = threading.Thread(target=send_request)
    threads.append(t)

# Start all simultaneously
for t in threads:
    t.start()

for t in threads:
    t.join()
```

### Connection Warming (Multi-Endpoint)

For multi-endpoint races, pre-warm connections to reduce timing gap:

```
1. Send dummy request to endpoint first (warms TCP connection)
2. Immediately send actual race requests
3. Reduces latency variance between endpoints
```

---

## High-Value Targets in Bug Bounty

| Target Type | Race Vector | Severity |
|-------------|-------------|----------|
| Crypto exchange | Double withdrawal | Critical |
| Crypto exchange | Order race / balance bypass | High-Critical |
| Payment platform | Coupon/promo double-claim | High |
| Payment platform | Refund + purchase race | High |
| Auth flow | Password reset token collision | High |
| Auth flow | 2FA bypass via parallel requests | High |
| E-commerce | Gift card double redemption | Medium-High |
| API | Rate limit bypass | Medium |
| Referral system | Bonus double-claim | Medium |

---

## Scope Check Before Submitting

Race conditions are tricky to scope — watch out for:

- **"DoS is OOS"** — race that causes data corruption could be framed as DoS, clarify impact is financial/data integrity
- **"Requires multiple accounts"** — some programs consider this reduced severity
- **Timing dependency** — if race window is microseconds and requires perfect timing, programs may rate it lower
- **Production risk** — some programs want you to test on staging only for financial endpoints

**Frame the impact clearly:** "Attacker can withdraw $X more than their balance" is Critical. "Attacker can apply discount twice" is Medium-High.

---

## Quick Checklist

```
[ ] Any endpoint with "single-use", "one-time", "rate-limited" in behavior?
[ ] Financial transactions (withdraw, transfer, purchase)?
[ ] Promo/coupon/voucher redemption?
[ ] Token generation (password reset, 2FA, invite codes)?
[ ] Multi-step flows with shared state (checkout, order, KYC)?
[ ] Parallel requests yield different responses?
[ ] Can reproduce impact with 2 simultaneous requests?
```
