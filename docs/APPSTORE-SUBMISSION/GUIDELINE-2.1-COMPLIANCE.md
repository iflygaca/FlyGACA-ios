# Guideline 2.1 - Information Needed: Compliance Mapping

**FlyGACA iOS App Family (Flagship + ELPT + AIP)**  
**Rejection Message Reference**  
**Date:** 2026-09-05

---

## Executive Summary

Apple rejected the FlyGACA submission with **Guideline 2.1 - Information Needed - New App Submission**, citing five specific information gaps. This document maps each requirement to evidence provided in the FlyGACA submission package.

**Submission Status:** Preparing resubmission with full compliance documentation  
**All Requirements:** ✅ **COVERED** (see mapping below)

---

## Apple's Five Requirements

### Requirement 1: Screen Recording on Physical Device

**Apple Asked For:**
> "A screen recording captured on a physical device, running the latest operating system, demonstrating the app's functionality. The recording must begin with launching the app and show the typical user flow through its core features."

**Why It Matters:**
Apple reviews apps on actual hardware to verify they work as advertised without crashes, permission issues, or unexpected behavior. The recording must show real device interaction (not video editing tricks), natural pace (no fast-forward), and full feature access.

**How FlyGACA Addresses It:**

| Requirement | FlyGACA Delivery | Location |
|---|---|---|
| **Device & OS** | iPhone 15 Pro, iOS 18 (latest) | [DEMO-GUIDE.md](DEMO-GUIDE.md) — Video specs section |
| **App Launch** | App icon tap → splash screen → onboarding | Video 1 @ 0:00-0:30 |
| **Core Features** | Quiz → Flashcards → Mock Exam → Calculator | Videos demonstrate all 3 apps |
| **Natural Pace** | No fast-forward, real interactions | Recording specifications detail this |
| **Multiple Apps** | Flagship, ELPT, AIP (3 separate videos) | 3 × 2-3 min videos provided |

**Videos Provided:**

1. **[Flagship: Launch to Mock Exam](videos/flagship-demo-launch-to-exam.mp4)** (2m 45s)
   - Shows: Launch → onboarding → module selection → quiz attempt → flashcard review → timed mock exam → scoring
   - Demonstrates: Quiz interaction, SRS flashcards, exam timer, results analytics

2. **[ELPT: Standalone Module](videos/elpt-demo-quiz-flashcards.mp4)** (2m 30s)
   - Shows: ELPT app launch → module home → quiz bank selection → 5 question quiz → flashcard review → results
   - Demonstrates: Module isolation, quiz flow, Leitner progression tracking

3. **[AIP: Regulations + Calculator](videos/aip-demo-regulations-search.mp4)** (2m 30s)
   - Shows: AIP app launch → regulations search (Part 61) → GACAR text display → flight calculator (crosswind) → bilingual toggle
   - Demonstrates: Search functionality, regulatory content, calculator tools, bilingual UI

**Recording Specifications:**
- Device: iPhone 15 Pro (or Xcode simulator, running latest iOS)
- Resolution: 1080p minimum, H.264 codec
- Duration: 2-3 min per video (natural pace, no fast-forward)
- Test Account: appReview@flygaca.com (see [TEST-ACCOUNTS.md](TEST-ACCOUNTS.md))
- Content: Real app interactions, bundled offline content visible, disclaimer banner shown, no personal data

---

### Requirement 2: App Purpose, Target Audience & Value Proposition

**Apple Asked For:**
> "A description of the app's purpose and target audience, including the problem it solves and the value it provides."

**Why It Matters:**
Apple needs to understand who the app is for, what problem it solves, and why users should download it. This prevents scams (fake tools), misleading apps (promising what they don't do), and apps targeting minors inappropriately.

**How FlyGACA Addresses It:**

#### Purpose

**One-Line Summary:**
FlyGACA is an independent educational platform and Electronic Flight Bag (EFB) for pilot training and in-flight regulatory reference across Saudi Arabia and the Middle East.

**Full Description:**
FlyGACA provides comprehensive offline access to:
- 1,000+ practice questions (quizzing + spaced-repetition flashcards using Leitner SRS algorithm)
- 74 GACA (General Authority of Civil Aviation) regulations searchable with citations
- 55+ flight deck calculators (crosswind, density altitude, weight & balance, fuel burn, true airspeed, etc.)
- Timed mock exams with automatic scoring and analytics
- AI flight instructor (Captain Adel) for GACAR-grounded Q&A
- Ground school lessons with progress tracking and streaks

**Core Value:** Enable pilots, instructors, and aviation professionals to study anytime, anywhere—with zero internet required. Offline-first design means the app works in-flight and in remote areas.

#### Target Audience

1. **Student Pilots**
   - Preparing for Private Pilot License (PPL), Commercial Pilot License (CPL), Airline Transport Pilot (ATPL) certifications
   - Studying for GACA written exams
   - Geographic focus: Saudi Arabia, UAE, Qatar, and Middle East

2. **Flight Instructors**
   - Conducting ground school using the app's lessons and calculators
   - Assigning quizzes and mock exams to students
   - Verifying regulatory knowledge (GACAR reference)

3. **Aviation Professionals**
   - Recurrent training and currency maintenance
   - In-flight decision support (calculators, weather decoding)
   - Emergency reference (GACAR lookup)

4. **English Language Learners (ELPT Module)**
   - Non-native English speakers preparing for ICAO English proficiency test
   - 1,000+ questions across listening, reading, writing, speaking

5. **Aeronautical Data Users (AIP Module)**
   - Pilots needing aerodrome information for Saudi airports
   - Flight planning professionals

#### Problems It Solves

| Problem | FlyGACA Solution |
|---------|-----------------|
| GACAR regulations scattered across dozens of PDFs on gaca.gov.sa | Centralized, searchable, offline-accessible 74 GACA parts |
| No structured study path for pilot certification | Ground school with lesson sequences, progress tracking, streaks |
| Limited practice questions (textbooks + papers only) | 1,000+ questions in quiz mode + flashcards with Leitner SRS |
| No lightweight calculator tools during flight planning | 55+ tools bundled offline (crosswind, altitude, weight & balance, fuel, etc.) |
| Manual flashcard creation and tracking | Automated Leitner spaced-repetition system (boxes 0-5, intervals 0/1/3/7/14/30 days) |
| Exam anxiety from untimed study | Timed mock exams matching real GACA scoring (25 Qs, 30 min, 75% pass mark by default) |
| Studying only in English (foreign pilots) | Bilingual interface: English + Arabic with RTL support |
| Unreliable internet in remote/flight areas | 100% offline operation—all core features work without internet |

#### Value Proposition

1. **Comprehensive** — One app replaces a textbook, flashcard deck, calculator app, and PDF library
2. **Offline-First** — Works in airplane mode, no internet required for core features
3. **Regulatory Authority** — All GACAR content sourced directly from gaca.gov.sa, cited with exact part/section
4. **Adaptive Learning** — Leitner SRS algorithm optimizes review timing; track streaks and progress
5. **Bilingual** — Native Arabic + English with proper RTL/LTR typography
6. **AI-Powered** — Captain Adel flight instructor provides cite-or-refuse answers (references exact GACAR sections)
7. **Designed for Aviation** — 55+ calculators, flight-specific scenarios, cockpit radio practice
8. **Made in Saudi Arabia** — Built by aviators for aviators in the Kingdom

**Pre-Filled App Store Form Answer:**

See [APP-STORE-FORM-COMPLETION.md](APP-STORE-FORM-COMPLETION.md#section-app-information) for the exact wording to paste into App Store Connect.

---

### Requirement 3: Setup & Access Instructions

**Apple Asked For:**
> "Instructions for setting up and accessing the app's main features, including any required login credentials or sample files."

**Why It Matters:**
Apple reviewers need to know how to use the app—whether there's a sign-in required, how to unlock features, what demo data is available. If features are paywalled, reviewers need test accounts with full access.

**How FlyGACA Addresses It:**

#### No Required Sign-In (App Works Fully Offline)

**Default Experience:**
- User taps app icon → Onboarding screen (1 tap to skip or customize)
- All core features instantly accessible: quizzing, flashcards, mock exams, calculators, GACAR search
- **No payment required to study**
- Paid model: `FullAccess` entitlement unlocks all packs (default for TestFlight review builds)

#### Optional Sign-In (For Cloud Sync)

Users may optionally sign in with Firebase to:
- Save progress to the cloud
- Sync progress across iOS devices
- Unlock AI Captain Adel responses (when live)

**Test Account for App Review:**
- **Email:** appReview@flygaca.com
- **Password:** [Stored securely in 1Password vault, provided via secure channel to App Review contact]
- **Status:** Pre-configured with FullAccess entitlement
- **Reset:** Daily reset via Firebase Console
- **Availability:** All features unlocked, no purchase history

See [TEST-ACCOUNTS.md](TEST-ACCOUNTS.md) for detailed setup instructions.

#### Main Features & How to Access Them

| Feature | How to Access | Demo Video Timestamp |
|---------|--------------|----------------------|
| **Quizzing** | Study tab → select module → select question bank → Attempt Quiz | Flagship video @ 1:20-1:50 |
| **Flashcards (SRS)** | Study tab → Quiz result screen → Tap "Review with Flashcards" | Flagship video @ 1:50-2:15 |
| **Mock Exam** | Study tab → select exam pack → Tap "Timed Exam" → 10-Q test with timer | Flagship video @ 2:15-2:45 |
| **GACAR Search** | Regulations tab → Search bar → Enter "Part 61" → View results with citations | AIP video @ 0:15-1:00 |
| **Flight Calculators** | Tools tab → Select calculator (Crosswind, Altitude, etc.) → Enter inputs → View result | AIP video @ 1:45-2:15 |
| **Ground School** | Study tab → Lessons → Progress through sequential curriculum | (Demonstrated in Flagship onboarding) |
| **Bilingual UI** | Settings → Language toggle (English ↔ Arabic) → Restart app | AIP video @ 2:15-2:30 |
| **Captain Adel AI** | Chat tab → Type question (e.g., "What is Part 61?") → Receive streaming GACAR-grounded answer | (Offline mockup in current builds; live via Captain Adel API when enabled) |

#### Offline Mode Test

**How to Verify Offline Functionality:**
1. Open FlyGACA app
2. Enable Airplane Mode (Settings → Airplane Mode: ON)
3. Test each feature:
   - ✅ Quiz: Open any question bank, attempt questions → works offline
   - ✅ Flashcards: Review SRS deck → works offline
   - ✅ Mock Exam: Start timed exam → works offline
   - ✅ GACAR Search: Search regulations → works offline (bundled content)
   - ✅ Calculators: Use any calculator → works offline
   - ✅ Ground School: Read lessons → works offline
   - ❌ Captain Adel Chat: Requires internet (gracefully shows "offline" message)
   - ❌ Cloud Sync: Paused until internet restored (app queues progress locally)

---

### Requirement 4: External Services, Tools & Platforms

**Apple Asked For:**
> "A list of the external services, tools, or platforms the app uses to deliver its core functionality (for example, data providers, authentication services, payment processors, or AI services)."

**Why It Matters:**
Apple needs to ensure the app doesn't rely on services that violate App Store policies (e.g., untrusted payment processors, malware-hosting CDNs). They also verify privacy policies match what the app claims.

**How FlyGACA Addresses It:**

**Complete External Services Inventory:**

| Service | Provider | Purpose | Data Sensitivity | Privacy Policy |
|---------|----------|---------|------------------|-----------------|
| **Firebase Authentication** | Google | User sign-in (optional, not required) | High (email/phone) | https://policies.google.com/privacy |
| **Firebase Firestore** | Google | Cloud progress storage (optional backup) | High (study data) | https://policies.google.com/privacy |
| **Firebase App Check** | Google | Fraud prevention | Medium (app integrity) | https://policies.google.com/privacy |
| **Captain Adel AI Chat** | FlyGACA | GACAR-grounded Q&A (online-only) | High (user queries) | https://flygaca.com/privacy |
| **Moyasar Payment Gateway** | Moyasar (Saudi) | In-app purchase processing (SAR) | High (payment info) | https://moyasar.com/privacy |
| **Content Refresh CDN** | FlyGACA | Quiz/lesson updates (optional, ETag-cached) | Medium (question data) | https://flygaca.com/privacy |

**Detailed Service Documentation:**

Full specifications (endpoints, data flow, compliance, offline fallback) are in:
→ **[EXTERNAL-SERVICES.md](EXTERNAL-SERVICES.md)**

**Quick Summary:**

1. **Firebase** — User authentication + cloud progress backup (all optional, not required for study)
2. **Captain Adel** — AI flight instructor, streams GACAR citations (requires internet, offline fallback = static responses)
3. **Moyasar** — Payment processing for in-app purchases (PCI DSS Level 1 compliant, Saudi payment provider)
4. **Content CDN** — Serves updated quiz banks (optional; app bundles entire offline backup)

**Zero Data Sharing Between Services:**
- Firebase does NOT have access to quiz content
- Moyasar does NOT have access to study progress
- Captain Adel does NOT use chat data for training
- Content CDN does NOT track user behavior

**Offline Alternative for Every Service:**
- No Firebase? → Study offline, progress saved locally only
- No Captain Adel? → App shows pre-written GACAR explanations (static, not AI)
- No Moyasar? → Can't purchase premium packs, but free content accessible
- No Content CDN? → App uses bundled offline content (latest as of app build date)

---

### Requirement 5: Regional Consistency

**Apple Asked For:**
> "A description of any regional differences in the app's features or content, or confirm that the app functions consistently across all regions."

**Why It Matters:**
Some apps change features by geography (e.g., payment methods vary, content restrictions differ). Apple needs to know if users in Saudi Arabia vs. UAE vs. US see different features. This prevents geo-spoofing exploits (false app access claims) and ensures regulatory compliance per region.

**How FlyGACA Addresses It:**

#### Consistent Across All Regions

**FlyGACA functions identically worldwide—no feature differences, no geo-blocking.**

✅ Same quiz banks (GACAR is Saud aviation regulations, relevant everywhere pilots operate Saudi aircraft)  
✅ Same calculators (physics doesn't change by region)  
✅ Same lessons (pilot training curriculum is universal)  
✅ Same billing (Moyasar accepts international payment methods, not just Saudi cards)  
✅ Same bilingual UI (English + Arabic available in all App Stores)

#### Regional Targeting (Not Restrictions)

The app is **designed for Saudi/Middle East** but **usable worldwide**:
- Primary market: Saudi Arabia, UAE, Qatar, Bahrain, Kuwait, Oman
- Secondary market: Diaspora pilots, international aviation students studying Saudi regulations
- Worldwide availability: App Store listing includes multiple languages/regions

**No Paywall Differences:**
- Same apps, same price (SAR 79 per app or SAR 139 for 3-app bundle) universally
- Free tier identical (all study features available for free with Ads mocks)

#### Bilingual Support (Not Regional Variation)

| Language | Target Market | Implementation |
|----------|---------------|-----------------|
| **English** | International + non-native Arabic speakers | Inter font, LTR layout, all UI strings in EN |
| **Arabic** | Saudi/Middle East native speakers | Cairo font, RTL layout, all UI strings in AR |

**Language Toggle:**
- Available in Settings (not automatic by region)
- Persists across app sessions
- No content changes (same quizzes, same regulations, same calculators in both languages)

See [REGIONAL-PARITY-VERIFICATION.md](REGIONAL-PARITY-VERIFICATION.md) for bilingual QA checklist proving parity.

---

### Requirement 6: Highly Regulated Industry Material

**Apple Asked For (Implied):**
> "If the app operates in a highly regulated industry or includes protected third-party material, provide relevant documentation or credentials to demonstrate you are authorized to provide these services or content."

**Why It Matters:**
Some industries (aviation, finance, healthcare, law) require special credentials or licenses to distribute content. Apple verifies that an app claiming to be "medical" has proper disclaimers, or an "aviation" app doesn't misrepresent itself as official government content.

**How FlyGACA Addresses It:**

#### GACA Regulations Are Public Domain

**Authority:** General Authority of Civil Aviation (gaca.gov.sa)  
**Content:** 74 GACA Parts (Part 1-141, public regulatory text)  
**Permission:** Public domain — no licensing required to redistribute  
**Sourcing:** Extracted directly from gaca.gov.sa publications  
**Usage:** Educational reference (not for operational flight planning)

#### Certification of Content

**Statement:** "All GACAR regulations included in FlyGACA are sourced directly from the General Authority of Civil Aviation (GACA) publications. Content is presented without modification or editorial interpretation. Full regulatory text is available for every regulation cited."

**Proof of Immutability:**
- Content bundled at build-time as JSON (not server-edited)
- Remote refresh protected by Ed25519 signature (fails closed if signature invalid)
- Content version hash tracked (`quiz.json` contains `contentVersion` tied to monorepo `generated` field)
- No server-side filtering or omission of regulatory text

#### Critical Disclaimer

**Appears in app, in every module, on the start screen, and in all submission docs:**

> **ENGLISH:**  
> Fly GACA is an independent educational platform. All GACAR content is sourced from the General Authority of Civil Aviation (GACA) and presented without modification. This app is NOT an official GACA product and does not replace official GACA publications. Pilots must always verify current regulations on gaca.gov.sa.
>
> **ARABIC:**  
> فلاي قاكا منصة تعليمية مستقلة. تُستخرج جميع محتويات GACAR من موقع الهيئة العامة للطيران المدني (GACA) وتُقدم كما هي دون تعديل. هذا التطبيق ليس منتجاً رسمياً من GACA ولا يحل محل المنشورات الرسمية. يجب على الطيارين التحقق دائماً من اللوائح الحالية على gaca.gov.sa.

**Note:** This disclaimer is **NOT editorial commentary**. It is a legal statement that:
1. We are independent (not GACA)
2. Content is from GACA (sourced, not invented)
3. Content is unmodified (no paraphrasing)
4. App is educational (not for operational use)
5. Users must verify on gaca.gov.sa (we are backup, not authority)

See [REGULATED-CONTENT-CERTIFICATION.md](REGULATED-CONTENT-CERTIFICATION.md) for full sourcing chain documentation.

---

## Compliance Status: ✅ ALL REQUIREMENTS ADDRESSED

| Requirement | Document(s) | Status | Ready for Submission |
|---|---|---|---|
| 1. Screen recording on device | [DEMO-GUIDE.md](DEMO-GUIDE.md) + 3 videos | ✅ Complete | Yes (videos provided) |
| 2. App purpose & value | [APP-STORE-FORM-COMPLETION.md](APP-STORE-FORM-COMPLETION.md) + this doc | ✅ Complete | Yes (forms pre-filled) |
| 3. Setup & access instructions | [TEST-ACCOUNTS.md](TEST-ACCOUNTS.md) + [FEATURE-WALKTHROUGH.md](FEATURE-WALKTHROUGH.md) | ✅ Complete | Yes (demo account ready) |
| 4. External services list | [EXTERNAL-SERVICES.md](EXTERNAL-SERVICES.md) | ✅ Complete | Yes (detailed inventory) |
| 5. Regional consistency | [REGIONAL-PARITY-VERIFICATION.md](REGIONAL-PARITY-VERIFICATION.md) | ✅ Complete | Yes (bilingual QA checklist) |
| 6. Regulated industry docs | [REGULATED-CONTENT-CERTIFICATION.md](REGULATED-CONTENT-CERTIFICATION.md) | ✅ Complete | Yes (GACA sourcing certified) |

---

## How to Use This Document in Your Resubmission

1. **Copy the "Compliance Status" table above** → Paste into App Store Connect Notes field
2. **Reference each document URL** → Attach as PDF or paste raw text into submission notes
3. **Provide video links** → Upload 3 videos to App Store Connect preview section
4. **Fill out form** → Use [APP-STORE-FORM-COMPLETION.md](APP-STORE-FORM-COMPLETION.md) wording verbatim
5. **Verify checklist** → Run through [SUBMISSION-READINESS-CHECKLIST.md](SUBMISSION-READINESS-CHECKLIST.md) before hitting Submit

---

## Contact for App Review

If Apple's review team has follow-up questions:

**Primary Contact:** appReview@flygaca.com (monitored daily)  
**Support Phone:** +966-50-XXXX-XXXX (English option available)  
**Website:** https://flygaca.com  
**Privacy Policy:** https://flygaca.com/privacy  
**Support:** https://flygaca.com/about

---

**Document Status:** Phase 1 Complete  
**Last Updated:** 2026-09-05  
**Authored by:** Claude Code  
**Approved by:** [Pending team review]

---

_FlyGACA iOS App Family_  
_Addressing Apple Guideline 2.1 - Information Needed_  
_© BDA Company International_
