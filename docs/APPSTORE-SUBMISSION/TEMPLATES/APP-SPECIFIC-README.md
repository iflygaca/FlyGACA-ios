# App-Specific Submission Documentation Template
## [MODULE-NAME] Module

**Template for App Store Submission Documentation**  
**Guidance: Adapt this template for new module launches (PPL, CPL, IR, ATPL)**  
**Date:** 2026-09-05

---

## Overview

This template provides a structured guide for preparing App Store submission documentation specific to a new FlyGACA study module. Use this to organize and document per-app details for submission to App Store Review.

**Key Principle:** All content, functionality, and regulatory compliance documentation specific to a module belongs in this roadmap. Shared documentation (external services, architecture, regional parity) is referenced, not duplicated.

---

## Module Information

| Property | Value |
|----------|-------|
| **Module Name** | [MODULE-NAME] |
| **Bundle ID** | `com.flygaca.[module-id]` |
| **Short Name** | [SHORT-NAME] (e.g., "Prepare for your [MODULE-NAME]") |
| **Category** | Education |
| **Content Rating** | 4+ |
| **Minimum iOS Version** | 17.0 |
| **Supported Devices** | iPhone (universal app) |
| **Release Date (Planned)** | [DATE] |

---

## App Purpose & Target Audience

### What the App Does
[WRITE: 1-2 sentence description of what the app teaches. Example: "FlyGACA PPL is a complete ground school and study companion for Private Pilot License candidates in Saudi Arabia, combining GACAR regulations, 900+ practice questions, spaced-repetition flashcards, and a 3-hour timed mock exam."]

### Target Audience
[LIST each audience segment with a brief description:]
- **Student Pilots:** Preparing for [MODULE-NAME] license exam; need practical study tools
- **Flight Instructors:** Verify student knowledge, teach regulatory material
- **Cadets:** At Saudi flight schools, use in classrooms and for independent study
- **Licensed Crew:** Staying current with regulations

### Problem Solved
[DESCRIBE the core problem this app solves. Example: "Finding and studying the right GACAR sections for a specific exam is slow and error-prone. FlyGACA bundles only the relevant material, delivers it offline, and tracks progress with spaced repetition so students study smarter, not harder."]

### Key Value Propositions
1. [VALUE 1] — [Brief explanation]
2. [VALUE 2] — [Brief explanation]
3. [VALUE 3] — [Brief explanation]

---

## Feature Walkthrough

### Primary Features

#### 1. **Ground School Lessons (Optional)**
- [DESCRIBE: Is ground school included? How many lessons? What topics?]
- Study path: Linear progression, or free-form selection?
- Offline availability: Yes (all bundled)
- Estimated time: [HOURS/MINUTES] to complete

#### 2. **Quiz Bank**
- **Size:** [NUMBER] questions across [NUMBER] topics
- **Difficulty:** [DESCRIBE: Progressive difficulty? Mixed? Per-topic variance?]
- **Scoring:** Instant feedback, percent score, detailed explanations with GACAR citations
- **Offline availability:** Yes (all bundled)
- **Typical session:** [NUMBER] questions, [NUMBER-NUMBER] minutes

#### 3. **Flashcard Study (Leitner Spaced Repetition)**
- **Coverage:** Questions drawn from quiz bank
- **SRS Algorithm:** 6 boxes (0-5), intervals [0, 1, 3, 7, 14, 30] days
- **Streak Tracking:** Consecutive days studied; resets on gap
- **Progress Visualization:** Box distribution, mastery percentage, streak count
- **Offline availability:** Yes (all local)
- **Typical session:** [NUMBER] cards, [NUMBER-NUMBER] minutes

#### 4. **Mock Exam (Timed Scored Simulation)**
- **Duration:** [NUMBER] minutes (optional: untimed practice mode)
- **Questions:** [NUMBER] questions, randomized order
- **Scoring:** Percent score, pass/fail (passing score [NUMBER]%)
- **Performance Analytics:** Score history, progress trends, weak areas
- **Offline availability:** Yes (all local)
- **Attempt frequency:** [NUMBER] attempts (unlimited practice, or [LIMIT] for full mock)

#### 5. **Regulations Reference (GACAR/AIP/Handbooks)**
- **Coverage:** [NUMBER] GACAR parts, [NUMBER] topical handbooks
- **Search:** Full-text search across all regulations
- **Navigation:** Table of contents, section links, cross-references
- **Bilingual:** English (LTR, Inter font) and Arabic (RTL, Cairo font)
- **Offline availability:** Yes (bundled at build time)

#### 6. **Captain Adel AI Flight Instructor (Optional, Online-Only)**
- **Availability:** When internet available
- **Interaction:** Type questions (e.g., "What is Part 61?"), receive GACAR-grounded responses
- **Response style:** Exact citations to GACAR sections
- **Offline fallback:** Static Q&A library (pre-written answers)
- **Session model:** Conversation history cleared on app close

#### 7. **Flight Calculators (Optional)**
- **Count:** [NUMBER] calculators (e.g., crosswind, weight & balance, E6B)
- **Use cases:** Solve flight planning problems
- **Offline availability:** Yes (all in-app)
- **Input:** Numerical (wind speed, aircraft weight, fuel, etc.)
- **Output:** Real-time calculations and visual aids

#### 8. **Settings & Preferences**
- **Sign In:** Optional Firebase email/phone sign-in (not required for study)
- **Language Toggle:** Switch between English and Arabic (RTL layout changes)
- **Cloud Sync:** Cloud backup of quiz scores, streaks, exam records (if signed in)
- **Data Management:** Clear local data, view sync status
- **App Info:** Version number, disclaimer, privacy policy, support contact

### Secondary Features

[ADD any other features specific to this module, e.g.:
- Video explanations of complex topics
- Scenario-based learning modules
- Instructor tools (track student progress, assign homework)
- Integration with flight school scheduling systems
]

---

## Feature Availability Matrix

| Feature | Free | Paid | Offline | Online-Only |
|---------|------|------|---------|-------------|
| Ground School Lessons | [YES/LIMITED] | ✅ | ✅ | ❌ |
| Quiz Bank | [NUMBER] Q | ✅ All | ✅ | ❌ |
| Flashcards (SRS) | [YES/LIMITED] | ✅ | ✅ | ❌ |
| Mock Exams | [NUMBER] | ✅ | ✅ | ❌ |
| GACAR/AIP Search | ✅ | ✅ | ✅ | ❌ |
| Captain Adel Chat | Static Q&A | ✅ | ❌ | ✅ |
| Flight Calculators | [LIMITED] | ✅ | ✅ | ❌ |
| Cloud Sync | ❌ | ✅ | ❌ | ✅ |
| Settings & Language | ✅ | ✅ | ✅ | ❌ |

---

## Billing & Entitlements

### Pricing Model
[DESCRIBE: Paid upfront? Freemium with in-app purchase? Subscription?]

### Packs/Bundles
| Pack Name | Price | Contents | Duration |
|-----------|-------|----------|----------|
| [PACK 1] | SAR [PRICE] | [CONTENTS] | Lifetime/[DURATION] |
| [PACK 2] | SAR [PRICE] | [CONTENTS] | Lifetime/[DURATION] |
| [BUNDLE] | SAR [PRICE] | All packs | Lifetime |

### Purchase Flow
1. User taps "Upgrade to [PACK]"
2. App presents Moyasar payment form (Mada, Apple Pay, credit card)
3. User selects payment method
4. Payment processed securely (no card data in app)
5. Transaction verified via Moyasar callback
6. Pack unlocked immediately (local device + cloud backup if signed in)
7. Receipt displayed and emailed

### No Subscription Charges
- Each purchase is one-time (no auto-renewal)
- User explicitly taps "Buy" for each purchase
- Refunds available within 14 days (Moyasar policy)

---

## Offline Functionality

### 100% Offline Features
- ✅ All quiz banks (1000+ questions)
- ✅ Flashcard study (Leitner SRS)
- ✅ Mock exams (timed or untimed)
- ✅ GACAR/AIP regulations (full-text search)
- ✅ Flight calculators
- ✅ Progress tracking (local device only)
- ✅ Language toggle (EN/AR)

### Online-Only Features (Graceful Degradation)
- ⚠️ Captain Adel Chat (falls back to static Q&A library)
- ⚠️ Cloud Sync (progress queued, syncs when internet returns)
- ⚠️ Payment/In-App Purchases (unavailable, shown gracefully)

### Offline Scenario
1. User enables Airplane Mode (or has no internet)
2. App launches, detects no internet
3. All offline features fully functional
4. Chat tab shows "Offline" badge (Captain Adel unavailable)
5. Payment button unavailable (but not blocking study)
6. User studies normally; progress saved locally
7. When internet restored: Auto-sync queues progress to Firebase
8. No data lost; seamless experience

---

## Bilingual Support (English & Arabic)

### English Version
- **Font:** Inter (system default, optimized readability)
- **Layout:** LTR (Left-to-Right)
- **Text Direction:** All text flows left → right
- **Numbers:** LTR (time 10:30, altitude 5000 ft, coordinates all LTR)
- **All features:** Fully available in English

### Arabic Version (العربية)
- **Font:** Cairo (RTL-optimized, supports GACAR terminology)
- **Layout:** RTL (Right-to-Left) — entire UI mirrors horizontally
- **Text Direction:** All text flows right → left
- **Numbers:** LTR (time 10:30, altitude 5000 ft, coordinates stay LTR — never RTL)
- **All features:** Fully available in Arabic
- **Disclaimer:** Exact translation of English version, no content omission

### Language Toggle
- **Location:** Settings → Language
- **Options:** English (EN) or العربية (AR)
- **Persistence:** Choice saved across app restarts
- **Effect:** Immediate — all UI text changes when toggled
- **Testing:** Toggle tested on real device in both directions

### Regulatory Parity
- **GACAR Content:** Identical across languages (same regulations, not paraphrased)
- **Quiz Questions:** Same questions in both languages (exact translation)
- **Exam Scoring:** Same algorithm, pass marks, time limits in both languages
- **Progress Tracking:** Streaks, SRS boxes, scores shared (not language-specific)

---

## Disclaimer & Regulatory Certification

### Disclaimer Text (English)
```
Fly GACA is an independent educational reference for civil aviation in the 
Kingdom of Saudi Arabia. It is not affiliated with, endorsed by, or operated 
by the General Authority of Civil Aviation (GACA) or the Government of Saudi 
Arabia.

All GACAR content (General Authority of Civil Aviation Regulations) is sourced 
directly from official GACA publications and presented without modification or 
editorial interpretation.

This app is a study aid, not an official GACA product or tool. The GACA is 
always the authoritative source for current regulations. Before relying on 
any information in this app for operational use, verify the current text at 
gaca.gov.sa.

This app is NOT for operational use in flight. Use only for ground study and 
theoretical knowledge preparation.
```

### Disclaimer Text (Arabic)
```
[EXACT ARABIC TRANSLATION OF ABOVE]
[Ensure translator is familiar with aviation terminology]
[Verify word-for-word accuracy against English version]
[Maintain same tone: clear, direct, non-promotional]
```

### Disclaimer Placement
- **On Launch:** Shown once per app session (dismissible via "I Understand" button)
- **In Settings:** Full disclaimer visible in both languages
- **In App Store Listing:** Reference to disclaimer in description
- **Verification:** Reviewed by legal counsel before submission

### Regulatory Certification
✅ All GACAR content sourced directly from gaca.gov.sa  
✅ Content not modified or paraphrased (exact citations)  
✅ No editorial interpretation or FlyGACA commentary mixed with regulations  
✅ Bilingual disclaimer in both English and Arabic  
✅ Immutability proof (Ed25519 signature verification for remote updates)  
✅ Content version tracking (links to specific monorepo commit)

---

## Cross-App Progress Sync

### Shared App Group
- **App Group ID:** `group.com.FlyGACA` (fixed, cannot change)
- **Shared Data:** Study progress across [MODULE-NAME], ELPT, AIP, and future modules
- **Sync Mechanism:** App Group container (no internet required)

### Unified Study History
When user installs and studies in multiple modules:
1. **ELPT App:** User studies 5 days, earns streak in ELPT module
2. **AIP App:** User switches to AIP, sees ELPT streak in Settings
3. **Flagship App:** If installed, shows unified progress across all modules
4. **Offline Sync:** All progress shared via App Group (local, no cloud required)

### Benefits
- ✅ User doesn't re-study same questions across modules
- ✅ Streaks carry across module switches
- ✅ Progress visible across any installed app
- ✅ No internet required for cross-app sync
- ✅ Purchases in one app unlock content in all apps

---

## App Store Submission Notes

### Demo Account (For App Review)
```
Email: appReview@flygaca.com
Firebase Account: Pre-configured, all features unlocked
All Services: Available for testing (Firebase, Captain Adel, Moyasar, CDN)
Password: Secured in 1Password (provided separately to Apple if needed)
```

### What to Expect During Review
1. **Launch:** Splash screen, disclaimer banner (EN/AR)
2. **Feature Test:** Quiz attempt (3-5 questions), flashcard study, mock exam
3. **Offline Test:** Enable Airplane Mode, verify all features work
4. **Bilingual Test:** Toggle to Arabic, verify RTL layout and Arabic text
5. **Sign-In Test:** Optional (can skip and study offline)
6. **Payment Test:** Tap "Buy" to see Moyasar form (test transaction available)

### Review Timeline
- **Initial Review:** Typically 24-48 hours
- **Resubmission:** If additional info requested, resubmit within 14 days
- **Expedited Review:** Not typically available; follow standard timeline

### Contact for Reviewer Questions
- **Email:** appReview@flygaca.com
- **Response Time:** Within 24 business hours
- **Issues:** Thorough troubleshooting steps provided

---

## Related Documentation

**Shared Across All Modules:**
- [README.md](../README.md) — Master navigation
- [GUIDELINE-2.1-COMPLIANCE.md](../GUIDELINE-2.1-COMPLIANCE.md) — Apple's 5 requirements mapping
- [EXTERNAL-SERVICES.md](../EXTERNAL-SERVICES.md) or [TEMPLATES/EXTERNAL-SERVICES-TEMPLATE.md](EXTERNAL-SERVICES-TEMPLATE.md) — Service inventory & data flows
- [REGULATED-CONTENT-CERTIFICATION.md](../REGULATED-CONTENT-CERTIFICATION.md) — GACA sourcing chain
- [ARCHITECTURE-DIAGRAM.md](../ARCHITECTURE-DIAGRAM.md) — System architecture & data flows
- [FEATURE-WALKTHROUGH.md](../FEATURE-WALKTHROUGH.md) — User flows (generic across modules)
- [DEMO-GUIDE.md](../DEMO-GUIDE.md) — Screen recording specs & scripts
- [TEST-ACCOUNTS.md](../TEST-ACCOUNTS.md) — Test account setup
- [REGIONAL-PARITY-VERIFICATION.md](../REGIONAL-PARITY-VERIFICATION.md) — Bilingual QA checklist
- [SCREENSHOTS-MANIFEST.md](../SCREENSHOTS-MANIFEST.md) — Screenshot rendering workflow

**Module-Specific (This Template):**
- APP-STORE-FORM-COMPLETION.md — Pre-filled form answers for this module
- SUBMISSION-READINESS-CHECKLIST.md — 5-phase gate verification for this module

---

## How to Adapt This Template

**For a New Module ([MODULE-NAME]):**

1. **Replace all placeholders:**
   - `[MODULE-NAME]` → "PPL", "CPL", "IR", or "ATPL"
   - `[module-id]` → Lowercase (e.g., "ppl", "cpl")
   - `[NUMBER]` → Actual quiz bank size, exam duration, etc.
   - `[PRICE]` → SAR amounts for packs
   - `[DATE]` → Planned launch date

2. **Customize features:**
   - Add/remove features specific to this module (ground school lessons, video, etc.)
   - Update quiz bank size, mock exam duration, calculator count
   - Adjust bilingual text if module has special terminology

3. **Cross-reference other docs:**
   - Link to EXTERNAL-SERVICES.md (or module-specific version)
   - Link to APP-STORE-FORM-COMPLETION.md for this module
   - Link to SUBMISSION-READINESS-CHECKLIST.md for this module

4. **Create companion files:**
   - Create `APP-STORE-FORM-COMPLETION.md` (pre-filled form answers)
   - Create `SUBMISSION-READINESS-CHECKLIST.md` (phase verification gates)
   - Create `DEMO-GUIDE.md` (module-specific video scripts)

5. **Version & ownership:**
   - Add module-specific footer with last updated date
   - Track version history for compliance audits
   - Maintain approval sign-offs

---

**Template Authorship:** Claude Code  
**Template Version:** 1.0  
**Effective Date:** 2026-09-05

_Use this template as a starting point for each new FlyGACA iOS study module. Adapt the feature list, pricing, and regulatory details to match the specific module's requirements. All external services and compliance standards must follow the same principles documented in the shared template library._
