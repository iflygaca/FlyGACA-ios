<div align="center">

# 🍎 Apple Developer Workspace & XcodeGen Pipeline
### Shared Swift Package Architecture, Dynamic Project Generation & Target Builds
#### مساحة عمل تطبيقات آبل · توليد مشاريع Xcode تلقائيًا · حزمة FlyGACAKit

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="صنع في السعودية" />
  <img src="https://img.shields.io/badge/XcodeGen-2.40%2B-FA7343?style=for-the-badge&logo=swift&logoColor=white&labelColor=0a0e12" alt="XcodeGen" />
  <img src="https://img.shields.io/badge/SPM-FlyGACAKit-F05138?style=for-the-badge&logo=apple&logoColor=white&labelColor=0a0e12" alt="FlyGACAKit" />
  <img src="https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS%2017%2B-000000?style=for-the-badge&logo=apple&logoColor=white&labelColor=0a0e12" alt="iOS 17+" />
</p>

</div>

---

## 🧭 Architecture Overview

The iOS codebase uses a clean, decoupled architecture:
1. **Shared Swift Package (`FlyGACAKit`):** Zero external dependencies containing pure domain logic, calculation engines, and SwiftUI views.
2. **Dynamic Project Generation:** `apple/project.yml` is the sole source of truth; Xcode projects are generated dynamically via XcodeGen and never committed to git.
3. **Bundled Content:** Raw GACAR json assets are synced into each target bundle as blue folder references for offline use.

---

## ⚡ Step-by-Step Developer Quickstart

### 1. Build and Test Core Package
```bash
cd apple/FlyGACAKit
swift build
swift test
```

### 2. Sync Offline Content Packs
```bash
# From repo root
node scripts/build-ios-content.mjs
```

### 3. Generate Xcode Project
```bash
npm run ios:generate
open apple/FlyGACA.xcodeproj
```

---

## 🏗 Adding New Study Modules & Apps

1. Declare the new target entry in `apple/project.yml`.
2. Create `Apps/<App>/<App>.xcconfig` defining `BUNDLE_IDENTIFIER` and `DISPLAY_NAME`.
3. Generate content assets using `node scripts/build-ios-content.mjs --app <app>`.
4. Re-run `npm run ios:generate`.

---

<div align="center">

<sub>🇸🇦 صنع في السعودية · Made in Saudi Arabia</sub>

</div>
