# Architecture Diagram: Data Flows & System Components

**FlyGACA iOS App Family**  
**Offline-First Architecture with Optional Online Services**  
**Date:** 2026-09-05

---

## System Overview: Offline-First Design

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         iOS Device (Airplane Mode ✓)                    │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                 FlyGACA / ELPT / AIP App Shell                   │  │
│  │                        (SwiftUI Views)                           │  │
│  │                                                                   │  │
│  │  Tabs: Study | Tools | Regulations | Profile | Chat              │  │
│  └────────────────────────┬────────────────────────────────────────┘  │
│                           │ (UI interacts with local data & services) │
│  ┌────────────────────────▼────────────────────────────────────────┐  │
│  │                    FlyGACAKit (Local Swift Package)              │  │
│  │                   (Zero External Dependencies)                   │  │
│  │                                                                   │  │
│  │  ┌─ CoreModels ────────────────────────────────────────────┐    │  │
│  │  │ • Module, Quiz, Question, Calculator types             │    │  │
│  │  │ • Question.id hash (sha256 "bankID|prompt")            │    │  │
│  │  │ • Exam scoring (percent, pass/fail logic)              │    │  │
│  │  └────────────────────────────────────────────────────────┘    │  │
│  │                                                                   │  │
│  │  ┌─ StudyEngines ────────────────────────────────────────────┐  │  │
│  │  │ • Leitner SRS: boxes 0-5, intervals [0,1,3,7,14,30]     │  │  │
│  │  │ • Readiness: which questions due, mastery tracking      │  │  │
│  │  │ • Sampler: random or spaced selection                   │  │  │
│  │  │ • Session: quiz attempts, scoring, time tracking        │  │  │
│  │  │ • Streak: consecutive days, gap resets                  │  │  │
│  │  │ All in-memory (no I/O, 100% offline)                    │  │  │
│  │  └────────────────────────────────────────────────────────┘    │  │
│  │                                                                   │  │
│  │  ┌─ ContentKit ───────────────────────────────────────────────┐ │  │
│  │  │ • ContentLoader: Parse bundled JSON (quiz.json, etc.)    │ │  │
│  │  │ • ContentRefresher: Optional remote update via CDN       │ │  │
│  │  │ • CorpusSignatureVerifier: Validate Ed25519 signature   │ │  │
│  │  │ • Bundled: 1000+ questions, 74 GACAR parts (offline)    │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                                   │  │
│  │  ┌─ PersistenceKit ──────────────────────────────────────────┐ │  │
│  │  │ • SwiftData @Models (SRS state, exam records, streaks)   │ │  │
│  │  │ • StudyStore (Sendable @ModelActor, single write path)   │ │  │
│  │  │ • App Group container (group.com.FlyGACA — shared)       │ │  │
│  │  │ • Encrypted at rest (iOS platform default)               │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                                   │  │
│  │  ┌─ AppServices ─────────────────────────────────────────────┐ │  │
│  │  │ • Protocol seams (Auth, Payments, Chat, Sync)            │ │  │
│  │  │ • Mocks (offline-ready, 100% deterministic)              │ │  │
│  │  │ • UI talks only to protocols, never implementations       │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                                   │  │
│  │  ┌─ PlatformLive (Built but Not Wired Yet) ────────────────┐ │  │
│  │  │ • FirebaseAuthService (OAuth 2.0)                        │ │  │
│  │  │ • FirebaseProgressSync (Firestore upload)                │ │  │
│  │  │ • CaptainAdelSSEClient (streaming chat)                  │ │  │
│  │  │ • MoyasarPaymentService (payment processing)             │ │  │
│  │  │ Injection point: composition root (FlyGACAApp.swift)     │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                                   │  │
│  │  ┌─ FeatureUI ───────────────────────────────────────────────┐ │  │
│  │  │ • Every screen, every component (SwiftUI)                │ │  │
│  │  │ • SingleModuleRootView (per-app root)                    │ │  │
│  │  │ • All screens work offline (no network requirement)      │ │  │
│  │  └────────────────────────────────────────────────────────┘ │  │
│  │                                                                   │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │  Bundled Content (Read-Only Resources)                           │  │
│  │                                                                   │  │
│  │  apple/Apps/{ELPT,AIP,Flagship}/Content/                         │  │
│  │  ├── module.json ──→ Pack metadata, content version hash         │  │
│  │  ├── quiz.json ────→ 1000+ questions (offline)                  │  │
│  │  ├── groundschool.json ─→ Lessons (optional)                    │  │
│  │  └── paths-index.json ──→ Study paths (optional)                │  │
│  │                                                                   │  │
│  │  Size: ~152 KB across both apps (minimal)                        │  │
│  │  Updated: Via scripts/sync-content.sh from monorepo             │  │
│  │  Versioned: contentVersion field tracks source commit           │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │  Local Persistence (SwiftData)                                   │  │
│  │                                                                   │  │
│  │  @Model classes (encrypted, app-group container):               │  │
│  │  ├── StudyProgress: { moduleId, quizBest, examRecords }        │  │
│  │  ├── Flashcard: { questionId, box, nextReview }                 │  │
│  │  ├── Streak: { moduleId, count, lastDate }                      │  │
│  │  ├── ExamAttempt: { date, score, questionStates }               │  │
│  │  └── Entitlements: { FullAccess, packs unlocked }              │  │
│  │                                                                   │  │
│  │  Access via: StudyStore (Sendable @ModelActor)                  │  │
│  │  Write path: Only through StudyStore actor (thread-safe)        │  │
│  │  Survives app restart (persistent, local device only)           │  │
│  │  Cleared manually: Settings → Storage → Clear All               │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
              ↑ ↓ (Optional internet connection, if available)
    ┌─────────┴─────────┐
    │                   │
    ▼                   ▼
[ONLINE SERVICES — All Optional, Fail-Safe]
```

---

## Data Flow: Quiz Attempt (Illustrating Offline-First Design)

```
User taps "Attempt Quiz"
  │
  ├─→ [Read] quiz.json (bundled, offline, local)
  │     ├─→ Parse questions array
  │     └─→ Decode CoreModels.Question (safe, validated JSON)
  │
  ├─→ [Read] StudyStore (SwiftData, local device)
  │     └─→ Fetch: "Which questions has this user seen before?"
  │
  ├─→ [Run] StudyEngines.Sampler (in-memory, zero I/O)
  │     ├─→ Filter questions (user's readiness level)
  │     ├─→ Sort by due date (SRS ordering)
  │     └─→ Return 10 random or spaced questions
  │
  └─→ [Display] Quiz UI (SwiftUI, local rendering)
        ├─→ Show question text
        ├─→ Show 4 answer options
        └─→ User taps answer
          │
          ├─→ [Record] Answer in memory
          │     └─→ QuestionState { questionId, selectedIndex, responseTime }
          │
          ├─→ [Compute] Score (in-memory)
          │     └─→ Correct/incorrect instant feedback
          │
          ├─→ [Repeat] For remaining 9 questions
          │     └─→ Same process as above
          │
          └─→ [Quiz Complete]
                ├─→ Final score: percent = round(correct/total × 100)
                │
                ├─→ [Compute] SRS progression
                │     └─→ Correct → promote to next box (capped at box 5)
                │     └─→ Wrong → reset to box 0
                │
                └─→ [Write] StudyStore (persist to SwiftData)
                      ├─→ Save quiz scores
                      ├─→ Update flashcard state
                      ├─→ Update streak (same day = unchanged, gap = reset)
                      └─→ Flush to device storage (encrypted)

RESULT: ✅ Quiz works 100% offline
        ✅ No network call needed
        ✅ Progress saved locally
        ✅ When internet available → Optional sync to Firebase
```

---

## Data Flow: Cloud Sync (Optional, If User Signed In)

```
✅ App has internet connection
✅ User signed in to Firebase (optional)
└─ StudyStore has queued progress updates
  │
  └─→ [Read] Queued progress from StudyStore
        ├─→ Quiz scores
        ├─→ Flashcard states
        ├─→ Exam records
        └─→ Streaks
  │
  └─→ [Serialize] to ProgressSummary JSON
        {
          userId: uid,
          timestamp: "2024-01-15T10:30:00Z",
          quizBest: { "questionId1": 100, "questionId2": 50 },
          streaks: { "elpt": 5, "aip": 3 },
          examRecords: [ { date, score, passed } ]
        }
  │
  └─→ [Encrypt] in app (optional, Firebase handles at-rest)
  │
  └─→ [POST] to Firebase Firestore
        https://firestore.googleapis.com
        ├─→ PUT /users/{uid}/progress/summary
        ├─→ Authenticated with Firebase JWT
        └─→ TLS encrypted in transit
  │
  └─→ Firebase Response
        ├─→ ✅ 200 OK → Sync success
        │     └─→ Clear queued updates (done)
        │
        └─→ ❌ Network error / 401 Unauthorized / Offline
              └─→ Keep updates queued (retry next launch)
                  App continues working normally

RESULT: ✅ Cloud sync optional (never blocks study)
        ✅ Queued updates survive app restart
        ✅ User can study offline, sync later
        ✅ If Firebase down, app fully functional
```

---

## Data Flow: Content Refresh (Optional, If Online)

```
On app launch (if internet available)
  │
  └─→ [Check] "Do I have quiz.json cached?"
        │
        ├─→ YES, cache exists:
        │     ├─→ [Read] ETag from last refresh
        │     │
        │     └─→ [GET] https://flygaca.com/data/quiz.json
        │           ├─→ Header: If-None-Match: [ETag]
        │           │
        │           ├─→ Server response 304 Not Modified
        │           │     └─→ [Use] Cached version (no download)
        │           │
        │           └─→ Server response 200 OK (content changed)
        │                 ├─→ [Download] new quiz.json + quiz.json.sig
        │                 │
        │                 ├─→ [Verify] Ed25519 signature
        │                 │     ├─→ Read FGCorpusPublicKey from Info.plist
        │                 │     ├─→ Compute signature over quiz.json bytes
        │                 │     │
        │                 │     ├─→ Signature valid? ✅ YES
        │                 │     │     └─→ [Save] new version
        │                 │     │     └─→ [Update] ETag
        │                 │     │     └─→ [Use] new content
        │                 │     │
        │                 │     └─→ Signature invalid? ❌ NO
        │                           └─→ [Reject] new content
        │                           └─→ [Use] cached version
        │                           └─→ (Fail closed — security first)
        │
        └─→ NO cache:
              ├─→ [GET] https://flygaca.com/data/quiz.json
              │     ├─→ No If-None-Match header
              │     │
              │     └─→ [Download] full content
              │           ├─→ Same signature verification as above
              │           └─→ [Save] with ETag
              │
              └─→ Network error / CDN down
                    └─→ [Use] bundled offline content
                          └─→ No error shown (transparent fallback)

RESULT: ✅ Bundled content always available (offline)
        ✅ Remote updates optional (check on each launch)
        ✅ ETag prevents redundant downloads
        ✅ Signature ensures tampering detection
        ✅ If CDN down → App works 100% offline
```

---

## Data Flow: Captain Adel AI Chat (Online Only, Optional)

```
✅ Internet available
└─ User taps Chat tab, types: "What is Part 61?"
  │
  └─→ [Check] Online status (NetworkMonitor)
        ├─→ ✅ Internet available
        │     └─→ [Proceed] to streaming chat
        │
        └─→ ❌ No internet
              └─→ [Show] "Offline" state
              └─→ [Offer] Static Q&A library
  │
  └─→ [Gather] conversation history (current session only)
        {
          messages: [
            { role: "user", content: "What is Part 61?" },
            { role: "assistant", content: "Part 61 covers Certification..." }
          ],
          sessionToken: "[random]"
        }
  │
  └─→ [POST] to Captain Adel API
        https://flygaca.com/api/chat
        ├─→ Content-Type: application/json
        ├─→ Authorization: Bearer [sessionToken]
        └─→ Body: { messages, modelId: "gaca-pilot-grounded" }
  │
  └─→ Captain Adel Service (FlyGACA backend)
        ├─→ Parse query for GACA keywords
        ├─→ Retrieve relevant regulations (local corpus)
        ├─→ Generate response grounded in GACAR text
        ├─→ Stream response as Server-Sent Events (SSE)
        │
        └─→ Response format:
              data: "Part"
              data: " 61"
              data: " covers"
              data: " Certification"
              ...
  │
  └─→ [Receive] SSE stream
        └─→ [Display] text in real-time (typing effect)
  │
  └─→ [Store] chat in memory (current session only)
        └─→ No persistent chat history
        └─→ Cleared when app restarts or user navigates away

RESULT: ✅ Chat online-only (transparent to user if offline)
        ✅ Session-isolated (no cross-app tracking)
        ✅ Queries not logged with user ID
        ✅ No training on user data
```

---

## Data Flow: Payment (Online Only, Optional)

```
✅ Internet available
└─ User taps "Buy ELPT"
  │
  ├─→ [Check] Online status
  │     ├─→ ✅ Internet → [Proceed]
  │     └─→ ❌ Offline → [Show] "Payment requires internet"
  │
  ├─→ [Present] Moyasar payment form
  │     ├─→ Options: Mada card, Apple Pay, credit card
  │     └─→ User selects payment method
  │
  ├─→ [Tokenize] payment info (Apple handles encryption)
  │     └─→ App never sees full card number
  │     └─→ Apple returns one-time token
  │
  ├─→ [POST] to Moyasar API
  │     https://api.moyasar.com/v1/payments
  │     {
  │       amount: 79000,  // SAR 79 in fils
  │       currency: "SAR",
  │       source: { type: "apple_pay", token: "[tokenized]" },
  │       callback_url: "https://flygaca.com/checkout/callback"
  │     }
  │
  ├─→ Moyasar Service (PCI DSS Level 1 compliant)
  │     ├─→ Process with Mada/card networks
  │     └─→ Return transaction ID (txn_XXXXXXX)
  │
  ├─→ [Receive] Response
  │     ├─→ Success: { status: "completed", id: "txn_XXXXXXX" }
  │     │     └─→ [Unlock] ELPT pack
  │     │     └─→ [Update] Firebase user doc (entitlements)
  │     │     └─→ [Display] receipt
  │     │
  │     └─→ Failure: { status: "failed" }
  │           └─→ [Show] error message
  │           └─→ [Allow] retry
  │
  └─→ [Webhook] Verification (async)
        └─→ Moyasar POSTs to https://flygaca.com/checkout/callback
              ├─→ Verifies transaction authenticity
              ├─→ Confirms purchase in Firebase
              └─→ Persists transaction record

RESULT: ✅ Payment online-only (transparent if offline)
        ✅ Card data never touches app (Moyasar handles)
        ✅ Transaction record persisted (auditability)
        ✅ No recurring charges (manual purchase each time)
```

---

## Component Dependencies (No Circular Refs)

```
┌────────────────────────────────────────────────┐
│ FlyGACAKit Dependency Graph (Clean Layers)     │
└────────────────────────────────────────────────┘

FeatureUI (UI Layer)
  ↑ ↓
  Depends on: AppServices (protocols), PersistenceKit, ContentKit, StudyEngines
  
PersistenceKit (Persistence Layer)
  ↑ ↓
  Depends on: CoreModels, StudyEngines, AppServices
  
ContentKit (Content Layer)
  ↑ ↓
  Depends on: CoreModels
  
PlatformLive (Service Implementation — Not Wired Yet)
  ↑ ↓
  Depends on: CoreModels, AppServices, PersistenceKit
  ✅ No dependency from AppServices to PlatformLive (protocol seam)
  
StudyEngines (Business Logic Layer)
  ↑ ↓
  Depends on: CoreModels (no I/O)
  
AppServices (Protocol Layer)
  ↑ ↓
  Depends on: CoreModels only
  ✅ No implementation details (protocol definitions only)
  
CoreModels (Domain Layer)
  ↑ ↓
  Depends on: Nothing (foundation)

✅ NO CIRCULAR DEPENDENCIES
✅ CLEAR LAYER SEPARATION
✅ EVERY SCREEN PREVIEWABLE (Mocks)
✅ SWIFT TEST INSTANT (No I/O in domain logic)
```

---

## Cross-App Data Sharing (App Group)

```
iOS Device Storage
  │
  ├── App Container: com.flygaca.app (Flagship)
  │     └─ Library/Application Support/default.store/
  │          └─ SQLite database (SwiftData)
  │               └─ StudyProgress, Flashcards, Streaks, Exams
  │
  ├── App Container: com.flygaca.elpt (ELPT)
  │     └─ Library/Application Support/default.store/
  │          └─ SQLite database (SwiftData)
  │               └─ Shared by App Group ↓
  │
  ├── App Container: com.flygaca.aip (AIP)
  │     └─ Library/Application Support/default.store/
  │          └─ SQLite database (SwiftData)
  │               └─ Shared by App Group ↓
  │
  └── App Group Container: group.com.FlyGACA (Shared)
        └─ Shared data (all 3 apps read/write)
             ├─ StudyProgress (unified SRS state)
             ├─ Flashcard states (shared Leitner boxes)
             ├─ Exam records (user can see progress across apps)
             ├─ Streaks (consistent across ELPT ↔ AIP ↔ Flagship)
             └─ Entitlements (purchase in ELPT unlocks content in AIP)

How It Works:
  1. User opens ELPT, studies for 5 minutes, completes 2 quizzes
     → Progress written to group.com.FlyGACA container
  
  2. User switches to AIP app
     → AIP reads SAME container (no re-sync needed)
     → AIP sees: "ELPT streak: 5 days, quiz scores: 100%, 80%"
  
  3. User taps "Buy" in AIP, purchases SAR 139 bundle
     → Entitlements written to shared container
  
  4. User switches back to Flagship
     → Flagship reads shared container
     → Flagship sees: All purchases, all study progress, all streaks
  
Result: ✅ Study progress syncs across apps (no network needed)
        ✅ Purchases apply app-family-wide
        ✅ Streaks carry across module switches
        ✅ One unified study history, not per-app silos
```

---

## Offline-First Principle in Action

```
┌─────────────────────────────────────────────────────────────┐
│                    User Scenario                            │
└─────────────────────────────────────────────────────────────┘

Day 1: User studies offline (airplane, remote area)
  ├─ Quizzes: ✅ Works (bundled content, SRS computation)
  ├─ Flashcards: ✅ Works (local SwiftData)
  ├─ Calculators: ✅ Works (in-memory math)
  ├─ GACAR Search: ✅ Works (bundled regulations)
  ├─ Cloud Sync: ❌ Skipped (no internet)
  ├─ Captain Adel: ❌ Offline (static Q&A available)
  └─ Payments: ❌ Offline (warning shown)
  
  Progress SAVED LOCALLY (not lost)

Day 2: User returns to wifi
  ├─ App launches
  ├─ Detects: Internet now available
  ├─ [Auto-syncs] queued progress to Firebase
  │    └─ Quiz scores from Day 1
  │    └─ Flashcard state
  │    └─ Streaks
  │    └─ Exam records
  ├─ [Checks] for content updates (quiz.json)
  │    └─ Verifies signature
  │    └─ Updates if newer version available
  └─ User continues studying
       ├─ All features (Cloud Sync, Captain Adel, Payments) now available
       └─ No interruption or lost progress

Key Points:
  ✅ No internet required to be productive
  ✅ All local data persisted
  ✅ Cloud sync is opportunistic (not blocking)
  ✅ Study experience is consistent offline or online
  ✅ No user interaction required for sync (automatic)
```

---

## Summary: Why This Architecture Matters

| Principle | Benefit | How It Serves Guideline 2.1 |
|-----------|---------|---------------------------|
| **Offline-First** | Works 100% without internet; study never blocked | Proves app delivers value without external services |
| **Protocol Seams** | UI never depends on Firebase/Moyasar/Captain Adel | Demonstrates external services are optional enhancements |
| **Content Bundling** | 1000+ GACAR questions always available | Proves regulatory content is not server-dependent |
| **Local Persistence** | SwiftData never loses progress | User trust: data belongs to device, not cloud |
| **Zero SDK Deps** | No Firebase SDK, Moyasar SDK, or payment library in code | Proves services are pluggable, not essential |
| **App Group Sharing** | Progress syncs across 3 apps without cloud | Cross-platform parity without external sync |
| **Fail Closed** | Content refresh rejects bad signatures; CDN down = offline | Security-first design; graceful degradation |

---

**Document Status:** Phase 1 Complete  
**Last Updated:** 2026-09-05  
**Authored by:** Claude Code  
**Approved by:** [Pending team review]

_FlyGACA iOS App Family — Architecture Diagram_  
_© BDA Company International_
