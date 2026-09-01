<div align="center">

# 🖥️ Headless HTML Screenshot Renderer (Mac-Free)
### Playwright & Chromium-Powered Automated Mockup Rasterizer for iOS App Store
#### مولد لقطات الشاشة بدون بيئة ماك · محاكاة واجهات SwiftUI · دعم اللغتين

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="صنع في السعودية" />
  <img src="https://img.shields.io/badge/Engine-Playwright%20Chromium-45BA4B?style=for-the-badge&logo=playwright&logoColor=white&labelColor=0a0e12" alt="Playwright" />
  <img src="https://img.shields.io/badge/Theme-Falcon%20Palette-2D6E8A?style=for-the-badge&labelColor=0a0e12" alt="Falcon Palette" />
  <img src="https://img.shields.io/badge/Output-Native%20Resolutions-C8A04A?style=for-the-badge&labelColor=0a0e12" alt="Native Resolutions" />
</p>

</div>

---

## 🧭 Purpose & Architecture

This tool generates high-resolution **marketing mockups and App Store screenshots** without needing a Mac, Xcode, or iOS Simulator.

It recreates every screen as HTML/CSS using the exact design tokens and colors from `FlyGACAKit/Sources/FeatureUI/Theme.swift`, populates them with live bundled JSON content, and renders pixel-exact images via Headless Chromium.

---

## ⚡ Execution Commands

```bash
# Install dependencies
npm i -D playwright-core

# 1. English (LTR)
node apple/Scripts/html-render/render.js            # Portrait screenshots
node apple/Scripts/html-render/render-landscape.js  # Landscape screenshots

# 2. Arabic (RTL)
SCREENSHOT_LANG=ar node apple/Scripts/html-render/render.js
SCREENSHOT_LANG=ar node apple/Scripts/html-render/render-landscape.js
```

---

## 📱 Supported Resolutions

- **iPhone 15/16 Pro:** 1179 × 2556 px (Viewport: 390 × 844 pt)
- **iPad Pro 12.9":** 2048 × 2732 px (Viewport: 1024 × 1366 pt)

Output images are written to `screenshots/raw/<device>/<orientation>/`.

---

<div align="center">

<sub>🇸🇦 صنع في السعودية · Made in Saudi Arabia</sub>

</div>
