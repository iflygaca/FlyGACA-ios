# Phase 3: App State Verification — Quick-Start Guide

**Local Testing on macOS**  
**For:** FlyGACA Flagship, ELPT, AIP  
**Time Required:** 45–60 minutes  
**Prerequisites:** Mac with Xcode 16+, iOS 17+, all 3 apps built and installed on simulator/device

---

## Pre-Flight Checklist

Before starting, verify:
- [ ] You're on branch `claude/new-session-thjamj` (or your designated branch)
- [ ] Xcode 16+ is installed and up to date
- [ ] iOS simulator is running (or device connected)
- [ ] Latest content synced: `bash scripts/sync-content.sh`
- [ ] All 3 apps built: `npm run ios:build:all`

---

## SECTION 1: Build Verification (5 min)

**Goal:** Confirm all 3 apps build without errors

```bash
# In project root
npm run ios:build:all
```

**Expected output:**
- ✅ Build succeeds for `elpt`, `aip`, `flygaca` apps
- ✅ No errors (warnings OK if pre-existing)
- ✅ Build time <5 minutes for debug build
- ✅ Artifacts in `apple/.build/`

**Checklist:**
- [ ] Build succeeded
- [ ] Build time acceptable (<5 min)
- [ ] No new errors introduced

---

## SECTION 2: Launch & Basic Features (20 min)

**Goal:** App launches cleanly, core features work, no crashes

### 2.1 FlyGACA Flagship Launch

```bash
# Launch Flagship app in simulator
open apple/Apps/Shared/FlyGACA.xcworkspace
# Or: npx xcodebuild -scheme FlyGACA -configuration Debug -simulator
```

**On Launch, verify:**
- [ ] App launches without crash
- [ ] Splash screen appears (no hang)
- [ ] Disclaimer banner visible (English or Arabic per device language)
- [ ] "I Understand" button tappable and dismisses banner
- [ ] Module home displays 5 modules:
  - [ ] ELPT
  - [ ] AIP
  - [ ] Flight Deck
  - [ ] Regulations
  - [ ] Captain Adel

### 2.2 Quiz Feature (Flagship)

**Tap ELPT → Quiz:**
- [ ] Quiz bank list loads (no spinner, instant)
- [ ] Tap a bank → questions load
- [ ] Question displays:
  - [ ] Question text readable
  - [ ] Answer options visible (A, B, C, D)
  - [ ] Source citation at bottom (e.g., "GACAR Part 61.3(c)")
- [ ] Answer 3+ questions:
  - [ ] Each answer registers (radio button highlights)
  - [ ] Submit button appears
- [ ] Tap Submit:
  - [ ] Results page displays
  - [ ] Score shows (e.g., "67%", "2/3 correct")
  - [ ] Pass/Fail indicator correct (pass = ≥75%, fail = <75%)
  - [ ] Breakdown by topic shown
  - [ ] Detailed explanations with GACAR citations visible

**Checklist:**
- [ ] Quiz loads instantly (no "Loading…" spinner)
- [ ] Questions display correctly
- [ ] Scoring correct (2/3 = 67%, should show as pass/fail per 75% threshold)
- [ ] Citations visible and accurate
- [ ] No crashes during quiz attempt

### 2.3 Flashcard Feature (Flagship)

**Tap ELPT → Flashcards:**
- [ ] Spaced Repetition (SRS) dashboard displays:
  - [ ] 5 boxes labeled 0, 1, 3, 7, 14, 30 (days)
  - [ ] Card count per box (e.g., "Box 0: 12 cards")
  - [ ] Mastery percentage shown (e.g., "45% mastered")
  - [ ] Streak counter (e.g., "5 day streak")
- [ ] Tap "Study" or "Box 0":
  - [ ] Flashcard appears (front side)
  - [ ] Question text readable
  - [ ] Tap card or "Reveal" → back side shows
  - [ ] Answer explanation visible
  - [ ] Mark "Correct" button:
    - [ ] Card moves to next box (0→1)
    - [ ] Next card loads
  - [ ] Mark "Wrong" button:
    - [ ] Card stays in Box 0
    - [ ] Next card loads

**Checklist:**
- [ ] SRS dashboard loads with correct box layout
- [ ] Cards load instantly
- [ ] Correct/Wrong buttons update boxes correctly
- [ ] No crashes during flashcard study

### 2.4 Mock Exam (Flagship)

**Tap ELPT → Mock Exam:**
- [ ] Exam setup screen displays:
  - [ ] "Start Exam" button
  - [ ] Exam details: "25 questions, 30 minutes, 75% to pass"
- [ ] Tap Start:
  - [ ] Timer starts (0:00, ticking)
  - [ ] First question displays
  - [ ] Progress indicator shows (e.g., "Question 1 of 25")
- [ ] Answer 3+ questions, then "Submit":
  - [ ] Results page displays
  - [ ] Score shows (percent and pass/fail)
  - [ ] Time taken shown
  - [ ] Breakdown by topic
  - [ ] Performance analytics visible (optional)

**Checklist:**
- [ ] Exam setup clear and correct
- [ ] Timer starts and counts down
- [ ] Questions display sequentially
- [ ] Submit calculates score correctly
- [ ] Results page shows breakdown
- [ ] No crashes during exam

### 2.5 Regulations (Flagship)

**Tap "Regulations" module:**
- [ ] Regulations home displays
- [ ] Search bar visible at top
- [ ] Tap search, type "Part 61":
  - [ ] Results appear (instantly, no spinner)
  - [ ] "Part 61" heading visible
  - [ ] Tap Part 61:
    - [ ] Full regulation text loads
    - [ ] Disclaimer at top (independent educational platform)
    - [ ] Table of contents / section navigation visible
    - [ ] Tap a section → scrolls to that content
- [ ] Text is readable (font size, contrast)

**Checklist:**
- [ ] Search works instantly
- [ ] Part loads cleanly
- [ ] No crashes during navigation
- [ ] Disclaimer visible

### 2.6 Flight Deck Calculators (Flagship)

**Tap "Flight Deck" module:**
- [ ] Calculator gallery displays (list or grid)
- [ ] Tap "Crosswind Calculator":
  - [ ] Input fields visible:
    - [ ] Wind speed (knots)
    - [ ] Wind angle (degrees)
    - [ ] Runway heading (degrees)
  - [ ] Enter test values (e.g., 15 knots, 45°, runway 180°)
  - [ ] Output updates in real-time:
    - [ ] Headwind component
    - [ ] Crosswind component
  - [ ] Values are reasonable (mathematically correct)

**Checklist:**
- [ ] Calculator loads
- [ ] Inputs work
- [ ] Calculations correct
- [ ] No crashes

### 2.7 Captain Adel Chat (Flagship)

**Tap "Captain Adel" module:**
- [ ] Chat interface displays
- [ ] Message input field visible
- [ ] Look for one of:
  - [ ] "Offline" badge (feature is online-only)
  - [ ] Chat input + "Send" button (if online)
- [ ] **Do NOT attempt to send messages** (not needed for this test)
- [ ] No crashes

**Checklist:**
- [ ] Captain Adel section loads
- [ ] Clear indication of online-only status

### 2.8 Settings (Flagship)

**Tap Settings icon (gear):**
- [ ] Settings screen displays
- [ ] Sign In section visible (email/phone sign-in option, or "Signed in as…")
- [ ] Language toggle visible (EN / العربية):
  - [ ] Tap to toggle
  - [ ] Entire UI switches instantly (see Section 3 below)
- [ ] Cloud sync section visible:
  - [ ] Sync status shown ("Not synced" / "Synced" / "Syncing…")
- [ ] Disclaimer section:
  - [ ] "View Full Disclaimer" link
  - [ ] Tap → full disclaimer displays in correct language
- [ ] App version shown
- [ ] Support/Privacy links visible

**Checklist:**
- [ ] Settings accessible
- [ ] Language toggle works
- [ ] Disclaimer viewable
- [ ] No crashes

---

## SECTION 3: Bilingual & RTL Verification (15 min)

**Goal:** Confirm English/Arabic rendering, RTL layout, no text truncation

### 3.1 Language Toggle Test (All 3 Apps)

**In Settings, tap Language toggle (EN ↔ العربية):**

**English Version (After toggling to EN):**
- [ ] All text is in English
- [ ] Font is **Inter** (sans-serif, modern)
- [ ] Layout is **LTR** (left-to-right):
  - [ ] Back button on left side
  - [ ] Text flows left → right
  - [ ] Numbers (time, scores, percentages) are **LTR**
- [ ] **No Arabic text visible** (toggle worked completely)
- [ ] No text truncation or overflow
- [ ] Buttons/UI elements properly aligned

**Arabic Version (After toggling to AR / العربية):**
- [ ] All text is in Arabic
- [ ] Font is **Cairo** (serif, RTL-optimized)
- [ ] Layout is **RTL** (right-to-left):
  - [ ] Back button on right side
  - [ ] Text flows right → left
  - [ ] **Numbers stay LTR** (time 10:30, scores, percentages, coordinates)
  - [ ] Punctuation and diacritics render correctly
- [ ] **No English text visible** (except proper nouns if any)
- [ ] No text truncation or overflow
- [ ] Buttons/UI elements properly aligned
- [ ] Special characters (like ء، ؤ، ئ) display cleanly

**Toggle back and forth (EN ↔ AR) 3 times:**
- [ ] Toggle works smoothly each time
- [ ] No UI elements stuck between languages
- [ ] Preference persists after app close/reopen

**Checklist (repeat for all 3 apps):**
- [ ] Flagship:
  - [ ] English (Inter, LTR) ✓
  - [ ] Arabic (Cairo, RTL) ✓
  - [ ] Numbers stay LTR ✓
  - [ ] No truncation ✓
  - [ ] Toggle works ✓
- [ ] ELPT:
  - [ ] English (Inter, LTR) ✓
  - [ ] Arabic (Cairo, RTL) ✓
  - [ ] Numbers stay LTR ✓
  - [ ] No truncation ✓
  - [ ] Toggle works ✓
- [ ] AIP:
  - [ ] English (Inter, LTR) ✓
  - [ ] Arabic (Cairo, RTL) ✓
  - [ ] Numbers stay LTR ✓
  - [ ] No truncation ✓
  - [ ] Toggle works ✓

### 3.2 Disclaimer Bilingual Check

**In Settings → "View Full Disclaimer":**

**English:**
- [ ] Starts with "Fly GACA is an independent educational platform…"
- [ ] Mentions "General Authority of Civil Aviation (GACA)"
- [ ] States "not affiliated with… GACA or the Government of Saudi Arabia"
- [ ] Says "verify current regulations on gaca.gov.sa"
- [ ] Ends with "NOT for operational use in flight"

**Arabic:**
- [ ] Exact translation of English version (same meaning, same structure)
- [ ] No paraphrasing or simplification
- [ ] Contains "فلاي قاكا منصة تعليمية مستقلة" (opening phrase in Arabic)
- [ ] Same regulatory caveats as English

**Checklist:**
- [ ] Disclaimer text matches between EN/AR ✓
- [ ] Both languages render cleanly ✓
- [ ] No truncation ✓

---

## SECTION 4: Offline Mode Test (10 min)

**Goal:** Confirm all core features work without internet

### 4.1 Enable Airplane Mode

**iOS Settings → Airplane Mode → ON**
- [ ] WiFi icon disappears from status bar
- [ ] Cellular icon changes (appears crossed out or grayed)
- [ ] No network connectivity

### 4.2 Test Each App (All 3 Apps)

**FlyGACA Flagship (Offline):**
- [ ] App launches
- [ ] Quiz bank loads instantly (no "Loading…" or "No internet" error)
- [ ] Start quiz → answer questions → results display ✓
- [ ] Flashcards load → study cards ✓
- [ ] Mock exam runs to completion ✓
- [ ] Regulations search works (tap Part 61, reads cleanly) ✓
- [ ] Calculators work (enter values, output updates) ✓
- [ ] Captain Adel shows "Offline" status (no crash when tapped) ✓
- [ ] Settings accessible ✓
- [ ] No "Network connection failed" errors ✓
- [ ] No crashes ✓

**Fly GACA ELPT (Offline):**
- [ ] App launches
- [ ] Quiz works (answer questions, get results) ✓
- [ ] Flashcards work ✓
- [ ] Mock exam works ✓
- [ ] Settings accessible ✓
- [ ] No network errors ✓

**Fly GACA AIP (Offline):**
- [ ] App launches
- [ ] Regulations search works (Part 61 loads cleanly) ✓
- [ ] Aerodromes lookup works (search/browse, tap Riyadh) ✓
- [ ] Flight Deck calculators work (enter values, results update) ✓
- [ ] No network errors ✓

**Checklist:**
- [ ] All 3 apps work fully offline
- [ ] No "Loading…" spinners or network errors
- [ ] All core features functional
- [ ] No crashes

### 4.3 Disable Airplane Mode & Verify Auto-Sync

**iOS Settings → Airplane Mode → OFF**
- [ ] WiFi/cellular reconnect
- [ ] If signed in (using test account):
  - [ ] Progress auto-syncs to cloud (should happen in background, no prompt)
  - [ ] No errors or sync failures
- [ ] If not signed in:
  - [ ] No sign-in prompt appears
  - [ ] App continues normally

**Checklist:**
- [ ] Network restored
- [ ] Auto-sync works (if signed in)
- [ ] No errors on reconnection
- [ ] All apps still functional

---

## SECTION 5: ELPT App Standalone Test (5 min)

**Goal:** Verify ELPT app works as standalone (no module selector)

**Launch Fly GACA ELPT app:**
- [ ] App opens directly to ELPT module home (no "Select Module" step)
- [ ] ELPT-specific features visible:
  - [ ] Quiz banks (listening, reading, speaking, writing)
  - [ ] Flashcards
  - [ ] Mock exam
  - [ ] Progress analytics
- [ ] All features work (quiz, flashcards, exam)
- [ ] Settings accessible
- [ ] Language toggle works
- [ ] Offline mode works
- [ ] No crashes

**Checklist:**
- [ ] Standalone app works correctly
- [ ] No module selector visible
- [ ] All features present and functional

---

## SECTION 6: AIP App Standalone Test (5 min)

**Goal:** Verify AIP app works as standalone (no module selector)

**Launch Fly GACA AIP app:**
- [ ] App opens directly to AIP home (no "Select Module" step)
- [ ] Three sections visible:
  - [ ] Regulations (search, Part 61 works)
  - [ ] Aerodromes (search, Riyadh works)
  - [ ] Flight Deck (calculators work)
- [ ] All features work offline
- [ ] Settings accessible
- [ ] Language toggle works
- [ ] No crashes

**Checklist:**
- [ ] Standalone app works correctly
- [ ] No module selector visible
- [ ] All 3 sections present and functional

---

## SECTION 7: Cross-App Consistency Test (5 min)

**Goal:** Verify all 3 apps behave identically

**Test these across all 3 apps:**

1. **Disclaimer:**
   - [ ] All 3 apps show identical disclaimer (word-for-word)
   - [ ] Both languages match across apps

2. **Language Toggle:**
   - [ ] Toggle in Flagship → EN/AR changes
   - [ ] Toggle in ELPT → EN/AR changes
   - [ ] Toggle in AIP → EN/AR changes
   - [ ] **All 3 apps inherit the same preference** (if you toggle in one, others show that language)

3. **Offline Mode:**
   - [ ] Airplane Mode OFF in all 3 apps
   - [ ] Airplane Mode ON in all 3 apps
   - [ ] All continue to work

4. **No Debug UI:**
   - [ ] Flagship: No "[DEBUG]", "[TEST]", or placeholder text visible anywhere
   - [ ] ELPT: No debug UI
   - [ ] AIP: No debug UI

5. **App Icons & Display Names:**
   - [ ] Flagship: Icon shows "FlyGACA", app name "FlyGACA"
   - [ ] ELPT: Icon shows different design, app name "Fly GACA ELPT"
   - [ ] AIP: Icon shows different design, app name "Fly GACA AIP"

**Checklist:**
- [ ] Disclaimer identical across all 3 apps
- [ ] Language preference shared (toggle in one affects all 3)
- [ ] Offline mode consistent
- [ ] No debug UI in any app
- [ ] App names and icons correct

---

## SECTION 8: Final Sign-Off

**Review all sections above. If all checks pass:**

| Section | Status | Notes |
|---------|--------|-------|
| 1. Build Verification | ☐ PASS | |
| 2. Launch & Basic Features | ☐ PASS | |
| 3. Bilingual & RTL | ☐ PASS | |
| 4. Offline Mode | ☐ PASS | |
| 5. ELPT Standalone | ☐ PASS | |
| 6. AIP Standalone | ☐ PASS | |
| 7. Cross-App Consistency | ☐ PASS | |

**Overall Phase 3 Result:**

- ☐ **PASS** — All sections pass, all apps ready for submission
- ☐ **FAIL** — Issues found (list below):
  - Issue 1: ________________
  - Issue 2: ________________
  - Issue 3: ________________

**If FAIL:** Fix issues, re-run relevant sections, then re-sign-off above.

**Tester Name:** ________________  
**Date:** ________________  
**Time Spent:** ________________  

---

## Troubleshooting

**App won't build:**
- [ ] Run `npm run ios:generate` to regenerate Xcode project
- [ ] Run `bash scripts/sync-content.sh` to refresh content
- [ ] Check Xcode 16+ installed: `xcodebuild -version`

**App crashes on launch:**
- [ ] Check Xcode console for error messages
- [ ] Clear simulator: `xcrun simctl erase all`
- [ ] Rebuild: `npm run ios:build:all`

**Content loads slowly:**
- [ ] Content should be instant (bundled, not downloaded)
- [ ] If slow, clear app cache: iOS Settings → FlyGACA → Clear Cache
- [ ] Restart simulator and relaunch app

**Bilingual toggle not working:**
- [ ] Ensure Settings → Language toggle is present
- [ ] Tap once (should toggle EN ↔ AR)
- [ ] Restart app; language preference should persist

**Offline mode fails:**
- [ ] Verify Airplane Mode is truly ON (status bar shows plane icon)
- [ ] Close app, wait 5 seconds, relaunch
- [ ] Try again

**Still have issues?**  
Contact: support@flygaca.com  
Reference: Phase 3 Quick-Start Guide

---

**Document Status:** Ready for Use  
**Version:** 1.0  
**Last Updated:** 2026-09-05

