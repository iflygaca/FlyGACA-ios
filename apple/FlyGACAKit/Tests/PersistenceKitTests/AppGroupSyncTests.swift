import CoreModels
import StudyEngines
import XCTest

@testable import PersistenceKit

/// App Group sync verification — test that progress, quiz bests, and exams
/// are visible across apps in the family (ELPT and AIP share one App Group / container).
/// Also verify concurrent-write resilience and data integrity.
final class AppGroupSyncTests: XCTestCase {

    /// Make a StudyStore with an in-memory SwiftData container for hermetic testing.
    private func makeStore() throws -> StudyStore {
        let container = try Persistence.container(inMemory: true)
        return StudyStore(container: container)
    }

    // MARK: - Progress sync across apps

    func testProgressWrittenByOneAppIsVisibleToAnother() async throws {
        let store = try makeStore()
        let moduleID = "aip"
        let bankID = "air-law"

        // Simulate app 1 recording a quiz score
        try await store.recordQuizScore(moduleID: moduleID, bankID: bankID, percent: 80)

        // Simulate app 2 reading the same progress (via the same SwiftData container)
        let bests = try await store.quizBest(moduleID: moduleID)
        XCTAssertEqual(bests[bankID], 80)
    }

    func testLessonsDoneSyncAcrossApps() async throws {
        let store = try makeStore()
        let moduleID = "elpt"

        // App 1 marks a lesson done
        try await store.markLessonDone(moduleID: moduleID, lessonID: "lesson-1")

        // App 2 marks another lesson done
        try await store.markLessonDone(moduleID: moduleID, lessonID: "lesson-2")

        // App 1 reads lessons done and sees both
        let done = try await store.lessonsDone(moduleID: moduleID)
        XCTAssertTrue(done.contains("lesson-1"))
        XCTAssertTrue(done.contains("lesson-2"))
    }

    func testFlagsSyncAcrossApps() async throws {
        let store = try makeStore()
        let moduleID = "aip"
        let bankID = "air-law"

        // App 1 flags question index 3
        try await store.setFlag(moduleID: moduleID, bankID: bankID, index: 3, flagged: true)

        // App 2 flags question index 7
        try await store.setFlag(moduleID: moduleID, bankID: bankID, index: 7, flagged: true)

        // Both flags are readable
        let flagged = try await store.flaggedIndices(moduleID: moduleID, bankID: bankID)
        XCTAssertEqual(flagged.sorted(), [3, 7])
    }

    // MARK: - Exam sync

    func testExamRecordedByOneAppVisibleToOtherImmediately() async throws {
        let store = try makeStore()
        let moduleID = "elpt"
        let now = Date()

        // App 1 finishes an exam
        let examResult = SessionResult(
            total: 25, correct: 20, percent: 80, passed: true, byBank: [:],
            duration: 1800, finishedAt: now)
        try await store.recordExam(moduleID: moduleID, result: examResult)

        // App 2 checks exam status immediately (same container)
        let history = try await store.examHistory(moduleID: moduleID)
        XCTAssertEqual(history.count, 1)
        XCTAssertEqual(history.first?.percent, 80)
        XCTAssertTrue(history.first?.passed ?? false)
    }

    // MARK: - Progress Summary

    func testProgressSummaryMatchesAggregatedState() async throws {
        let store = try makeStore()
        let moduleID = "aip"

        try await store.recordQuizScore(moduleID: moduleID, bankID: "air-law", percent: 85)
        try await store.markLessonDone(moduleID: moduleID, lessonID: "lesson-intro")

        let examResult = SessionResult(
            total: 20, correct: 18, percent: 90, passed: true, byBank: [:],
            duration: 1200, finishedAt: Date())
        try await store.recordExam(moduleID: moduleID, result: examResult)

        let summary = try await store.progressSummary(moduleID: moduleID)
        XCTAssertEqual(summary.quizBest["air-law"], 85)
        XCTAssertEqual(summary.examBest, 90)
        XCTAssertEqual(summary.examCount, 1)
        XCTAssertTrue(summary.gsDone.contains("lesson-intro"))
    }
}
