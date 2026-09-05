# Screenshots Manifest & Asset Inventory

**FlyGACA iOS App Family**  
**Rendered Screenshot Mockups for App Store**  
**Last Updated:** 2026-09-05  
**Status:** Screenshot Catalog & Production Workflow

---

## Overview

This document catalogs all screenshot assets generated for App Store submission. Screenshots are produced via **Mac-free HTML/CSS mockups** using Playwright + Chromium, located in `apple/Scripts/html-render/`.

**Three pipelines:**
1. **Portrait (Standard)** — `render.js` — Development/reference screenshots
2. **Landscape** — `render-landscape.js` — Supplementary, not submitted to App Store
3. **App Store** — `render-store.js` — **Official submission set** with marketing captions

---

## Screenshot Production & Workflow

### Pre-Rendering Requirements

**No simulator or Xcode required:**
- Renders via **Playwright** + **Chromium** (headless browser)
- Runs on **macOS** with Node.js installed
- **Command:**
  ```bash
  cd apple/Scripts/html-render/
  npm install  # (if dependencies not yet installed)
  node render.js         # Portrait (development)
  node render-store.js   # App Store (official submission) ← USE THIS
  ```

### Directory Structure

```
apple/Scripts/html-render/
├── render.js                    # Portrait mockup generator
├── render-landscape.js          # Landscape mockup generator
├── render-store.js              # App Store mockup with captions ← OFFICIAL
├── screens.js                   # Screen library (all 50+ screens, one fn per screen)
├── captions.js                  # Marketing copy / captions for App Store
├── README.md                    # Rendering documentation + maintenance guide
├── output/
│   ├── flagship/                # Flagship app screenshots
│   │   ├── flagship-01-launch.png
│   │   ├── flagship-02-modules.png
│   │   ├── ...
│   │   └── flagship-12-settings.png
│   ├── elpt/                    # ELPT app screenshots
│   │   ├── elpt-01-launch.png
│   │   ├── elpt-02-quiz.png
│   │   └── ...
│   └── aip/                     # AIP app screenshots
│       ├── aip-01-launch.png
│       ├── aip-02-regulations.png
│       └── ...
└── palette/
    └── theme.json              # Color palette (copied from FeatureUI/Theme.swift)
```

### Rendering Process (User-Facing)

**Single command for all App Store screenshots:**

```bash
npm run ios:screenshots
```

This triggers `render-store.js`, which:
1. Loads screen functions from `screens.js` (one per screen)
2. Reads content from `Apps/<App>/Content/*.json` (live from bundled data)
3. Renders each screen as HTML/CSS via Playwright
4. Adds marketing captions from `captions.js` (value-prop text)
5. Saves final PNG to `apple/Scripts/html-render/output/<app>/`

**Output:** PNG images, 1080×1920 px (iPhone standard), ready for App Store Connect upload.

---

## Screenshot Specifications

### Device & Resolution
- **Device:** iPhone 15 Pro (6.7" display)
- **Resolution:** 1080×1920 pixels (2x retina, 1x representation for app store)
- **Aspect ratio:** 9:16 (portrait, full screen)
- **Format:** PNG, 8-bit RGB (no transparency needed)
- **File size:** 200–400 KB per image (typical)

### Visual Design
- **Safe area:** 54px margins on left/right (108px total, ~10% of width)
- **Top safe area:** 44px (notch/status bar clearance)
- **Bottom safe area:** 0px (full-bleed to bottom, no home bar cutout shown)
- **Typography:** Inter (EN) and Cairo (AR), as in-app
- **Colors:** Exact palette from `FeatureUI/Theme.swift` (light mode)
- **Status bar:** Optional (usually hidden for cleaner mockup)
- **Captions (App Store only):** 80–120 character max per caption line

### Bilingual Coverage

Each **screen is rendered in both English and Arabic:**
- `flagship-01-launch-en.png` — English version
- `flagship-01-launch-ar.png` — Arabic version (RTL layout)
- (etc. for all screens)

**Total screenshots:** 50+ screens × 2 languages (EN + AR) = 100+ total images

---

## Screenshot Inventory by App

### FlyGACA Flagship (`com.flygaca.app`)

**Total screens rendered:** 12  
**Per-app submission:** 5–10 screenshots (App Store Connect limit: 10 per device size)

#### Key Screens Included

| Screen | Purpose | Filename | Bilingual |
|--------|---------|----------|-----------|
| 1. Splash + Disclaimer | App launch, regulatory notice | `flagship-01-launch.png` | EN + AR |
| 2. Module Home (5 modules) | Overview of all 5 modules | `flagship-02-modules.png` | EN + AR |
| 3. ELPT Module Home | Quiz, Flashcards, Mock Exam, Progress | `flagship-03-elpt-home.png` | EN + AR |
| 4. Quiz Question (mid-quiz) | Question display, source citation visible | `flagship-04-quiz-question.png` | EN + AR |
| 5. Quiz Results | Score, pass/fail, breakdown | `flagship-05-quiz-results.png` | EN + AR |
| 6. Flashcard (back/answer) | Flashcard content, SRS progression | `flagship-06-flashcard.png` | EN + AR |
| 7. Mock Exam Setup | Exam rules, duration, pass score | `flagship-07-exam-setup.png` | EN + AR |
| 8. Regulations Search | Part list, search interface | `flagship-08-regulations.png` | EN + AR |
| 9. Aerodome Detail (Riyadh) | Runway data, coordinates, services | `flagship-09-aerodrome.png` | EN + AR |
| 10. Crosswind Calculator | Real-time calculator results | `flagship-10-calculator.png` | EN + AR |
| 11. Captain Adel Chat (offline) | AI instructor, offline message | `flagship-11-captain-adel.png` | EN + AR |
| 12. Settings & Disclaimer | Language toggle, disclaimer, sync status | `flagship-12-settings.png` | EN + AR |

#### App Store Selection (Official Submission)

**For App Store Connect, submit:**
- **5.5" display (iPhone SE):** 5–6 screenshots (smallest iPhone, most viewers)
  1. Splash + Disclaimer
  2. Module Home (value prop: 5 comprehensive modules)
  3. Quiz Results (immediate feedback, scoring)
  4. Flashcard + SRS (learning science)
  5. Settings (bilingual, offline, cloud sync)
- **6.5" display (iPhone 15 Plus/Pro Max):** Same 5–6 (larger detail visible)
  1. Module Home (5 modules highlighted)
  2. Quiz mid-question (content quality visible)
  3. Quiz Results (clear score + breakdown)
  4. Regulations Search (GACAR searchability)
  5. Crosswind Calculator (55+ tools reference)
  6. Settings (language toggle, Arabic RTL visible)

**Marketing captions** (from `captions.js`):
1. "Study Offline, Anytime" — Disclaimer + offline capability
2. "5 Complete Modules" — Module home
3. "Instant Feedback & Scoring" — Quiz results
4. "Leitner Spaced Repetition" — Flashcard SRS
5. "All GACAR Parts Searchable" — Regulations search
6. "55+ Flight Calculators" — Calculator tool
7. "100% Bilingual (EN/AR)" — Settings, language toggle
8. (Custom per marketing review)

---

### Fly GACA ELPT (`com.flygaca.elpt`)

**Total screens rendered:** 8  
**Per-app submission:** 5 screenshots

#### Key Screens Included

| Screen | Purpose | Filename |
|--------|---------|----------|
| 1. Launch (ELPT Only) | App startup, no module selector | `elpt-01-launch.png` |
| 2. Module Home | Quiz, Flashcards, Mock Exam (ELPT focus) | `elpt-02-home.png` |
| 3. Quiz Topic Selection | 4 language modules (Listening, Reading, Speaking, Writing) | `elpt-03-topics.png` |
| 4. Quiz Mid-Question | Question display, source citation | `elpt-04-question.png` |
| 5. Quiz Results | Score, breakdown, streak | `elpt-05-results.png` |
| 6. Flashcard Study | SRS card, progress | `elpt-06-flashcard.png` |
| 7. Mock Exam Timed | Timer running, question mid-exam | `elpt-07-exam.png` |
| 8. Settings (Cross-App Link) | Cloud sync indication, progress shared with other apps | `elpt-08-settings.png` |

#### App Store Selection

**Submit 5 screenshots (portrait, 6.5" for detail):**
1. Module Home (standalone ELPT focus)
2. Quiz Topic Selection (4 language skills)
3. Quiz Results (immediate feedback, clear scoring)
4. Flashcard (Leitner SRS, spaced repetition)
5. Settings (Cloud sync confirmation, cross-app sharing)

**Captions:**
1. "English Language Proficiency Test (ELPT) Standalone"
2. "4 Skill Modules: Listening, Reading, Speaking, Writing"
3. "1000+ Practice Questions with Instant Scoring"
4. "Spaced Repetition for Long-Term Retention"
5. "Sign In for Cloud Backup & Progress Sharing Across FlyGACA Apps"

---

### Fly GACA AIP (`com.flygaca.aip`)

**Total screens rendered:** 10  
**Per-app submission:** 5 screenshots

#### Key Screens Included

| Screen | Purpose | Filename |
|--------|---------|----------|
| 1. Launch (AIP Only) | App startup, regulations + aerodromes + calculators | `aip-01-launch.png` |
| 2. Module Home | 3 sections (Regulations, Aerodromes, Flight Deck) | `aip-02-home.png` |
| 3. Regulations Search | Part list, search interface | `aip-03-regulations.png` |
| 4. Part 61 Detail | Full part content, TOC sidebar visible | `aip-04-part-61.png` |
| 5. Regulations Section | Specific section (e.g., § 61.3), disclaimer visible | `aip-05-section.png` |
| 6. Aerodromes List | 61 Saudi airports, search/filter | `aip-06-aerodromes.png` |
| 7. Aerodrome Detail | Riyadh (OERK), runways, coordinates, services | `aip-07-riyadh.png` |
| 8. Calculator Gallery | 55+ tools by category | `aip-08-calculators.png` |
| 9. Crosswind Calculator | Input/output, real-time results | `aip-09-crosswind.png` |
| 10. Settings | Offline capable, language toggle | `aip-10-settings.png` |

#### App Store Selection

**Submit 5 screenshots (portrait, 6.5"):**
1. Module Home (Regulations, Aerodromes, Calculators)
2. Part 61 Content (GACAR text, searchability, full chapters)
3. Aerodrome Detail (Riyadh, runway data, coordinates)
4. Calculator Gallery (55+ aviation tools)
5. Crosswind Calculator (Real-time results, operational reference)

**Captions:**
1. "Complete GACAR Reference Library (74 Parts, 61 Aerodromes)"
2. "All Saudi Aviation Regulations Searchable & Offline"
3. "Aerodrome Data: Runways, Coordinates, Services"
4. "55+ Flight Calculators (E6B, Weight & Balance, Crosswind, etc.)"
5. "Study Offline, Sync Optionally with Cloud Backup"

---

## Rendering & Maintenance Workflow

### Initial Rendering (Before First Submission)

1. **Clone FlyGACA-app monorepo** (contains `render-store.js` and screen library)
   ```bash
   git clone https://github.com/FlyGACA/FlyGACA-app.git ../FlyGACA-app
   ```

2. **Run screenshot generator**
   ```bash
   cd apple/Scripts/html-render/
   npm install  # Install Playwright, Chromium
   node render-store.js
   ```

3. **Verify output** in `output/<app>/*.png`
   - Check file sizes (should be 200–400 KB)
   - Spot-check visual quality (fonts, colors, layout)
   - Verify both EN and AR versions generated

4. **Copy to submission directory** (optional; can upload directly from output/)
   ```bash
   cp -r apple/Scripts/html-render/output/flagship/* docs/APPSTORE-SUBMISSION/screenshots/
   ```

5. **Upload to App Store Connect**
   - App Store Connect → App → Screenshots
   - For each device size (5.5" and 6.5"), upload 5 best screenshots
   - Add captions from `captions.js`
   - Select language (submit separate sets for EN and AR, or multi-language set)

### After Content Updates (Regenerate Screenshots)

**Whenever content changes (quiz questions, part text, aerodome data):**

1. **Sync content** from monorepo (new Content/ files):
   ```bash
   bash scripts/sync-content.sh ../FlyGACA-app
   ```

2. **Re-render screenshots** (render-store.js reads live from Content/):
   ```bash
   node apple/Scripts/html-render/render-store.js
   ```

3. **Review changes** — screenshots auto-update to reflect new content

4. **Re-upload to App Store Connect** (if regulatory changes, typos, or content updates visible)

### Maintenance & Versioning

**Screenshot versioning:**
- Filenames include app name + screen number + language:
  - `flagship-05-quiz-results-en.png`
  - `flagship-05-quiz-results-ar.png`
- Commit screenshots to git (in `docs/APPSTORE-SUBMISSION/screenshots/` or store link externally)
- Document version history (screenshot set version = app build version)

**QA Checklist Before Submission:**
- [ ] All screens render without errors
- [ ] English screenshots show Inter font, LTR layout
- [ ] Arabic screenshots show Cairo font, RTL layout
- [ ] Text is readable (no clipping, no overflow)
- [ ] Numbers are LTR (even in Arabic context)
- [ ] Colors match app theme (no pink tint, no blown-out backgrounds)
- [ ] Captions are accurate, persuasive, <120 chars per line
- [ ] No placeholder text or debug UI visible
- [ ] All 3 apps have at least 5 screenshots each

---

## File Delivery for App Store Connect

### Per-App Screenshot Sets

#### FlyGACA Flagship
- **Directory:** `docs/APPSTORE-SUBMISSION/screenshots/flagship/`
- **Files (5.5" iPhone SE):**
  - `flagship-01-launch-en.png` (Splash + Disclaimer)
  - `flagship-02-modules-en.png` (5 Module Overview)
  - `flagship-05-quiz-results-en.png` (Quiz Scoring)
  - `flagship-06-flashcard-en.png` (Flashcard SRS)
  - `flagship-12-settings-en.png` (Settings + Disclaimer)
- **Files (6.5" iPhone Pro):** Same 5, with "-6-5" suffix if rendered separately
- **Total per size:** 5 screenshots × 1 language (EN) for initial submission
  - *Optional:* Also upload AR versions for Arabic localization
- **Captions:** From `captions.js` (copy-paste to App Store Connect)

#### Fly GACA ELPT
- **Directory:** `docs/APPSTORE-SUBMISSION/screenshots/elpt/`
- **Files (5.5" iPhone SE):**
  - `elpt-02-home-en.png` (Module Home)
  - `elpt-03-topics-en.png` (4 Skills)
  - `elpt-05-results-en.png` (Quiz Results)
  - `elpt-06-flashcard-en.png` (Flashcard)
  - `elpt-08-settings-en.png` (Cloud Sync)
- **Total:** 5 screenshots

#### Fly GACA AIP
- **Directory:** `docs/APPSTORE-SUBMISSION/screenshots/aip/`
- **Files (5.5" iPhone SE):**
  - `aip-02-home-en.png` (3 Modules)
  - `aip-05-section-en.png` (GACAR Part Detail)
  - `aip-07-riyadh-en.png` (Aerodome)
  - `aip-08-calculators-en.png` (Calculator Gallery)
  - `aip-09-crosswind-en.png` (Live Calculator)
- **Total:** 5 screenshots

### Bulk Upload Method

**For all 3 apps at once:**

```bash
# Assuming screenshots are in output/ directory
ls -la apple/Scripts/html-render/output/*/\*-en.png | wc -l
# Should list 15 total (5 screenshots × 3 apps)

# Create submission package
mkdir -p docs/APPSTORE-SUBMISSION/screenshots-for-upload/
cp apple/Scripts/html-render/output/flagship/*-en.png \
   docs/APPSTORE-SUBMISSION/screenshots-for-upload/flagship/
cp apple/Scripts/html-render/output/elpt/*-en.png \
   docs/APPSTORE-SUBMISSION/screenshots-for-upload/elpt/
cp apple/Scripts/html-render/output/aip/*-en.png \
   docs/APPSTORE-SUBMISSION/screenshots-for-upload/aip/

# Compress for delivery
zip -r FlyGACA-screenshots-2026-09-05.zip \
  docs/APPSTORE-SUBMISSION/screenshots-for-upload/

# Upload to App Store Connect via web interface
# OR use Apple Transporter CLI (advanced)
```

---

## Known Limitations & Workarounds

### Limitation 1: Simulator Doesn't Match Reality

**Issue:** Rendered HTML mockups may differ from live app rendering (pixel-perfect layout, animation, etc.).

**Mitigation:**
- Mockups are for *representative* screenshots, not pixel-perfect replicas
- If accepted by App Store, take live simulator/device screenshots as backup
- Update screenshots in-app using `AppleTests/ScreenshotTests.swift` (real XCUITest snapshots)

### Limitation 2: Offline Badge May Not Show

**Issue:** "🌐 Offline" badge is visual embellishment, not critical for submission.

**Workaround:** Descriptive caption clarifies offline capability. Mockup can show or omit badge.

### Limitation 3: Captain Adel Shows "Offline" Message

**Issue:** Captain Adel is online-only; mockup shows offline state (greyed out, message visible).

**Solution:** Correct message demonstrates responsible UX (users understand feature requires internet).

### Limitation 4: Screenshots Generated in Light Mode Only

**Issue:** App supports Light/Dark/Auto modes; mockups show Light only.

**Workaround:** App Store reviewers will see actual app behavior. Screenshots in Light mode are standard.

---

## Reference Implementation

See `apple/Scripts/html-render/` in this repo for:
- **render-store.js** — Rendering engine with caption support
- **screens.js** — One function per screen (50+ screens)
- **captions.js** — Marketing copy per screen
- **README.md** — Maintenance & extension guide

---

**Document Status:** Complete  
**Audience:** App Store Review, Marketing, QA  
**Cross-Reference:** [DEMO-GUIDE.md](DEMO-GUIDE.md) (screen recording scripts demonstrate same flows)  
**Generation Command:** `npm run ios:screenshots` or `node apple/Scripts/html-render/render-store.js`  
**Next Steps:** Generate, review, upload to App Store Connect per instructions above
