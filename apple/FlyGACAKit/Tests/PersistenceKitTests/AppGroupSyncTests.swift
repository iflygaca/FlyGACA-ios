import CoreModels
import StudyEngines
import XCTest

@testable import PersistenceKit

/// App Group sync verification — test that progress, streaks, and entitlements
/// are visible across apps in the family (ELPT and AIP share one App Group: group.com.FlyGACA).
/// Also verify concurrent-write resilience when one app studies while another runs offline.
///
/// Parity contract: StudyStore is the sole durable write path (an actor) — concurrent
/// updates from multiple app processes are serialized via SwiftData locking. These tests
/// verify that writes from one app are immediately visible to another, and that concurrent
/// sessions don't corrupt state.
final class AppGroupSyncTests: XCTestCase {

    /// Make a StudyStore with an in-memory SwiftData container for hermetic testing.
    /// Real App Group testing happens in integration tests on the simulator.
    private func makeStore() throws -> StudyStore {
        let container = try Persistence.container(inMemory: true)
        return StudyStore(container: container)
    }

    private func makeQuestion(bankID: String = "bank-a", index: Int = 0) -> Question {
        Question(
            id: "q-\(index)", bankID: bankID, index: index, prompt: "Q\(index)",
            choices: ["A", "B"], correctIndex: 0, explanation: "Explanation.")
    }

    private func makeQuizFile(bankID: String, count: Int = 5) -> QuizFile {
        let questions = (0..<count).map { makeQuestion(bankID: bankID, index: $0) }
        return QuizFile(
            generated: "v2", exam: .standard,
            banks: [Bank(id: bankID, title: bankID, blurb: "", source: nil, questions: questions)])
    }

    // MARK: - Progress sync across apps

    func testProgressWrittenByOneAppIsVisibleToAnother() async throws {
        let store = try makeStore()
        let moduleID = "aip"
        let bankID = "air-law"
        let quiz = makeQuizFile(bankID: bankID)

        // Simulate app 1 recording a quiz result
        let result = QuizSessionResult(
            bankID: bankID, moduleID: moduleID, correct: 4, total: 5,
            answers: [:], finishedAt: Date())
        try await store.recordQuiz(moduleID: moduleID, result: result)

        // Simulate app 2 reading the same progress (via the same swiftdata container)
        let best = try await store.bestQuizScore(moduleID: moduleID, bankID: bankID)

        XCTAssertEqual(best, 80) // 4/5 = 80%
    }

    func testStreakSyncAcrossApps() async throws {
        let store = try makeStore()
        let moduleID = "elpt"
        let now = Date()

        // App 1 records a quiz on day 1
        let day1Quiz = QuizSessionResult(
            bankID: "bank-a", moduleID: moduleID, correct: 3, total: 5,
            answers: [:], finishedAt: now)
        try await store.recordQuiz(moduleID: moduleID, result: day1Quiz)

        var streak = try await store.currentStreak(moduleID: moduleID)
        XCTAssertEqual(streak.count, 1)

        // App 2 records a quiz on day 2 (simulated by moving time forward 1 day)
        let day2 = now.addingTimeInterval(86400)
        let day2Quiz = QuizSessionResult(
            bankID: "bank-b", moduleID: moduleID, correct: 5, total: 5,
            answers: [:], finishedAt: day2)
        try await store.recordQuiz(moduleID: moduleID, result: day2Quiz)

        // App 1 reads the streak and sees day 2 (consecutive day increment)
        streak = try await store.currentStreak(moduleID: moduleID)
        XCTAssertEqual(streak.count, 2)
    }

    func testEntitlementsSyncAcrossApps() async throws {
        let store = try makeStore()
        let moduleID = "aip"

        // App 1 grants an entitlement (simulating a webhook from payment service)
        try await store.grantEntitlement(moduleID: moduleID, expiresAt: Date().addingTimeInterval(86400 * 365))

        // App 2 checks entitlements (via same SwiftData store)
        let hasAccess = try await store.hasEntitlement(moduleID: moduleID)
        XCTAssertTrue(hasAccess)

        let expiry = try await store.entitlementExpiry(moduleID: moduleID)
        XCTAssertNotNil(expiry)
    }

    // MARK: - Concurrent-write resilience

    func testConcurrentQuizRecordsFromMultipleAppsSerialize() async throws {
        let store = try makeStore()
        let moduleID = "elpt"
        let quiz = makeQuizFile(bankID: "bank-a", count: 10)

        // Simulate two apps recording quizzes concurrently (StudyStore actor serializes)
        async let record1 = store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-a", moduleID: moduleID, correct: 7, total: 10,
                answers: [:], finishedAt: Date()))
        async let record2 = store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-a", moduleID: moduleID, correct: 8, total: 10,
                answers: [:], finishedAt: Date().addingTimeInterval(1)))

        _ = try await (record1, record2)

        // Both records should be present (no corruption)
        let history = try await store.quizHistory(moduleID: moduleID, bankID: "bank-a")
        XCTAssertGreaterThanOrEqual(history.count, 2)
    }

    func testOneAppOfflineWhileOtherStudiesDoesNotCorruptState() async throws {
        let store = try makeStore()
        let moduleID = "aip"

        // App 1 (online) records a quiz
        try await store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-a", moduleID: moduleID, correct: 5, total: 5,
                answers: [:], finishedAt: Date()))

        // App 2 (offline) continues to use the same store and records its own quiz
        // (in real scenarios, offline app uses cached data; here we simulate dual writes)
        try await store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-b", moduleID: moduleID, correct: 4, total: 5,
                answers: [:], finishedAt: Date().addingTimeInterval(1)))

        // App 1 reads back and sees both results — no data loss
        let scoreA = try await store.bestQuizScore(moduleID: moduleID, bankID: "bank-a")
        let scoreB = try await store.bestQuizScore(moduleID: moduleID, bankID: "bank-b")

        XCTAssertEqual(scoreA, 100)
        XCTAssertEqual(scoreB, 80)
    }

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

    func testSameDayQuizDuplicateDoesNotIncrementCount() async throws {
        let store = try makeStore()
        let moduleID = "aip"
        let now = Date()

        // App 1 records a quiz
        try await store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-a", moduleID: moduleID, correct: 3, total: 5,
                answers: [:], finishedAt: now))

        // App 2 (same day, possibly seconds later) records a quiz in the same bank
        try await store.recordQuiz(
            moduleID: moduleID,
            result: QuizSessionResult(
                bankID: "bank-a", moduleID: moduleID, correct: 4, total: 5,
                answers: [:], finishedAt: now.addingTimeInterval(10)))

        // Check streak — same-day activity doesn't increment
        let streak = try await store.currentStreak(moduleID: moduleID)
        XCTAssertEqual(streak.count, 1)

        // Best score is still updated (highest of the two)
        let best = try await store.bestQuizScore(moduleID: moduleID, bankID: "bank-a")
        XCTAssertEqual(best, 80) // 4/5
    }

    // MARK: - State consistency after sync

    func testAppGroupStateRemainsConsistentAfterInterleavedUpdates() async throws {
        let store = try makeStore()
        let moduleIDs = ["aip", "elpt"]
        let quizBanks = ["air-law", "aircraft"]

        // Simulate rapid, interleaved updates from two apps
        for moduleID in moduleIDs {
            for bankID in quizBanks {
                try await store.recordQuiz(
                    moduleID: moduleID,
                    result: QuizSessionResult(
                        bankID: bankID, moduleID: moduleID, correct: 5, total: 5,
                        answers: [:], finishedAt: Date()))
            }
        }

        // Verify all updates are intact (no data loss, no corruption)
        for moduleID in moduleIDs {
            for bankID in quizBanks {
                let score = try await store.bestQuizScore(moduleID: moduleID, bankID: bankID)
                XCTAssertEqual(score, 100)
            }
        }
    }
}
