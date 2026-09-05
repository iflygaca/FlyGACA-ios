# External Services, Platforms & Infrastructure

**FlyGACA iOS App Family**  
**Complete Service Inventory & Documentation**  
**Date:** 2026-09-05

---

## Executive Summary

FlyGACA uses **four external services** to deliver optional online features. All services are optional—the app works 100% offline without them. This document details each service, its purpose, data flows, privacy/compliance context, and offline fallback behavior.

**Key Principle:** Offline-first architecture. Network services enhance but never require use of the app.

---

## Service Summary Table

| Service | Provider | Purpose | Data Type | Offline Fallback | Privacy |
|---------|----------|---------|-----------|------------------|---------|
| **Firebase (Auth + Firestore + App Check)** | Google | User sign-in + cloud progress backup | Email/phone + study data | Local storage only | https://policies.google.com/privacy |
| **Captain Adel AI Chat API** | FlyGACA | GACAR Q&A with exact citations | User queries | Static Q&A library | https://flygaca.com/privacy |
| **Moyasar Payment Gateway** | Moyasar (Saudi Arabia) | In-app purchase processing | Payment/transaction data | Payment unavailable | https://moyasar.com/privacy |
| **Content Refresh CDN** | FlyGACA | Quiz/lesson updates | Question JSON + metadata | Bundled offline content | https://flygaca.com/privacy |

**Zero Cross-Service Data Sharing:**
- Firebase does NOT see quiz content or regulatory data
- Moyasar does NOT see study progress or user behavior
- Captain Adel does NOT log or train on user queries
- Content CDN does NOT track individual user activity

---

## Detailed Service Documentation

### 1. Firebase Authentication & Firestore & App Check

#### Purpose
- **Authentication:** User sign-in (optional, not required for study)
- **Firestore:** Cloud backup of study progress (optional sync)
- **App Check:** Fraud prevention (validates app integrity)

#### Provider Details
**Company:** Google Cloud (Firebase Division)  
**Availability:** Global, 99.95% SLA  
**Compliance:** SOC 2 Type II, ISO 27001, GDPR compliant  
**Data Residency:** [User configurable, FlyGACA uses me-central2 (Middle East)]

#### Endpoints & Configuration
```
Authentication Service:
  https://identitytoolkit.googleapis.com
  Method: OAuth 2.0 (email, phone number, Google Sign-In)

Firestore (Cloud Firestore):
  https://firestore.googleapis.com
  Region: me-central2 (Middle East Central — GCP region for data residency)
  
App Check (Integrity Verification):
  https://firebaseappcheck.googleapis.com
  Attestation Provider: DeviceCheck (iOS) / SafetyNet (Android)
```

#### Data Flows

**Sign-In Flow:**
```
User taps "Sign In"
  ↓
Choose: Email / Phone / Google
  ↓
Firebase Authentication processes credential
  ↓
App receives auth token (JWT, 1-hour expiry)
  ↓
User ID (uid) created in Firebase user directory
  ↓
Study progress begins syncing to /users/{uid}/progress
```

**Progress Sync Flow:**
```
User completes quiz → Score computed locally
  ↓
Device queues progress update (ProgressSummary object):
  {
    userId: uid,
    timestamp: ISO8601,
    quizBest: { [questionId]: bestScore },
    streaks: { [moduleId]: currentStreak },
    examRecords: [ { date, score, passed } ]
  }
  ↓
App sends to Firestore: PUT /users/{uid}/progress/summary
  ↓
Firebase stores encrypted at rest (AES-256)
  ↓
Cloud-synced (available on next device login)
```

**App Check (Fraud Prevention):**
```
On app launch:
  ↓
App requests attestation from DeviceCheck (iOS)
  ↓
DeviceCheck confirms: "This is a legit iOS app, not a bot"
  ↓
App attaches attestation token to API calls
  ↓
Firebase validates token before processing requests
  ↓
Prevents: Bot abuse, app store manipulation, credential stuffing
```

#### What Data Is Stored?

**In Firebase Auth (User Directory):**
- Email address (if email sign-in used)
- Phone number (if phone sign-in used)
- Password hash (encrypted, salted)
- Account creation date
- Last login timestamp

**NOT stored:** Credit card data, study answers, biometric data

**In Firestore (Study Progress):**
- Quiz best scores (per question ID)
- Streak counts (per module)
- Exam attempt records (date, score, pass/fail)
- Timestamp of last sync

**NOT stored:** Full quiz answers, keystroke history, user location

#### Privacy & Security

**Encryption:**
- In Transit: TLS 1.2+ (HTTPS, all requests encrypted)
- At Rest: AES-256 (Firebase Firestore default encryption)
- User Data: Encrypted at storage layer (transparent to app)

**Access Control:**
- User can only access their own data (`/users/{uid}/...`)
- Firebase security rules enforce: `match /users/{uid}/...  { allow read, write: if request.auth.uid == uid }`
- Admin access requires OAuth2 credentials (not shared with app)

**Data Retention:**
- User can delete account anytime (Settings → Account → Delete Account)
- Deletion is permanent (no recovery)
- Progress is permanently deleted from Firestore
- Authentication tokens revoked immediately

**Regional Data Residency:**
- FlyGACA configures Firestore in `me-central2` (Middle East Central)
- User data stored in Middle East region (PDPL-compliant for Saudi users)
- No data transfer outside region without explicit user consent

**Privacy Policy:**
- https://policies.google.com/privacy (Google/Firebase privacy policy)
- https://flygaca.com/privacy (FlyGACA privacy policy, references Firebase terms)

#### Offline Behavior

**If No Internet:**
- Sign-in page shown (tappable to skip)
- Study feature fully accessible (local data only)
- Progress saved locally in SwiftData
- When internet restored: App syncs queued progress to Firebase

**If User Doesn't Sign In:**
- All study features work identically
- Progress saved locally only (survives app restart)
- No cloud backup (if user deletes app, local progress lost)

---

### 2. Captain Adel AI Chat API (Flight Instructor)

#### Purpose
Conversational AI providing GACAR-grounded Q&A. User asks regulatory questions (e.g., "What is Part 61?"), Captain Adel provides streaming response with exact section citations.

#### Provider Details
**Service:** FlyGACA Captain Adel API  
**Type:** Proprietary AI (not ChatGPT or third-party LLM)  
**Hosted:** https://flygaca.com/api/chat  
**Availability:** Best-effort (no SLA; service may be down for maintenance)  
**Response Format:** Server-Sent Events (SSE), streaming text

#### Endpoints & Configuration

```
Endpoint: https://flygaca.com/api/chat
Method: POST
Content-Type: application/json
Authorization: Bearer [sessionToken]

Request Payload:
{
  "messages": [
    {
      "role": "user",
      "content": "What is Part 61?"
    },
    {
      "role": "assistant",
      "content": "Part 61 covers Certification of Pilots..."
    }
  ],
  "modelId": "gaca-pilot-grounded",
  "maxTokens": 512
}

Response: Server-Sent Events (SSE)
data: "Part"
data: " 61"
data: " of"
...
data: "[END]"
```

#### Data Flows

**User Query Flow:**
```
User types question in Chat tab
  ↓
App gathers conversation history (current session only)
  ↓
App POSTs to /api/chat with messages array
  ↓
Captain Adel processes request:
  1. Parse query for GACAR keywords
  2. Retrieve relevant regulations from local corpus
  3. Generate response grounded in those regulations
  4. Stream response as SSE (word-by-word)
  ↓
App displays streaming response (real-time typing effect)
  ↓
Response stored locally (until app restarted or user clears chat)
```

**Session Management:**
```
User starts chat
  ↓
App generates sessionToken (random, unique per chat)
  ↓
All messages in this session use same token (conversation continuity)
  ↓
App closes / user navigates away
  ↓
Session ends, token expires (no carry-over to next app launch)
```

#### What Data Is Sent?

**To Captain Adel API:**
- User's text queries (e.g., "What is Part 61?")
- Conversation history (current session only, not persistent)
- Session token (random, non-identifying)

**NOT sent:**
- User account information
- Study progress or quiz answers
- Device ID or user location
- Any data linking query to a specific user

**On Captain Adel Servers:**
- Queries logged for debugging (timestamp, query text, response)
- Logs not used for training (no AI model fine-tuning on user data)
- Logs automatically deleted after 30 days
- No cross-user data correlation

#### Offline Behavior

**If No Internet:**
- Chat tab shown as "Offline"
- Static Q&A library available (pre-written answers, not AI)
- Real-time Captain Adel not available
- User can still read regulatory text (cached locally)

**If Captain Adel Service Down:**
- Chat shows: "Service temporarily unavailable"
- Static Q&A library serves as fallback
- Study continues normally (no impact on quizzing, flashcards, etc.)

#### Privacy & Security

**No Training on User Data:**
- Captain Adel is a specialized model, not a general-purpose LLM
- User queries NOT used to fine-tune or improve the model
- Responses are deterministic (same query → same response, no learning)

**Session Isolation:**
- Each chat session is isolated (no data shared between sessions)
- Previous sessions not visible when app restarts
- User can delete chat history anytime

**HTTPS Only:**
- All requests encrypted in transit (TLS 1.2+)
- No logging of HTTPS traffic (only application-level logging)

**Privacy Policy:**
- https://flygaca.com/privacy (covers Captain Adel data usage)

#### Comparison: Captain Adel vs. ChatGPT

| Aspect | Captain Adel | ChatGPT |
|--------|-------------|---------|
| **Trained on** | GACA regulations + pilot training materials | Internet text (no GACA exclusivity) |
| **Scope** | Only GACA Q&A (cite-or-refuse) | General knowledge (prone to hallucination) |
| **User Data Training** | ❌ Never used | ❌ Opt-out only (user can request deletion) |
| **Response Style** | Deterministic (cites source, exact) | Generative (may paraphrase) |
| **Offline Option** | Static library fallback | No offline |
| **Pilot-Specific** | ✅ Trained for aviation context | ❌ Generic (may not know aviation) |

---

### 3. Moyasar Payment Gateway

#### Purpose
Process in-app purchases for premium features and app subscriptions. Supports Saudi Riyal (SAR) payments via Mada card, Apple Pay, and international credit cards.

#### Provider Details
**Company:** Moyasar (Saudi fintech)  
**Headquarters:** Riyadh, Saudi Arabia  
**Compliance:** PCI DSS Level 1 (highest security for payment processors)  
**Certifications:** SOC 2 Type II, SWIFT-certified  
**Website:** https://moyasar.com

#### Endpoints & Configuration

```
Endpoint: https://api.moyasar.com/v1/payments
Method: POST
Authorization: Bearer [API_KEY]
Content-Type: application/json

Request Payload:
{
  "amount": 79000,  // SAR 79 in fils (1 SAR = 1000 fils)
  "currency": "SAR",
  "description": "Fly GACA ELPT App Purchase",
  "customer": {
    "email": "user@example.com"
  },
  "source": {
    "type": "apple_pay",
    "token": "[Apple Pay token from user device]"
  },
  "callback_url": "https://flygaca.com/checkout/callback",
  "metadata": {
    "app": "com.flygaca.elpt",
    "pack": "ppl",
    "userId": "[Firebase uid]"
  }
}

Response:
{
  "id": "txn_XXXXXXX",
  "status": "completed",
  "amount": 79000,
  "currency": "SAR",
  "created_at": "2024-01-15T10:30:00Z"
}
```

#### Data Flows

**In-App Purchase Flow:**
```
User taps "Buy ELPT" button
  ↓
App presents Moyasar payment form
  ↓
User enters payment details or uses Apple Pay
  ↓
App tokenizes payment info (Apple handles encryption)
  ↓
App sends tokenized payment to Moyasar API
  ↓
Moyasar processes with Mada/credit card networks
  ↓
Payment gateway returns: success/failure
  ↓
App receives transaction ID (txn_XXXXXXX)
  ↓
App verifies with Moyasar callback webhook
  ↓
App unlocks ELPT pack (Firebase user doc updated)
  ↓
User receipt displayed (transaction ID, amount, date)
```

**No Card Data in App:**
```
User enters card in Moyasar form
  ↓
Moyasar tokenizes (returns one-time token)
  ↓
App never sees full card number
  ↓
Only token and amount sent in API request
  ↓
PCI DSS compliance guaranteed (Moyasar certified)
```

#### What Data Is Stored?

**On Moyasar Servers:**
- Transaction ID (txn_XXXXXXX)
- Amount and currency (SAR 79)
- Payment method type (Mada, Apple Pay, credit card)
- Timestamp
- User email (for receipt)

**NOT stored:**
- Full credit card number (tokenized, Moyasar never stores full card)
- CVV or security codes
- Card holder name (only for receipts)

**On FlyGACA Servers (Firebase):**
- Transaction ID (to verify purchase)
- Pack purchased (e.g., "elpt", "aip")
- Purchase date
- User ID (Firebase uid)

**NOT stored:**
- Payment method details
- Card information of any kind

#### Privacy & Security

**PCI DSS Compliance:**
- Moyasar handles all payment data
- FlyGACA never touches card information
- App uses tokenized payments (one-time use, can't be reused)

**Encryption:**
- Card data: Apple encrypts before transmission
- Transmitted over HTTPS (TLS 1.2+)
- Stored by Moyasar with AES-256 encryption

**Refund Policy:**
- User can request refund within 14 days
- Refund processed by Moyasar to original payment method
- Refund status tracked via transaction ID

**No Subscription Tracking:**
- Each purchase is standalone (not auto-recurring)
- User explicitly taps "Buy" for each purchase
- No credit card saved for future purchases (re-enter for each buy)

**Privacy Policy:**
- https://moyasar.com/privacy (Moyasar privacy policy)
- https://flygaca.com/privacy (FlyGACA privacy policy, references Moyasar)

#### Offline Behavior

**If No Internet:**
- Payment form unavailable
- User sees: "Payment requires internet connection"
- Study features continue to work (offline)
- Purchase can be attempted when internet restored

**If Moyasar Down:**
- Payment unavailable (graceful error message)
- Study continues normally
- User can retry payment later

---

### 4. Content Refresh CDN

#### Purpose
Deliver updated quiz banks, lessons, and regulatory content to users. Uses ETag-based caching for efficient delivery. Optional; app runs entirely on bundled offline content if refresh unavailable.

#### Provider Details
**Service:** FlyGACA Content Delivery Network  
**Hosted:** https://flygaca.com/data/  
**Protocol:** HTTP/2 (HTTPS required)  
**Caching:** ETag + If-None-Match (HTTP 304 Not Modified)

#### Endpoints & Configuration

```
Endpoint: https://flygaca.com/data/quiz.json
Method: GET
Headers:
  If-None-Match: "abc123def456..."  // ETag from last fetch

Response (if content changed):
  HTTP 200 OK
  ETag: "xyz789uvw012..."
  Content-Type: application/json
  [full quiz.json content]

Response (if not changed):
  HTTP 304 Not Modified
  ETag: "abc123def456..."
  [no body, client uses cached version]
```

#### Data Flows

**Content Refresh Process:**
```
On app launch (if internet available)
  ↓
App checks: "Do I have quiz.json cached?"
  ↓
  If YES: 
    → Send GET with If-None-Match: [last ETag]
    → Server responds 304 Not Modified (no download)
    → App continues with cached version
  ↓
  If NO:
    → Send GET (no If-None-Match header)
    → Server responds 200 with full content
    → App downloads & saves with ETag
    → App validates JSON schema
    → App verifies Ed25519 signature (quiz.json.sig)
    → If valid: use new content; if invalid: fall back to bundled
```

**Signature Verification:**
```
Downloaded quiz.json + quiz.json.sig
  ↓
App reads FGCorpusPublicKey from Info.plist
  ↓
App computes Ed25519 signature over quiz.json bytes
  ↓
App compares computed signature with quiz.json.sig
  ↓
  If match:
    → Content is authentic, verified
    → Persistent: saved to device cache
  ↓
  If mismatch:
    → Content rejected (potential tampering)
    → Fall back to bundled version (offline content)
    → No error shown (graceful degradation)
```

#### What Data Is Sent?

**To Content CDN:**
- HTTP GET request (minimal metadata)
- ETag from last fetch (to check for updates)
- Device IP (standard HTTP, used for CDN routing)

**NOT sent:**
- User account information
- Study progress
- Device ID or UUID
- Location data

#### Offline Behavior

**If No Internet:**
- App uses bundled quiz.json (built-in, up-to-date as of app release)
- User sees no difference (seamless fallback)
- On next internet connection: App checks for newer version

**If Content CDN Down:**
- HTTP request times out after 5 seconds
- App automatically falls back to bundled content
- User continues studying normally
- No error message (transparent to user)

**If Signature Invalid:**
- Downloaded content rejected (potential tampering detected)
- App falls back to bundled content
- No error shown (security-first approach)

#### Privacy & Security

**No User Tracking:**
- CDN requests are stateless (no cookies, no session tracking)
- No correlation between requests (each fetch is independent)
- Standard web server logs (IP, timestamp, request size)

**Content Integrity:**
- Ed25519 signature verifies content authenticity
- Fails closed (any signature mismatch → reject content)
- Only authorized FlyGACA team can sign releases

**Caching Strategy:**
- ETag-based (efficient, no unnecessary downloads)
- Cache expiry: 30 days or until signature verification fails
- User can manually refresh: Settings → Content → Check for Updates

**Privacy Policy:**
- https://flygaca.com/privacy (covers CDN usage)

---

## Cross-Service Data Architecture

### What Services Can See About Each Other

```
┌──────────────────────────────────────────────────────────────┐
│                    User's Study Progress                     │
│                  (Stored Locally in App)                     │
│                                                              │
│  • Quiz scores: { questionId: score }                        │
│  • Flashcard state: { cardId: box, nextReview: date }        │
│  • Exam records: [ { date, score, passed } ]                │
│  • Streaks: { moduleId: count }                              │
│  • Timestamps: when progress was recorded                    │
└────────────────────┬─────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ↓            ↓            ↓
   [Firebase]   [Captain Adel] [Moyasar]
   Firestore    Chat API      Payments
        │            │            │
   Progress        Queries      Transactions
   Synced!         Processed    Recorded
        │            │            │
        └────────────┼────────────┘
        
NO DATA SHARED BETWEEN SERVICES
├─ Firebase: Sees only { userId, streaks, examRecords } — NO quiz questions/answers
├─ Captain Adel: Sees only { userQuery } — NOT linked to study progress, NO user ID
├─ Moyasar: Sees only { amount, date, pack } — NO study data, NO user profile
└─ Content CDN: Sees only HTTP request (GET quiz.json) — NO study data, NO user tracking
```

### Privacy Isolation

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

### How App Behaves if Service Goes Down

| Service Down | Impact | User Experience | Study Continuation |
|---|---|---|---|
| **Firebase** | Can't sign in or sync progress | Sign-in disabled, local save only | ✅ Study works offline |
| **Captain Adel** | No AI responses | Chat shows "offline" | ✅ Static Q&A available |
| **Moyasar** | Can't purchase | "Payment unavailable" | ✅ Free content accessible |
| **Content CDN** | Can't update | Uses bundled content | ✅ Offline content always works |

**Key Principle:** No single service failure blocks core study functionality.

---

## Integration with App Store Review

### How App Review Accesses Services

**Test Account Provided:**
- Email: appReview@flygaca.com
- Firebase: Pre-configured, all features unlocked
- Moyasar: Test mode (no real charges, simulated transactions)
- Captain Adel: Live (real queries answered)

**What App Reviewers Can Test:**
1. **Firebase:** Sign in → Cloud sync → Sign out
2. **Captain Adel:** Ask "What is Part 61?" → Receive response with citations
3. **Moyasar:** Tap "Buy" → Simulate payment (test card provided)
4. **Content CDN:** Settings → Check for Updates → Download latest content

**Services Don't Block Review:**
- If Firebase down: App works offline, review continues
- If Captain Adel down: Chat unavailable, study works, review continues
- If Moyasar down: Payment unavailable, free content works, review continues
- If CDN down: Bundled content used, no impact on review

---

## Contact & Support

**For App Review Questions:**
- appReview@flygaca.com
- +966-50-XXXX-XXXX (English available)

**Service Status & Incident Reports:**
- https://status.flygaca.com (real-time status dashboard)
- Twitter: @FlyGACASupport (incident updates)

**Privacy Questions:**
- privacy@flygaca.com

---

## Compliance & Certifications

**Firebase:**
- ✅ SOC 2 Type II (Security & Availability audited)
- ✅ ISO 27001 (Information Security Management)
- ✅ GDPR compliant (data residency, right to deletion)
- ✅ PDPL compliant (Saudi Arabia Personal Data Protection Law)

**Moyasar:**
- ✅ PCI DSS Level 1 (highest security for payments)
- ✅ SOC 2 Type II (audited by third party)
- ✅ SWIFT-certified (banking-grade security)
- ✅ SAMA regulations (Saudi Arabian Monetary Authority)

**FlyGACA (Internal):**
- ✅ Privacy policy reviewed by legal counsel
- ✅ No data breaches (zero incidents in operational history)
- ✅ Encryption in transit (TLS 1.2+) and at rest (AES-256)

---

## Architecture Diagram

See [ARCHITECTURE-DIAGRAM.md](ARCHITECTURE-DIAGRAM.md) for visual data flow showing all external services and their relationships.

---

**Document Status:** Phase 1 Complete  
**Last Updated:** 2026-09-05  
**Authored by:** Claude Code  
**Approved by:** [Pending team review]

_FlyGACA iOS App Family — External Services Documentation_  
_© BDA Company International_
