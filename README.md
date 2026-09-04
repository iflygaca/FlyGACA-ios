<div align="center">

# 📱 **Fly GACA iOS**
> *Native flight deck for your pocket*

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/STATUS-TestFlight_Beta-00ff88?style=for-the-badge&labelColor=0a0e12&fontColor=ffffff">
  <img alt="Status: Beta" src="https://img.shields.io/badge/STATUS-TestFlight_Beta-0D96F6?style=for-the-badge&labelColor=0a0e12">
</picture>

**SwiftUI** · **100% Offline** · **Bilingual** · **App Groups** · **Exam Prep**

</div>

## 🏗 Fly GACA Family

[📚 FlyGACA Web & API](https://github.com/ay2m/FlyGACA) • 
[🤖 Captain Adel AI](https://github.com/ay2m/Captain-Adel) • 
[📱 FlyGACA iOS](https://github.com/ay2m/FlyGACA-ios) • 
[🏢 Office & Governance](https://github.com/ay2m/Office)

<!-- 
  README ENHANCEMENT AUDIT — ay2m/FlyGACA-ios
  Last audit: 2026-09-04 by claude-readme-supervisor
  Status: READY for phase 1 (family links + audit blocks added)
  
  DRIFT RISKS IDENTIFIED:
  - No app bundle size metrics (ELPT/AIP) — binary footprint unknown to readers
  - No question count per app — content scope not transparent
  - No test count badge (5 test targets in Package.swift) — Swift test coverage hidden
  - "Coming Soon" milestones lack ETAs — readers can't gauge timeline
  - ELPT/AIP links don't point to App Store or TestFlight beta pages
  - No bilingual status indicator — Arabic localization readiness unclear
  - No reference to FlyGACAKit dependency or Content/ sync process
  
  PHASE 2 TASKS:
  - Extract app bundle size from last successful `ios:build:release:all` artifact
  - Count quiz.json entries per app (ELPT module.json + quiz.json line count)
  - Extract swift test count from `Package.swift` testTargets array
  - Parse git tags for version/timeline context
  - Gather TestFlight beta tester count from App Store Connect API
  
  PHASE 3 TASKS:
  - Create `.github/workflows/readme-supervisor.yml` with App Store Connect API credential
  - Link "ELPT" and "AIP" to App Store/TestFlight pages
  - Add inline bundle size and question count to app descriptions
  
  CROSS-REPO SYNC CHECK: Family contract parity ✓ (ay2m/Office, ay2m/FlyGACA aligned)
-->

---

## 🎯 What's this?

Fly GACA for iOS is a **native flight study and calculator app** built with SwiftUI for iPhone and iPad. Everything you need for flight training—no internet required.

### Currently Shipping
✅ **ELPT** (Saudi Pilot English Language Test)  
✅ **AIP** (Aeronautical Information Publication)  

### Coming Soon
📋 PPL, CPL, IR, ATPL (previously paused, architecture ready)

---

## 🌟 Key Features

### **📖 100% Offline**
Study GACAR, quiz banks, flashcards—all on device. Perfect for the flight bag.

### **🎓 Spaced Repetition (SRS)**
Leitner-based flashcard system. Boxes 0–5, intervals of 1–30 days. Web-parity algorithms.

### **🧮 Flight Calculators**
- Crosswind & runway components
- Altimetry & density altitude
- Weight & balance (CG envelope)
- Fuel reserves & burn rate
- Part 91 compliance checks

### **🤖 Captain Adel AI Chat** *(coming)*
Grounded RAG with exact GACAR citations. Available on-device via SSE streaming.

### **🌤️ Saudi Weather Integration** *(coming)*
Live METAR/TAF for 61 Saudi aerodromes. NOAA weather feeds.

### **🌍 Bilingual Interface**
Native RTL/LTR switching. Arabic + English. Proper typography (Cairo, Inter).

### **💾 App Group Sync**
All apps in the family share study progress. Switch between ELPT and AIP—your streaks follow you.

---

## ⚡ Quick Start

### Requirements
- **macOS 14+** (Sonoma or Sequoia)
- **Xcode 16+**
- **Swift 5.9+**
- **iOS 17+ deployment target**

### 1️⃣ Clone & Setup
```bash
git clone https://github.com/ay2m/FlyGACA-ios.git
cd FlyGACA-ios
npm install              # Thin package.json for scripts only
```

### 2️⃣ Generate Xcode Project
```bash
npm run ios:generate
# Creates apple/FlyGACA.xcodeproj from apple/project.yml
```

### 3️⃣ Build & Run
```bash
npm run ios:build:debug:elpt
# Or open in Xcode: open apple/FlyGACA.xcodeproj
```

---

## 🏗 Architecture

```
FlyGACAKit (Zero-dependency Swift package)
│
├─ CoreModels              (Question, Module, Study types)
├─ StudyEngines            (SRS, sessions, readiness—no IO)
├─ ContentKit              (JSON loading + signed refresh)
├─ AppServices             (Protocol seams + mocks)
├─ PersistenceKit          (SwiftData + App Group)
├─ PlatformLive            (Firebase, Captain Adel, Moyasar—not yet wired)
└─ FeatureUI               (All screens & components)
```

**No external SDK dependencies.** `swift test` runs in <10s. Every screen previews offline.

---

## 📦 File Structure

```
apple/
├── Apps/
│   ├── Shared/            # Common app shell (FlyGACAApp.swift)
│   ├── ELPT/              # ELPT-specific config
│   ├── AIP/               # AIP-specific config
│   └── Content/           # Bundled quiz.json, module.json (synced from web)
├── FlyGACAKit/            # Swift package (5 targets)
├── Scripts/
│   ├── native/            # Build orchestration
│   ├── html-render/       # App Store screenshot mocks
│   └── sign-corpus.sh     # Ed25519 corpus signing
├── project.yml            # XcodeGen source of truth
└── README.md              # Architecture deep-dive
```

---

## 🧪 Testing

### Unit Tests (5 targets)
```bash
npm run ios:test
# CoreModelsTests, StudyEnginesTests, ContentKitTests, 
# PersistenceKitTests, PlatformLiveTests
```

### Parity Vectors
Study algorithms (SRS) are mathematically verified against web test vectors:
- Leitner box progression
- Spaced repetition intervals
- Streak calculation
- Exam scoring

See `apple/FlyGACAKit/Tests/StudyEnginesTests/` for vectors.

---

## 🎯 Commands

```bash
# Build & Test
npm run ios:test                  # Swift test suite
npm run ios:test:watch            # Live test mode
npm run ios:build:debug:elpt      # Debug build (ELPT)
npm run ios:build:release:all     # Unsigned release archives
npm run ios:clean                 # Clean build artifacts

# Code Generation
npm run ios:generate              # XcodeGen → .xcodeproj
npm run ios:info                  # Env + available commands

# Signing & Deploy
npm run firebase:register         # Register Firebase apps
npm run sync:content              # Pull quiz.json from web monorepo

# Screenshots (Mac-free mockups)
npm run ios:screenshots           # Portrait mockups (Playwright)
node apple/Scripts/html-render/render-landscape.js  # Landscape
```

---

## 🔐 Signing & TestFlight

Manual signing (App Groups require named profiles, not wildcards).

**Setup:** `docs/RUNBOOK-ios-signing.md`  
**Checklist:** `docs/RUNBOOK-ios-signing-CHECKLIST.md`  
**Firebase:** `docs/RUNBOOK-ios-firebase.md`  

TestFlight apps ship on `main` pushes via GitHub Actions (`.github/workflows/ios.yml`).

---

## 🌐 App Group & Persistence

All Fly GACA apps on one device share:
- 📊 Study progress (quiz history, flashcard boxes)
- 🔥 Streaks (consecutive study days)
- 🎯 Mastery levels (per-question SRS state)

**App Group ID:** `group.com.FlyGACA`  
**Storage:** SwiftData (on-device SQLite)  
**Sync:** `StudyStore` actor (thread-safe writes)  

---

## 🚀 What's Coming

| Phase | Status | What |
|-------|--------|------|
| **Phase 1** | ✅ Done | Native apps (ELPT, AIP), offline study |
| **Phase 2** | ✅ Done | Captain Adel SSE chat (code ready, not yet wired) |
| **Phase 3** | 🚧 In progress | Live weather, flight tracking integration |
| **Phase 4** | 📋 Planned | Moyasar billing, in-app purchases, sync to cloud |
| **Phase 5** | 🎯 Strategic | PPL, CPL, IR, ATPL (paused pending decision) |

---

## 📖 Full Docs

- **[apple/ARCHITECTURE.md](./apple/ARCHITECTURE.md)** — Deep technical dive
- **[apple/README.md](./apple/README.md)** — Setup & build guide
- **[docs/RUNBOOK-ios-release.md](./docs/RUNBOOK-ios-release.md)** — Release checklist
- **[docs/RUNBOOK-ios-xcodebuild.md](./docs/RUNBOOK-ios-xcodebuild.md)** — Build troubleshooting
- **[CAUSE.md](./CAUSE.md)** — Mission & principles
- **[ROADMAP.md](./ROADMAP.md)** — Feature roadmap

---

## 🇸🇦 PDPL & Data Residency

- ✅ All user data stays in Saudi Arabia (`me-central2`)
- ✅ No biometrics, passports, or sensitive PII
- ✅ Immutable audit trail (who studied what, when)
- ✅ Right-to-be-forgotten deletion implemented
- ✅ Zero external trackers on the device

---

## 🧑‍💻 Contributing

We welcome pilots, iOS engineers, designers, and aviation enthusiasts.

1. **Fork** this repo
2. **Create** a feature branch
3. **Test** thoroughly (`npm run ios:test`)
4. **Push** and open a **Pull Request**

See [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## 📜 License

MIT © BDA Company International, operating as Fly GACA

---

<div align="center">

**Study offline. Fly prepared. Master the regulations.**

[TestFlight Beta](https://testflight.apple.com/join/...) · [Report Issues](https://github.com/ay2m/FlyGACA-ios/issues) · [Star ⭐](https://github.com/ay2m/FlyGACA-ios)

🇸🇦 صنع في السعودية · Made in Saudi Arabia

</div>
