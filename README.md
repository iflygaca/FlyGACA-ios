<div align="center">

<img src="https://raw.githubusercontent.com/FlyGACA/FlyGACA-ios/main/apple/Apps/Shared/Assets.xcassets/AppIcon.appiconset/1024.png" width="128" alt="Fly GACA iOS Falcon Logo" />

# 📱 Fly GACA — Native iOS
### The Native SwiftUI Flight Deck & EFB for Saudi Civil Aviation
#### تطبيق الطيران السعودي المتكامل لأجهزة iPhone و iPad

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="صنع في السعودية" />
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white&labelColor=0a0e12" alt="Swift 5.9+" /></a>
  <a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/iOS-17+-000000?style=for-the-badge&logo=apple&logoColor=white&labelColor=0a0e12" alt="iOS 17+" /></a>
  <a href="https://developer.apple.com/xcode"><img src="https://img.shields.io/badge/Xcode-16+-147EFB?style=for-the-badge&logo=xcode&logoColor=white&labelColor=0a0e12" alt="Xcode 16+" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-006C35?style=for-the-badge&labelColor=0a0e12" alt="MIT License" /></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/TestFlight-Beta-0D96F6?style=flat-square&logo=testflight&logoColor=white&labelColor=0a0e12" alt="TestFlight" />
  <img src="https://img.shields.io/badge/Bilingual-EN%20%2F%20AR-C8A04A?style=flat-square&labelColor=0a0e12" alt="Bilingual" />
  <img src="https://img.shields.io/badge/Architecture-100%25%20Offline%20First-FF6B00?style=flat-square&labelColor=0a0e12" alt="Offline First" />
  <img src="https://img.shields.io/badge/Persistence-SwiftData-8E75B2?style=flat-square&labelColor=0a0e12" alt="SwiftData" />
</p>

[**⚡ Quickstart**](#-building--running) · [**📱 Flagship Modules**](#-flagship-modules) · [**🏗 Architecture**](#-architecture) · [**🛡️ Privacy & Offline**](#-offline-first-principles)

</div>

---

> [!IMPORTANT]
> **Independent Educational EFB.** Fly GACA iOS is an independent training and flight tool app and is not affiliated with GACA. The official and authoritative source for all Saudi civil aviation regulations is always [gaca.gov.sa](https://gaca.gov.sa).

---

## 🛫 Offline-First Principles

Every feature in the Fly GACA iOS app is built for the **flight bag**:

- 📶 **100% Offline Capable:** Entire GACAR regulatory library, Leitner flashcards, question banks, and flight calculators run natively on-device in Airplane Mode.
- 🗣️ **Native Bilingual Interface:** Dynamic RTL/LTR layout transitions, native Arabic typography, and localized Apple design tokens.
- 🔄 **Unified App Group (`group.com.FlyGACA`):** Shared study streak, spaced-repetition memory weights, and mock exam results stay synchronized across the entire app family.
- 🧮 **Web-Parity Calculation Vectors:** Crosswind, TAS, Weight & Balance, and Density Altitude algorithms are mathematically verified against web test vectors.

---

## 📱 Flagship Modules

```
┌───────────────────────────────────────┬───────────────────────────────────────┐
│ 🎓 Academics & Exam Prep              │ 🧮 Flight Deck Calculators            │
│ • PPL, CPL, IR, ATPL Prep             │ • Crosswind & Runway Components       │
│ • SAELPT / ICAO Level 4 Prep          │ • Altimetry & Density Altitude        │
│ • Saudi AIP Study Packs               │ • Weight & Balance Envelope (CG)      │
│ • Leitner Spaced Repetition Flashcards│ • Part 91 Fuel Reserves & Burn Rate   │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ 🤖 Captain Adel AI Instructor         │ 🌤️ Saudi Weather & Aerodromes          │
│ • Streaming SSE Chat on Device        │ • Live METAR & TAF Weather Decoder    │
│ • GACAR Section Deep Links            │ • 61 Saudi Aerodromes (`OE**`)        │
│ • Offline Rule Reference Cache        │ • Flight Categories (VFR/MVFR/IFR)    │
└───────────────────────────────────────┴───────────────────────────────────────┘
```

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│     CoreModels    │   StudyEngines   │   ContentKit   │   AppServices   │
│     (value types) │   (SRS, exams)   │   (all JSON)   │  (seams/mocks)  │
└──────────┬────────┴─────────┬────────┴────────┬───────┴────────┬────────┘
           │                  │                 │                │
           └──────────────────┼─────────────────┼────────────────┘
                              │                 │
                     ┌────────┴─────────────────┴────────┐
                     │          PersistenceKit           │
                     │      (SwiftData + App Group)      │
                     └────────────────┬──────────────────┘
                                      │
                     ┌────────────────┴──────────────────┐
                     │             FeatureUI             │
                     │  (MainAppView, Tools, AI, Exams)  │
                     └────────────────┬──────────────────┘
                                      │
                     ┌────────────────┴──────────────────┐
                     │           PlatformLive            │
                     │   (Firebase, Captain Adel SSE)    │
                     └────────────────┬──────────────────┘
                                      │
                                      ▼
                           Fly GACA (iOS Flagship)
```

---

## ⚡ Building & Running

### Requirements
- **macOS 14+ (Sonoma or Sequoia)**
- **Xcode 16+**
- **iOS 17+ Simulator or Physical Device**

### 1. Open the Xcode Workspace
```bash
cd FlyGACA-ios
open apple/FlyGACA.xcworkspace
```

### 2. Select Scheme & Target
- Target: `FlyGACA (iOS)`
- Scheme: `Debug` or `Release`

### 3. Build & Run
Press `Cmd + R` in Xcode or run via command line:
```bash
xcodebuild -workspace apple/FlyGACA.xcworkspace \
  -scheme FlyGACA \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  test
```

---

## 🛡️ License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
