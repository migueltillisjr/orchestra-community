# SMS Best Practices for Programmatic Messaging

_Last updated: 2026-06-23_

This guide covers practical best practices for sending SMS messages programmatically from an application, automation script, or backend service. It is written for transactional, notification, reminder, and customer communication workflows.

> This is implementation guidance, not legal advice. For production SMS, review carrier, provider, and local legal requirements before sending.

---

## 1. Core Principles

Programmatic SMS should be:

- **Permission-based**: only text users who clearly opted in.
- **Expected**: send the type of message the user agreed to receive.
- **Identifiable**: make it clear who the message is from.
- **Useful**: send messages that help the recipient take action.
- **Easy to stop**: support opt-out using standard keywords like `STOP`.
- **Auditable**: store consent, message history, and opt-out events.

SMS is a high-trust channel. Treat it like direct access to someone’s attention, not like a cheap notification stream.

---

## 2. Choose the Right SMS Channel

### Transactional SMS

Use for messages tied to a user action or account event.

Examples:

- Login codes
- Appointment confirmations
- Payment reminders
- Delivery updates
- Security alerts

### Marketing SMS

Use for promotional or sales messages.

Examples:

- Discounts
- Campaigns
- Product announcements
- Sales follow-ups

Marketing SMS usually requires stricter opt-in language, more explicit disclosures, and careful frequency control.

### Conversational SMS

Use when the user expects a human or agent-like back-and-forth conversation.

Examples:

- Support follow-up
- Scheduling conversation
- Sales qualification
- Customer service

For conversational use, still collect consent and provide opt-out handling.

---

## 3. Consent and Opt-In

Before sending SMS, collect clear consent.

Your opt-in language should explain:

- Who is sending the messages
- What type of messages the user will receive
- How often messages may be sent, if applicable
- That message and data rates may apply
- How to opt out
- How to get help

Example opt-in copy:

```text
I agree to receive SMS messages from Example Company about appointment reminders and account updates. Message and data rates may apply. Reply STOP to opt out or HELP for help.
```

For marketing:

```text
I agree to receive promotional SMS messages from Example Company. Message frequency may vary. Message and data rates may apply. Reply STOP to opt out or HELP for help.
```

Do not pre-check consent boxes. The user should take a clear affirmative action.

Good opt-in sources:

- Website form checkbox
- Account settings toggle
- Checkout flow checkbox
- Keyword opt-in
- Written agreement
- Inbound SMS from the user, when appropriate for the use case

Bad opt-in sources:

- Purchased phone lists
- Scraped phone numbers
- Consent hidden inside unrelated terms
- Assuming consent because the user gave you a phone number
- Reusing consent from one purpose for a different purpose

---

## 4. Store Consent Records

Keep enough data to prove consent later.

Recommended database fields:

```text
sms_consent
- id
- user_id
- phone_e164
- consent_status
- consent_type
- consent_source
- consent_text
- consented_at
- revoked_at
- ip_address
- user_agent
- campaign_id
- provider
```

Recommended consent statuses:

```text
opted_in
opted_out
pending
unknown
```

Recommended consent types:

```text
transactional
marketing
security
support
appointment_reminders
```

Never send marketing texts to a number that only opted into transactional messages.

---

## 5. Opt-Out Handling

Always support opt-out.

At minimum, handle:

```text
STOP
STOPALL
UNSUBSCRIBE
CANCEL
END
QUIT
```

Some providers or number types may only support specific keywords. For example, U.S. toll-free opt-outs may be carrier-managed with `STOP` as the supported keyword.

When a user opts out:

1. Mark the phone number as opted out immediately.
2. Stop sending non-essential messages.
3. Send a short confirmation if allowed by your provider/carrier.
4. Keep the opt-out record.

Example opt-out confirmation:

```text
You have opted out of Example Company SMS messages. Reply START to resubscribe.
```

Your application should check opt-out status before every send.

Example send guard:

```python
if user.sms_opted_in and not user.sms_opted_out_at:
    send_sms(user.phone_e164, body)
else:
    skip_send(user.id, reason="not opted in or opted out")
```

---

## 6. HELP Handling

Support `HELP` messages.

Example HELP response:

```text
Example Company: Get help at support@example.com or https://example.com/help. Reply STOP to opt out. Msg & data rates may apply.
```

Keep it short. SMS has limited space.

---

## 7. Use E.164 Phone Number Format

Store phone numbers in E.164 format.

Example:

```text
+16197045891
```

Avoid storing local formats as your canonical value.

Bad:

```text
619-704-5891
(619) 704-5891
6197045891
```

Good:

```text
+16197045891
```

Recommended fields:

```text
phone_raw
phone_e164
phone_country
phone_verified_at
```

---

## 8. Verify Phone Ownership

Before sending sensitive messages, verify the user controls the phone number.

Use cases that should require verification:

- Login codes
- Password reset
- Account security
- Payment alerts
- Personal data notifications

Verification flow:

1. User enters phone number.
2. System sends one-time code.
3. User enters code.
4. System marks phone number as verified.

Do not send sensitive account data to an unverified number.

---

## 9. Sender Registration and Compliance

For U.S. application-to-person SMS, you usually need a registered sender identity.

Common options:

- **10DLC number**: standard local U.S. number for business/application messaging.
- **Toll-free number**: useful for many business messaging use cases, with toll-free verification.
- **Short code**: high-volume and expensive, often used by larger brands.

You register the **sender/use case**, not every recipient.

A2P 10DLC registration usually includes:

- Brand/business identity
- Campaign/use case
- Sample messages
- Opt-in process
- Opt-out and HELP handling
- Associated sending number or messaging service

Do not try to bypass carrier registration for production U.S. messaging. Unregistered traffic is commonly blocked or filtered.

---

## 10. Message Content Best Practices

Good SMS content is clear, short, and expected.

Recommended structure:

```text
[Brand]: [Useful message]. [Action/link if needed]. Reply STOP to opt out.
```

Example transactional message:

```text
Example Co: Your appointment is confirmed for Tue at 3:00 PM. Reply STOP to opt out.
```

Example security message:

```text
Example Co: Your login code is 482913. Do not share this code.
```

Example reminder:

```text
Example Co: Reminder: your consultation starts at 2:00 PM today. Join: https://example.com/meet
```

Avoid:

- Link-only messages
- URL shorteners from unknown domains
- ALL CAPS
- Excessive punctuation
- Misleading urgency
- Spammy phrasing
- Sending attachments unless the user expects MMS
- Content unrelated to the opt-in purpose

---

## 11. Encoding and Length

SMS length depends on encoding.

General guidance:

- Standard GSM-7 SMS supports up to 160 characters per segment.
- Unicode characters may reduce the limit to 70 characters per segment.
- Long messages may be split into multiple billable segments.

Be careful with:

- Curly quotes
- Emojis
- Trademark symbols
- Non-standard punctuation
- Non-Latin characters

For cost and deliverability, keep messages concise.

Good:

```text
Example Co: Your code is 123456. Do not share it.
```

Riskier due to special characters:

```text
Example Co™: Your code is “123456” ✅
```

---

## 12. Links and Domains

If you include links:

- Use your own branded domain.
- Avoid public URL shorteners when possible.
- Keep the destination consistent with the message purpose.
- Use HTTPS.
- Do not redirect through suspicious or unrelated domains.

Good:

```text
https://example.com/appointments/123
```

Avoid:

```text
https://bit.ly/random-code
```

---

## 13. Sending Frequency

Do not over-message users.

Suggested limits:

- OTP/security: only when user requests or security event occurs
- Appointment reminders: 1–3 messages per appointment
- Transactional updates: only meaningful status changes
- Marketing: conservative frequency, clearly disclosed at opt-in

Add rate limits:

```text
per_user_per_hour
per_user_per_day
per_number_per_day
per_campaign_per_day
```

Example:

```python
if messages_sent_to_user_today >= DAILY_LIMIT:
    skip_send(user.id, reason="daily limit reached")
```

---

## 14. Quiet Hours

Respect local time.

Avoid sending non-urgent messages too early or too late.

Suggested default:

```text
Send non-urgent SMS only between 8:00 AM and 8:00 PM recipient local time.
```

Exceptions may include:

- User-requested OTP codes
- Critical security alerts
- Emergency notifications

Store or infer user timezone carefully.

---

## 15. Message Types

Classify every outbound SMS.

Recommended message types:

```text
otp
security_alert
appointment_reminder
account_update
payment_notice
support_reply
marketing
system_notification
```

Use message type to enforce:

- Consent rules
- Templates
- Sending windows
- Rate limits
- Provider routing
- Logging

---

## 16. Template Management

Use templates for repeatable messages.

Example template:

```text
{brand}: Your appointment is confirmed for {date} at {time}. Reply STOP to opt out.
```

Store:

```text
sms_templates
- id
- name
- message_type
- body
- approved_at
- active
```

Validate templates before sending:

- Required brand name present
- Required opt-out text present when needed
- Character count under threshold
- No forbidden words or risky links
- Variables are filled

---

## 17. Delivery Tracking

Track the full lifecycle of each message.

Recommended fields:

```text
sms_messages
- id
- provider
- provider_message_id
- user_id
- phone_e164
- direction
- message_type
- body
- status
- failure_code
- failure_reason
- sent_at
- delivered_at
- failed_at
- created_at
```

Common statuses:

```text
queued
sent
delivered
failed
undelivered
blocked
skipped
```

Use provider callbacks/webhooks to update status.

---

## 18. Error Handling

Your sender should handle failures gracefully.

Common failure causes:

- Invalid phone number
- Landline number
- User opted out
- Carrier filtering
- Unregistered sender
- Provider account restriction
- Rate limit exceeded
- Insufficient balance/spend limit

Do not blindly retry every failure.

Suggested retry policy:

```text
Temporary provider error: retry with backoff
Carrier filtering: do not retry immediately
Invalid number: mark invalid
Opted out: suppress permanently until resubscribe
Unregistered sender: stop campaign and fix compliance
```

---

## 19. Logging and Auditability

Log enough to debug without exposing unnecessary sensitive data.

Log:

- Message ID
- User ID
- Destination phone hash or masked number
- Message type
- Provider
- Status
- Error code
- Timestamp

Avoid logging:

- Full OTP codes
- Sensitive personal data
- Full message bodies when not needed
- Secrets or API keys

Masked phone example:

```text
+1******5891
```

---

## 20. Security

Protect SMS infrastructure like production payment or auth infrastructure.

Required controls:

- Store provider API keys in a secrets manager.
- Never commit secrets to Git.
- Use least-privilege IAM/API permissions.
- Rotate credentials.
- Validate outbound message templates.
- Rate-limit OTP sends.
- Monitor unusual send spikes.
- Use separate senders/projects for dev and production.

For OTP:

- Use short expiration windows.
- Hash codes at rest.
- Limit attempts.
- Prevent brute force.
- Do not send OTP to unverified high-risk numbers without controls.

---

## 21. Data Privacy

Phone numbers are sensitive personal data.

Best practices:

- Store only what you need.
- Encrypt sensitive fields at rest when possible.
- Limit employee access.
- Do not sell or share phone numbers without permission.
- Honor deletion requests when legally required.
- Keep retention policies documented.

---

## 22. Development and Testing

Use separate environments:

```text
dev
staging
production
```

Do not test production campaigns on real user lists.

For local testing:

- Send only to your own number or test numbers.
- Use provider sandbox if available.
- Use a dry-run mode.
- Log the message instead of sending.

Example dry run:

```python
def send_sms(to_number: str, body: str, dry_run: bool = False):
    if dry_run:
        print({"to": to_number, "body": body, "dry_run": True})
        return None

    return provider.send(to=to_number, body=body)
```

---

## 23. Recommended Application Flow

### Opt-In Flow

```text
User enters phone number
→ User checks SMS consent box
→ Store consent text and timestamp
→ Send verification code
→ User verifies code
→ Mark phone as verified and opted in
```

### Send Flow

```text
Application event occurs
→ Determine message type
→ Check consent
→ Check opt-out
→ Check phone verification
→ Check quiet hours
→ Check rate limits
→ Render template
→ Validate content
→ Send through provider
→ Store provider message ID
→ Update status from webhook
```

### Opt-Out Flow

```text
Inbound message received
→ Normalize keyword
→ If STOP keyword, mark opted out
→ Suppress future messages
→ Send confirmation if allowed
```

---

## 24. Example Minimal Schema

```sql
CREATE TABLE sms_contacts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    phone_e164 TEXT NOT NULL UNIQUE,
    phone_verified_at TEXT,
    sms_opted_in_at TEXT,
    sms_opted_out_at TEXT,
    consent_source TEXT,
    consent_text TEXT,
    created_at TEXT NOT NULL
);

CREATE TABLE sms_messages (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    phone_e164 TEXT NOT NULL,
    direction TEXT NOT NULL,
    message_type TEXT NOT NULL,
    body TEXT,
    provider TEXT,
    provider_message_id TEXT,
    status TEXT NOT NULL,
    failure_code TEXT,
    failure_reason TEXT,
    created_at TEXT NOT NULL,
    sent_at TEXT,
    delivered_at TEXT,
    failed_at TEXT
);
```

---

## 25. Python Send Guard Example

```python
from dataclasses import dataclass
from datetime import datetime, timezone


@dataclass
class SmsContact:
    phone_e164: str
    phone_verified_at: str | None
    sms_opted_in_at: str | None
    sms_opted_out_at: str | None


def can_send_sms(contact: SmsContact, message_type: str) -> tuple[bool, str]:
    if not contact.phone_e164.startswith("+"):
        return False, "phone is not in E.164 format"

    if not contact.phone_verified_at and message_type in {"otp", "security_alert"}:
        return False, "phone is not verified"

    if not contact.sms_opted_in_at:
        return False, "user has not opted in"

    if contact.sms_opted_out_at:
        return False, "user has opted out"

    return True, "ok"


def send_sms(contact: SmsContact, body: str, message_type: str):
    allowed, reason = can_send_sms(contact, message_type)

    if not allowed:
        return {
            "status": "skipped",
            "reason": reason,
            "phone_e164": contact.phone_e164,
        }

    # provider.send(to=contact.phone_e164, body=body)
    return {
        "status": "queued",
        "phone_e164": contact.phone_e164,
        "message_type": message_type,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
```

---

## 26. Production Checklist

Before launching SMS in production:

- [ ] Sender identity is registered or verified.
- [ ] Opt-in language is clear and stored.
- [ ] Consent records are saved.
- [ ] Phone numbers are stored in E.164 format.
- [ ] Sensitive flows verify phone ownership.
- [ ] STOP handling works.
- [ ] HELP handling works.
- [ ] Opted-out users are suppressed.
- [ ] Message templates are reviewed.
- [ ] Links use trusted branded domains.
- [ ] Quiet hours are enforced for non-urgent messages.
- [ ] Rate limits are enforced.
- [ ] Delivery webhooks update status.
- [ ] Logs do not expose sensitive data.
- [ ] Provider errors are handled correctly.
- [ ] API keys are stored securely.
- [ ] Dev/staging/prod are separated.
- [ ] Monitoring alerts exist for send spikes and failures.

---

## 27. Provider Notes

### Twilio

For U.S. local long-code SMS, register A2P 10DLC brand and campaign before production sending. Use Messaging Services where possible.

### AWS End User Messaging SMS

Use AWS End User Messaging SMS for production SMS workloads. Configure origination identities, opt-out handling, pools, and message type routing.

### SNS SMS

SNS can send SMS, but for production-grade SMS programs, prefer the newer AWS End User Messaging SMS features and compliance controls.

---

## 28. References

- Twilio Programmable Messaging and A2P 10DLC: https://www.twilio.com/docs/messaging/compliance/a2p-10dlc
- Twilio A2P 10DLC Quickstart: https://www.twilio.com/docs/messaging/compliance/a2p-10dlc/quickstart
- AWS End User Messaging SMS Best Practices: https://docs.aws.amazon.com/sms-voice/latest/userguide/best-practices.html
- AWS Required Opt-Out Keywords: https://docs.aws.amazon.com/sms-voice/latest/userguide/keywords-required.html
- AWS SNS SMS Best Practices: https://docs.aws.amazon.com/sns/latest/dg/channels-sms-best-practices.html
- CTIA Messaging Principles and Best Practices: https://www.ctia.org/the-wireless-industry/industry-commitments/messaging-interoperability-sms-mms

---

## 29. Simple Rule

Before sending any SMS, ask:

```text
Did this person clearly ask for this type of message, from this sender, at this number?
```

If the answer is not clearly yes, do not send it.
