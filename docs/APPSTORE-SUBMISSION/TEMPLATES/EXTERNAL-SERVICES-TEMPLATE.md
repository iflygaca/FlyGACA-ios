# External Services Template
## [MODULE-NAME] App Module

**Template for App Store Submission Documentation**  
**Guidance: Adapt this template for new module launches (PPL, CPL, IR, ATPL)**  
**Date:** 2026-09-05

---

## Overview

This template documents external services used by a FlyGACA study module. Use this as a starting point when adding a new module. Replace all `[PLACEHOLDER]` sections with module-specific values.

**Key Principle:** Offline-first architecture. All external services are optional—the app works 100% offline without them.

---

## Module-Specific Configuration

| Property | Value |
|----------|-------|
| **Module Name** | [MODULE-NAME] (e.g., PPL, CPL, IR, ATPL) |
| **Module ID** | [MODULE_ID] (e.g., `ppl`, `cpl`, `ir`, `atpl`) |
| **Bundle ID** | `com.flygaca.[module-id-lowercase]` |
| **Firebase Project** | `flygaca-app` (shared across all modules) |
| **Content Source** | FlyGACA-app monorepo → `src/lib/prepCatalog.ts` → `Content/` folder in this repo |
| **Quiz Bank Size** | [NUMBER]-[NUMBER] questions (typical: 800-1200) |
| **Regulatory Parts** | [NUMBER] GACAR parts + [NUMBER] topical handbooks (if applicable) |
| **Launch Date (Planned)** | [DATE] |

---

## Service Summary Table

| Service | Purpose | Offline Fallback | Status |
|---------|---------|------------------|--------|
| **Firebase (Auth + Firestore + App Check)** | Optional user sign-in + cloud progress backup | Local storage only | Shared |
| **Captain Adel AI Chat API** | GACAR Q&A with exact citations | Static Q&A library | Shared |
| **Moyasar Payment Gateway** | In-app purchase processing for premium packs | Payment unavailable | Shared |
| **Content Refresh CDN** | Quiz/lesson updates | Bundled offline content | Shared |

---

## Firebase Authentication & Firestore & App Check

### Purpose
- **Authentication:** User sign-in (optional, not required for study)
- **Firestore:** Cloud backup of study progress (optional sync)
- **App Check:** Fraud prevention (validates app integrity)

### Configuration
**Company:** Google Cloud (Firebase Division)  
**Project:** `flygaca-app` (shared by ELPT, AIP, [MODULE-NAME])  
**Compliance:** SOC 2 Type II, ISO 27001, GDPR compliant  
**Data Residency:** me-central2 (Middle East Central — PDPL-compliant for Saudi users)

### Endpoints
```
Authentication: https://identitytoolkit.googleapis.com
Firestore: https://firestore.googleapis.com (region: me-central2)
App Check: https://firebaseappcheck.googleapis.com
```

### Data Stored in Firebase

**In Firebase Auth:**
- Email address (if email sign-in used)
- Phone number (if phone sign-in used)
- Password hash (encrypted, salted)
- Account creation date, last login timestamp

**In Firestore (Study Progress):**
- Quiz best scores (per question ID)
- Streak counts (per module)
- Exam attempt records (date, score, pass/fail)
- Timestamp of last sync
- Entitlements (which packs user has purchased)

**NOT stored:**
- Full quiz answers, keystroke history, user location, biometric data

### Privacy & Security
- **Encryption in Transit:** TLS 1.2+ (HTTPS)
- **Encryption at Rest:** AES-256 (Firebase default)
- **Access Control:** User can only access their own data (`/users/{uid}/...`)
- **Data Retention:** Permanent deletion available in Settings
- **Regional Compliance:** PDPL-compliant for Saudi users (me-central2 region)

### Offline Behavior
- If no internet: Sign-in page shown (skippable), all study features accessible (local only)
- If user doesn't sign in: All features work identically, progress saved locally only
- When internet restored: App auto-syncs queued progress to Firebase

---

## Captain Adel AI Chat API

### Purpose
Conversational AI providing GACAR-grounded Q&A. Users ask regulatory questions (e.g., "What is Part 61?"), Captain Adel provides streaming response with exact section citations.

### Configuration
**Service:** FlyGACA Captain Adel API  
**Type:** Proprietary AI (not ChatGPT or third-party LLM)  
**Hosted:** https://flygaca.com/api/chat  
**Availability:** Best-effort (no SLA; service may be down for maintenance)  
**Response Format:** Server-Sent Events (SSE), streaming text

### Endpoint
```
POST https://flygaca.com/api/chat
Authorization: Bearer [sessionToken]
Content-Type: application/json

Request:
{
  "messages": [
    { "role": "user", "content": "What is Part 61?" },
    { "role": "assistant", "content": "Part 61 covers Certification of Pilots..." }
  ],
  "modelId": "gaca-pilot-grounded",
  "maxTokens": 512
}

Response: Server-Sent Events (SSE)
data: "Part"
data: " 61"
data: " covers"
...
```

### Data Flows
**User Query Flow:**
1. User types question in Chat tab
2. App gathers conversation history (current session only)
3. App POSTs to /api/chat with messages array
4. Captain Adel processes: retrieves GACAR regulations, generates grounded response
5. Response streamed as SSE (word-by-word)
6. App displays streaming response in real-time
7. Response stored locally (until app restart or user clears chat)

### Data Sent to Captain Adel
- User's text queries
- Conversation history (current session only, not persistent)
- Session token (random, non-identifying)

**NOT sent:** User account info, study progress, quiz answers, device ID, location data

### Privacy & Security
- **No Training on User Data:** Captain Adel is specialized, not fine-tuned on user queries
- **Session Isolation:** Each chat session isolated; no data shared between sessions
- **HTTPS Only:** All requests encrypted in transit (TLS 1.2+)
- **Logs:** Queries logged for debugging, auto-deleted after 30 days, never used for model training

### Offline Behavior
- If no internet: Chat tab shows "Offline", static Q&A library available
- If service down: Chat shows "Service temporarily unavailable", static Q&A fallback
- Study continues normally (no impact on quizzing, flashcards, etc.)

---

## Moyasar Payment Gateway

### Purpose
Process in-app purchases for premium features and app subscriptions. Supports Saudi Riyal (SAR) payments via Mada card, Apple Pay, and international credit cards.

### Configuration
**Company:** Moyasar (Saudi fintech)  
**Headquarters:** Riyadh, Saudi Arabia  
**Compliance:** PCI DSS Level 1, SOC 2 Type II, SWIFT-certified  
**Website:** https://moyasar.com

### Endpoint
```
POST https://api.moyasar.com/v1/payments
Authorization: Bearer [API_KEY]
Content-Type: application/json

Request:
{
  "amount": 79000,  // SAR 79 in fils (1 SAR = 1000 fils)
  "currency": "SAR",
  "description": "Fly GACA [MODULE-NAME] App Purchase",
  "customer": { "email": "user@example.com" },
  "source": { "type": "apple_pay", "token": "[Apple Pay token]" },
  "callback_url": "https://flygaca.com/checkout/callback"
}

Response:
{
  "id": "txn_XXXXXXX",
  "status": "completed",
  "amount": 79000,
  "currency": "SAR"
}
```

### Data Flows
1. User taps "Buy [PACK-NAME]" button
2. App presents Moyasar payment form
3. User enters payment details or uses Apple Pay
4. App tokenizes payment info (Apple handles encryption)
5. App sends tokenized payment to Moyasar API
6. Moyasar processes with Mada/credit card networks
7. Payment gateway returns success/failure
8. App receives transaction ID
9. App verifies with Moyasar callback webhook
10. App unlocks [PACK-NAME] (Firebase user doc updated)
11. User receipt displayed

### Data Stored
**On Moyasar Servers:**
- Transaction ID, amount, currency, payment method type, timestamp, user email
- **NOT stored:** Full credit card number (tokenized), CVV, security codes

**On FlyGACA Servers (Firebase):**
- Transaction ID, pack purchased, purchase date, user ID
- **NOT stored:** Payment method details, card information

### Privacy & Security
- **PCI DSS Compliance:** Moyasar handles all payment data; FlyGACA never touches card info
- **Tokenization:** One-time use tokens, cannot be reused
- **Encryption:** Apple encrypts card data before transmission, Moyasar stores with AES-256
- **No Subscription Tracking:** Each purchase is standalone; no auto-recurring charges

### Offline Behavior
- If no internet: Payment form unavailable; user sees "Payment requires internet connection"
- If Moyasar down: Payment unavailable (graceful error); study continues normally

---

## Content Refresh CDN

### Purpose
Deliver updated quiz banks, lessons, and regulatory content to users. Uses ETag-based caching for efficient delivery. Optional; app runs entirely on bundled offline content if refresh unavailable.

### Configuration
**Service:** FlyGACA Content Delivery Network  
**Hosted:** https://flygaca.com/data/  
**Protocol:** HTTP/2 (HTTPS required)  
**Caching:** ETag + If-None-Match (HTTP 304 Not Modified)

### Endpoints
```
GET https://flygaca.com/data/quiz.json
GET https://flygaca.com/data/quiz.json.sig  // Ed25519 signature
GET https://flygaca.com/data/groundschool.json (optional)
GET https://flygaca.com/data/paths-index.json (optional)

Headers (if cached):
  If-None-Match: "abc123def456..."  // ETag from last fetch

Response (if changed):
  HTTP 200 OK
  ETag: "xyz789uvw012..."
  [full content]

Response (if not changed):
  HTTP 304 Not Modified
  [no body, client uses cached version]
```

### Data Flows
1. On app launch (if internet available)
2. App checks: "Do I have quiz.json cached?"
3. If YES: Send GET with If-None-Match (ETag); server responds 304 (no download)
4. If NO: Send GET without header; server responds 200 with full content
5. App downloads & saves with ETag
6. App validates JSON schema
7. App verifies Ed25519 signature (quiz.json.sig)
8. If valid: Use new content; if invalid: Fall back to bundled

### Signature Verification Process
1. Downloaded quiz.json + quiz.json.sig
2. App reads FGCorpusPublicKey from Info.plist
3. App computes Ed25519 signature over quiz.json bytes
4. App compares computed signature with quiz.json.sig
5. If match: Content authentic, use it
6. If mismatch: Content rejected (potential tampering), fall back to bundled

### Data Sent to CDN
- HTTP GET request (minimal metadata)
- ETag from last fetch (to check for updates)
- Device IP (standard HTTP, used for CDN routing)

**NOT sent:** User account info, study progress, device ID, location data

### Privacy & Security
- **No User Tracking:** Stateless requests (no cookies, no session tracking)
- **Content Integrity:** Ed25519 signature verifies authenticity
- **Fail Closed:** Any signature mismatch → reject content, use bundled fallback
- **Caching:** ETag-based (efficient), cache expiry 30 days or when signature fails

### Offline Behavior
- If no internet: App uses bundled content (built-in, up-to-date as of app release)
- If CDN down: HTTP request times out after 5 seconds; app falls back to bundled content
- If signature invalid: Downloaded content rejected; app falls back to bundled content

---

## Cross-Service Data Architecture

**No Third-Party Tracking:**
- Firebase does NOT send data to Google Analytics
- Captain Adel does NOT log queries with user ID
- Moyasar does NOT send transaction data to FlyGACA profile
- Content CDN requests are stateless (no session cookies)

**User Has Control:**
- Can sign out of Firebase (progress stored locally only)
- Can delete chat history (no persistence across sessions)
- Can view/delete payment records (Moyasar dashboard)
- Can clear app cache (forces fresh content download)

---

## Service Outage Scenarios

| Service Down | Impact | User Experience | Study Continuation |
|---|---|---|---|
| **Firebase** | Can't sign in or sync progress | Sign-in disabled, local save only | ✅ Study works offline |
| **Captain Adel** | No AI responses | Chat shows "offline" | ✅ Static Q&A available |
| **Moyasar** | Can't purchase | "Payment unavailable" | ✅ Free content accessible |
| **Content CDN** | Can't update | Uses bundled content | ✅ Offline content always works |

**Key Principle:** No single service failure blocks core study functionality.

---

## Compliance & Certifications

**Firebase:**
- ✅ SOC 2 Type II, ISO 27001, GDPR compliant, PDPL compliant

**Moyasar:**
- ✅ PCI DSS Level 1, SOC 2 Type II, SWIFT-certified, SAMA regulations

**FlyGACA:**
- ✅ Privacy policy reviewed by legal counsel
- ✅ Encryption in transit (TLS 1.2+) and at rest (AES-256)

---

## How to Adapt This Template

**For a New Module ([MODULE-NAME]):**

1. **Replace placeholders:**
   - `[MODULE-NAME]` → "PPL", "CPL", "IR", or "ATPL"
   - `[MODULE_ID]` → lowercase module ID (e.g., "ppl")
   - `[NUMBER]` → Actual quiz bank size, regulatory parts count
   - `[PACK-NAME]` → Pack name (e.g., "PPL Knowledge Pack")
   - `[DATE]` → Planned launch date

2. **Customize if needed:**
   - If module has different content structure (ground school, paths, scenarios), update Content Refresh section
   - If module requires unique payment pricing, update Moyasar section with specific currency/amount
   - If module adds new services (e.g., video streaming, NOTAM service), add new section using same structure

3. **Cross-reference:**
   - Link back to REGULATED-CONTENT-CERTIFICATION.md for that module
   - Link to REGIONAL-PARITY-VERIFICATION.md for bilingual verification
   - Link to module-specific APP-STORE-FORM-COMPLETION.md

4. **Version & ownership:**
   - Add module-specific footer with last updated date and author
   - Maintain version history for compliance audits

---

**Template Authorship:** Claude Code  
**Template Version:** 1.0  
**Effective Date:** 2026-09-05

_Use this template as a starting point for each new FlyGACA iOS study module. All external services must follow the same offline-first principles and compliance standards documented here._
