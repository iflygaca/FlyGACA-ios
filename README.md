<div align="center">

<!-- Falcon Logo -->
<img src="https://raw.githubusercontent.com/FlyGACA/FlyGACA-ios/main/apple/Apps/Shared/Assets.xcassets/AppIcon.appiconset/1024.png" width="120" alt="Fly GACA Falcon Logo" />

# 📱 Fly GACA — Native iOS App Family

### The native SwiftUI flight deck for Saudi civil aviation

**_find it · study it · always verify against GACA_**

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-F05138?logo=swift&logoColor=white)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios)
[![Xcode 16+](https://img.shields.io/badge/Xcode-16+-147EFB?logo=xcode&logoColor=white)](https://developer.apple.com/xcode)
[![MIT License](https://img.shields.io/badge/License-MIT-3DA639?logo=opensourceinitiative&logoColor=white)](LICENSE)
[![CI Status](https://img.shields.io/badge/CI-passing-3DA639?logo=githubactions&logoColor=white)](.github/workflows/ios.yml)

[![TestFlight](https://img.shields.io/badge/TestFlight-ELPT%20%26%20AIP-0D96F6?logo=appstore&logoColor=white)](https://testflight.apple.com)
[![Bilingual](https://img.shields.io/badge/Bilingual-EN%20%2F%20AR-1E3A5F?logo=translate&logoColor=white)](SEO-PLAN.md)
[![Offline First](https://img.shields.io/badge/Offline-First-FF6B00?logo=wifi&logoColor=white)](apple/ARCHITECTURE.md)

</div>

---

## 🎯 What is Fly GACA?

**Fly GACA** is an independent, bilingual educational platform for Saudi civil aviation — built by pilots, for pilots. We make every GACAR regulation and AIP publication **authoritative, accessible, and instantly searchable** on every device you own, with or without a signal.

> **Independent & Educational, Not Regulatory.** Fly GACA is **not affiliated with, endorsed by, or operated by** the General Authority of Civil Aviation (GACA) or the Government of Saudi Arabia. The official source for all regulations is always [gaca.gov.sa](https://gaca.gov.sa).
>
> **فلاي جاكا منصة تعليمية مستقلة.** وهي غير تابعة للهيئة العامة للطيران المدني (GACA) ولا معتمدة منها ولا تُديرها. المصدر الرسمي والمعتمد لجميع لوائح الطيران المدني هو GACA دائمًا.

### One Cause, Three Surfaces

| Surface | What It Does | Repository |
|---------|-------------|------------|
| 🌐 **flygaca.com** | Open regulatory library, flight tools, study packs, guides | [`FlyGACA/FlyGACA-app`](https://github.com/FlyGACA/FlyGACA-app) |
| 🤖 **Captain Adel** | AI flight instructor with cite-or-refuse grounding | [`FlyGACA/Captain-Adel`](https://github.com/FlyGACA/Captain-Adel) |
| 📱 **This repo** | Native iOS study apps — fully offline, bilingual, exam-ready | `ay2m/FlyGACA-ios` *(you are here)* |

---

## ✨ What Makes This Special

### 🛫 Built for the Flight Bag
Every app is **100% offline-capable** by design. No account, no network, no excuses. Study in the crew room, review on the apron, prep in the air — the full feature set works with airplane mode on.

### 🗣️ Bilingual by Design, Not by Afterthought
Arabic is **first-class**, not a translation pass. RTL layouts, Arabic UI chrome, and parity checks that fail the build when one language falls behind. The app advertises `CFBundleLocalizations = [en, ar]` so iOS serves Arabic natively on Arabic devices.

### 🔗 One Family, One Device
The shared **App Group** (`group.com.FlyGACA`) carries your streaks, spaced-repetition progress, and exam history across every app in the family. Buying the next rating doesn't mean starting over.

### ⚖️ Web-Parity Semantics
Spaced repetition, exam scoring, and streaks are **literal ports** of the web app's contracts — guarded by parity test vectors. Move between phone and browser; you're always studying against the same rules.

### 🛡️ Never Paywall the Regulations
The law stays free to read on [flygaca.com](https://flygaca.com). What you buy is the **offline study toolchain** — the packs, the tools, the apps — never access to the regulation itself.

---

## 📱 App Lineup & Flagship Architecture

| App | Bundle ID | Module ID | What's Inside |
|-----|-----------|-----------|---------------|
| **Fly GACA (Unified Flagship)** | `com.flygaca.app` | `all` | **All Features in One App**: Full study suites for PPL, CPL, IR, ATPL, ELPT & AIP · 2,000+ questions · Ground school · Crosswind & Density Altitude calculators · Weight & Balance · Fuel Planner · TSD · Unit Converter · Saudi METAR/TAF weather · Captain Adel AI Flight Instructor · GACAR offline library |
| **ELPT (Standalone)** | `com.flygaca.elpt` | `elp` | 5 question banks · 191 questions + scenario bank · ICAO Level 4 prep |
| **AIP (Standalone)** | `com.flygaca.aip` | `aip` | 3 question banks · 113 questions · Aeronautical Information Publication study |

---

## 🏗 Architecture at a Glance

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
                     ┌────────────────┴──────────────────┐
                     ▼                                   ▼
          Fly GACA (Flagship App)              Standalone (ELPT / AIP)
```

**One shared Swift package (`FlyGACAKit`), unified 5-tab native flight deck (`MainAppView`).** Every feature runs offline-first, local-first, and with full Arabic RTL and English bilingual parity. See [`apple/ARCHITECTURE.md`](apple/ARCHITECTURE.md) for the full blueprint.

### Key Design Rules

| Rule | Why It Matters |
|------|---------------|
| **Engines never do IO** | `StudySession` takes `now: Date` as a parameter; tests pass fixed dates. `swift test` needs no simulator. |
| **Firebase never leaks upstream** | Only `PlatformLive` may import platform SDKs. Pure targets build instantly and every screen previews with mocks. |
| **UI talks to protocols** | The composition root injects live services; until then, the mocks *are* the shipping product. |
| **Content syncs one way** | Monorepo → here, never reverse. This repo owns Swift; the monorepo owns the corpus. |

---

## ⚡ Quickstart (Mac, Xcode 16+)

```bash
# 1. Generate Xcode project from XcodeGen specification
npm run ios:generate        # Generates apple/FlyGACA.xcodeproj (installs xcodegen if missing)

# 2. Open project in Xcode
open apple/FlyGACA.xcodeproj
# Select target (ELPT or AIP) and run on simulator or device (fully offline)

# 3. Test FlyGACAKit package directly — the fastest way to verify Swift changes
cd apple/FlyGACAKit && swift test

# 4. Headless build verification
npm run ios:build:elpt      # Debug build for ELPT (or: aip / all)
```

> ⚠️ **Important:** Run `swift test` **directly**. The root `npm run ios:test` wrapper may skip Swift execution if environment paths are missing and **exits 0 even when tests fail**.

---

## 📂 Repository Documentation

Every doc in this repo is natively owned here — nothing is sync-overwritten anymore:

| Document | Purpose & Contents |
|----------|-------------------|
| [`apple/ARCHITECTURE.md`](apple/ARCHITECTURE.md) | **Engineering Blueprint** — Target graph, SwiftData contracts, App Group configuration, store strategy |
| [`apple/README.md`](apple/README.md) | **Mac Setup Guide** — Detailed developer setup and target generation walkthrough |
| [`CAUSE.md`](CAUSE.md) | **Mission & Principles** — Why Fly GACA exists and our 7 core principles |
| [`ROADMAP.md`](ROADMAP.md) | **Active Work & Backlog** — Single source of truth for upcoming feature releases |
| [`MIGRATION.md`](MIGRATION.md) | **Monorepo Separation** — Historical log of iOS code extraction from web monorepo |
| [`SEO-PLAN.md`](SEO-PLAN.md) | **ASO Strategy** — App Store Search Optimization for ELPT and AIP targets |
| [`THE-BOOK-OF-FLY-GACA.md`](THE-BOOK-OF-FLY-GACA.md) | **Ecosystem Reference** — Cross-repository manual mapping all 10 Fly GACA repos |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | **Contributor Guide** — Testing conventions, sync boundary rules, PR standards |
| [`CLAUDE.md`](CLAUDE.md) | **AI Assistant Guide** — Conventions, gotchas, and the sync boundary for coding assistants |
| [`docs/`](docs/) | **Runbooks Index** — Release execution, signing, TestFlight, Firebase setup, corpus signing |

---

## 🔄 Content Synchronization

Content files (`module.json`, `quiz.json`, ground school decks) in `apple/Apps/*/Content/` are **committed snapshots**. The authoritative source of truth lives in the [`FlyGACA-app`](https://github.com/FlyGACA/FlyGACA-app) monorepo.

```bash
# Refresh content from a local FlyGACA-app clone
bash scripts/sync-content.sh ../FlyGACA-app
```

> **Review the diff before committing.** This repo owns its Swift code; the monorepo owns the corpus. The sync is one-way and reviewed.

---

## ⚙️ Continuous Integration (CI)

The CI pipeline ([`.github/workflows/ios.yml`](.github/workflows/ios.yml)) validates every PR and push to `main`:

1. **Unit & Parity Tests** — `swift test` across `FlyGACAKit` (5 targets, 11 files), testing spaced-repetition math and scoring parity against the web app
2. **XcodeGen Validation** — Verifies that `apple/project.yml` compiles into a valid `.xcodeproj`
3. **Headless Builds** — Builds unsigned debug binaries for all targets on macOS GitHub runners
4. **TestFlight Upload** — Signed release archives uploaded to TestFlight (gated by secrets presence)

| Event | What Runs |
|-------|-----------|
| Push to feature branch | **Nothing** (triggers are `main`-only) |
| PR targeting `main` | `swift-test` + `xcodegen-validate` + `ios-build` (fail-fast matrix) |
| Push to `main` | All above + release archives + TestFlight (if secrets exist) |
| `workflow_dispatch` | Same as `main` push, on demand |

---

## 🌐 The Fly GACA Repository Ecosystem

| Repository | Role & Description |
|-----------|-------------------|
| **ay2m/FlyGACA-ios** (this repo) | Native iOS app family — `FlyGACAKit` package + ELPT and AIP App Store targets |
| [`FlyGACA/FlyGACA-app`](https://github.com/FlyGACA/FlyGACA-app) | flygaca.com — React 19 + Vite 8 PWA web app, Firebase backend (`me-central1`), content pipelines |
| [`FlyGACA/Captain-Adel`](https://github.com/FlyGACA/Captain-Adel) | Captain Adel — AI flight instructor service (`captadel.com`), RAG engine behind chat |
| [`FlyGACA/Office`](https://github.com/FlyGACA/Office) | Business operating system — strategy, governance, legal, finance, KSA compliance, HR & GTM docs |
| `FlyGACA/ELPT` · `FlyGACA/AIP` | App Store metadata repos — store listing copy, screenshots, per-app roadmap |
| `FlyGACA/PPL` · `CPL` · `IR` · `ATPL` | App Store metadata repos for **paused** exam modules |

---

## 🛡️ Security & Trust

- **Corpus signing:** Remote content refresh is gated on a detached Ed25519 signature. It fails closed in every failure mode — missing sig, bad base64, mismatch, or missing public key all reject the refresh. See [`docs/CORPUS-SIGNING.md`](docs/CORPUS-SIGNING.md).
- **Zero external dependencies in the kit:** `swift build && swift test` needs no network, no simulator, no SDK downloads.
- **In-Kingdom by default:** User data stays under Saudi jurisdiction (PDPL). Hosting and model inference default to KSA regions.
- **The disclaimer is a discipline:** One statement, verbatim, on every surface, in both languages. It is never reworded, never abbreviated, never a footnote.

---

## ⚖️ Disclaimer & License

**Fly GACA is an independent educational platform.** It is not affiliated with, endorsed by, or operated by the General Authority of Civil Aviation (GACA) or the Government of the Kingdom of Saudi Arabia. The official source for all civil aviation regulations is always [gaca.gov.sa](https://gaca.gov.sa).

**فلاي جاكا منصة تعليمية مستقلة.** وهي غير تابعة للهيئة العامة للطيران المدني (GACA) ولا معتمدة منها ولا تُديرها. المصدر الرسمي والمعتمد لجميع لوائح الطيران المدني هو GACA دائمًا.

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

**صُنع في السعودية 🇸🇦 · Made in Saudi Arabia**

---

<div align="center">

**[🚀 Get Started](apple/README.md) · [📖 Architecture](apple/ARCHITECTURE.md) · [🗺️ Roadmap](ROADMAP.md) · [🤝 Contribute](CONTRIBUTING.md)**

</div>
