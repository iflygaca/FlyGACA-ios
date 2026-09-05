# App Store Submission Documentation for FlyGACA iOS App Family

**Master Navigation & Overview**  
**Last Updated:** 2026-09-05  
**Status:** Phase 1 In Progress

---

## What This Is

This directory contains comprehensive documentation addressing Apple's **Guideline 2.1 - Information Needed** rejection for the FlyGACA iOS app family (Flagship + ELPT + AIP). The documentation satisfies all five Apple requirements while establishing reusable templates for future module launches (PPL, CPL, IR, ATPL).

---

## Quick Start: Document Map

### 🎯 Core Requirements (Read First)
1. **[GUIDELINE-2.1-COMPLIANCE.md](GUIDELINE-2.1-COMPLIANCE.md)** — Apple's exact requirements mapped to evidence location  
   *What Apple asked for & how we prove we have it*

2. **[REGULATED-CONTENT-CERTIFICATION.md](REGULATED-CONTENT-CERTIFICATION.md)** — GACA sourcing chain + bilingual disclaimers  
   *Critical for aviation regulations review*

3. **[EXTERNAL-SERVICES.md](EXTERNAL-SERVICES.md)** — Complete inventory of online services (Firebase, Captain Adel, Moyasar, CDN)  
   *What data flows where & privacy/compliance context*

### 📹 For App Reviewers
4. **[DEMO-GUIDE.md](DEMO-GUIDE.md)** — Screen recording scripts (3 videos, 2-3 min each)  
   *Exact walkthrough for Flagship, ELPT, AIP*

5. **[FEATURE-WALKTHROUGH.md](FEATURE-WALKTHROUGH.md)** — Per-app user flows  
   *What each app does, step-by-step*

6. **[TEST-ACCOUNTS.md](TEST-ACCOUNTS.md)** — Demo account setup (appReview@flygaca.com)  
   *How to sign in & access all features*

### ✅ Verification & Submission
7. **[REGIONAL-PARITY-VERIFICATION.md](REGIONAL-PARITY-VERIFICATION.md)** — Bilingual QA checklist  
   *Confirms English/Arabic parity across all 3 apps*

8. **[APP-STORE-FORM-COMPLETION.md](APP-STORE-FORM-COMPLETION.md)** — Pre-filled submission answers  
   *Copy-paste ready for App Store Connect*

9. **[SUBMISSION-READINESS-CHECKLIST.md](SUBMISSION-READINESS-CHECKLIST.md)** — Final 5-phase gate verification  
   *Pass this before uploading to App Store Connect*

### 🏗️ Supporting Infrastructure
- **[ARCHITECTURE-DIAGRAM.md](ARCHITECTURE-DIAGRAM.md)** — Data flow ASCII diagram (offline-first + optional online services)
- **[SCREENSHOTS-MANIFEST.md](SCREENSHOTS-MANIFEST.md)** — Rendered mockup inventory (bilingual, all device sizes)

### 📋 Templates for Future Apps
- **[TEMPLATES/EXTERNAL-SERVICES-TEMPLATE.md](TEMPLATES/EXTERNAL-SERVICES-TEMPLATE.md)** — Reusable service documentation template
- **[TEMPLATES/APP-SPECIFIC-README.md](TEMPLATES/APP-SPECIFIC-README.md)** — Per-app metadata template (PPL, CPL, IR, ATPL ready)

### 📁 Reference
- **[ARCHIVE/submission-attempts/](ARCHIVE/submission-attempts/)** — Historical submission records
- **[ARCHIVE/reviewer-feedback-log.md](ARCHIVE/reviewer-feedback-log.md)** — Past rejection tracking & resolutions
- **[videos/](videos/)** — 3 screen recording videos (2-3 min each, hosted externally)

---

## At a Glance: The FlyGACA App Family

**Three apps, one shared codebase:**

| App | Bundle ID | Focus | Modules | Status |
|-----|-----------|-------|---------|--------|
| **FlyGACA Flagship** | `com.flygaca.app` | Complete suite | ELPT, AIP, Flight Deck, Regulations, Captain Adel | Shipping |
| **Fly GACA ELPT** | `com.flygaca.elpt` | English Language Proficiency Test | PPL, CPL, ATPL study | Shipping |
| **Fly GACA AIP** | `com.flygaca.aip` | Aeronautical Info Publication | Saudi aerodrome data, GACAR regulations | Shipping |

**Paused (web-only, iOS codebase ready):**  
PPL, CPL, IR, ATPL — stored in git history; App Store metadata repos marked "Parked"

---

## What Makes FlyGACA Different (Why Guideline 2.1 Matters)

1. **Highly Regulated Content**  
   - 74 GACA (General Authority of Civil Aviation) regulations sourced directly from gaca.gov.sa
   - Immutable, non-editorial, zero modifications (cite-or-refuse precision)
   - Bilingual (English + Arabic) with RTL support
   - Offline-first: bundled JSON, optional remote refresh via signed corpus

2. **Multiple External Services**  
   - Firebase (Auth + Firestore + App Check)
   - Captain Adel AI Chat API (SSE streaming)
   - Moyasar Payment Gateway (SAR processing)
   - Content Refresh CDN (ETag-cached quiz updates)
   - All optional—app works 100% offline without them

3. **Cross-Platform Parity**  
   - SRS algorithm ported from web (Leitner boxes, intervals, mastery rules)
   - Exam scoring (percent = round(correct/total × 100), pass = percent ≥ passMark)
   - Streak tracking (consecutive +1, gap resets)
   - Study progress syncs across ELPT → AIP → Flagship via App Group

4. **Bilingual Regional Deployment**  
   - 100% English support (Inter font, LTR layout)
   - 100% Arabic support (Cairo font, RTL layout, numbers LTR)
   - Language toggle persists across app sessions
   - Disclaimer appears in both languages

---

## How to Use This Documentation

### For App Review Submission:
1. **Start with** [GUIDELINE-2.1-COMPLIANCE.md](GUIDELINE-2.1-COMPLIANCE.md) — shows what Apple asked for
2. **Then review** [REGULATED-CONTENT-CERTIFICATION.md](REGULATED-CONTENT-CERTIFICATION.md) — proof of GACA certification
3. **Add** [EXTERNAL-SERVICES.md](EXTERNAL-SERVICES.md) to submission notes
4. **Attach** 3 videos from [DEMO-GUIDE.md](DEMO-GUIDE.md) walkthrough
5. **Fill App Store Connect form** using [APP-STORE-FORM-COMPLETION.md](APP-STORE-FORM-COMPLETION.md)
6. **Verify with** [SUBMISSION-READINESS-CHECKLIST.md](SUBMISSION-READINESS-CHECKLIST.md) before hitting Submit

### For Resubmitting After Rejection:
1. Review [ARCHIVE/reviewer-feedback-log.md](ARCHIVE/reviewer-feedback-log.md) — what was the specific issue?
2. Update relevant doc(s)
3. Re-record affected video(s) if content flow changed
4. Re-run [SUBMISSION-READINESS-CHECKLIST.md](SUBMISSION-READINESS-CHECKLIST.md)
5. Resubmit via App Store Connect

### For Adding a New Module (PPL, CPL, IR, ATPL):
1. Copy [TEMPLATES/APP-SPECIFIC-README.md](TEMPLATES/APP-SPECIFIC-README.md) → new app directory
2. Use [TEMPLATES/EXTERNAL-SERVICES-TEMPLATE.md](TEMPLATES/EXTERNAL-SERVICES-TEMPLATE.md) if new services added
3. Reuse shared docs: EXTERNAL-SERVICES.md, REGULATED-CONTENT-CERTIFICATION.md, REGIONAL-PARITY-VERIFICATION.md
4. Create app-specific: FEATURE-WALKTHROUGH.md, DEMO-GUIDE.md, test account notes

---

## Document Status & Ownership

| Document | Status | Owner | Last Update |
|----------|--------|-------|------------|
| GUIDELINE-2.1-COMPLIANCE | Draft | Product | 2026-09-05 |
| REGULATED-CONTENT-CERTIFICATION | Draft | Engineering + Legal | 2026-09-05 |
| EXTERNAL-SERVICES | Draft | Engineering | 2026-09-05 |
| ARCHITECTURE-DIAGRAM | Draft | Engineering | 2026-09-05 |
| FEATURE-WALKTHROUGH | Pending | QA | Week 1-2 |
| DEMO-GUIDE | Pending | QA | Week 1-2 |
| TEST-ACCOUNTS | Pending | Engineering | Week 2 |
| REGIONAL-PARITY-VERIFICATION | Pending | QA | Week 2 |
| SCREENSHOTS-MANIFEST | Pending | QA | Week 2 |
| APP-STORE-FORM-COMPLETION | Pending | Product | Week 3 |
| SUBMISSION-READINESS-CHECKLIST | Pending | QA | Week 3 |

---

## Key Files Outside This Directory

These documents provide essential context:
- **[CAUSE.md](../../CAUSE.md)** — Mission + 7 tenets (Tenet 7 = regulatory disclaimer language)
- **[apple/ARCHITECTURE.md](../../apple/ARCHITECTURE.md)** — Technical architecture (being expanded for Phase 4 PlatformLive services)
- **[apple/README.md](../../apple/README.md)** — Swift package structure
- **[CONTRIBUTING.md](../../CONTRIBUTING.md)** — Contribution guidelines
- **[THE-BOOK-OF-FLY-GACA.md](../../THE-BOOK-OF-FLY-GACA.md)** — Cross-repo reference (all 10 FlyGACA repos)

---

## Regulatory & Compliance Context

**GACA Sourcing:**
- All regulations sourced from **General Authority of Civil Aviation (gaca.gov.sa)**
- No editorial changes, no paraphrasing, no omissions
- Content bundled immutably per app (no server-side filtering)
- Remote refresh via signed corpus (`quiz.json.sig`, Ed25519) — fails closed if invalid

**Disclaimer (Bilingual):**

> **EN:** Fly GACA is an independent educational platform. All GACAR content is sourced from the General Authority of Civil Aviation (GACA) and presented without modification. This app is NOT an official GACA product and does not replace official GACA publications. Pilots must always verify current regulations on gaca.gov.sa.
>
> **AR:** فلاي قاكا منصة تعليمية مستقلة. تُستخرج جميع محتويات GACAR من موقع الهيئة العامة للطيران المدني (GACA) وتُقدم كما هي دون تعديل. هذا التطبيق ليس منتجاً رسمياً من GACA ولا يحل محل المنشورات الرسمية. يجب على الطيارين التحقق دائماً من اللوائح الحالية على gaca.gov.sa.

This disclaimer appears in the app and in all submission documentation.

---

## Contact & Support

- **App Review Questions:** appReview@flygaca.com (monitored daily)
- **Support Line:** +966-50-XXXX-XXXX (English option available)
- **Website:** https://flygaca.com
- **Privacy Policy:** https://flygaca.com/privacy
- **Terms of Use:** https://flygaca.com/terms

---

## Version History

| Date | Phase | Status | Notes |
|------|-------|--------|-------|
| 2026-09-05 | Phase 1 | In Progress | Initial framework documents created |
| TBD | Phase 2 | Pending | Features + demo scripts + 3 videos |
| TBD | Phase 3 | Pending | Services deep-dive + architecture |
| TBD | Phase 4 | Pending | Bilingual QA + test accounts |
| TBD | Phase 5 | Pending | Form completion + submission checklist |

---

**Last Reviewed:** 2026-09-05  
**Next Review:** End of Phase 1 (Week 1)

Generated by Claude Code on 2026-09-05  
Fly GACA iOS App Family  
© BDA Company International
