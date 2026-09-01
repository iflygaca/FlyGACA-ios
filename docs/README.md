<div align="center">

# 📚 iOS Engineering Runbooks & Documentation Index
### Canonical Operational Guides, Signing Checklists & TestFlight Distribution Manuals
#### أدلة التشغيل الهندسي لنظام iOS · التوقيع الرقمي · النشر على TestFlight

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-Saudi%20Arabia-006C35?style=for-the-badge&labelColor=0a0e12" alt="صنع في السعودية" />
  <img src="https://img.shields.io/badge/Platform-Apple%20iOS%20%2F%20iPadOS-000000?style=for-the-badge&logo=apple&logoColor=white&labelColor=0a0e12" alt="iOS" />
  <img src="https://img.shields.io/badge/Runbooks-8%20Manuals-0D96F6?style=for-the-badge&labelColor=0a0e12" alt="8 Runbooks" />
  <img src="https://img.shields.io/badge/Status-Active-C8A04A?style=for-the-badge&labelColor=0a0e12" alt="Active" />
</p>

</div>

---

## 🧭 Master Runbook Catalog

| Runbook Document | Focus Area | Description & Purpose |
|:---|:---|:---|
| **[`RUNBOOK-ios-release.md`](./RUNBOOK-ios-release.md)** | **Primary Release Path** | **Start here.** Complete end-to-end instructions for syncing content, generating projects, testing, building, code signing, and pushing to TestFlight. |
| **[`RUNBOOK-ios-signing.md`](./RUNBOOK-ios-signing.md)** | Code Signing & Certs | Comprehensive explanation of provisioning profiles, App Store certificates, and CI automated signing keys. |
| **[`RUNBOOK-ios-signing-CHECKLIST.md`](./RUNBOOK-ios-signing-CHECKLIST.md)** | Signing Checklist | Quick-reference checklist for secret keys, bundle identifiers, and team provisioning. |
| **[`RUNBOOK-ios-firebase.md`](./RUNBOOK-ios-firebase.md)** | Backend & Auth | Configuration guide for `GoogleService-Info.plist` and Sign in with Apple entitlement setup. |
| **[`RUNBOOK-ios-xcodebuild.md`](./RUNBOOK-ios-xcodebuild.md)** | CI/CD & Build CLI | Command-line build automation, destination specifiers, and troubleshooting common build errors. |
| **[`PORTAL-RUNSHEET-wave1.md`](./PORTAL-RUNSHEET-wave1.md)** | App Store Portal | Pre-filled Apple Developer Portal configuration, privacy manifests, and App Store Connect metadata. |
| **[`TESTING-sync-suites.md`](./TESTING-sync-suites.md)** | Persistence Tests | Specification for `PersistenceKitTests` verifying App Group shared container synchronization. |
| **[`CORPUS-SIGNING.md`](./CORPUS-SIGNING.md)** | Cryptographic Integrity | Ed25519 asymmetric signature generation and verification for remote study packs. |

---

## ⚡ Standard Release Pipeline

```
1. Sync Assets       → node scripts/build-ios-content.mjs
2. Generate Project  → npm run ios:generate
3. Run Package Tests → cd apple/FlyGACAKit && swift test
4. Build & Sign      → xcodebuild -workspace apple/FlyGACA.xcworkspace -scheme FlyGACA archive
5. Upload & Distribute → xcrun altool --upload-app -f FlyGACA.ipa
```

---

<div align="center">

<sub>🇸🇦 صنع في السعودية · Made in Saudi Arabia</sub>

</div>
