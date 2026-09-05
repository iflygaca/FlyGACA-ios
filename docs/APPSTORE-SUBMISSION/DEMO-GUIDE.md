# Demo Guide: Screen Recording Scripts & Specifications

**FlyGACA iOS App Family**  
**Three Video Walkthroughs for App Store Review**  
**Last Updated:** 2026-09-05  
**Video Specifications & Detailed Recording Scripts**

---

## Video Specification Requirements

**All three videos must meet these exact requirements for App Store review:**

### Device & Recording Setup
- **Device:** iPhone 15 Pro (or iPhone 15/14 Pro), portrait orientation
- **Simulator Alternative:** Xcode simulator (macOS 15+, Xcode 16+) running iOS 17+
- **Resolution:** 1080p (1920×1080) minimum, 60 FPS preferred
- **Aspect Ratio:** 9:16 (portrait, full screen)
- **Codec:** H.264 (MP4 container)
- **File Format:** .mp4 (QuickTime Movie or MP4 file)
- **Audio:** Clear, natural speech at 0 dB baseline (no background music unless noted)
- **Capture Tool:** QuickTime Player (Mac) or built-in screen recording (iOS)

### Recording Best Practices
- **Tap/Swipe Speed:** Natural, human-paced (0.5–1.5 seconds between actions)
- **No fast-forward:** Real-time recording, no speed-up
- **Loading times:** Show briefly (1–2 seconds), don't skip
- **Transitions:** Fade naturally, don't jump abruptly between screens
- **Text readability:** Ensure all on-screen text is clear (zoom in via Xcode settings if needed)
- **Personal data:** Use test account only (appReview@flygaca.com); do not record personal progress
- **Disclaimer visibility:** Always show disclaimer banner at app launch
- **Language:** Record in **English** (language toggle is demoed but not required for all videos)

### Timing
- **Target duration per video:** 2:30–3:00 minutes (total, not per segment)
- **Minimum:** 2:00 (very tight; not preferred)
- **Maximum:** 3:30 (App Store reviewers work through 100s of videos per day)

### Test Account Prerequisites
- **Email:** appReview@flygaca.com
- **Password:** [Secure password stored in 1Password, not in this doc]
- **Firebase Project:** flygaca-app
- **App Group:** group.com.FlyGACA (progress shares across all 3 apps)
- **Sync State:** Cloud sync enabled (to show sync icon in Settings)
- **Data State:** Fresh/partial (no 100% completion; show realistic progress like 30–50%)

### Naming Convention for Deliverables
```
flygaca-demo-flagship-launch-to-exam.mp4        (Video 1, 2:45)
flygaca-demo-elpt-quiz-to-results.mp4           (Video 2, 2:30)
flygaca-demo-aip-regulations-calculator.mp4     (Video 3, 2:40)
```

---

## Video 1: FlyGACA Flagship — Launch to Mock Exam

**Duration:** 2:45  
**Purpose:** Showcase complete offline-first app with modular architecture, study features (quiz → flashcards → mock exam), and cloud sync.  
**Key Features Demonstrated:**
1. ✅ App launch, disclaimer visible
2. ✅ Module home (5 modules: ELPT, AIP, Flight Deck, Regulations, Captain Adel)
3. ✅ Quiz attempt (ELPT: 3 questions, results)
4. ✅ Flashcard study (SRS, mark correct, see progression)
5. ✅ Mock Exam (timed, 5 questions, auto-submit on timeout)
6. ✅ Cloud sync indication (signed-in user, last sync shown)
7. ✅ Settings: disclaimer, language toggle available

### Script Timeline (2:45 total)

#### Segment 1: Launch & Onboarding (0:00–0:20)
**Screen Recording:**
- **0:00** — Tap FlyGACA Flagship icon on home screen (show home screen briefly, 0:02 max)
- **0:02** — Splash screen appears (FlyGACA logo, 1–2 second fade-in)
- **0:04** — Flagship app shell loads, Welcome screen visible
- **0:06** — Show disclaimer banner at top: "Fly GACA is an independent educational platform..."
- **0:08** — Tap "Start Studying" button (bypass sign-in for this demo)
- **0:10** — Dashboard/Module Home loads with 5 module cards:
  - ELPT (📚)
  - AIP (📖)
  - Flight Deck (🧮)
  - Regulations (📋)
  - Captain Adel (🤖, greyed out "Offline")
- **0:15** — Pause briefly to let reviewer see all 5 modules (scroll if needed to show all)
- **0:20** — Narration: "FlyGACA Flagship includes five modules. ELPT for language proficiency, AIP for regulations and aerodromes, Flight Deck calculators, full Regulations library, and Captain Adel AI instructor (online only). Let's study offline first."

#### Segment 2: Quiz Attempt (0:20–1:00)
**Screen Recording:**
- **0:20** — Tap ELPT module card
- **0:22** — ELPT Module Home loads (4 sections: Quiz Bank, Flashcards, Mock Exam, Progress)
- **0:25** — Tap "Start Quiz" under Quiz Bank
- **0:27** — Quiz topic selector loads; tap "Module 1: Listening" (or first available topic)
- **0:30** — Question 1 appears
  - Prompt: "Which of the following is correct according to GACAR Part 1?"
  - 4 options (A, B, C, D)
  - Source citation visible: "GACAR Part 1.1"
- **0:35** — Narration: "Quiz questions are sourced directly from GACAR regulations. Each question cites the exact part and section."
- **0:40** — User taps Option B (correct answer)
- **0:42** — Tap "Next →" button
- **0:45** — Question 2 appears (different question, different topic or same module)
- **0:50** — Tap Option C (incorrect answer)
- **0:52** — Tap "Next →"
- **0:55** — Question 3 appears
- **1:00** — Tap Option A (correct answer), then "Next →"

#### Segment 3: Quiz Results (1:00–1:25)
**Screen Recording:**
- **1:00** — Quiz Results screen loads
  - Large score: "67% (2/3 Correct)"
  - Pass/Fail badge (in this case: "Passed" if 75%+, else "Not Yet")
  - Breakdown: "Module 1: 2/3" (example)
  - Streak indicator visible
  - SRS progression note: "2 cards added to SRS box 0"
- **1:05** — Narration: "Quiz results are calculated and stored locally. Progress syncs to the cloud when you sign in. Spaced repetition cards are created from missed questions."
- **1:10** — Tap "Review Answers" button
- **1:12** — Review screen shows all 3 questions with correctness indicators:
  - Q1: ✅ Correct, your answer: B, correct answer: B
  - Q2: ❌ Wrong, your answer: C, correct answer: D
  - Q3: ✅ Correct, your answer: A, correct answer: A
- **1:18** — Scroll briefly to show all 3 review entries
- **1:22** — Tap back button or "Back to Module"
- **1:25** — Return to ELPT Module Home

#### Segment 4: Flashcard Study (1:25–1:55)
**Screen Recording:**
- **1:25** — From ELPT Module Home, tap "Study Flashcards"
- **1:27** — Flashcard Dashboard loads
  - SRS box overview visible:
    - Box 0 (New): 2 cards
    - Box 1 (1 day): 1 card
    - Mastered: 10 cards
  - "15 cards due today" counter visible
- **1:32** — Narration: "Flashcards use Leitner spaced repetition. Cards are organized into 5 boxes plus mastered. Study now to review cards due today."
- **1:35** — Tap "Start Study Session"
- **1:37** — Flashcard front (prompt) appears:
  - "Define 'airspeed' according to GACAR Part 1."
  - Placeholder: "Tap to reveal"
- **1:42** — Tap "Reveal Answer"
- **1:45** — Flashcard back (answer) appears:
  - Answer text: "The speed of the aircraft relative to the surrounding air."
  - Source citation: "GACAR Part 1, Definitions"
- **1:48** — User taps 🟢 "Correct" button
- **1:50** — Celebration: "✅ Correct!" (brief overlay, 0:5 sec)
- **1:52** — Next card automatically loads (another flashcard)
- **1:55** — Pause to let reviewer see card progression

#### Segment 5: Mock Exam & Settings (1:55–2:45)
**Screen Recording:**
- **1:55** — Go back to ELPT Module Home (tap back button)
- **1:58** — Tap "Start Mock Exam"
- **2:00** — Mock Exam Setup screen:
  - Title: "ELPT Mock Exam"
  - Duration: 30 minutes
  - Questions: 25 questions
  - Pass: 75%
  - Warning: "This is a scored assessment. Results count toward your progress."
- **2:05** — Narration: "Mock exams are scored. Users must achieve 75% to pass. Exams are timed with auto-submit at the end."
- **2:10** — Tap "Start Exam" (or "Practice Mode" if available to show untimed alternative)
- **2:13** — Exam Question 1 appears:
  - Timer shows: "29:45" (almost full time, just after start)
  - "Question 1 of 25"
  - Question prompt and 4 options visible
  - Note: No "Previous" button (forward-only on exams)
- **2:18** — Tap an option (e.g., Option A)
- **2:20** — Tap "Next →"
- **2:22** — Question 2 appears (timer now ~29:30)
- **2:25** — Narration: "Exam timing is strict. Unanswered questions are marked wrong. Let me show you the offline capability and settings."
- **2:30** — Go back to home / settings (tap back or home icon; or swipe to dismiss exam if available)
  - *Alternative:* Complete exam and show results, then settings. (This adds ~20–30 sec, so timeline may need adjustment.)
- **2:32** — Tap Settings (⚙️) icon in top-right
- **2:34** — Settings screen loads:
  - "Account: Signed in as appReview@flygaca.com" (if test account signed in)
  - Language toggle: "English | العربية"
  - Cloud sync status: "Last synced: 2:15 PM"
  - Disclaimer visible at bottom: "Fly GACA is an independent educational platform..."
- **2:40** — Tap Language toggle to Arabic
- **2:42** — Screen transitions to Arabic RTL layout (same settings, mirror layout)
  - Narration (in English voiceover): "The app is fully bilingual. All features are available in English and Arabic with proper right-to-left layout."
- **2:48** — Tap back to return to home
- **2:50** — (End of video)

**Narration/Voiceover Summary (to be recorded separately):**
- 0:20 — "FlyGACA Flagship includes five modules…"
- 0:35 — "Quiz questions are sourced directly from GACAR regulations…"
- 1:05 — "Quiz results are calculated and stored locally…"
- 1:32 — "Flashcards use Leitner spaced repetition…"
- 2:05 — "Mock exams are scored…"
- 2:25 — "Exam timing is strict…"
- 2:42 — "The app is fully bilingual…"

---

## Video 2: Fly GACA ELPT — Quiz Bank & Results

**Duration:** 2:30  
**Purpose:** Showcase standalone ELPT app, demonstrate quiz workflow (multiple-choice questions, immediate results, streaks).  
**Key Features Demonstrated:**
1. ✅ App launch (ELPT-specific)
2. ✅ Module Home (ELPT only, no module selector)
3. ✅ Quiz Bank: topic selection
4. ✅ 5-question quiz attempt with natural pacing
5. ✅ Immediate results with score, breakdown, streak tracking
6. ✅ Offline indication (if applicable)
7. ✅ Cross-app progress indication (if launched after Flagship demo)

### Script Timeline (2:30 total)

#### Segment 1: Launch & Module Home (0:00–0:15)
**Screen Recording:**
- **0:00** — Tap FlyGACA ELPT icon on home screen
- **0:02** — Splash screen (same as Flagship)
- **0:05** — App loads directly to ELPT Module Home (no module selector, app is ELPT-only)
- **0:07** — Show four sections:
  - Quiz Bank (📚 "1000+ questions across 4 modules")
  - Flashcards (with SRS progress: "42 cards mastered")
  - Mock Exam
  - Progress Analytics
- **0:10** — Narration: "Fly GACA ELPT is a focused app for English language proficiency study. It's also available as a standalone app on the App Store, or bundled in the Flagship suite."
- **0:15** — Offline badge visible (if no network)

#### Segment 2: Quiz Topic Selection (0:15–0:25)
**Screen Recording:**
- **0:15** — Tap "Start Quiz" under Quiz Bank
- **0:18** — Topic Selector loads with 4 packages:
  - Module 1: Listening (25 Qs, 0% done)
  - Module 2: Reading (25 Qs, 60% done — showing prior progress)
  - Module 3: Speaking (25 Qs, 0% done)
  - Module 4: Writing (25 Qs, 40% done)
- **0:22** — Narration: "Quiz packages are organized by skill. Users can continue previous progress or start new."
- **0:25** — Tap "Module 1: Listening" (or "Resume" if already in progress)

#### Segment 3: Quiz Attempt (5 Questions) (0:25–1:50)
**Screen Recording:**
- **0:25** — Question 1 appears:
  - Progress: "Question 1 of 25"
  - Prompt: "Listen to the audio and select the correct answer" (or text-based listening comprehension Q)
  - 4 options, no preselection
- **0:30** — User taps Option B
- **0:32** — Tap "Next →"
- **0:35** — Question 2 appears
  - Same format, different content
- **0:42** — User taps Option A (correct)
- **0:44** — Tap "Next →"
- **0:47** — Question 3 appears
- **0:54** — User taps Option D (incorrect)
- **0:56** — Tap "Next →"
- **1:02** — Question 4 appears
- **1:09** — User taps Option C (correct)
- **1:11** — Tap "Next →"
- **1:14** — Question 5 appears (last question in this demo)
- **1:20** — User taps Option B (correct)
- **1:22** — Tap "Next →" or "Submit Quiz"
- **1:25** — Narration: "Questions are answered quickly. No timer on standard quizzes. Each question cites the source regulation."
- **1:30** — (Natural pause, next screen loading)

#### Segment 4: Quiz Results (1:30–2:15)
**Screen Recording:**
- **1:30** — Quiz Results screen loads:
  - Large score: "80% (4/5 Correct)" (or similar realistic result)
  - Pass/Fail: ✅ "Passed" (green)
  - Breakdown: "Module 1 (Listening): 4/5 (80%)"
  - Streak: "4-question streak!" or "2-question streak"
  - SRS note: "3 cards added to SRS (for incorrect Q)"
- **1:37** — Narration: "Results are calculated instantly. The app tracks streaks and creates flashcards from missed questions. Results sync to the cloud when signed in."
- **1:45** — Tap "Review Answers"
- **1:48** — Review screen shows all 5 Qs:
  - Q1: ✅ Correct (B)
  - Q2: ✅ Correct (A)
  - Q3: ❌ Wrong (D vs. correct: C)
  - Q4: ✅ Correct (C)
  - Q5: ✅ Correct (B)
- **1:55** — Scroll to see all 5 review entries
- **2:05** — Tap back to results
- **2:08** — Show action buttons: "Redo Quiz", "Study Flashcards for Missed", "Back to Module"
- **2:12** — Tap "Back to Module"
- **2:15** — Return to ELPT Module Home

#### Segment 5: Cross-App Consistency & Settings (2:15–2:30)
**Screen Recording:**
- **2:15** — From ELPT Module Home, tap Settings (⚙️)
- **2:17** — Settings screen:
  - Signed in status (if test account logged in)
  - Language: English (toggle to Arabic visible)
  - Cloud sync: "Last synced: 2:10 PM"
- **2:23** — Narration: "Progress is shared across all FlyGACA apps via local App Group storage. Cloud sync is optional but recommended for backup."
- **2:28** — Tap back or home to exit
- **2:30** — (End of video)

**Voiceover Summary:**
- 0:10 — "Fly GACA ELPT is a focused app…"
- 0:22 — "Quiz packages are organized by skill…"
- 1:25 — "Questions are answered quickly…"
- 1:37 — "Results are calculated instantly…"
- 2:23 — "Progress is shared across all FlyGACA apps…"

---

## Video 3: Fly GACA AIP — Regulations Search & Flight Calculator

**Duration:** 2:40  
**Purpose:** Showcase AIP app's regulatory reference capabilities (GACAR search, Part detail view) and flight calculator functionality.  
**Key Features Demonstrated:**
1. ✅ App launch (AIP-specific)
2. ✅ Module Home (AIP only)
3. ✅ GACAR Regulations search (search by keyword, view full Part detail)
4. ✅ Aerodrome data reference (quick aerodrome lookup)
5. ✅ Flight Deck calculator (crosswind calculator example)
6. ✅ Offline capability (all content bundled, loads instantly)
7. ✅ Disclaimers (regulatory content disclaimer on Part view)

### Script Timeline (2:40 total)

#### Segment 1: Launch & AIP Home (0:00–0:15)
**Screen Recording:**
- **0:00** — Tap FlyGACA AIP icon on home screen
- **0:02** — Splash screen
- **0:05** — AIP Module Home loads
  - Three primary sections visible:
    1. GACAR Regulations ("Search 74 GACAR Parts")
    2. Aerodromes ("Browse 61 Saudi airports")
    3. Flight Deck ("55+ aviation calculators")
  - Quick search box at top: "Search regulations, aerodromes, calculators..."
- **0:10** — Narration: "FlyGACA AIP provides comprehensive regulatory reference. All 74 GACAR Parts are searchable and fully offline."
- **0:15** — Settings icon visible in top-right

#### Segment 2: GACAR Regulations Search (0:15–1:25)
**Screen Recording:**
- **0:15** — Tap search box and type "certification"
- **0:22** — Search results appear instantly (offline, no delay):
  - List of Parts matching "certification":
    - Part 21 — Certification of Aircraft
    - Part 61 — Certification of Pilots, Flight Instructors
    - Part 63 — Certification of Flight Crew
    - Part 65 — Certification of Airmen (Mechanics)
- **0:30** — Narration: "Searching is fast and returns relevant regulations. Let's look at Part 61, which governs pilot certification."
- **0:35** — Tap "Part 61 — Certification of Pilots, Flight Instructors, and Ground Instructors"
- **0:38** — Part 61 detail page loads:
  - Title: "GACAR Part 61 — Certification of Pilots, Flight Instructors, and Ground Instructors"
  - Disclaimer at top: "This is an educational reference. Verify on gaca.gov.sa for authoritative text."
  - Table of Contents (TOC) sidebar:
    - Subpart A — General
    - Subpart B — Aircraft and Ratings
    - (etc., collapsible)
  - Main content area shows full text of a section (e.g., "§ 61.1 — Applicability")
- **0:45** — Narration: "Each GACAR Part includes the full regulatory text, organized by section. Sections are directly sourced from GACA without modification."
- **0:52** — Tap on a section link in TOC (e.g., "§ 61.3 — Certification Required")
- **0:55** — Content area updates to show § 61.3:
  - Full section text: (e.g., "A person may not act as...") [placeholder legal text]
  - Clear typography, proper formatting
- **1:05** — Tap "Add to Favorites" button (bookmark this section)
- **1:08** — Show Toast notification: "✓ Added to favorites"
- **1:12** — Scroll down briefly to show more of the section text
- **1:18** — Tap back button to return to Part list
- **1:22** — (Natural pause)
- **1:25** — (Transition to next segment)

#### Segment 3: Aerodromes Lookup (1:25–1:55)
**Screen Recording:**
- **1:25** — From AIP Home, tap "Aerodromes"
- **1:28** — Aerodrome Selector loads:
  - List of 61 Saudi aerodromes:
    - Riyadh International (OERK)
    - Jeddah King Abdulaziz (OEJN)
    - Dammam King Fahd (OEDD)
    - (scroll to see more)
- **1:35** — Narration: "The AIP includes data for 61 major and regional Saudi aerodromes. Let's look up Riyadh."
- **1:38** — Tap "Riyadh International (OERK)"
- **1:40** — Aerodrome detail card loads:
  - Header: "Riyadh King Fahd Regional Airport"
  - ICAO: OERK | IATA: RYD
  - Location: "Riyadh, Saudi Arabia"
  - Quick info grid:
    - Elevation: 2,065 ft
    - Lat/Long: 24.9242° N, 46.6983° E
    - Magnetic Variation: 1.5° W
  - Runway data table:
    - Runway 09/27: 3,750×60m, Asphalt
    - Runway 05/23: 3,200×45m, Asphalt
  - Service info: Fuel, MRO, Weather link, NOTAM link
- **1:50** — Narration: "Aerodrome data includes runway dimensions, elevation, coordinates, and fuel/service availability. Perfect for flight planning reference."
- **1:55** — Tap back to return to AIP Home

#### Segment 4: Flight Calculator Demo (1:55–2:35)
**Screen Recording:**
- **1:55** — From AIP Home, tap "Flight Deck" (or navigate to Calculators)
- **1:58** — Calculator Gallery loads:
  - Grid of calculator categories:
    - E6B Emulation (TAS, Density Altitude, Fuel Calc)
    - Weight & Balance
    - Navigation (Crosswind, Heading/Wind, Distance)
    - Performance (Takeoff, Landing)
    - Weather/Conversion
- **2:05** — Tap "Crosswind Component" calculator (or search for it)
- **2:08** — Crosswind Calculator screen:
  - Input fields:
    - Runway heading: [090]
    - Wind direction: [120]
    - Wind speed (knots): [15]
  - Real-time output:
    - Headwind: 7.5 kts
    - Crosswind: 13.0 kts (left/right indicator)
    - Gauge showing "13.0 / 20.0 kts — ✅ OK"
- **2:15** — Narration: "Calculators provide real-time results as you enter data. This crosswind calculator shows headwind and crosswind components. Results update instantly, even offline."
- **2:22** — Change wind speed to 20 kts (tap input, clear, type 20)
- **2:26** — Output updates in real-time:
  - Headwind: 10.0 kts
  - Crosswind: 17.3 kts
  - Gauge updates: "17.3 / 20.0 kts — ✅ OK" (still within limits)
- **2:32** — Tap "Save This Calculation" button
- **2:35** — Show Toast: "✓ Calculation saved"
- **2:38** — (Transition to final segment)

#### Segment 5: Settings & Offline Confirmation (2:38–2:40)
**Screen Recording:**
- **2:38** — Tap Settings (⚙️)
- **2:40** — Settings screen visible briefly:
  - Disclaimer visible: "Fly GACA is an independent educational platform…"
  - Language toggle, cloud sync status (if signed in)
  - **Narration (voiceover):** "All FlyGACA apps work completely offline. Study anywhere, anytime. Optional cloud sync backs up your progress to Firebase."
- **2:40** — (End of video)

**Voiceover Summary:**
- 0:10 — "FlyGACA AIP provides comprehensive regulatory reference…"
- 0:30 — "Searching is fast and returns relevant regulations…"
- 0:45 — "Each GACAR Part includes the full regulatory text…"
- 1:50 — "Aerodrome data includes runway dimensions…"
- 2:15 — "Calculators provide real-time results…"
- 2:38+ — "All FlyGACA apps work completely offline…"

---

## Recording & Delivery Checklist

### Before Recording

- [ ] **Device setup:**
  - [ ] Device or simulator running iOS 17+
  - [ ] Test account (appReview@flygaca.com) signed in to Firebase
  - [ ] Device in **English** language setting (for natural screen text)
  - [ ] WiFi on (to show cloud sync working), or test Airplane Mode
  - [ ] Do Not Disturb enabled (suppress notifications)
  - [ ] Brightness: 50% (readable but not blown out)
  - [ ] Volume: Muted (record voiceover separately)

- [ ] **App state:**
  - [ ] Fresh install OR partial progress (30–50% complete), not 100% done
  - [ ] Content fully bundled (no "loading…" spinners on data; fast local load)
  - [ ] No debug UI, no test flags visible
  - [ ] Disclaimer banner shows on app launch

- [ ] **Recording setup:**
  - [ ] Microphone tested (if recording voiceover in-app; not recommended)
  - [ ] Screen recording tool ready (QuickTime Player on Mac or Xcode)
  - [ ] Destination folder ready for MP4 files
  - [ ] Backup external drive connected (for file safety)

### During Recording

- [ ] **Pacing:**
  - [ ] Tap and swipe at natural, human speed (0.5–1.5 sec between actions)
  - [ ] Pause briefly after screen transitions (1–2 sec) to let reviewers read
  - [ ] No fast-forward, no speed-up filters
  - [ ] Narration will be added in post-production (not recorded on device)

- [ ] **Visibility:**
  - [ ] All text is readable (16pt+ effective size)
  - [ ] Tap targets are visible (highlight where you tap if possible)
  - [ ] Scroll smoothly to show content (not jump)
  - [ ] No personal data or sensitive info visible

- [ ] **Offline demonstration (if included):**
  - [ ] Enable Airplane Mode mid-recording (show toggle)
  - [ ] Attempt feature that requires internet (e.g., Captain Adel) → show offline message
  - [ ] Show quiz/flashcards still work offline

### After Recording

- [ ] **File processing:**
  - [ ] Export as MP4 (H.264, 1080p, 60 FPS preferred)
  - [ ] File size: typically 80–200 MB per 2:30 video
  - [ ] Audio: Muted or silence (voiceover will be dubbed in)
  - [ ] No watermarks or overlays (except app UI)

- [ ] **Voiceover production:**
  - [ ] Script approved (use scripts above)
  - [ ] Record voiceover in quiet room (0 dB baseline, clear articulation)
  - [ ] Voiceover duration matches video segments (pre-record, test timing)
  - [ ] Audio format: WAV or AAC, 16-bit, 48 kHz

- [ ] **Video editing (optional, but recommended):**
  - [ ] Import MP4 into video editor (Final Cut Pro, iMovie, Adobe Premiere, etc.)
  - [ ] Layer voiceover audio track
  - [ ] Sync voiceover to video pacing (may require slight speed adjustments)
  - [ ] Add fade-in at start (0.5 sec), fade-out at end (0.5 sec)
  - [ ] **Color grading:** No heavy filters; match natural device color
  - [ ] Export final MP4 with video + audio track

- [ ] **Quality assurance:**
  - [ ] Play back full video on Mac/iPad (check sync, audio levels, clarity)
  - [ ] Check file format: `.mp4` (not `.mov` or `.m4v`)
  - [ ] Verify duration: 2:30–3:00 (not over 3:30)
  - [ ] Verify resolution: 1080p minimum
  - [ ] Spot-check frame rate: smooth playback, no stuttering

### Delivery

- [ ] **Files renamed per spec:**
  - `flygaca-demo-flagship-launch-to-exam.mp4` (2:45)
  - `flygaca-demo-elpt-quiz-to-results.mp4` (2:30)
  - `flygaca-demo-aip-regulations-calculator.mp4` (2:40)

- [ ] **Upload to hosting (if required):**
  - App Store Connect: Use "Preview" upload tool for videos
  - OR: Host on external CDN (Vimeo, AWS S3, Google Drive) and link in submission notes
  - Ensure videos are accessible to App Store reviewers (public link or App Store preview feature)

- [ ] **Metadata:**
  - [ ] Video 1 title: "FlyGACA Flagship — App Launch, Study Features, Cloud Sync"
  - [ ] Video 2 title: "Fly GACA ELPT — Quiz & Results"
  - [ ] Video 3 title: "Fly GACA AIP — Regulations Search & Flight Calculator"
  - [ ] Playlist order: Flagship first, ELPT second, AIP third

---

## Common Recording Mistakes to Avoid

❌ **Do NOT:**
- Record at non-human speed (too fast/slow)
- Include personal study progress or real user data
- Show network errors or app crashes (restart and redo)
- Use screen zoom or scaling that makes text unreadable
- Include debug UI, test banners, or simulator status bar
- Record with sound on (distracting notifications, typing sounds)
- Skip loading screens (show them briefly; they're proof of offline bundling)
- Record in Dark Mode unless app is **only** tested in Dark (show Light Mode)
- Include multiple failed attempts (do one clean take)
- Narrate on-device (record voiceover separately in quiet room)

✅ **DO:**
- Record at natural human speed (0.5–1.5 sec per tap)
- Use fresh or partial progress (30–50% complete)
- Show error states if they're graceful (offline message on Captain Adel)
- Ensure all text is readable (no tiny fonts)
- Keep app UI clean and professional
- Record in quiet environment (add voiceover in post)
- Show loading screens briefly (1–2 sec, proof of design)
- Test in both Light and Dark Mode (record whichever is default)
- Do one clean, complete take (no cuts/edits within segments)
- Add voiceover in post-production (clear voice, professional audio)

---

## Timeline Summary

| Video | Module | Duration | Key Segments | Voiceover Count |
|-------|--------|----------|--------------|-----------------|
| Video 1 | Flagship | 2:45 | Launch, Quiz (3Q), Results, Flashcards, Exam setup, Settings | 7 clips |
| Video 2 | ELPT | 2:30 | Launch, Topic select, Quiz (5Q), Results, review, Settings | 5 clips |
| Video 3 | AIP | 2:40 | Launch, Regulations search (Part 61), Aerodromes, Calculator, Settings | 6 clips |
| **Total** | — | **7:55** | — | **18 voiceover clips** |

---

**Document Status:** Complete  
**Audience:** App Store Review Team, QA Video Production Team  
**Cross-Reference:** [FEATURE-WALKTHROUGH.md](FEATURE-WALKTHROUGH.md) (flows that structure these videos)  
**Next Steps:** Record videos per specs above, add voiceovers, deliver to App Store Connect or external hosting.
