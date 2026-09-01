# Apple App Store Connect — Metadata & Submission Guide

This document defines the production metadata, character counts, keyword banks, and submission checklists for publishing **Fly GACA** on the Apple App Store.

---

## 1. Store Listing Specifications

| Parameter | Limit | English (`en-US`) | Arabic (`ar-SA`) |
|:---|:---:|:---|:---|
| **App Name** | ≤ 30 chars | `Fly GACA: Saudi Aviation EFB` (29) | `فلاي قاكا: طيران وأنظمة GACA` (28) |
| **Subtitle** | ≤ 30 chars | `Pilot Ground School & GACAR` (27) | `حقيبة الطيار والمدرسة الأرضية` (29) |
| **Primary Category** | — | **Education** | **التعليم** |
| **Secondary Category** | — | **Navigation / Utilities** | **الملاحة / الأدوات** |
| **Age Rating** | — | **4+** (No unrestricted web, no objectionable content) | **4+** |
| **Pricing** | — | **Free** (In-App Pro Subscription optional) | **مجاني** |
| **Support URL** | — | `https://flygaca.com/about` | `https://flygaca.com/ar/about` |
| **Marketing URL** | — | `https://flygaca.com` | `https://flygaca.com/ar` |
| **Privacy Policy** | — | `https://flygaca.com/privacy` | `https://flygaca.com/ar/privacy` |

---

## 2. Keywords Strategy (≤ 100 characters, no spaces after commas)

### English (`en-US`): 94 chars
```
aviation,pilot,GACA,GACAR,EFB,flight,cockpit,crosswind,PPL,CPL,ATPL,Saudi,METAR,TAF,navigation
```

### Arabic (`ar-SA`): 81 chars
```
طيران,طيار,قاكا,لوائح,GACA,GACAR,ملاحة,حاسبة,طقس,مطار,السعودية,رخصة,PPL,CPL,كابتن
```

---

## 3. Marketing & Screenshot Matrix

Rendered using the headless Playwright engine in [`apple/Scripts/html-render/`](../apple/Scripts/html-render/README.md):

| Target Device | Resolution | Orientations | Locales |
|:---|:---:|:---:|:---|
| **iPhone 6.9" Display** (16 Pro Max / 15 Plus) | 1320 × 2868 px | Portrait & Landscape | `en` + `ar` |
| **iPhone 6.5" Display** (11 Pro Max / XS Max) | 1242 × 2688 px | Portrait & Landscape | `en` + `ar` |
| **iPad Pro 13" Display** (M4 / 6th Gen) | 2064 × 2752 px | Portrait & Landscape | `en` + `ar` |

---

## 4. Release Automation Checklist

1. **Verify Binary & Metadata:**
   ```bash
   node -e "const meta = require('./apple/AppStore-Metadata.json'); console.log('Metadata valid for:', Object.keys(meta.localizations));"
   ```
2. **Build and Archive Release IPA:**
   ```bash
   npm run ios:build:release
   ```
3. **Upload to TestFlight:**
   ```bash
   xcrun altool --upload-app -f apple/.build/FlyGACA.ipa -t ios -u "$APPLE_ID" -p "$APP_SPECIFIC_PASSWORD"
   ```

---

<div align="center">

<sub>🇸🇦 صنع في السعودية · Made in Saudi Arabia</sub>

</div>
