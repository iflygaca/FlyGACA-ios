# Regional Parity & Bilingual QA Verification

**FlyGACA iOS App Family**  
**Cross-App Bilingual Consistency Checklist**  
**Last Updated:** 2026-09-05  
**Status:** QA & Compliance Verification

---

## Overview

FlyGACA is deployed **globally** with emphasis on Middle East (Saudi Arabia) and operates **monolingually per user session** — each user chooses English OR Arabic at launch, and the app renders entirely in that language throughout their session. There is **no regional blocking, no content filtering, and no feature differences** based on geography, device location, or language setting.

**Key principle:** Function identically worldwide; language toggle provides 100% UI and content parity.

---

## Bilingual Architecture

### Language Selection Flow

1. **On first launch:** User sees language picker OR inherits device language
   - Device in English locale → App defaults to English
   - Device in Arabic locale (ar, ar_SA, ar_AE, etc.) → App defaults to Arabic
   - User can toggle any time in Settings → Language

2. **Persistent selection:** Choice stored in `@AppStorage("userLanguagePreference")` (SwiftUI)
   - Survives app restart
   - Survives sign out / sign in
   - Shared across all 3 apps via App Group

3. **UI rendering:** SwiftUI dynamically switches based on language preference
   - No restart required
   - Immediate, smooth transition (RTL ↔ LTR layout flip)

### Layout & Typography

#### English (LTR - Left-to-Right)
- **Font:** Inter (system font, 400/500/600/700 weights)
- **Direction:** Left-to-right layout
- **Text alignment:** `.leading` (left side)
- **Navigation:** Back button on left, Settings on right
- **Numbers:** Left-to-right (25, 09:30, 75%)
- **Punctuation:** Standard ASCII (., ,, ?, !, :, --, —)

#### Arabic (RTL - Right-to-Left)
- **Font:** Cairo (custom, 400/500/600/700 weights)
- **Direction:** Right-to-left layout
- **Text alignment:** `.trailing` (right side)
- **Navigation:** Back button on right, Settings on left
- **Numbers:** Left-to-right even in RTL context (25, 09:30, 75%, 24.9242° N)
- **Punctuation:** Arabic punctuation where appropriate (؟, ، — no English punctuation in Arabic text)

### Content Parity Rule (Non-Negotiable)

**Every feature, every screen, every button is available in both English and Arabic.** No exceptions. No hidden features. No read-only modes.

Examples of what **NOT** to do:
- ❌ Hide "Captain Adel Chat" in Arabic (it's available in EN, so it's available in AR)
- ❌ Show regulations search only in English (search works in both languages)
- ❌ Disable calculator in one language (if it works in EN, it works in AR)
- ❌ Show different quiz questions based on language (same questions, translated prompts)
- ❌ Truncate Arabic text to fit (expand space/lines if needed; never omit)

---

## QA Verification Checklist

### Phase 1: English (LTR) Verification

**Device Setup:**
- [ ] iOS device or simulator set to English locale (e.g., en_US, en_GB, en_SA)
- [ ] FlyGACA app language preference: English (EN)
- [ ] Time zone: Flexible (doesn't affect UI language, only date/time display)

#### Screen-by-Screen Verification (All 3 Apps)

##### Startup & Onboarding
- [ ] **Splash screen** loads with FlyGACA logo (no locale-specific images)
- [ ] **Disclaimer banner** visible in English: "Fly GACA is an independent educational platform…"
- [ ] **Module home** displays all sections in English:
  - ELPT (English Language Proficiency Test)
  - AIP (Aeronautical Information Publication)
  - Flight Deck (Calculators)
  - Regulations (GACAR Library)
  - Captain Adel (AI Flight Instructor)
- [ ] **Font:** Inter font used throughout (Arial/Helvetica fallback if custom font unavailable)
- [ ] **Text rendering:** No emoji or special character issues
- [ ] **Layout:** All text left-aligned (`.leading`), back buttons on left, settings on right
- [ ] **Button text:**
  - "Start Studying" — readable, no clipping
  - "Sign In" — readable
  - "Start Quiz" — readable
  - "Study Flashcards" — readable
  - All button labels fully visible (not truncated)

##### Quiz Feature
- [ ] **Quiz bank:** "1000+ questions across 4 modules" visible in English
- [ ] **Start Quiz:** Button tappable, quiz launcher opens
- [ ] **Question display:**
  - Prompt/stem in English (complete, no truncation)
  - All 4 options (A, B, C, D) in English
  - Source citation visible: "GACAR Part XX.Y(z)"
  - Option buttons selectable (radio or checkbox style)
- [ ] **Navigation:**
  - "← Previous" button (or similar) in English, left-aligned
  - "Next →" button in English, right-aligned (or standard flow)
  - "Flag for Review" button in English
- [ ] **Results:**
  - Score displayed: "75% (18/25 Correct)" (numbers are LTR, always)
  - Pass/Fail badge: "PASSED" (green) or "NOT PASSED" (red)
  - Breakdown in English: "Module 1: 5/6 (83%)"
  - "Review Answers" button in English, functional
  - No untranslated strings (no [key] placeholders)

##### Flashcard Feature
- [ ] **Flashcard home:** SRS box labels in English
  - "Box 0 (New)"
  - "Box 1 (1 day)"
  - "Box 2 (3 days)"
  - (etc.)
- [ ] **Study session:** Card front/back display
  - Prompt in English
  - Answer in English
  - Source citation in English
- [ ] **Judgment buttons:** All in English
  - 🔴 "Wrong"
  - 🟡 "Hard"
  - 🟢 "Correct"
- [ ] **Session stats:** "Session complete! 5/8 mastered, 0 reset. Streak: +5" (in English, numbers LTR)
- [ ] **Streak celebration:** "🎉 5-card streak! Keep it going!" (if implemented)

##### Mock Exam
- [ ] **Setup screen:**
  - "ELPT Mock Exam" (in English)
  - "Duration: 30 minutes"
  - "Questions: 25 questions"
  - "Passing score: 75%"
- [ ] **Exam in progress:**
  - Timer displays correctly (MM:SS format, numbers LTR)
  - "Question X of 25" (numbers LTR)
  - "Next →" button in English
  - No "Previous" button (exams are forward-only)
- [ ] **Results:**
  - Score, breakdown, time completed all in English
  - No untranslated keys visible

##### Regulations (AIP Only)
- [ ] **Regulations search:**
  - Search placeholder text: "Search regulations…" (in English)
  - Search results list all matching parts in English
  - Part titles: "Part 1 — Definitions and General Requirements" (full English title)
- [ ] **Part detail:**
  - Full part text displayed in English
  - Section headings in English (e.g., "§ 61.1 — Applicability")
  - Disclaimer in English: "This is an educational reference. Verify on gaca.gov.sa…"
  - No Arabic mixed in (pure English rendering)
- [ ] **Navigation within part:**
  - Table of contents (TOC) sidebar in English
  - Section links work, content updates to English section

##### Aerodromes (AIP Only)
- [ ] **Aerodrome selector:**
  - List of 61 aerodromes with English names
  - "Riyadh International (OERK)" (English name)
  - Search placeholder in English
- [ ] **Aerodrome detail:**
  - "Riyadh King Fahd Regional Airport" (English name)
  - Coordinates, elevation, runway data in English
  - "Service info" heading in English
  - Buttons: "Save to Favorites", "View on Map" (in English)

##### Flight Deck Calculators (All Apps)
- [ ] **Calculator gallery:**
  - Category headings in English: "E6B Emulation", "Weight & Balance", "Navigation", etc.
  - Calculator names in English: "True Airspeed", "Crosswind Component", etc.
  - Search placeholder in English
- [ ] **Crosswind calculator (example):**
  - Input labels in English: "Runway heading", "Wind direction", "Wind speed"
  - Unit labels in English: "(degrees)", "(knots)"
  - Output labels in English: "Headwind", "Crosswind"
  - Buttons: "Save", "Clear", "Copy" (in English)

##### Settings Screen
- [ ] **Account section:**
  - "Sign In" button (in English) OR
  - "Signed in as: user@example.com" (in English) + "Sign Out" button
- [ ] **Language preference:**
  - "Language" label in English
  - "English" and "العربية" options visible
  - Current selection highlighted (should be "English" now)
- [ ] **Theme:**
  - "Theme" label in English
  - Options: "Auto", "Light", "Dark" (in English)
- [ ] **Disclaimer banner:**
  - Full English disclaimer visible: "Fly GACA is an independent educational platform…"
  - Readable, not truncated
- [ ] **Links:**
  - "Privacy Policy" — link in English
  - "Terms of Use" — link in English
  - Links are tappable and working

##### App-Specific Details
- [ ] **ELPT app:** Bundle ID shows as `com.flygaca.elpt` (in Settings or app info)
- [ ] **AIP app:** Bundle ID shows as `com.flygaca.aip`
- [ ] **Flagship app:** Bundle ID shows as `com.flygaca.app`
- [ ] **Version number:** Consistent across all 3 apps (if applicable)
- [ ] **Build number:** Visible in Settings (if "About" section present)

---

### Phase 2: Arabic (RTL) Verification

**Device Setup:**
- [ ] iOS device or simulator set to Arabic locale (e.g., ar_SA, ar_AE, ar)
- [ ] **OR** FlyGACA app language preference manually set to Arabic (العربية)
- [ ] Clear app cache / restart to ensure full RTL layout

#### Screen-by-Screen Verification (All 3 Apps)

##### Startup & Onboarding
- [ ] **Splash screen** loads identically (no locale-specific image changes)
- [ ] **Disclaimer banner** appears in Arabic:
  - "فلاي قاكا منصة تعليمية مستقلة…"
  - **Note:** Exact Arabic translation matches English meaning (see REGULATED-CONTENT-CERTIFICATION.md)
- [ ] **Module home** displays all sections in Arabic:
  - اختبار القدرة على اللغة الإنجليزية (ELPT)
  - منشور المعلومات الملاحية (AIP)
  - طاقم الرحلات (Flight Deck)
  - اللوائح (Regulations)
  - الكابتن عادل (Captain Adel)
- [ ] **Font:** Cairo font used throughout (Arabic-specific glyphs render correctly)
- [ ] **Layout:** RTL layout activated
  - Text right-aligned (`.trailing`)
  - Back button on RIGHT side (not left)
  - Settings button on LEFT side (not right)
  - All UI elements mirrored
- [ ] **Numbers:** Numbers always LTR (25, 09:30, 75%), even in RTL context
  - Coordinates displayed as: "24.9242° N, 46.6983° E" (numbers LTR, Arabic text RTL)
- [ ] **Button alignment:** All buttons remain centered or flow with RTL direction
  - No overlaps or misalignments caused by mirroring

##### Quiz Feature (Arabic)
- [ ] **Quiz bank:** "1000+ questions across 4 modules" in Arabic
- [ ] **Start Quiz:** Button tappable, quiz launcher opens in Arabic
- [ ] **Question display:**
  - Prompt/stem in Arabic (complete, no truncation, proper diacritics if needed)
  - All 4 options (أ, ب, ج, د) **OR** (A, B, C, D) with Arabic option labels
  - Source citation in Arabic: "جزء GACAR XX.Y(z)" (or similar — regulation number stays numeric)
  - Option buttons selectable
- [ ] **Navigation:**
  - "← السابق" (Previous, but arrow points right in RTL) — on RIGHT side of screen
  - "التالي →" (Next, arrow points left in RTL) — on LEFT side of screen
  - "علم للمراجعة" (Flag for Review) in Arabic
- [ ] **Results:**
  - Score displayed: "75% (18/25 صحيح)" (numbers LTR, Arabic text RTL)
  - Pass/Fail badge: "نجح" (green) or "لم تنجح" (red)
  - Breakdown in Arabic: "الوحدة 1: 5/6 (83%)"
  - "مراجعة الإجابات" (Review Answers) button in Arabic, functional
  - No [key] placeholders (all strings translated)

##### Flashcard Feature (Arabic)
- [ ] **Flashcard home:** SRS box labels in Arabic
  - "الصندوق 0 (جديد)"
  - "الصندوق 1 (يوم واحد)"
  - (etc.)
- [ ] **Study session:** Card front/back display in Arabic
  - Prompt in Arabic
  - Answer in Arabic
  - Source citation in Arabic
- [ ] **Judgment buttons:** All in Arabic
  - 🔴 "خطأ" (Wrong)
  - 🟡 "صعب" (Hard)
  - 🟢 "صحيح" (Correct)
- [ ] **Session stats:** "اكتملت الجلسة! 5/8 تم إتقانها، 0 إعادة. سلسلة: +5" (in Arabic, numbers LTR)

##### Mock Exam (Arabic)
- [ ] **Setup screen:**
  - "اختبار ELPT النهائي" (in Arabic)
  - "المدة: 30 دقيقة"
  - "الأسئلة: 25 سؤال"
  - "درجة النجاح: 75%"
- [ ] **Exam in progress:**
  - Timer displays correctly (MM:SS, numbers LTR)
  - "السؤال X من 25" (in Arabic, numbers LTR)
  - "التالي →" button in Arabic
  - No "السابق" button (exams forward-only, even in Arabic)
- [ ] **Results:** All in Arabic, numbers LTR

##### Regulations (AIP Only, Arabic)
- [ ] **Regulations search:**
  - Search placeholder in Arabic: "ابحث عن اللوائح…"
  - Results list in Arabic
  - Part titles in Arabic (or title + number): "الجزء 1 — التعاريف والمتطلبات العامة"
- [ ] **Part detail:**
  - Full part text in Arabic
  - Section headings in Arabic: "§ 61.1 — التطبيق"
  - Disclaimer in Arabic
  - No English mixed in
- [ ] **Navigation:** TOC sidebar in Arabic, section links work

##### Aerodromes (AIP Only, Arabic)
- [ ] **Aerodrome selector:**
  - List of 61 aerodromes with Arabic names (or Arabic aliases + ICAO codes)
  - "مطار الرياض الدولي (OERK)" (Riyadh + ICAO code)
  - Search in Arabic
- [ ] **Aerodrome detail:**
  - Aerodrome name in Arabic
  - Coordinates, elevation, runways displayed correctly (numbers LTR)
  - Service info in Arabic
  - Buttons in Arabic

##### Flight Deck Calculators (Arabic)
- [ ] **Calculator gallery:**
  - Category headings in Arabic
  - Calculator names in Arabic
  - Search in Arabic
- [ ] **Crosswind calculator:**
  - Input labels in Arabic: "اتجاه المدرج", "اتجاه الريح", "سرعة الريح"
  - Unit labels in Arabic
  - Output labels in Arabic: "الريح الأمامية", "الريح الجانبية"
  - Buttons in Arabic

##### Settings Screen (Arabic)
- [ ] **Account section:**
  - "تسجيل الدخول" (in Arabic) OR "تم تسجيل الدخول كـ: …" (in Arabic)
- [ ] **Language preference:**
  - "اللغة" label in Arabic
  - "English" and "العربية" options visible
  - Current selection highlighted (should be "العربية" now)
- [ ] **Theme:** In Arabic
- [ ] **Disclaimer banner:** Full Arabic disclaimer visible and readable
- [ ] **Links:** In Arabic

---

### Phase 3: Cross-App Language Consistency

**Setup:** All 3 apps installed, test account signed in to all 3.

#### Language Toggle Consistency
- [ ] **In Flagship:** Toggle Language EN → AR
  - App immediately switches to Arabic RTL layout
- [ ] **Switch to ELPT:** Language is Arabic (inherited from Flagship via App Group)
  - No re-toggle needed
- [ ] **Switch to AIP:** Language is Arabic (inherited)
- [ ] **In AIP:** Toggle Language AR → EN
  - App immediately switches to English LTR layout
- [ ] **Switch to Flagship:** Language is English (updated via App Group)
- [ ] **Switch to ELPT:** Language is English

**Conclusion:** Language selection shared across all 3 apps (no per-app language parity needed; all 3 inherit the single user language preference).

#### Feature Parity Across Apps (EN & AR)
- [ ] **ELPT quiz:** Available in both EN and AR, same questions, same parity
- [ ] **Flagship ELPT quiz:** Identical results to ELPT app
- [ ] **AIP regulations search:** Works in both EN and AR
- [ ] **Flagship regulations:** Same search capabilities as AIP app
- [ ] **Flight calculators:** Available in Flagship + AIP, both EN and AR
- [ ] **Captain Adel:** Available in Flagship only, both EN and AR (online only)

#### Cross-App Progress Sync (EN & AR)
- [ ] **Study in ELPT (EN):** Answer quiz, record score
- [ ] **Switch to Flagship → AIP (EN):** Same score visible in quiz history
- [ ] **Toggle to AR in Settings:** All interfaces switch to Arabic
- [ ] **Study in Flagship (AR):** Answer quiz, record new score
- [ ] **Switch to ELPT (AR):** New score appears in Arabic quiz history
- [ ] **Toggle back to EN:** All apps switch back to English, all scores preserved

---

## Font & Typography Verification

### Inter Font (English)

**Characteristics:**
- Geometric, modern sans-serif
- Character set: Extended Latin (A–Z, a–z, 0–9, punctuation)
- Weights used: 400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold)
- Fallback chain: Inter → Helvetica Neue → Helvetica → Arial

**QA Checks:**
- [ ] Text renders cleanly (no pixelation, proper antialiasing)
- [ ] All weights display correctly (bold headings, normal body)
- [ ] Spacing (kerning, leading) is natural and readable
- [ ] Special characters (©, ®, °, etc.) render correctly
- [ ] Numbers (0-9) align properly, mono-spaced if needed
- [ ] Punctuation (. , : ; ! ?) renders correctly

### Cairo Font (Arabic)

**Characteristics:**
- Arabic-optimized, modern sans-serif
- Character set: Arabic script + Extended Latin (for numbers, English fallback)
- Weights used: 400, 500, 600, 700
- Diacritics: Proper support for Arabic vowel marks (fatha, damma, etc.)
- Fallback chain: Cairo → Arabic Typesetting → Traditional Arabic

**QA Checks:**
- [ ] Arabic text renders clearly (proper glyph shaping, ligatures)
- [ ] All weights display correctly
- [ ] Diacritics align properly above/below Arabic letters
- [ ] Numbers in Arabic text stay LTR (25, 09:30, 75%) — not RTL
- [ ] English text within Arabic context (e.g., GACAR part numbers) renders correctly
- [ ] Spacing is natural (no overlaps, no excessive gaps)
- [ ] Text doesn't get cut off at right edge (proper RTL margin handling)

### Number Formatting

**Rules (Applies to All Languages):**
- [ ] Dates display as YYYY-MM-DD (e.g., "2026-09-05") — always LTR
- [ ] Times display as HH:MM (e.g., "09:30") — always LTR
- [ ] Percentages display as "75%" (number LTR, % symbol LTR) — even in Arabic context
- [ ] Coordinates display as "24.9242° N, 46.6983° E" — numbers LTR, compass directions in user language
- [ ] Quiz scores: "18/25" (slash LTR, numbers LTR)
- [ ] Runway numbers: "09/27" (LTR, standard aviation format)

---

## Disclaimer Bilingual Verification

**English (must appear in English mode):**

> Fly GACA is an independent educational platform. All GACAR content is sourced from the General Authority of Civil Aviation (GACA) and presented without modification. This app is NOT an official GACA product and does not replace official GACA publications. Pilots must always verify current regulations on gaca.gov.sa.

**Arabic (must appear in Arabic mode):**

> فلاي قاكا منصة تعليمية مستقلة. تُستخرج جميع محتويات GACAR من موقع الهيئة العامة للطيران المدني (GACA) وتُقدم كما هي دون تعديل. هذا التطبيق ليس منتجاً رسمياً من GACA ولا يحل محل المنشورات الرسمية. يجب على الطيارين التحقق دائماً من اللوائح الحالية على gaca.gov.sa.

**Verification:**
- [ ] **English disclaimer** appears on app launch (EN mode)
- [ ] **Arabic disclaimer** appears on app launch (AR mode)
- [ ] Both disclaimers are identical in meaning (see REGULATED-CONTENT-CERTIFICATION.md)
- [ ] Disclaimer appears in Settings → About (both EN and AR)
- [ ] Disclaimer appears in initial onboarding (if applicable)
- [ ] Disclaimer is readable, not truncated, proper line breaks

---

## Summary: Verification Passing Criteria

✅ **All Three Apps Pass When:**

1. English mode: All screens, all features work in English (Inter font, LTR layout)
2. Arabic mode: All screens, all features work in Arabic (Cairo font, RTL layout)
3. Language toggle: Switch EN ↔ AR instantly, no restart required
4. Cross-app consistency: Language choice shared across all 3 apps (App Group)
5. Feature parity: No features hidden in either language
6. Numbers: Always LTR (dates, times, percentages, coordinates, scores)
7. Font rendering: No placeholder text, no missing glyphs, no text clipping
8. Disclaimer: Appears in both EN and AR, matches spec exactly
9. Offline: All features work offline in both EN and AR
10. Cloud sync: Progress syncs correctly regardless of language, numbers preserved

---

**Document Status:** Complete  
**Audience:** QA Team, App Store Review  
**Cross-Reference:** [REGULATED-CONTENT-CERTIFICATION.md](REGULATED-CONTENT-CERTIFICATION.md) (disclaimer bilingual spec), [EXTERNAL-SERVICES.md](EXTERNAL-SERVICES.md) (internationalization context)  
**Test Results:** Pass/Fail to be recorded by QA before submission
