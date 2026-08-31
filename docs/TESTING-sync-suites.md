# The sync test suites — App Group + Firestore

**Date:** 2026-08-31
**Files:** `apple/FlyGACAKit/Tests/PersistenceKitTests/AppGroupSyncTests.swift` (8 tests) ·
`FirestoreSyncIntegrationTests.swift` (13 tests)
**Web counterpart:** `ay2m/FlyGACA` → `docs/CROSS-PLATFORM-TEST-SUITE.md` (68 tests over the same
contract, from the web side)

Two XCTest suites added to `PersistenceKitTests` covering the two ways study state moves: sideways
between family apps on one device (App Group), and up/down to the server (Firestore sync).

---

## ⚠️ Status: written, not yet run

**Neither suite has been compiled or executed.** They were authored on a Linux container with no
Swift toolchain, so nothing has type-checked them. Before treating these 21 tests as real coverage:

```bash
cd apple/FlyGACAKit && swift test --filter PersistenceKitTests
```

Run `swift test` **directly**, not `npm run ios:test` — per the root `CLAUDE.md`, the npm wrapper's
`&&`/`||` chain prints "Swift not available" and exits 0 even when tests fail, so it will show green
on a suite that does not build. Expect to fix compile errors on the first pass. CI's `swift-test`
job (`macos-15`) will surface them on the first PR targeting `main`.

Both suites are hermetic by design — in-memory SwiftData container, no simulator, no network, no
Firebase SDK — so once they compile they should run anywhere `swift test` runs, including a laptop
with no Apple developer account.

---

## AppGroupSyncTests.swift — sideways, between apps

`group.com.FlyGACA` is what lets a learner's streak and SRS state follow them from ELPT to AIP on the
same device. It is the mechanism the whole "one bundle, many apps" model rests on, and nothing tested
it. These eight assert that a write from one app is visible to another, and that concurrent writes
serialize through the `StudyStore` `@ModelActor` rather than racing:

| Test | What it pins |
|---|---|
| `testProgressWrittenByOneAppIsVisibleToAnother` | The basic shared-store guarantee |
| `testStreakSyncAcrossApps` | Streaks are family-wide, not per-app |
| `testEntitlementsSyncAcrossApps` | A pack bought in one app unlocks in another |
| `testConcurrentQuizRecordsFromMultipleAppsSerialize` | Actor serialization under simultaneous writes |
| `testOneAppOfflineWhileOtherStudiesDoesNotCorruptState` | Mixed online/offline apps don't corrupt shared state |
| `testExamRecordedByOneAppVisibleToOtherImmediately` | No staleness window on exam records |
| `testSameDayQuizDuplicateDoesNotIncrementCount` | Same-day idempotence (matches web `nextStreak`) |
| `testAppGroupStateRemainsConsistentAfterInterleavedUpdates` | Consistency after interleaving |

The App Group id is settled at `group.com.FlyGACA` in all three places that decide it — see the root
`CLAUDE.md`. These tests should not be "fixed" by changing that id.

---

## FirestoreSyncIntegrationTests.swift — up and down, to the server

Thirteen tests over the sync lifecycle: the round trip
(`testSyncsProgressAfterQuizCompletion`, `testFetchesProgressFromFirestore`), offline queueing and
reconnect retry, last-write-wins conflict resolution, server-schema parity, per-bank independence,
App Group visibility of synced state, audit-trail capture, question-id stability across content
refreshes, and the error paths — missing user, duplicate/idempotent sync, concurrent syncs from
multiple family apps.

**What is actually under test:** a mock sync service defined inside the test file. Not
`FirebaseProgressSync`, and not the network. That is a deliberate consequence of where the code is —
`PlatformLive` is built but wired into no composition root, so the shipping apps run entirely on the
`AppServices` mocks and there is no live sync path to integration-test yet. Read these as the
contract `FirebaseProgressSync` must honor **when** the composition root is wired, and as executable
documentation of last-write-wins semantics in the meantime.

The parity halves — SRS boxes 0–5 and intervals `[0, 1, 3, 7, 14, 30]`, UTC day-string due dates,
`percent = round(correct/total × 100)`, mastery at box ≥ 3 — are asserted from the web side too, in
`ay2m/FlyGACA`'s `tests/cross-platform-integration.test.ts`. If you change one, change both; the
`parity-guard` agent exists for exactly this.

---

## Follow-ups

1. Run both suites on a Mac; fix compile errors; report the real pass count.
2. When `PlatformLive` is wired into `FlyGACAApp.swift`, re-point
   `FirestoreSyncIntegrationTests` at the real `FirebaseProgressSync` so it tests shipping code
   rather than a mock.
3. Consider folding the App Group assertions into `StudyStoreTests.swift` if the two suites end up
   sharing most of their fixtures.
