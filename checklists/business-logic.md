# Business Logic Vulnerabilities

## Price Manipulation

### Direct Tampering
- [ ] Change price: `100 → 1` or `100 → 0`
- [ ] Negative price: `100 → -100` (credit to account)
- [ ] Multiply by fraction: `price * 0.01`
- [ ] Integer overflow: very large number wraps to small

### Quantity Manipulation
- [ ] Negative quantity: `-1` item
- [ ] Zero quantity with positive total
- [ ] Quantity > available stock
- [ ] Fractional quantity: `0.001`

### Currency Arbitrage
- [ ] Pay in USD, refund in EUR (conversion rate diff)
- [ ] Change currency mid-transaction

---

## Coupon/Discount Abuse

- [ ] Reuse same coupon code multiple times
- [ ] Race condition: parallel requests with same coupon
- [ ] Apply coupon to non-discounted items
- [ ] Stack multiple coupons (Mass Assignment)
- [ ] HPP: `?coupon=CODE1&coupon=CODE2`
- [ ] Negative discount value
- [ ] Expired coupon still works

---

## Cart/Checkout Flow

### Cart Manipulation
- [ ] Add item in negative quantity
- [ ] Move items between user carts
- [ ] Modify cart after price lock
- [ ] Race condition on limited stock

### Checkout Bypass
- [ ] Skip payment step (direct URL access)
- [ ] Modify order after payment
- [ ] Cancel order, keep access/item
- [ ] Duplicate order submission

### Delivery Charges
- [ ] Tamper delivery charges to negative
- [ ] Free delivery by parameter manipulation
- [ ] Change delivery address post-payment

---

## Subscription/Premium Abuse

- [ ] Access premium features via forced browsing
- [ ] Cancel subscription, keep access
- [ ] Trial abuse (multiple accounts)
- [ ] Modify `isPremium: false → true` in request/cookie
- [ ] localStorage/cookie controls premium access
- [ ] Race condition on subscription cancellation (multiple refunds)

---

## Refund Abuse

- [ ] Refund + keep digital product/access
- [ ] Multiple refund requests (race condition)
- [ ] Partial refund manipulation
- [ ] Refund to different payment method

---

## Review/Rating Manipulation

- [ ] Post review without purchase
- [ ] Post as "Verified Buyer" without buying
- [ ] Rating outside valid range: `0`, `6`, `-1`
- [ ] Multiple reviews from same user
- [ ] Review as another user (IDOR)
- [ ] File upload in review (unrestricted)
- [ ] CSRF on review submission

---

## Authentication/Authorization Logic

### Session Issues
- [ ] Session not invalidated on logout
- [ ] Concurrent session abuse
- [ ] Session fixation
- [ ] Privilege retained after role change

### Role/Permission Bypass
- [ ] Parameter: `isAdmin=true`, `role=admin`
- [ ] Cookie/localStorage controls permissions
- [ ] Hidden fields control access level
- [ ] Change user ID to access other accounts

---

## Workflow Bypass

### Step Skipping
- [ ] Skip email verification
- [ ] Skip payment step
- [ ] Skip 2FA step
- [ ] Access step 3 without completing step 1-2

### Order of Operations
- [ ] Perform action before required validation
- [ ] Submit form before JS validation loads
- [ ] Race condition in multi-step process

---

## Parameter Tampering

### Critical Fields
- [ ] User ID in request body
- [ ] Email in password change request
- [ ] Account number in transfer
- [ ] Hidden form fields

### Mass Assignment
```json
{"email":"user@mail.com","role":"admin"}
{"amount":100,"discount":99}
```

### Response Manipulation
- [ ] Change `{"success":false}` to `{"success":true}`
- [ ] Bypass 2FA via response modification
- [ ] Modify validation responses

---

## File/Export Abuse

- [ ] IDOR on file download
- [ ] Access other user's exports
- [ ] Predictable file names
- [ ] Directory traversal in file param
- [ ] Export functionality leaks data

---

## Exam/Quiz Bypass

```
Example: Semrush Academy
1. Take exam with wrong answers
2. Retake exam
3. Intercept final submission
4. Modify answers: {"503":"1","504":"","505":"1"...}
   (1 = correct, empty = wrong)
5. Submit modified answers → pass
```

---

## Common Parameters to Test

```
price, amount, quantity, total
discount, coupon, promo
userId, accountId, orderId
role, isAdmin, isPremium, permissions
step, stage, flow
file, doc, export, download
```

---

## Testing Approach

1. **Profile** - Map all business flows
2. **Identify** - Critical parameters and hidden fields
3. **Tamper** - Modify values, add/remove parameters
4. **Skip** - Try accessing steps out of order
5. **Race** - Parallel requests on critical actions
6. **Compare** - Test with different user roles

---

## References
- https://portswigger.net/web-security/logic-flaws
- https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/10-Business_Logic_Testing/
