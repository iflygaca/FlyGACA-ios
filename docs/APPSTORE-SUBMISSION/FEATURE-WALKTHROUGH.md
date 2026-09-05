# Feature Walkthrough: Per-App User Flows

**FlyGACA iOS App Family**  
**Last Updated:** 2026-09-05  
**Status:** Detailed user flows for all three apps

---

## Overview

This document describes the exact user experience flow for each app in the FlyGACA family, from launch through accessing all major features. Each flow demonstrates:

1. ✅ Offline-first capability (no sign-in required to study)
2. ✅ Optional Firebase sign-in for cloud sync
3. ✅ Core study features (quiz, flashcards, mock exams)
4. ✅ Navigation between modules (where applicable)
5. ✅ Language toggle (English ↔ Arabic)
6. ✅ Settings and data management

---

## FlyGACA Flagship App (`com.flygaca.app`)

**Purpose:** Complete suite of study tools, flight calculators, GACAR regulations, and AI flight instructor.  
**Target Users:** Student pilots (all license levels), flight instructors, aviation professionals.  
**Modules Included:** ELPT, AIP, Flight Deck (calculators), Regulations (library), Captain Adel (AI chat).

### User Flow 1: Fresh Install → Module Selection → Quiz

#### 1.1 Launch & Onboarding
- **Action:** User taps FlyGACA icon
- **Screen:** Splash screen (FlyGACA logo, 1-2 second fade-in)
- **What User Sees:**
  - Disclaimer banner: "Fly GACA is an independent educational platform. GACA on gaca.gov.sa is authoritative." (in user's language)
  - Brief welcome message: "Welcome to Fly GACA. Study offline. Sync optionally."
  - **Two CTAs:** "Sign In" (optional) | "Start Studying" (skip sign-in, offline mode)

#### 1.2 Offline Path (No Sign-In)
- **Action:** User taps "Start Studying"
- **Screen:** Module home / dashboard
- **What User Sees:**
  - Five module cards in a scrollable grid:
    1. **ELPT** — English Language Proficiency Test (PPL/CPL/ATPL prep)
       - Icon: 📚 (or custom FlyGACA icon)
       - Subtitle: "1000+ questions across 4 modules"
       - Stats badge: "0% complete" (or "42% complete" if user has studied before)
    2. **AIP** — Aeronautical Information Publication (GACA regulations)
       - Icon: 📖
       - Subtitle: "74 GACAR Parts + 61 aerodromes"
       - Stats badge: "0% complete"
    3. **Flight Deck** — Calculators (E6B, weight/balance, crosswind, etc.)
       - Icon: 🧮
       - Subtitle: "55+ aviation calculators"
       - Stats badge: "0 saved" (bookmarks)
    4. **Regulations** — Full GACAR library (searchable)
       - Icon: 📋
       - Subtitle: "All 74 GACAR Parts + topical handbooks"
       - Stats badge: "0 searches"
    5. **Captain Adel** — AI Flight Instructor
       - Icon: 🤖
       - Subtitle: "Chat with GACAR-grounded AI"
       - Status badge: "Offline" (greyed out, tappable for details)
  - **Settings icon** (⚙️) in top-right corner
  - **Language toggle** (EN/AR flag icon) in top-left corner

#### 1.3 Selecting ELPT Module
- **Action:** User taps ELPT card
- **Screen:** ELPT Module Home
- **What User Sees:**
  - Module title: "English Language Proficiency Test (ELPT)"
  - Study progress overview (if none: "No progress yet")
  - **Four main sections / buttons:**
    1. **Quiz Bank** — "Practice Questions"
       - Button text: "Start Quiz" or "Continue Quiz"
       - Subtitle: "1000+ questions, 4 topic packages"
    2. **Flashcards** — "Leitner SRS"
       - Button text: "Study Flashcards"
       - Subtitle: "Spaced repetition, 5 boxes"
       - Progress bar: "0 cards mastered"
    3. **Mock Exam** — "Scored Assessment"
       - Button text: "Start Mock Exam"
       - Subtitle: "25 questions, 30 minutes, 75% pass"
       - Status: "Practice mode (untimed)" if never taken
    4. **Progress** — "Analytics Dashboard"
       - Button text: "View Progress"
       - Subtitle: "Quiz scores, flashcard stats, exam history"
  - **Back button** (← arrow) in top-left to return to module home
  - **Settings icon** (⚙️) in top-right

#### 1.4 Starting a Quiz
- **Action:** User taps "Start Quiz" under Quiz Bank
- **Screen:** Quiz Topic Selector (if first-time)
- **What User Sees:**
  - Title: "Select Topic Package"
  - List of available packages (e.g., "Module 1: Listening", "Module 2: Reading", "Module 3: Speaking", "Module 4: Writing")
  - For each package:
    - Package name + description
    - Progress indicator: "0 / 25 questions answered"
    - Button: "Start" or "Resume"
  - **Skip option:** "Take a Random Mixed Quiz" (all packages, random order)

**Alternative (if user has prior progress):**
- **Screen:** Quiz Dashboard
- **What User Sees:**
  - List of recently-studied packages with resume buttons
  - "New Quiz" button to start fresh
  - Recent quiz scores (history)

#### 1.5 Quiz Interface (Mid-Quiz)
- **Action:** User taps "Start" on Module 1
- **Screen:** Quiz Question Display
- **What User Sees:**
  - Progress indicator at top: "Question 3 of 25" (e.g.)
  - **Question card:**
    - Prompt/stem (e.g., "Which of the following is correct?")
    - Four radio-button options (A, B, C, D), no preselection
    - Source citation below (faint): "GACAR Part 61.3(c)"
  - **Navigation buttons:**
    - "← Previous" (disabled on Q1)
    - "Next →" (enabled after selection; skips if unanswered, showing "Unanswered = Wrong")
    - "Flag for Review" (bookmark this question)
  - **Quiz controls (bottom bar):**
    - "Pause Quiz" button (brings up confirm dialog)
    - Progress bar (visual 3/25 filled)
  - **Offline indicator** (if applicable): Small "🌐 Offline" badge

#### 1.6 Quiz Results
- **Action:** User submits final answer on Q25
- **Screen:** Quiz Results Summary
- **What User Sees:**
  - Large score display: "72% (18/25 Correct)"
  - Pass/Fail badge: ✅ "Passed" (green) or ❌ "Not Yet" (red)
  - Breakdown by topic (if mixed quiz): "Module 1: 4/5, Module 2: 5/5, Module 3: 3/5, Module 4: 6/10"
  - Streak indicator: "2-question streak!" or "Streak broken"
  - **Action buttons:**
    - "Review Answers" → shows all Q's with correctness, correct answer, user's answer
    - "Redo Quiz" → starts fresh
    - "Study Flashcards for Missed" → pre-selects cards from wrong Qs
    - "Back to Module Home"
  - **SRS progression indicator:** "4 cards added to SRS box 0 (new)"

### User Flow 2: Flashcard Study (Spaced Repetition)

#### 2.1 Flashcard Home
- **Action:** User taps "Study Flashcards" from ELPT module home
- **Screen:** Flashcard Dashboard
- **What User Sees:**
  - **SRS Box Overview (5 boxes + mastered):**
    ```
    📦 Box 0 (New)         — 12 cards → Review Today
    📦 Box 1 (1 day)       — 8 cards → Review Today
    📦 Box 2 (3 days)      — 5 cards → Review in 2 days
    📦 Box 3 (7 days)      — 3 cards → Review in 5 days
    📦 Box 4 (14 days)     — 2 cards → Review in 9 days
    🎓 Mastered           — 42 cards → Review in 30 days
    ```
  - **Daily summary:** "15 cards due today (Boxes 0–1)"
  - **Action buttons:**
    - "Start Study Session" (if cards due today)
    - "Add to Deck" (import from quiz)
    - "Search Cards"
    - "Review All"
  - **Settings:** Filter by topic, sort by due date

#### 2.2 Study Session (Active Flashcard Drill)
- **Action:** User taps "Start Study Session"
- **Screen:** Flashcard Drill (front of card)
- **What User Sees:**
  - **Card face (front):**
    - Prompt (e.g., "Define 'airspeed':")
    - Placeholder: "Tap to reveal"
  - **Box indicator:** "Box 1 — Card 3 of 8"
  - **Progress bar:** 3/8 filled
  - **Buttons at bottom:**
    - "Reveal Answer" (taps to flip)
  - **Skip option:** "Skip" (card stays in current box, counts as unanswered)

#### 2.3 Flashcard Back (Reveal Answer)
- **Action:** User taps "Reveal Answer"
- **Screen:** Flashcard Drill (back of card, showing answer)
- **What User Sees:**
  - **Card face (back):**
    - Prompt (still visible, smaller)
    - **Answer:** (e.g., "The speed of the aircraft relative to the surrounding air.")
    - Source citation: "GACAR Part 1, Definitions"
  - **User judgment buttons (choose one):**
    - 🔴 "Wrong" — Card returns to Box 0 (wrong = restart)
    - 🟡 "Hard" — Card stays in current box (reviewed again in 1-3 days)
    - 🟢 "Correct" — Card advances to next box (correct = promote)
  - **Session stats (bottom):** "Session: 3 cards learned, 2 promoted, 1 reset"

#### 2.4 Mastery & Streak
- **Action:** User marks 5 consecutive cards as "Correct"
- **Screen:** Flashcard Drill (with celebration)
- **What User Sees:**
  - Card display as normal
  - **Celebration overlay (brief, 1-2 sec):** 🎉 "5-card streak! Keep it going!"
  - **Session summary (after 8 card review):** "Session complete! 5/8 mastered, 0 reset. Streak: +5"

### User Flow 3: Mock Exam (Timed, Scored)

#### 3.1 Mock Exam Launcher
- **Action:** User taps "Start Mock Exam" from ELPT module home
- **Screen:** Mock Exam Setup
- **What User Sees:**
  - **Exam details card:**
    - Title: "ELPT Mock Exam"
    - Duration: "30 minutes"
    - Questions: "25 questions"
    - Passing score: "75% (19+ correct)"
    - Rules: "Auto-submit at 0:00, unanswered = wrong"
  - **Warning banner (red):** "This is a scored assessment. Results count toward your progress."
  - **Action buttons:**
    - "Start Exam" (launches 30-min countdown)
    - "Review Rules" (explains scoring, timing, auto-submit)
    - "Cancel"
  - **Optional:** "Practice Mode (Untimed)" toggle if user prefers

#### 3.2 Exam in Progress
- **Action:** User taps "Start Exam"
- **Screen:** Exam Question Display
- **What User Sees:**
  - **Timer (top center):** Large red countdown: "28:45" (MM:SS format)
  - **Progress (top left):** "Question 7 of 25"
  - **Question card:** (identical to quiz, but no "Previous" button — forward-only)
    - Prompt
    - Four options (radio buttons)
    - Source citation
  - **Navigation:**
    - "Next →" (required selection to proceed)
    - "Flag for Review" (red flag icon, toggleable)
  - **Pause is disabled** (no pausing on exams — this is mentioned in rules)
  - **Unanswered notice:** If user tries Next without selecting: "This question is unanswered. Unanswered = wrong. Continue anyway?"

#### 3.3 Exam Time's Up / Auto-Submit
- **Action:** Timer reaches 0:00
- **Screen:** Auto-submit dialog
- **What User Sees:**
  - **Dialog:** "Time's up! Your exam is being submitted..."
  - Auto-submit happens (no user action needed)
  - Any unanswered questions marked wrong automatically
  - **Screen transitions to:** Exam Results (see 3.4 below)

#### 3.4 Exam Results
- **Action:** Exam submitted (by user or auto-submit)
- **Screen:** Exam Results Summary
- **What User Sees:**
  - **Large score display:** "78% (19/25 Correct)" (example)
  - **Pass/Fail badge:** ✅ "PASSED" (green) — or ❌ "NOT PASSED" (red)
  - **Breakdown by topic:** (if mixed exam)
    - "Module 1: 5/6 (83%)"
    - "Module 2: 4/5 (80%)"
    - "Module 3: 5/7 (71%)"
    - "Module 4: 5/7 (71%)"
  - **Timing info:** "Completed in 28:15"
  - **Action buttons:**
    - "Review Exam" → shows all questions with correctness
    - "View Analytics" → detailed performance graphs
    - "Retake Exam" → start fresh
    - "Back to Module"
  - **Persistent storage:** Exam result saved to local study record + synced to cloud (if signed in)

---

## Fly GACA ELPT App (`com.flygaca.elpt`)

**Purpose:** Standalone English Language Proficiency Test study.  
**Target Users:** Student pilots preparing for ELPT exam.  
**Modules:** ELPT only (same as Flagship's ELPT module).

### User Flow: Simplified Path (Single-Module App)

#### Flow 1: Launch → Quiz → Results
- **Action:** User taps FlyGACA ELPT icon
- **Screen:** Splash → Module Home (no module selector, goes straight to ELPT)
- **What User Sees:**
  - Identical ELPT module home as Flagship (see Flagship Flow 1.3 above)
  - No "module selector" needed (app is ELPT only)
  - Same four sections: Quiz Bank, Flashcards, Mock Exam, Progress
- **Rest of experience:** Identical to Flagship (quizzes, flashcards, mock exam flows are the same)

#### Flow 2: Cross-App Progress Sync
- **Scenario:** User studied in ELPT app on Monday (10 cards in SRS), then opens Flagship app on Tuesday.
- **What User Sees (in Flagship → ELPT module):**
  - SRS shows "10 cards in Box 0, 2 due today" (same state as in ELPT app)
  - Progress bar reflects same completion percentage
  - Quiz history includes Monday's quiz scores
  - **Seamless experience:** No re-syncing prompt, no data conflicts; App Group sharing keeps both apps synchronized locally.

---

## Fly GACA AIP App (`com.flygaca.aip`)

**Purpose:** Standalone Aeronautical Information Publication reference and study.  
**Target Users:** Pilots, flight instructors, aviation professionals consulting regulatory and aerodrome data.  
**Modules:** AIP only (regulations + aerodromes + flight calculators reference).

### User Flow 1: Regulations Search & Reference

#### 1.1 Launch & Dashboard
- **Action:** User taps FlyGACA AIP icon
- **Screen:** Splash → AIP Module Home
- **What User Sees:**
  - Three primary sections:
    1. **GACAR Regulations** — "Search 74 GACAR Parts"
    2. **Aerodromes** — "Browse 61 Saudi airports"
    3. **Flight Deck** — "Calculator reference (E6B, weight/balance, etc.)"
  - **Quick search box at top:** "Search regulations, aerodromes, calculators..."
  - **Settings / Language toggle** (top-right / top-left)

#### 1.2 GACAR Part Search
- **Action:** User taps "GACAR Regulations"
- **Screen:** Regulations Navigator
- **What User Sees:**
  - **Search bar:** "Find a part..." (search-as-you-type)
  - **List of all 74 parts:**
    ```
    Part 1 — Definitions and General Requirements
    Part 11 — General Rulemaking Procedures
    Part 13 — Administrative Procedures
    ...
    Part 99 — Security Control of Air Traffic
    + 21 Topical Handbooks (AIM, etc.)
    ```
  - **Example:** User types "certification" → results narrow to Parts 21, 23, 27–29, 33, 35, 43, 45, 47, 49, 61, 63, 65, 67 (all parts mentioning certification)
  - **Tappable results:** Each part shows a summary line

#### 1.3 Part 61 Deep-Dive
- **Action:** User taps "Part 61 — Certification of Pilots, Flight Instructors, and Ground Instructors"
- **Screen:** Part Content Viewer
- **What User Sees:**
  - **Part title:** "GACAR Part 61 — Certification of Pilots, Flight Instructors, and Ground Instructors"
  - **Disclaimer at top:** "This is an educational reference. Verify on gaca.gov.sa for authoritative text."
  - **Navigation sidebar (collapsible):**
    ```
    Part 61 (TOC — Table of Contents)
    ├─ Subpart A — General
    │  ├─ § 61.1 — Applicability
    │  ├─ § 61.3 — Certification Required
    │  └─ § 61.5 — Certificates and Ratings
    ├─ Subpart B — Aircraft and Ratings
    │  ├─ § 61.31 — Type Rating Requirements
    │  ├─ § 61.33 — Special Emphasis Areas
    │  └─ ...
    └─ ...
    ```
  - **Main content area:** Full text of selected section (e.g., "§ 61.3 — Certification Required")
  - **Text formatting:** Clean, readable typography; section numbers bold; key terms highlighted
  - **Buttons:**
    - "Add to Favorites" (save for offline reference)
    - "Share Link" (to section)
    - "Print" or "Export to PDF"
  - **Footer citation:** "Source: General Authority of Civil Aviation (gaca.gov.sa) | Last updated: 2026-Q3"

#### 1.4 Quick Reference: Certification Minimums
- **Action:** User searches "minimum age pilot certificate" in search bar
- **Screen:** Search Results
- **What User Sees:**
  - **Matched sections:**
    - "§ 61.3(c) — Minimum Age for Private Pilot Certificate: 17 years"
    - "§ 61.3(e) — Minimum Age for Commercial Pilot Certificate: 18 years"
    - "§ 61.3(f) — Minimum Age for Airline Transport Pilot Certificate: 23 years"
  - **Each result is tappable** → opens full section
  - **Highlighting:** Search term "age" highlighted in yellow within each result

### User Flow 2: Aerodrome Data Reference

#### 2.1 Aerodrome Browser
- **Action:** User taps "Aerodromes" on AIP home
- **Screen:** Aerodrome Selector
- **What User Sees:**
  - **Search bar:** "Find an aerodrome..." (or "Filter by region...")
  - **List of 61 Saudi aerodromes:**
    ```
    Riyadh International (OERK)
    Jeddah King Abdulaziz (OEJN)
    Dammam King Fahd (OEDD)
    ...
    Dhahran Regional (OEDH)
    Khamis Mushayt Regional (OEKY)
    Tabuk Regional (OETB)
    ```
  - **For each aerodrome:** ICAO code, city, status (active/inactive), elevation (ft/m)
  - **Filtering options:** Region (Eastern, Central, Western, etc.), type (International, Regional, etc.)

#### 2.2 Aerodrome Detail Card
- **Action:** User taps "Riyadh International (OERK)"
- **Screen:** Aerodrome Information Card
- **What User Sees:**
  - **Header:**
    - Aerodrome name: "Riyadh King Fahd Regional Airport"
    - ICAO: OERK | IATA: RYD
    - Location: "Riyadh, Saudi Arabia"
  - **Quick info grid:**
    ```
    Elevation: 2,065 ft (630 m)
    Lat/Long: 24.9242° N, 46.6983° E
    Magnetic Variation: 1.5° W
    ARP Coordinates: Runway 09/27 threshold
    ```
  - **Runway data table:**
    ```
    Runway  | Surface  | Dimensions | Heading
    09/27   | Asphalt  | 3,750×60m | 090°/270°
    05/23   | Asphalt  | 3,200×45m | 050°/230°
    ```
  - **Service info:**
    - Fuel: "Jet A-1, Avgas (seasonal)"
    - MRO: "Available, book ahead"
    - Weather: "METAR link"
    - NOTAMs: "Check NOTAM sources"
  - **Disclaimer:** "For operational use, verify current AIP and NOTAM data."
  - **Action buttons:**
    - "Save to Favorites"
    - "View on Map" (if map capability added)
    - "Get Directions"

### User Flow 3: Flight Calculators (Reference)

#### 3.1 Calculator Home
- **Action:** User taps "Flight Deck" on AIP home, or "Calculators" from module home
- **Screen:** Calculator Gallery
- **What User Sees:**
  - **Grid of 55+ calculators by category:**
    - **E6B Emulation:**
      - True Airspeed (TAS)
      - Density Altitude
      - Fuel Calculations
    - **Weight & Balance:**
      - CG Calculation
      - Payload Optimization
    - **Navigation:**
      - Crosswind Component
      - Heading/Wind Correction
      - Great Circle Distance
    - **Performance:**
      - Takeoff Distance
      - Landing Distance
    - **Weather/Conversion:**
      - Wind Speed (knots ↔ mph)
      - Altitude (ft ↔ m)
      - Temperature (°C ↔ °F)
      - Pressure (inHg ↔ hPa)
  - **Search bar:** "Find a calculator..." (e.g., "crosswind")
  - **Bookmarks:** "Saved Calculations" section (calculations user pinned for re-use)

#### 3.2 Crosswind Calculator
- **Action:** User taps "Crosswind Component" calculator
- **Screen:** Crosswind Calculator
- **What User Sees:**
  - **Input fields:**
    - Runway heading (degrees): [  090  ] (e.g.)
    - Wind direction (degrees): [  120  ]
    - Wind speed (knots): [  15  ]
  - **Real-time output (updates on input change):**
    - Headwind component: 7.5 kts (tailwind if negative)
    - Crosswind component: 13.0 kts (left/right indicator)
  - **Visual gauge:** Needle showing crosswind relative to aircraft max (e.g., "13.0 / 20.0 kts — ✅ OK")
  - **Action buttons:**
    - "Save This Calculation" (stores values for re-access)
    - "Copy Values"
    - "Clear"
  - **Offline:** "🌐 Offline mode — Calculator works fully offline"
  - **Disclaimer:** "For operational planning, verify with current weather, AFM, and flight planning tools."

---

## Language Toggle & Bilingual Parity

### User Flow: Switching Languages

#### All Three Apps
- **Action:** User taps language toggle (EN/AR flag) in top-left or visits Settings → Language
- **Screen:** Current screen (any screen)
- **What User Sees (after toggle):**
  - **Immediate switch to Arabic (RTL layout):**
    - All text switches to Arabic
    - Layout flips to right-to-left (RTL)
    - Numbers remain left-to-right (LTR: "25", "09:30", "75%")
    - Font changes from Inter (English) to Cairo (Arabic)
    - UI elements realign (back button moves to right, etc.)
  - **Example: ELPT module home in Arabic:**
    ```
    [⚙️] [EN/AR]        [← Arabic title]        [EN/AR] [⚙️]
    
    اختبار القدرة على اللغة الإنجليزية
    (English Language Proficiency Test)
    
    [بنك الأسئلة] [بطاقات التذكر] [الاختبار النهائي] [التقدم]
    ```
  - **Content parity:** Every question, every screen, every feature is available in both languages
  - **Disclaimer in Arabic:** Appears on startup and in Settings (verbatim translation of English version)
  - **No content loss:** Switching to Arabic doesn't hide features (unlike some apps)
  - **Persistent:** Language choice saved to device (toggles back to same language on next launch)

---

## Settings & Data Management

### User Flow: Accessing Settings

#### All Three Apps
- **Action:** User taps Settings (⚙️) icon (top-right on all screens)
- **Screen:** Settings Home
- **What User Sees:**
  - **Account section:**
    - If signed out: "Sign In" button → Opens Firebase Auth (email + password, or Google OAuth)
    - If signed in: "User: user@example.com" + "Sign Out" button
  - **Study preferences:**
    - Language: English / العربية (current selection highlighted)
    - Theme: Auto / Light / Dark
    - Notifications: On / Off (for cloud sync alerts)
  - **Data & storage:**
    - "Local study data size: 2.5 MB"
    - "Cloud progress synced: Yes, last sync 2:30 PM"
    - "Clear local data" button (warns before deleting)
    - "Download my data" button (exports as JSON)
  - **About:**
    - Version: "1.0.1"
    - Build: "2026.09.05"
    - **Disclaimer banner:** Full text of disclaimer in current language
    - "View privacy policy" link → opens externa website
    - "View terms of use" link → opens external website
  - **Advanced (collapsed by default):**
    - "Enable debug mode" (for internal use)
    - "View app logs"
    - "Report a bug" (opens email compose)

---

## Offline Mode Demonstration

### Scenario: Airplane Mode Test

#### User Flow: Full Study Session with No Internet

- **Setup:** User enables Airplane Mode on device (kills all network)
- **Launch:** User opens FlyGACA app (any app, any module)
- **What User Sees:**
  - Disclaimer still visible
  - All bundled content loads instantly (no loading spinners)
  - Module home fully functional (Quiz Bank, Flashcards, Mock Exam all tappable)
  - **Offline badge:** Small "🌐 Offline" indicator in top-right (or settings)
- **Quiz attempt:** User starts a quiz
  - Questions load instantly from bundled content
  - No network calls attempted
  - Answer submission happens locally (saved to SwiftData)
- **Flashcard study:** User studies 10 cards
  - SRS progression updates locally
  - Cards marked correct/wrong update SwiftData immediately
  - No sync attempted (no network available)
- **Mock exam:** User takes a timed exam
  - Timer counts down correctly
  - Questions load from bundled content
  - Results calculated and stored locally
- **Re-enable network:** User disables Airplane Mode
  - If signed in, auto-sync begins (no prompt)
  - Results from offline study propagate to Firebase Firestore
  - "Last synced: Now" appears in settings
- **Cross-app sync:** User opens ELPT app (was using Flagship offline)
  - **No fetch from cloud:** Progress appears immediately (App Group sync from local SwiftData)
  - If signed in, ELPT will also push its data to cloud
- **Captain Adel attempt (offline):** User taps Captain Adel AI chat
  - **Greyed-out button:** "Offline — requires internet"
  - Tapping shows modal: "Captain Adel is available online only. Connect to internet to chat with the AI flight instructor."
  - User can dismiss and continue with other features

---

## Summary: Cross-App Feature Parity

| Feature | Flagship | ELPT | AIP | Offline | Cloud Optional |
|---------|----------|------|-----|---------|-----------------|
| Quiz Banking | ✅ | ✅ | ✅ | ✅ | ✅ |
| Flashcards (SRS) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mock Exams | ✅ | ✅ | ✅ | ✅ | ✅ |
| Regulations Search | ✅ | ❌ | ✅ | ✅ | N/A |
| Aerodromes Data | ✅ | ❌ | ✅ | ✅ | N/A |
| Flight Calculators | ✅ | ❌ | ✅ | ✅ | N/A |
| Captain Adel Chat | ✅ | ❌ | ❌ | ❌ | ✅ (online only) |
| Bilingual (EN/AR) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Progress Sync (Cloud) | ✅ | ✅ | ✅ | ✅ (queued) | ✅ (optional) |
| Streak Tracking | ✅ | ✅ | ✅ | ✅ | ✅ (shared) |

---

**Document Status:** Complete  
**Audience:** App Store Review Team, QA Testers, Feature Documentation  
**Cross-Reference:** [DEMO-GUIDE.md](DEMO-GUIDE.md) (screen recording scripts based on these flows)
